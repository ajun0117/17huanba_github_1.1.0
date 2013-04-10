//
//  Caogaoxiang.h
//  17huanba
//
//  Created by Chen Hao on 13-2-5.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Caogaoxiang : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(retain,nonatomic)UITableView *caogaoTableView;
@property(retain,nonatomic)NSMutableArray *caogaoArray;

@end
