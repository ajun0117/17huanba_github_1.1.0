//
//  GerenDongtai.h
//  17huanba
//
//  Created by Chen Hao on 13-3-14.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "AsyncImageView.h"

@interface GerenDongtai : UIViewController<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate,UIScrollViewDelegate>
{
    int page;
}
@property(retain,nonatomic)UIImageView *changeIV;
@property(retain,nonatomic)UIButton *kindsBtn;
@property(retain,nonatomic)PullingRefreshTableView *friendTableView;
@property(assign,nonatomic)BOOL refreshing;
@property(retain,nonatomic)NSMutableArray *dongtaiArray;
@property(retain,nonatomic)AsyncImageView *head;
@property(retain,nonatomic)UILabel *nameL;
@property(retain,nonatomic)UILabel *QQL;
@property(retain,nonatomic)NSDictionary *userDic;
//@property(retain,nonatomic)UIImageView *shoujiIV;
//@property(retain,nonatomic)UIImageView *shenfenIV;

@end
