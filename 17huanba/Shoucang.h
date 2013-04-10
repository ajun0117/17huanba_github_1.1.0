//
//  Shoucang.h
//  17huanba
//
//  Created by Chen Hao on 13-2-5.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"

@interface Shoucang : UIViewController<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate>
{
    int page;
}

@property(retain,nonatomic)PullingRefreshTableView *shoucangTableView;
@property(assign,nonatomic)BOOL refreshing;
@property(retain,nonatomic)NSMutableArray *shouArray;

@end
