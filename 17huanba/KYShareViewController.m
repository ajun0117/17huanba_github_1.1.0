//
//  KYShareViewController.m
//  KYGuideline
//
//  Created by chen xin on 12-8-21.
//  Copyright (c) 2012年 Kingyee. All rights reserved.
//

#import "KYShareViewController.h"
#import "WaitView.h"

#define kBorderWidth 20
#define kTextViewHeight 120

#define kWaitViewTag1 211
#define kWaitViewTag2 212

@implementation KYShareViewController

@synthesize shareType;
@synthesize shareText;
@synthesize weiBoEngine;
@synthesize renren = _renren;
//@synthesize nameL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        shareType = 0;
        shareText = nil;
    }
    return self;
}

- (void)dealloc {
    [_textView release];
    [_stateLabel release];
    [_countLabel release];
    [weiBoEngine setDelegate:nil];
    [weiBoEngine release];
    [shareText release];
    [_OpenApi release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_renren release];
//    [nameL release];
    [super dealloc];
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
- (int)wordCount:(NSString*)s
{
    int i,n=[s length],l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[s characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return l+(int)ceilf((float)(a+b)/2.0);
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];

	UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] 
								initWithTitle:@"返回" 
								style:UIBarButtonItemStylePlain 						
								target:nil 
								action:nil];
	self.navigationItem.backBarButtonItem = backBtn;
	[backBtn release];
    
    UIBarButtonItem *shareBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleBordered target:self action:@selector(shareBtnItemClicked)];
    self.navigationItem.rightBarButtonItem = shareBtnItem;
    [shareBtnItem release];
    
    CGRect rect = self.view.bounds;
    CGRect tvRect;
    tvRect.origin.x = kBorderWidth;
    tvRect.origin.y = kBorderWidth + 10 + 44;
    tvRect.size.width = rect.size.width - 2*kBorderWidth;
    tvRect.size.height = kTextViewHeight;
    _textView = [[UITextView alloc] initWithFrame:tvRect];
    _textView.layer.cornerRadius = 5.f;
    _textView.layer.borderWidth = 1.f;
    _textView.layer.borderColor = [[UIColor grayColor] CGColor];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:_textView];
    
    CGRect lbRect;
    lbRect.origin.x = kBorderWidth;
    lbRect.origin.y = 5 + 44;
    lbRect.size.width = 60;
    lbRect.size.height = kBorderWidth;
    _stateLabel = [[UILabel alloc] initWithFrame:lbRect];
    _stateLabel.backgroundColor = [UIColor clearColor];
    _stateLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_stateLabel];
    
    lbRect.origin.x = 180;
    lbRect.size.width = 120;
    _countLabel = [[UILabel alloc] initWithFrame:lbRect];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textAlignment = UITextAlignmentRight;
    _countLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_countLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oauthDidSuccess) name:@"TencentOauthDidSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popShareView) name:@"TencentSendWeiboSuccessed" object:nil];
}

- (void)refreshView {
    if (shareText == nil) {
        _textView.text = kDefaultText;
    }
    else {
        _textView.text = shareText;
        _textView.selectedRange = NSMakeRange(0, 0);
    }
    int length = [self wordCount:_textView.text];
    _countLabel.text = [NSString stringWithFormat:@"还可以输入%d字", kWeiboMaxWordCount - length];
    
    if (shareType == SinaWeibo) {
        if (weiBoEngine == nil) {
            weiBoEngine = [[WBEngine alloc] initWithAppKey:kSinaAppKey appSecret:kSinaAppSecret];
            [weiBoEngine setRootViewController:self];
            [weiBoEngine setDelegate:self];
            [weiBoEngine setRedirectURI:@"http://"];
            [weiBoEngine setIsUserExclusive:NO];
        }
        if ([weiBoEngine isLoggedIn] == NO) 
        {
            _stateLabel.text = @"未绑定";
        }
        else {
            _stateLabel.text = @"已绑定";
        }
    }
    else if (shareType == Tencent) {
        if ([OpenSdkOauth isLoggedIn] == NO) 
        {
            _stateLabel.text = @"未绑定";
        }
        else {
            _stateLabel.text = @"已绑定";
        }
    }
    else if (shareType == RenrenShare) {
        self.renren = [Renren sharedRenren];
        if ([_renren isSessionValid] == NO) 
        {
            _stateLabel.text = @"未绑定";
        }
        else {
            _stateLabel.text = @"已绑定";
        }
    }
    /*
     NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
     NSString *loginUserID = [[ud objectForKey:kLoginUserIDKey] stringValue];
     NSDictionary *shareDict = [ud objectForKey:loginUserID];
     if (shareDict == nil) {
     _stateLabel.text = @"未绑定";
     }
     else {
     if (shareType == SinaWeibo) {
     NSDictionary *wbDict = [shareDict objectForKey:kSinaLoginKey];
     if (wbDict == nil) 
     {
     _stateLabel.text = @"未绑定";
     }
     else {
     _stateLabel.text = @"已绑定";
     }
     }
     }
     */
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self refreshView];
    [_textView becomeFirstResponder];
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

