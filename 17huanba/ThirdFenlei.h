//
//  ThirdFenlei.h
//  17huanba
//
//  Created by Chen Hao on 13-3-20.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackToSecond <NSObject>

-(void)backToSecond:(NSDictionary *)fenleiDic;

@end

@interface ThirdFenlei : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)UITableView *fenleiTableView;
@property(nonatomic,retain)UILabel *navTitleL;
@property(nonatomic,retain)NSString *idStr;
@property(nonatomic,retain)NSMutableArray *thirdArray;
@property(nonatomic,retain)NSMutableDictionary *thirdDic;
@property(assign,nonatomic)id <BackToSecond> backSecondDelegate;

@end
