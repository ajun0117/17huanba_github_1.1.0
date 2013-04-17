//
//  KYShareViewController.h
//  KYGuideline
//
//  Created by chen xin on 12-8-21.
//  Copyright (c) 2012年 Kingyee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareConfig.h"

//新浪微博
#import "WBEngine.h"
//腾讯微博
#import "OpenApi.h"

@interface KYShareViewController : UIViewController <UITextViewDelegate, WBEngineDelegate, RenrenDelegate> {
    UITextView      *_textView;
    UILabel         *_stateLabel;
    UILabel         *_countLabel;
    BOOL            isLogined;
    WBEngine        *weiBoEngine;
    OpenApi         *_OpenApi;
}

@property KYShareType shareType;
@property (nonatomic, copy)NSString* shareText;
@property (retain,nonatomic)Renren *renren;
@property (retain,nonatomic)WBEngine *weiBoEngine;
//@property (retain,nonatomic)UILabel *nameL;

- (void)shareBtnItemClicked;

- (void)oauthDidSuccess;
- (void)tencentLoginWithMicroblogAccount;
- (void)tencentSendWeibo;

@end
