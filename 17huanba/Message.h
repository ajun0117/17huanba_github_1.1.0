//
//  Message.h
//  17huanba
//
//  Created by Chen Hao on 13-1-24.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"

@interface Message : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,PullingRefreshTableViewDelegate>
{
    int page;
}
@property(retain,nonatomic)PullingRefreshTableView *messageTableView;
@property(retain,nonatomic)UIButton *backBtn;
@property(retain,nonatomic)NSMutableArray *messageArray;
@property(assign,nonatomic)BOOL istabMessage;
@property(assign,nonatomic)BOOL refreshing;

@end
