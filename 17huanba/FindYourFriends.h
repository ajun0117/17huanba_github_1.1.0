//
//  FindYourFriends.h
//  17huanba
//
//  Created by Chen Hao on 13-2-5.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"

@interface FindYourFriends : UIViewController<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate,UIScrollViewDelegate>
{
    int page;
    int type;
}
@property(retain,nonatomic)PullingRefreshTableView *myFriendsTableView;
@property(retain,nonatomic)UIImageView *changeIV;
@property(retain,nonatomic)UIButton *kindsBtn;
@property(assign,nonatomic)BOOL refreshing;
@property(retain,nonatomic)NSMutableArray *friendsArray;

@end
