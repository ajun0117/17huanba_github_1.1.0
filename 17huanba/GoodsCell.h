//
//  GoodsCell.h
//  一起换吧
//
//  Created by Chen Hao on 13-4-13.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface GoodsCell : UITableViewCell
@property(retain,nonatomic)AsyncImageView *gdimg;
@property(retain,nonatomic)UILabel *nameL;
@property(retain,nonatomic)UILabel *catType; //分类
@property(retain,nonatomic)UILabel *sell_type; //交易方式
@property(retain,nonatomic)UILabel *last_update; //更新时间
@property(retain,nonatomic)UIButton *xiajiaBtn; //下架按钮
@property(retain,nonatomic)UIButton *shangjiaBtn; //上架按钮
@property(retain,nonatomic)UIButton *editBtn; //下架按钮
@property(retain,nonatomic)UIButton *shareBtn; //下架按钮


@end
