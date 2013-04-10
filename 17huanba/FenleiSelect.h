//
//  FenleiSelect.h
//  17huanba
//
//  Created by Chen Hao on 13-2-21.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "secondFenlei.h"

@protocol BackToFabu <NSObject>

-(void)backToFabu:(NSDictionary *)fenleiDic;

@end

@interface FenleiSelect : UIViewController<UITableViewDelegate,UITableViewDataSource,BackToFrist>
@property(nonatomic,retain)UITableView *fenleiTableView;
@property(nonatomic,retain)NSMutableArray *fristArray;
@property(assign,nonatomic)id <BackToFabu> backFabuDelegate;

@end