#pragma mark - textview delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    int length = [self wordCount:textView.text];
    //if (shareType == SinaWeibo) 
    {
        if (length <= kWeiboMaxWordCount && length > 0) {
            _countLabel.textColor = [UIColor blackColor];
            _countLabel.text = [NSString stringWithFormat:@"还可以输入%d字", kWeiboMaxWordCount - length];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        else {
            _countLabel.textColor = [UIColor redColor];
            _countLabel.text = [NSString stringWithFormat:@"已经超过%d字", length - kWeiboMaxWordCount];
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
}

#pragma mark - shareBtnItemClicked
- (void)shareBtnItemClicked {
    if (shareType == SinaWeibo) {
        if ([weiBoEngine isLoggedIn] == NO) {
            [_textView resignFirstResponder];
            [weiBoEngine logIn];
        }
        else {
            [weiBoEngine sendWeiBoWithText:_textView.text image:nil];
            /*
             NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
             NSString *loginUserID = [[ud objectForKey:kLoginUserIDKey] stringValue];
             NSDictionary *shareDict = [ud objectForKey:loginUserID];
             if (shareDict == nil) {
             }
             else {
             if (shareType == SinaWeibo) {
             
             NSDictionary *wbDict = [shareDict objectForKey:kSinaLoginKey];
             if (wbDict == nil) {
             }
             else {
             //NSString *accessToken = [wbDict objectForKey:kSinaAccessTokenKey];
             [weiBoEngine sendWeiBoWithText:_textView.text image:nil];
             }
             }
             
             }
             */
        }
    }
    else if (shareType == Tencent) {
        if ([OpenSdkOauth isLoggedIn]) {
            [self tencentSendWeibo];
        }
        else {
            [self tencentLoginWithMicroblogAccount];
        }
    }
    else if (shareType == RenrenShare) {
        if ([self.renren isSessionValid]) {
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:10];
            [params setObject:@"status.set" forKey:@"method"];
            [params setObject:_textView.text forKey:@"status"];
            [self.renren requestWithParams:params andDelegate:self];
        }
        else {
            [_textView resignFirstResponder];
            NSArray *permissions = [NSArray arrayWithObjects:@"status_update", nil];
            [self.renren authorizationInNavigationWithPermisson:permissions andDelegate:self];
        }
    }
}

- (void)oauthDidSuccess {
    _stateLabel.text = @"已绑定";
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WBEngineDelegate Methods

#pragma mark Authorize

- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    if ([engine isUserExclusive])
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
                                                           message:@"请先登出！" 
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定" 
                                                 otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void)engineDidLogIn:(WBEngine *)engine
{
    [_textView becomeFirstResponder];
    NSString *msg = nil;//[NSString stringWithFormat:@"userID:%@, accessToken:%@", engine.userID, engine.accessToken];
    /*
    NSDictionary *wbDict = [NSDictionary dictionaryWithObjectsAndKeys:engine.userID, kSinaUserIDKey, engine.accessToken, kSinaAccessTokenKey, nil];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *loginUserID = [[ud objectForKey:kLoginUserIDKey] stringValue];
    NSDictionary *shareDict = [ud objectForKey:loginUserID];
    if (shareDict == nil) {
        shareDict = [NSDictionary dictionaryWithObject:wbDict forKey:kSinaLoginKey];
        [ud setObject:shareDict forKey:loginUserID];
        [ud synchronize];
    }
    else {
        NSMutableDictionary *newShareDict = [NSMutableDictionary dictionaryWithDictionary:shareDict];
        [newShareDict setObject:wbDict forKey:kSinaLoginKey];
        [ud setObject:newShareDict forKey:loginUserID];
        [ud synchronize];
        
    }
    */
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"绑定成功！" 
													   message:msg
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
    [alertView setTag:kWBAlertViewLogInTag];
	[alertView show];
	[alertView release];
    [self oauthDidSuccess];
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    [_textView becomeFirstResponder];
    NSLog(@"didFailToLogInWithError: %@", [error description]);
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"绑定失败！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)engineDidLogOut:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登出成功！" 
													  delegate:self
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
    [alertView setTag:kWBAlertViewLogOutTag];
	[alertView show];
	[alertView release];
}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"请重新登录！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error{
    
    NSLog(@"requestDidFailWithError: %@", [error description]);
    NSDictionary *errorInfo = [error userInfo];
    NSInteger error_code = [[errorInfo objectForKey:@"error_code"] intValue];
    if (error_code == 20019) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
                                                           message:@"此内容已分享！" 
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定" 
                                                 otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        return;
    }
    WaitView *waitView2 = (WaitView *)[self.view viewWithTag:kWaitViewTag2];
    if (waitView2 == nil) {
        waitView2 = [[WaitView alloc] initWithCenterText:@"分享失败!"];
        waitView2.tag = kWaitViewTag2;
        [self.view addSubview:waitView2];
        waitView2.hidden = YES;
        [waitView2 release];
        waitView2 = (WaitView *)[self.view viewWithTag:kWaitViewTag2];
    }
    else {
        waitView2.label.text = @"分享失败!";
    }
    [waitView2 showWithTimeInInterval:1.0];
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result {
    
    WaitView *waitView2 = (WaitView *)[self.view viewWithTag:kWaitViewTag2];
    if (waitView2 == nil) {
        waitView2 = [[WaitView alloc] initWithCenterText:@"分享成功!"];
        waitView2.tag = kWaitViewTag2;
        [self.view addSubview:waitView2];
        waitView2.hidden = YES;
        [waitView2 release];
        waitView2 = (WaitView *)[self.view viewWithTag:kWaitViewTag2];
    }
    else {
        waitView2.label.text = @"分享成功!";
    }
    [waitView2 showWithTimeInInterval:1.0];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(popShareView) userInfo:nil repeats:NO];
}

