//
//  Xiangxi.h
//  17huanba
//
//  Created by Chen Hao on 13-1-24.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface Xiangxi : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPageViewControllerDelegate,UIScrollViewDelegate,UIAlertViewDelegate>

@property(retain,nonatomic)UITableView *myTableView;
@property (nonatomic,assign) BOOL refreshing;
@property(nonatomic,retain)UIPageControl *page;
@property(nonatomic,retain)UIView *sectionHeadView;
@property(nonatomic,retain)UISegmentedControl *seg;
@property(nonatomic,retain)NSString *gdid; //商品ID
@property(nonatomic,retain)NSDictionary *dataDic;
@property(nonatomic,retain)NSArray *liuyanArray;
@property(nonatomic,retain)NSDictionary *myInfoDic; //登录用户信息字典

@property(nonatomic,retain)ASIFormDataRequest *detailGoodsRequest;

@property(retain,nonatomic)ASIFormDataRequest *userMessage_request;

-(void)requestWithDetailGoods; //根据商品ID请求详细信息

@end
