//
//  FankuiYijian.h
//  17huanba
//
//  Created by Chen Hao on 13-3-30.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface FankuiYijian : UIViewController<UITextViewDelegate,MFMailComposeViewControllerDelegate>
@property(retain,nonatomic)UILabel *numberL;
@property(retain,nonatomic)UITextView *yijianTV;

@end
