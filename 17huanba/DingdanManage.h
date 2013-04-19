//
//  DingdanManage.h
//  一起换吧
//
//  Created by Chen Hao on 13-4-18.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PullingRefreshTableView.h"
#import "ASIFormDataRequest.h"

@interface DingdanManage : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    int type; //身份类型 1是买家 2是卖家
}
@property(retain,nonatomic)UIImageView *changeIV;
@property(retain,nonatomic)UIButton *kindsBtn;
@property(retain,nonatomic)UITableView *dingdanTableView;
@property(retain,nonatomic)NSMutableArray *dingdanArray;
@property(retain,nonatomic)ASIFormDataRequest *dingdan_request;

@end
