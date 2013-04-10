//
//  ListCell.h
//  17huanba
//
//  Created by Chen Hao on 13-2-1.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "StrikeThroughLabel.h"

@interface ListCell : UITableViewCell
@property(retain,nonatomic)AsyncImageView *imageV;
@property(retain,nonatomic)UILabel *nameL;
@property(retain,nonatomic)UILabel *valueL;
@property(retain,nonatomic)StrikeThroughLabel *yuanValueL;
@property(retain,nonatomic)UILabel *timeL;
@property(retain,nonatomic)UILabel *fangshiL;
@property(retain,nonatomic)UILabel *weizhiL;

@end
