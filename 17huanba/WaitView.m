//
//  WaitView.m
//  DrugRef
//
//  Created by chen xin on 11-12-8.
//  Copyright (c) 2011年 Kingyee. All rights reserved.
//

#import "WaitView.h"
#import <QuartzCore/QuartzCore.h>

#define kAlphaValue .7f

@implementation WaitView

@synthesize label;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithText:(NSString *)text Frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        aiView.tag = 1;
        aiView.backgroundColor = [UIColor clearColor];
        [aiView setHidesWhenStopped:YES];
        [aiView startAnimating];
        //[self addSubview:aiView];
        CGRect aiRect = aiView.frame;
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.tag = 2;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.text = text;
        //[self addSubview:label];
        [label sizeToFit];
        CGRect labelRect = label.frame;
        
        CGRect roundRect;
        roundRect.origin = CGPointZero;
        /*
        roundRect.size.width = aiRect.size.width + labelRect.size.width + 30;
        CGFloat contentHeight = (aiRect.size.height > labelRect.size.height) ? aiRect.size.height : labelRect.size.height;
        roundRect.size.height = contentHeight +20;
         */
        
        CGFloat contentWidth = (aiRect.size.width > labelRect.size.width) ? aiRect.size.width + 10 : labelRect.size.width + 10;
        roundRect.size.width = contentWidth;
        roundRect.size.height = roundRect.size.width;
        UIView *bgdView = [[UIView alloc] initWithFrame:roundRect];
        bgdView.tag = 3;
        [bgdView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        bgdView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:kAlphaValue];
        bgdView.layer.cornerRadius = 7.0f;
        [self addSubview:bgdView];
        [self sendSubviewToBack:bgdView];
        /*
        roundRect = bgdView.frame;
        aiRect.origin.x = roundRect.origin.x + 10;
        aiRect.origin.y = roundRect.origin.y + (roundRect.size.height - aiRect.size.height)/2;
        aiView.frame = aiRect;
        labelRect.origin.x = aiRect.origin.x + aiRect.size.width + 10;
        labelRect.origin.y = roundRect.origin.y + (roundRect.size.height - labelRect.size.height)/2;
        label.frame = labelRect;
         */
        aiView.center = CGPointMake(contentWidth/2, contentWidth/2);
        label.center = CGPointMake(contentWidth/2, contentWidth - labelRect.size.height/2 - 10);
        
        [bgdView addSubview:aiView];
        [bgdView addSubview:label];
        [bgdView release];
    }
    return self;
}

- (id)initWithText:(NSString *)text {
    CGRect frame = CGRectMake(0, -44, 320, 460);
    self = [self initWithText:text Frame:frame];
    return self;
}

- (id)initWithCenterText:(NSString *)text{
    CGRect frame = CGRectMake(0, -44, 320, 460);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 40)];
        label.tag = 2;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:14.0f];
        label.textAlignment = UITextAlignmentCenter;
        label.numberOfLines = 0;
        label.text = text;
        //[self addSubview:label];
        CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:14.0f]];
        if (size.width < 180) {
            [label sizeToFit];
        }
        CGRect labelRect = label.frame;
        
        CGRect roundRect;
        roundRect.origin = CGPointZero;
        
        CGFloat contentWidth = labelRect.size.width + 30;
        roundRect.size.width = contentWidth;
        //roundRect.size.height = roundRect.size.width;
        roundRect.size.height = labelRect.size.height + 30;
        UIView *bgdView = [[UIView alloc] initWithFrame:roundRect];
        bgdView.tag = 3;
        [bgdView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        bgdView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:kAlphaValue];
        bgdView.layer.cornerRadius = 7.0f;
        [self addSubview:bgdView];
        [self sendSubviewToBack:bgdView];
        roundRect = bgdView.frame;
        
        label.center = CGPointMake(contentWidth/2, roundRect.size.height/2);
        [bgdView addSubview:label];
        [bgdView release];
    }
    return self;
}

- (void)showTip:(NSString*)tip Position:(CGPoint)position {
    self.label.text = tip;
    //CGRect oldRect = self.label.frame;
    self.label.font = [UIFont boldSystemFontOfSize:12.0f];
    //[self.label sizeToFit];
    //CGSize tipSize = [tip sizeWithFont:[UIFont systemFontOfSize:14.0f]];
    UIView *bgdView = [self viewWithTag:3];
    CGRect lbRect = self.label.frame;
    lbRect.origin = CGPointMake(5, 2);
    self.label.frame = lbRect;
    CGRect bgRect;
    bgRect.origin = position;
    bgRect.size.width = lbRect.size.width + 10;
    bgRect.size.height = lbRect.size.height + 4;
    bgdView.frame = bgRect;
    [self showWithTimeInInterval:1.5f];
}

- (void)hideWaitView {
    self.hidden = YES;
}

- (void)showWithTimeInInterval:(NSTimeInterval)time {
    [self.superview bringSubviewToFront:self];
    self.hidden = NO;
    [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(hideWaitView) userInfo:nil repeats:NO];
}
/*
- (void)layoutSubviews {
    
    UIView *bgdView = [self viewWithTag:3];
    bgdView.center = self.center;
    CGRect roundRect = bgdView.frame;
    
	//2012-05-23, ChenXin added
	if (label.text == nil) {
		aiView.center = self.center;
		return;
	}
	//
    CGRect aiRect = aiView.frame;
    aiRect.origin.x = roundRect.origin.x + 10;
    aiRect.origin.y = roundRect.origin.y + (roundRect.size.height - aiRect.size.height)/2;
    aiView.frame = aiRect;
    CGRect labelRect = label.frame;
    labelRect.origin.x = aiRect.origin.x + aiRect.size.width + 10;
    labelRect.origin.y = roundRect.origin.y + (roundRect.size.height - labelRect.size.height)/2;
    label.frame = labelRect;
     
}
*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [aiView release];
    [label release];
    [super dealloc];
}

@end
