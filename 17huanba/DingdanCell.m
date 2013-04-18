//
//  DingdanCell.m
//  一起换吧
//
//  Created by Chen Hao on 13-4-18.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "DingdanCell.h"

@implementation DingdanCell
@synthesize gdimg,nameL,bianhaoL,numberL,toNameL,state,xiangqingBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.gdimg = [[AsyncImageView alloc]initWithFrame:CGRectMake(5, 12, 80, 80)];
        gdimg.image = DEFAULTIMG;
        gdimg.clipsToBounds = YES;
        gdimg.layer.cornerRadius = 10; //头像显示圆角
        [self addSubview:gdimg];
        [gdimg release];
        
        self.bianhaoL = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 220, 20)];
        bianhaoL.font = [UIFont systemFontOfSize:12];
//        bianhaoL.textAlignment = UITextAlignmentRight;
        bianhaoL.backgroundColor = [UIColor grayColor];
        [self addSubview:bianhaoL];
        [bianhaoL release];
        
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(90, 30, 220, 20)];
        nameL.backgroundColor = [UIColor grayColor];
        [self addSubview:nameL];
        [nameL release];
        
//        self.sell_type = [[UILabel alloc]initWithFrame:CGRectMake(90, 50, 170, 15)];
//        sell_type.font = [UIFont systemFontOfSize:15];
//        sell_type.textAlignment = UITextAlignmentRight;
//        sell_type.textColor = [UIColor redColor];
//        sell_type.backgroundColor = [UIColor grayColor];
//        [self addSubview:sell_type];
//        [sell_type release];
        
        self.numberL = [[UILabel alloc]initWithFrame:CGRectMake(90, 55, 150, 15)];
        numberL.font = [UIFont systemFontOfSize:12];
//        numberL.textAlignment = UITextAlignmentRight;
        numberL.backgroundColor = [UIColor grayColor];
        [self addSubview:numberL];
        [numberL release];
        
        self.toNameL = [[UILabel alloc]initWithFrame:CGRectMake(90, 75, 150, 15)];
        toNameL.font = [UIFont systemFontOfSize:12];
//        toNameL.textAlignment = UITextAlignmentRight;
        toNameL.backgroundColor = [UIColor grayColor];
        [self addSubview:toNameL];
        [toNameL release];
        
        self.state = [[UILabel alloc]initWithFrame:CGRectMake(90, 95, 150, 15)];
        state.font = [UIFont systemFontOfSize:12];
//        state.textAlignment = UITextAlignmentRight;
        state.backgroundColor = [UIColor grayColor];
        [self addSubview:state];
        [state release];
        
        
        self.xiangqingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [xiangqingBtn setBackgroundImage:[UIImage imageNamed:@"60_20.png"] forState:UIControlStateNormal];
        xiangqingBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [xiangqingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [xiangqingBtn setTitle:@"订单详情" forState:UIControlStateNormal];
        [self addSubview:xiangqingBtn];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