- (void)popShareView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Tencent Methods
- (void)tencentLoginWithMicroblogAccount {
    KYAuthorizeController *aCtrl = [[KYAuthorizeController alloc] init];
    aCtrl.title = @"绑定腾讯微博";
    aCtrl.shareType = Tencent;
    [self.navigationController pushViewController:aCtrl animated:YES];
    [aCtrl release];
}

- (void)tencentSendWeibo {
    
    //Todo：请填写调用t/add发表微博接口所需要的参数值，具体请参考http://wiki.open.t.qq.com/index.php/API文档
    if (_OpenApi == nil) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        _OpenApi = [[OpenApi alloc] initForApi:[OpenSdkBase getAppKey] appSecret:[OpenSdkBase getAppSecret] accessToken:[ud objectForKey:kTXaccessTokenKey] accessSecret:[ud objectForKey:kTXaccessSecretKey] openid:[ud objectForKey:kTXopenidKey] oauthType:oauthMode];
    }
    [_OpenApi publishWeibo:_textView.text jing:@"" wei:@"" format:@"json" clientip:@"CLIENTIP" syncflag:@"0"]; //发表微博
}

#pragma mark - RenrenDelegate methods

-(void)renrenDidLogin:(Renren *)renren{
    _stateLabel.text = @"已绑定";
}

- (void)renren:(Renren *)renren loginFailWithError:(ROError*)error{
	NSString *title = [NSString stringWithFormat:@"Error code:%d", [error code]];
	NSString *description = [NSString stringWithFormat:@"%@", [error localizedDescription]];
	UIAlertView *alertView =[[[UIAlertView alloc] initWithTitle:title message:description delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] autorelease];
	[alertView show];
}

- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response{
	NSDictionary* params = (NSDictionary *)response.rootObject;
    if (params!=nil) {
/*
        NSString *msg=nil;
        NSMutableString *result = [[NSMutableString alloc] initWithString:@""];
        for (id key in params)
		{
			msg = [NSString stringWithFormat:@"key: %@ value: %@    ",key,[params objectForKey:key]];
		    [result appendString:msg];
		}
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Widget Dialog" 
                                                       message:result delegate:nil
                                             cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [result release];
*/
        [self popShareView];
	}
    
    
}

- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error{
#ifdef Debug
    NSString* errorCode = [NSString stringWithFormat:@"Error:%d",error.code];
    NSString* errorMsg = [error localizedDescription];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:errorCode message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];
#endif
}

@end
