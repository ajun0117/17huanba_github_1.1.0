//
//  Save_CartCell.m
//  17huanba
//
//  Created by Chen Hao on 13-3-1.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "Save_CartCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation Save_CartCell
@synthesize head,nameL,chengseL,fangshiL,accessBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.head= [[AsyncImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
        head.image = DEFAULTIMG;
        head.clipsToBounds = YES;
        head.layer.cornerRadius = 10; //头像显示圆形
        [self.contentView addSubview:head];
        [head release];
        
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 200, 15)];
        nameL.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:nameL];
        [nameL release];
        
        self.fangshiL = [[UILabel alloc]initWithFrame:CGRectMake(60, 35, 190, 15)];
        fangshiL.textAlignment = UITextAlignmentRight;
        fangshiL.font = [UIFont systemFontOfSize:13];
        fangshiL.textColor = [UIColor redColor];
        fangshiL.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:fangshiL];
        [fangshiL release];
        
        self.accessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        accessBtn.frame = CGRectMake(0, 0, 45, 20);
        accessBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [accessBtn setBackgroundImage:[UIImage imageNamed:@"cartBtn.png"] forState:UIControlStateNormal];
        self.accessoryView = accessBtn;
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    [head release];
    [nameL release];
    [chengseL release];
    [fangshiL release];
    [accessBtn release];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
