//
//  DingdanXiangqing.h
//  一起换吧
//
//  Created by Chen Hao on 13-4-19.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface DingdanXiangqing : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIAlertViewDelegate>
{
    int type; //身份类型 1是我的商品 2是对方商品
}
@property(retain,nonatomic)UIImageView *changeIV;
@property(retain,nonatomic)UIButton *kindsBtn;
@property(retain,nonatomic)UITableView *xiangqingTableView;
@property(retain,nonatomic)NSDictionary *xiangqingDic;
@property(retain,nonatomic)ASIFormDataRequest *dingdan_request;

@property(retain,nonatomic)NSString *gdimgStr;
@property(retain,nonatomic)NSString *gnameStr;
@property(retain,nonatomic)NSString *oidStr;


@end
