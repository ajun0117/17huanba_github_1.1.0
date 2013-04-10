//
//  Zhuce.h
//  17huanba
//
//  Created by Chen Hao on 13-2-28.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface Zhuce : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *sexPicker;
}

@property(retain,nonatomic)UITextField *email;
@property(retain,nonatomic)UITextField *password;
@property(retain,nonatomic)UITextField *rePassword;
@property(retain,nonatomic)UITextField *nameF;
@property(retain,nonatomic)UITextField *sexF;
@property(retain,nonatomic)UITextField *phoneF;
@property(retain,nonatomic)UIButton *rememberBtn;
@property(retain,nonatomic)UIButton *autoLoginBtn;
@property(retain,nonatomic)ASIFormDataRequest *zhuce_request;
@property(nonatomic,retain)NSArray *sexArray;
@property(nonatomic,retain)UIImageView *bgIV;

@end
