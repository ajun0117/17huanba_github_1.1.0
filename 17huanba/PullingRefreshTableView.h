//
//  PullingRefreshTableView.h
//  糗百
//
//  Created by Apple on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullLoadingView.h"

@protocol PullingRefreshTableViewDelegate;
@interface PullingRefreshTableView : UITableView
{
    PullLoadingView *_headerView;
    PullLoadingView *_footerView;
    BOOL _isFooterInAction;
    
    UILabel *_msgLabel;
}

@property (nonatomic) BOOL reachedTheEnd;
@property (nonatomic) BOOL autoScrollToNextPage;
@property (nonatomic,getter = isHeaderOnly) BOOL headerOnly;
@property (assign,nonatomic) id <PullingRefreshTableViewDelegate> pullingDelegate;
-(id)initWithFrame:(CGRect)frame pullingDelegate:(id<PullingRefreshTableViewDelegate>)aPullingDelegate;
- (void)launchRefreshing;
- (void)flashMessage:(NSString *)msg;

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView;
- (void)tableViewDidFinishedLoading;
- (void)tableViewDidScroll:(UIScrollView *)scrollView;

- (void)tableViewDidFinishedLoadingWithMessage:(NSString *)msg;
@end




@protocol PullingRefreshTableViewDelegate <NSObject>

@required
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView;
@optional
//Implement this method if headerOnly is false
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView;
//Implement the follows to set date you want,Or Ignore them to use current date 
- (NSDate *)pullingTableViewRefreshingFinishedDate;
- (NSDate *)pullingTableViewLoadingFinishedDate;

@end