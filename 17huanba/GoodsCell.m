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
        
        self.gdimg = [[AsyncImageView alloc]initWithFrame:CGRectMake(5, 7, 80, 80)];
        gdimg.image = DEFAULTIMG;
        gdimg.clipsToBounds = YES;
        gdimg.layer.cornerRadius = 10; //头像显示圆形
        [self addSubview:gdimg];
        [gdimg release];
        
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 170, 20)];
        nameL.backgroundColor = [UIColor clearColor];
        [self addSubview:nameL];
        [nameL release];
        
        self.catType = [[UILabel alloc]initWithFrame:CGRectMake(90, 30, 170, 12)];
        catType.font = [UIFont systemFontOfSize:12];
        catType.textAlignment = UITextAlignmentRight;
        catType.backgroundColor = [UIColor clearColor];
        [self addSubview:catType];
        [catType release];
        
        self.sell_type = [[UILabel alloc]initWithFrame:CGRectMake(90, 50, 170, 15)];
        sell_type.font = [UIFont systemFontOfSize:15];
        sell_type.textAlignment = UITextAlignmentRight;
        sell_type.textColor = [UIColor redColor];
        sell_type.backgroundColor = [UIColor clearColor];
        [self addSubview:sell_type];
        [sell_type release];
        
        self.last_update = [[UILabel alloc]initWithFrame:CGRectMake(90, 75, 170, 15)];
        last_update.font = [UIFont systemFontOfSize:12];
        last_update.textAlignment = UITextAlignmentRight;
        last_update.backgroundColor = [UIColor clearColor];
        [self addSubview:last_update];
        [last_update release];
        
        self.xiajiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [xiajiaBtn setBackgroundImage:[UIImage imageNamed:@"cartBtn.png"] forState:UIControlStateNormal];
        xiajiaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [xiajiaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [xiajiaBtn setTitle:@"下架" forState:UIControlStateNormal];
        [self addSubview:xiajiaBtn];
        
        self.shangjiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shangjiaBtn setBackgroundImage:[UIImage imageNamed:@"cartBtn.png"] forState:UIControlStateNormal];
        shangjiaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [shangjiaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [shangjiaBtn setTitle:@"上架" forState:UIControlStateNormal];
        [self addSubview:shangjiaBtn];
        
        self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [editBtn setBackgroundImage:[UIImage imageNamed:@"cartBtn.png"] forState:UIControlStateNormal];
        editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self addSubview:editBtn];
        
        self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"cartBtn.png"] forState:UIControlStateNormal];
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
