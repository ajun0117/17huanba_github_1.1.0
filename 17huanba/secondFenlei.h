//
//  secondFenlei.h
//  17huanba
//
//  Created by Chen Hao on 13-2-21.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThirdFenlei.h"

@protocol BackToFrist <NSObject>

-(void)backToFrist:(NSDictionary *)fenleiDic;

@end


@interface secondFenlei : UIViewController<UITableViewDelegate,UITableViewDataSource,BackToSecond>
@property(nonatomic,retain)UITableView *fenleiTableView;
@property(nonatomic,retain)UILabel *navTitleL;
@property(nonatomic,retain)NSString *idStr;
@property(nonatomic,retain)NSMutableArray *secondArray;
@property(nonatomic,retain)NSMutableDictionary *secondDic;
@property(assign,nonatomic)id <BackToFrist> backFristDelegate;

@end
