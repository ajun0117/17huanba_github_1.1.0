//
//  PullLoadingView.h
//  糗百
//
//  Created by Apple on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    kPRStateNormal = 0,
    kPRStatePulling = 1,
    kPRStateLoading = 2,
    kPRStateHitTheEnd = 3
} PRState;
@interface PullLoadingView : UIView
{
    UILabel *_stateLabel;
    UILabel *_dateLabel;
    UIImageView *_arrowView;
    CALayer *_arrow;
    UIActivityIndicatorView *_activityView;//滚动的小圆圈
    BOOL _loading;
}

@property (nonatomic) PRState state;
@property (nonatomic,getter = isLoading) BOOL loading;  
@property (nonatomic,getter = isAtTop) BOOL atTop;
- (id)initWithFrame:(CGRect)frame atTop:(BOOL)top;
- (void)layouts;
- (void)setState:(PRState)state animated:(BOOL)animated;
- (void)updateRefreshDate:(NSDate *)date;
@end
