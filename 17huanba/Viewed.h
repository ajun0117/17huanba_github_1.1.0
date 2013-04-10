//
//  Viewed.h
//  17huanba
//
//  Created by Chen Hao on 13-2-5.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Viewed : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(retain,nonatomic)UITableView *liulanTableView;
@property(retain,nonatomic)NSMutableArray *viewedArray;

@end
