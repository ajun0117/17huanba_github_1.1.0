//
//  Gouwuche.h
//  17huanba
//
//  Created by Chen Hao on 13-3-2.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"

@interface Gouwuche : UIViewController<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate>
{
    int page;
}

@property(retain,nonatomic)PullingRefreshTableView *cartTableView;
@property(assign,nonatomic)BOOL refreshing;
@property(retain,nonatomic)NSMutableArray *cartArray;


@end
