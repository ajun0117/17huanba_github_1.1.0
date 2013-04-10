//
//  DetailFenlei.h
//  17huanba
//
//  Created by Chen Hao on 13-2-1.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailFenlei : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(retain,nonatomic)UITableView *detailFenleiTableView;
@property(nonatomic,retain)UILabel *navTitleL;
@property(nonatomic,retain)NSString *idStr;
@property(nonatomic,retain)NSMutableArray *secondArray;
@property(nonatomic,retain)NSMutableDictionary *secondDic;
@end
