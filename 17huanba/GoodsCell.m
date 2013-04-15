//
//  GoodsCell.m
//  一起换吧
//
//  Created by Chen Hao on 13-4-13.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "GoodsCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation GoodsCell
@synthesize gdimg,nameL,catType,sell_type,last_update;
@synthesize xiajiaBtn,shangjiaBtn,editBtn,shareBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.gdimg = [[AsyncImageView alloc]initWithFrame:CGRectMake(5, 5, 60, 60)];
        gdimg.image = DEFAULTIMG;
        gdimg.clipsToBounds = YES;
        gdimg.layer.cornerRadius = 10; //头像显示圆形
        [self addSubview:gdimg];
        [gdimg release];
        
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 150, 20)];
        nameL.backgroundColor = [UIColor grayColor];
        [self addSubview:nameL];
        [nameL release];
        
        self.catType = [[UILabel alloc]initWithFrame:CGRectMake(70, 26, 150, 12)];
        catType.textAlignment = UITextAlignmentRight;
        catType.backgroundColor = [UIColor grayColor];
        [self addSubview:catType];
        [catType release];
        
        self.sell_type = [[UILabel alloc]initWithFrame:CGRectMake(70, 45, 150, 15)];
        sell_type.textColor = [UIColor redColor];
        sell_type.backgroundColor = [UIColor grayColor];
        [self addSubview:sell_type];
        [sell_type release];
        
        self.last_update = [[UILabel alloc]initWithFrame:CGRectMake(70, 65, 150, 15)];
        last_update.backgroundColor = [UIColor grayColor];
        [self addSubview:last_update];
        [last_update release];
        
        self.xiajiaBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [xiajiaBtn setTitle:@"下架" forState:UIControlStateNormal];
        [self addSubview:xiajiaBtn];
        
        self.shangjiaBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [shangjiaBtn setTitle:@"上架" forState:UIControlStateNormal];
        [self addSubview:shangjiaBtn];
        
        self.editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self addSubview:editBtn];
        
        self.shareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [self addSubview:shareBtn];
        
    }
    return self;
}

- (void)prepareForReuse //重用表单元格前调用的方法
{
    self.xiajiaBtn.frame = CGRectZero;
    self.shangjiaBtn.frame = CGRectZero;
    self.editBtn.frame = CGRectZero;
    self.shareBtn.frame = CGRectZero;
    [super prepareForReuse];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
