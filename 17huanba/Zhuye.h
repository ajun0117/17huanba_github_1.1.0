//
//  Zhuye.h
//  17huanba
//
//  Created by Chen Hao on 13-1-25.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface Zhuye : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property(retain,nonatomic)UITableView *personTableView;
@property(retain,nonatomic)UIButton *exitBtn;
@property(retain,nonatomic)UIAlertView *exitAlert;
@property(retain,nonatomic)AsyncImageView *head;
@property(retain,nonatomic)UILabel *nameL;
@property(retain,nonatomic)UILabel *QQL;
@property(retain,nonatomic)UIImageView *shoujiIV;
@property(retain,nonatomic)UIImageView *shenfenIV;

@end
