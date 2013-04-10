//
//  Dijishi.h
//  17huanba
//
//  Created by Chen Hao on 13-3-4.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Dijishi : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)UITableView *dijishiTableView;
@property(nonatomic,retain)UILabel *navTitleL;

@end
