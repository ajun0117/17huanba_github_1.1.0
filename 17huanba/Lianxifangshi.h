//
//  Lianxifangshi.h
//  17huanba
//
//  Created by Chen Hao on 13-3-11.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Lianxifangshi : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(retain,nonatomic)UITableView *LianxiTableView;
@property(retain,nonatomic)UITextField *phoneF;
@property(retain,nonatomic)UITextField *emailF;

@property(retain,nonatomic)UILabel *phoneL;
@property(retain,nonatomic)UILabel *emailL;
@end
