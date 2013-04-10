//
//  FriendTimeLineCell.h
//  17huanba
//
//  Created by Chen Hao on 13-3-12.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface FriendTimeLineCell : UITableViewCell
@property(retain,nonatomic)AsyncImageView *head;
@property(retain,nonatomic)UILabel *uNameL;
@property(retain,nonatomic)UILabel *gNameL;
@property(retain,nonatomic)UILabel *titleL;
@property(retain,nonatomic)AsyncImageView *gImage;
@property(retain,nonatomic)UILabel *timeL;
@property(retain,nonatomic)UIButton *shareBtn;
@property(retain,nonatomic)UIButton *pingBtn;
@property(retain,nonatomic)UIWebView *sayWeb;
@end
