//
//  Denglu.h
//  17huanba
//
//  Created by Chen Hao on 13-2-28.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface Denglu : UIViewController
//    NSString *sign; //SHA1加密过的用户密码
@property(retain,nonatomic)UITextField *email;
@property(retain,nonatomic)UITextField *password;
@property(retain,nonatomic)UIButton *rememberBtn;
@property(retain,nonatomic)UIButton *autoLoginBtn;
@property(retain,nonatomic)ASIFormDataRequest *login_request;

@end
