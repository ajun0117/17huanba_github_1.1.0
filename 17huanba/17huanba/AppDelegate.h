//
//  AppDelegate.h
//  17huanba
//
//  Created by Chen Hao on 13-1-16.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShouYe.h"
#import "Message.h"
#import "Zhuye.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ShouYe *shouyeViewController;
@property(retain,nonatomic)Message *messageVC;
@property(retain,nonatomic)Zhuye *zhuyeVC;

@end
