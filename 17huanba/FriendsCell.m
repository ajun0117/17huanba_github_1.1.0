//
//  FriendsCell.m
//  17huanba
//
//  Created by Chen Hao on 13-3-1.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "FriendsCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation FriendsCell
@synthesize head,nameL,genderL,list_bgIV,fa_bgIV,shou1_bgIV,shou2_bgIV,weizhiL;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.head = [[AsyncImageView alloc]initWithFrame:CGRectMake(5, 5, 60, 60)];
        head.image = DEFAULTIMG;
        head.clipsToBounds = YES;
        head.layer.cornerRadius = 10; //头像显示圆形
        [self addSubview:head];
        [head release];
        
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 150, 15)];
        nameL.backgroundColor = [UIColor clearColor];
        [self addSubview:nameL];
        [nameL release];
        
        self.genderL = [[UILabel alloc]initWithFrame:CGRectMake(70, 25, 30, 15)];
        genderL.backgroundColor = [UIColor clearColor];
        [self addSubview:genderL];
        [genderL release];
        
        self.weizhiL = [[UILabel alloc]initWithFrame:CGRectMake(70, 45, 200, 15)];
        weizhiL.font = [UIFont systemFontOfSize:14];
        weizhiL.backgroundColor = [UIColor clearColor];
        [self addSubview:weizhiL];
        [weizhiL release];
        
        self.list_bgIV = [[UIImageView alloc]init];
        list_bgIV.userInteractionEnabled = YES;
        list_bgIV.clipsToBounds = YES;
        [self addSubview:list_bgIV];
        [list_bgIV release];
        
        UIButton *sixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sixinBtn setImage:[UIImage imageNamed:@"friendLetter.png"] forState:UIControlStateNormal];
        sixinBtn.tag = 20;
        sixinBtn.frame = CGRectMake(0, 0, 40, 26);
        [list_bgIV addSubview:sixinBtn];
        
        UIButton *shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shopBtn setImage:[UIImage imageNamed:@"friendShop.png"] forState:UIControlStateNormal];
        shopBtn.tag = 30;
        shopBtn.frame = CGRectMake(40, 0, 40, 26);
        [list_bgIV addSubview:shopBtn];
        
        
        self.fa_bgIV = [[UIImageView alloc]init];
        fa_bgIV.userInteractionEnabled = YES;
        fa_bgIV.clipsToBounds = YES;
        [self.contentView addSubview:fa_bgIV];
        [fa_bgIV release];
        
        UIButton *waitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        waitBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [waitBtn setTitle:@"等待同意" forState:UIControlStateNormal];
        waitBtn.tag = 11;
        waitBtn.frame = CGRectMake(0, 0, 60, 26);
        [fa_bgIV addSubview:waitBtn];
        
        
        self.shou1_bgIV = [[UIImageView alloc]init];
        shou1_bgIV.userInteractionEnabled = YES;
        shou1_bgIV.clipsToBounds = YES;
        [self addSubview:shou1_bgIV];
        [shou1_bgIV release];
        
        UIButton *yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        yesBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [yesBtn setTitle:@"接受请求" forState:UIControlStateNormal];
        yesBtn.tag = 10;
        yesBtn.frame = CGRectMake(0, 0, 60, 26);
        [shou1_bgIV addSubview:yesBtn];
        
        
        self.shou2_bgIV = [[UIImageView alloc]init];
        shou2_bgIV.userInteractionEnabled = YES;
        shou2_bgIV.clipsToBounds = YES;
        [self addSubview:shou2_bgIV];
        [shou2_bgIV release];
        
        UIButton *noBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        noBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [noBtn setTitle:@"拒绝请求" forState:UIControlStateNormal];
        noBtn.tag = 100;
        noBtn.frame = CGRectMake(0, 0, 60, 26);
        [shou2_bgIV addSubview:noBtn];
        
        UIButton *missBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        missBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [missBtn setTitle:@"忽略请求" forState:UIControlStateNormal];
        missBtn.tag = 1000;
        missBtn.frame = CGRectMake(60, 0, 60, 26);
        [shou2_bgIV addSubview:missBtn];
        
    }
    return self;
}

- (void)prepareForReuse //重用表单元格前调用的方法
{
//    self.head.frame = CGRectZero;
//    self.nameL.frame = CGRectZero;
//    self.genderL.frame = CGRectZero;
    self.list_bgIV.frame = CGRectZero;
    self.fa_bgIV.frame = CGRectZero;
    self.shou1_bgIV.frame = CGRectZero;
    self.shou2_bgIV.frame = CGRectZero;
//    self.weizhiL.frame = CGRectZero;
    [super prepareForReuse];
}


-(void)dealloc{
    [super dealloc];
    [head release];
    [nameL release];
    [genderL release];
    [list_bgIV release];
    [fa_bgIV release];
    [shou1_bgIV release];
    [shou2_bgIV release];
    [weizhiL release];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
