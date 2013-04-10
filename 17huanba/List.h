//
//  List.h
//  17huanba
//
//  Created by Chen Hao on 13-2-1.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "ASIFormDataRequest.h"

@interface List : UIViewController<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate,UIScrollViewDelegate>
{
    int page;
    BOOL isKeySearch;//是否通过关键字搜索
}

@property(retain,nonatomic)PullingRefreshTableView *listTableView;
@property(nonatomic,assign) BOOL refreshing;
@property(nonatomic,retain)NSString *cidStr; //通过cid查找商品
@property(nonatomic,retain)NSMutableArray *listArray;
@property(nonatomic,retain)UILabel *nameL;
@property(nonatomic,assign)BOOL isKeySearch;
@property(nonatomic,retain)NSString *keyword; //搜索关键字
@property(nonatomic,retain)ASIFormDataRequest *form_request;

@end
