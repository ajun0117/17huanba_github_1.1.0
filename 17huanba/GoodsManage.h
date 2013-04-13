//
//  GoodsManage.h
//  一起换吧
//
//  Created by Chen Hao on 13-4-13.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "ASIFormDataRequest.h"

@interface GoodsManage : UIViewController<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate,UIScrollViewDelegate>
{
    int page;
    int type; //商品列表类型
}
@property(retain,nonatomic)UIImageView *changeIV;
@property(retain,nonatomic)UIButton *kindsBtn;
@property(retain,nonatomic)PullingRefreshTableView *goodsTableView;
@property(assign,nonatomic)BOOL refreshing;
@property(retain,nonatomic)NSMutableArray *goodsArray;
@property(retain,nonatomic)ASIFormDataRequest *goods_request;

@end
