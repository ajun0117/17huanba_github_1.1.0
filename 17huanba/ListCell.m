//
//  ListCell.m
//  17huanba
//
//  Created by Chen Hao on 13-2-1.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.


#import "ListCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ListCell
@synthesize imageV,nameL,valueL,yuanValueL,timeL,fangshiL,weizhiL;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.imageV = [[AsyncImageView alloc]init];
//        imageV.layer.cornerRadius = 3;
//        imageV.clipsToBounds = YES;
        imageV.userInteractionEnabled = NO;
        imageV.frame = CGRectMake(5, 10, 80, 80);
        imageV.image = DEFAULTIMG;
        [self addSubview:imageV];
        [imageV release];
        
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 200, 17)];
        nameL.font = [UIFont boldSystemFontOfSize:17];
        [self addSubview:nameL];
        [nameL release];
        
        self.valueL = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, 200, 20)];
        valueL.textColor = [UIColor redColor];
        valueL.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:valueL];
        [valueL release];
        
        self.yuanValueL = [[StrikeThroughLabel alloc]initWithFrame:CGRectMake(90, 55, 100, 15)];
        yuanValueL.strikeThroughEnabled = YES; //在原价中间画直线
        yuanValueL.font = [UIFont systemFontOfSize:14];
        [self addSubview:yuanValueL];
        [yuanValueL release];
        
        self.timeL = [[UILabel alloc]initWithFrame:CGRectMake(90, 75, 70, 15)];
//        timeL.backgroundColor = [UIColor grayColor];
        timeL.textColor = [UIColor grayColor];
        timeL.font = [UIFont systemFontOfSize:12];
        [self addSubview:timeL];
        [timeL release];
        
        self.fangshiL = [[UILabel alloc]initWithFrame:CGRectMake(190, 55, 100, 15)];
        fangshiL.font = [UIFont systemFontOfSize:13];
        fangshiL.textAlignment = UITextAlignmentRight;
        [self addSubview:fangshiL];
        [fangshiL release];
        
        self.weizhiL = [[UILabel alloc]initWithFrame:CGRectMake(165, 75, 125, 15)];
//        weizhiL.backgroundColor = [UIColor grayColor];
        weizhiL.font = [UIFont systemFontOfSize:13];
        weizhiL.textAlignment = UITextAlignmentRight;
        [self addSubview:weizhiL];
        [weizhiL release];
        
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    [imageV release];
    [nameL release];
    [valueL release];
    [yuanValueL release];
    [timeL release];
    [fangshiL release];
    [weizhiL release];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
