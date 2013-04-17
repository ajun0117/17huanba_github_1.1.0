//
//  Sets.h
//  17huanba
//
//  Created by Chen Hao on 13-1-24.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckUpdate.h"

@interface Sets : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,CheckUpdateDelegate>

@property(retain,nonatomic)UITableView *setTableView;

@end
