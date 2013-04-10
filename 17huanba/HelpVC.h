//
//  HelpVC.h
//  找地儿
//
//  Created by Ibokan on 12-11-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShouYe.h"
#import "Message.h"
#import "Zhuye.h"    

@interface HelpVC : UIViewController<UIScrollViewDelegate>
@property(retain,nonatomic)UIScrollView *helpScrollView;
@property (strong, nonatomic) ShouYe *shouyeViewController;
@property(retain,nonatomic)Message *messageVC;
@property(retain,nonatomic)Zhuye *zhuyeVC;
@property(retain,nonatomic)UIPageControl *pageC;

@end
