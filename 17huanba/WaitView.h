//
//  WaitView.h
//  DrugRef
//
//  Created by chen xin on 11-12-8.
//  Copyright (c) 2011年 Kingyee. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLabelMaxWidth 200

@interface WaitView : UIView {
    UIActivityIndicatorView *aiView;
    UILabel                 *label;
    CGSize                  _contentSize;
}

@property (nonatomic, retain)UILabel *label;

- (id)initWithText:(NSString *)text Frame:(CGRect)frame;
- (id)initWithText:(NSString *)text;
- (id)initWithCenterText:(NSString *)text;
- (void)showWithTimeInInterval:(NSTimeInterval)time;
- (void)showTip:(NSString*)tip Position:(CGPoint)position;

@end
