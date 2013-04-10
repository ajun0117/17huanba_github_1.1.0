//
//  ShouYe.h
//  17huanba
//
//  Created by Chen Hao on 13-1-24.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PullingRefreshTableView.h"

@interface ShouYe : UIViewController<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate,UIScrollViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>
{
    int page;
}

@property(retain,nonatomic)PullingRefreshTableView *timeLineTable;//类目展示视图
@property (nonatomic,assign) BOOL refreshing;
@property(retain,nonatomic)NSMutableArray *timeLineArray;//存展示内容的数组
@property(retain,nonatomic)UIScrollView *sv;//幻灯片视图
@property(retain,nonatomic)UIPageControl *pageC;//页面指示器
@property(retain,nonatomic)NSArray *AdImageArr; //存放广告图片的数组
@property(assign,nonatomic)int TimeNum;
@property(assign,nonatomic)BOOL Tend;
@property(retain,nonatomic)UIScrollView *searSV;
@property(retain,nonatomic)UISearchBar *searchB;
@property(retain,nonatomic)UISearchDisplayController *searchDis;

//-(void)startTheRequset:(int)page;
-(void)requestTheHomeImage;
-(NSString *)stringFromDate:(NSTimeInterval)secs;

@end
