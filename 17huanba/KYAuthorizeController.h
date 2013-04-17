//
//  KYAuthorizeController.h
//  KYGuideline
//
//  Created by chen xin on 12-9-7.
//  Copyright (c) 2012年 Kingyee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareConfig.h"
#import "OpenSdkOauth.h"

@protocol KYAuthorizeDelegate <NSObject>

- (void)didReceiveAuthorizeCode:(NSString *)code;

@end

@interface KYAuthorizeController : UIViewController <UIWebViewDelegate>{
    UIActivityIndicatorView *indicatorView;
    OpenSdkOauth    *_OpenSdkOauth;
}

@property (nonatomic, retain)UIWebView *webView;
@property (nonatomic, assign) id<KYAuthorizeDelegate> delegate;
@property (nonatomic, retain)NSURL *authorizeURL;
@property KYShareType shareType;

- (void)loadRequestWithURL:(NSURL *)url;

@end
