//
//  FriendsTimeLine.h
//  17huanba
//
//  Created by Chen Hao on 13-2-5.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "ASIFormDataRequest.h"

@interface FriendsTimeLine : UIViewController<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate,UIScrollViewDelegate>
{
    int page;
    BOOL isMyDongtai;
}
@property(retain,nonatomic)UIImageView *changeIV;
@property(retain,nonatomic)UIButton *kindsBtn;
@property(retain,nonatomic)PullingRefreshTableView *friendTableView;
@property(assign,nonatomic)BOOL refreshing;
@property(retain,nonatomic)NSMutableArray *dongtaiArray;
@property(retain,nonatomic)ASIFormDataRequest *friendTimeLine_request;

@end
