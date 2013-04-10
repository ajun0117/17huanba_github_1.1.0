//
//  Save_CartCell.h
//  17huanba
//
//  Created by Chen Hao on 13-3-1.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface Save_CartCell : UITableViewCell
@property(retain,nonatomic)AsyncImageView *head;
@property(retain,nonatomic)UILabel *nameL;
@property(retain,nonatomic)UILabel *chengseL;
@property(retain,nonatomic)UILabel *fangshiL;
@property(retain,nonatomic)UIButton *accessBtn;

@end
