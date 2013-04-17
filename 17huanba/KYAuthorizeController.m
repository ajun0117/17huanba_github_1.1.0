//
//  KYAuthorizeController.m
//  KYGuideline
//
//  Created by chen xin on 12-9-7.
//  Copyright (c) 2012年 Kingyee. All rights reserved.
//

#import "KYAuthorizeController.h"

@implementation KYAuthorizeController

@synthesize webView = _webView;
@synthesize delegate;
@synthesize authorizeURL;
@synthesize shareType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [_webView setDelegate:self];
    [self.view addSubview:_webView];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView setCenter:self.view.center];
    [self.view addSubview:indicatorView];
    
}

- (void)dealloc {
    _webView.delegate = nil;
    [_webView release];
    [indicatorView release];
    [_OpenSdkOauth release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.shareType == SinaWeibo) {
        [self loadRequestWithURL:self.authorizeURL];
    }
    else if (self.shareType == Tencent) {
        
        if (([OpenSdkBase getAppKey] == (NSString *)[NSNull null]) || ([OpenSdkBase getAppKey].length == 0)) {
            [OpenSdkBase showMessageBox:@"client_id为空，请到OPenSdkBase中填写您应用的appkey"];
            return;
        }
        
        if (_OpenSdkOauth == nil) {
            _OpenSdkOauth = [[OpenSdkOauth alloc] initAppKey:[OpenSdkBase getAppKey] appSecret:[OpenSdkBase getAppSecret]];
            _OpenSdkOauth.oauthType = oauthMode;
        }
        [_OpenSdkOauth doWebViewAuthorize:self.webView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadRequestWithURL:(NSURL *)url
{
    NSURLRequest *request =[NSURLRequest requestWithURL:url
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:60.0];
    [_webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)aWebView
{
	[indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
	[indicatorView stopAnimating];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error
{
    [indicatorView stopAnimating];
    if (self.shareType == Tencent) {
        if (!([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)) {
            [_OpenSdkOauth oauthDidFail:InWebView success:NO netNotWork:YES];
        }
    }
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (self.shareType == SinaWeibo) {
        
        NSRange range = [request.URL.absoluteString rangeOfString:@"code="];
        
        if (range.location != NSNotFound)
        {
            NSString *code = [request.URL.absoluteString substringFromIndex:range.location + range.length];
            
            if ([code isEqualToString:@"21330"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                
                if ([delegate respondsToSelector:@selector(didReceiveAuthorizeCode:)])
                {
                    [delegate didReceiveAuthorizeCode:code];
                }
            }
        }
    }
    else if (self.shareType == Tencent) {
        
        NSURL* url = request.URL;
        NSLog(@"response url is %@", url);
        NSRange start = [[url absoluteString] rangeOfString:oauth2TokenKey];
        
        //如果找到tokenkey,就获取其他key的value值
        if (start.location != NSNotFound)
        {
            NSString *accessToken = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2TokenKey];
            NSString *openid = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2OpenidKey];
            NSString *openkey = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2OpenkeyKey];
            NSString *expireIn = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2ExpireInKey];
            
            NSDate *expirationDate =nil;
            if (_OpenSdkOauth.expireIn != nil) {
                int expVal = [_OpenSdkOauth.expireIn intValue];
                if (expVal == 0) {
                    expirationDate = [NSDate distantFuture];
                } else {
                    expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
                } 
            } 
            
            NSLog(@"token is %@, openid is %@, expireTime is %@", accessToken, openid, expirationDate);
            
            if ((accessToken == (NSString *) [NSNull null]) || (accessToken.length == 0) 
                || (openid == (NSString *) [NSNull null]) || (openkey.length == 0) 
                || (openkey == (NSString *) [NSNull null]) || (openid.length == 0)) {
                [_OpenSdkOauth oauthDidFail:InWebView success:YES netNotWork:NO];
            }
            else {
                [_OpenSdkOauth oauthDidSuccess:accessToken accessSecret:nil openid:openid openkey:openkey expireIn:expireIn];
            }
            return NO;
        }
        else
        {
            start = [[url absoluteString] rangeOfString:@"code="];
            if (start.location != NSNotFound) {
                [_OpenSdkOauth refuseOauth:url];
            }
        }
    }
    
    return YES;
}
@end
