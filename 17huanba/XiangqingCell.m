//
//  XiangqingCell.m
//  一起换吧
//
//  Created by Chen Hao on 13-4-19.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

/*
 @property(retain,nonatomic)AsyncImageView *gdimg;
 @property(retain,nonatomic)UILabel *nameL;
 @property(retain,nonatomic)UILabel *bianhaoL; //订单编号
 @property(retain,nonatomic)UILabel *addressL; //收货地址
 @property(retain,nonatomic)UILabel *realNameL; //收货人
 @property(retain,nonatomic)UILabel *phoneL; //联系方式
 @property(retain,nonatomic)UILabel *youBianL; //邮政编码
 @property(retain,nonatomic)UILabel *liuYanL; //留言
 @property(retain,nonatomic)UILabel *yunfeiL; //运费
 @property(retain,nonatomic)UILabel *kuaidiL; //快递公司
 @property(retain,nonatomic)UILabel *danhaoL; //快递单号
 */

#import "XiangqingCell.h"

@implementation XiangqingCell
@synthesize gdimg,nameL,bianhaoL,addressL,realNameL,phoneL,youBianL,liuYanL,yunfeiL,kuaidiL,danhaoL;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.gdimg = [[AsyncImageView alloc]initWithFrame:CGRectMake(5, 12, 80, 80)];
        gdimg.image = DEFAULTIMG;
        gdimg.clipsToBounds = YES;
        gdimg.userInteractionEnabled = NO;
        gdimg.layer.cornerRadius = 10; //头像显示圆角
        [self addSubview:gdimg];
        [gdimg release];
        
        self.bianhaoL = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 220, 20)];
        bianhaoL.font = [UIFont systemFontOfSize:12];
        bianhaoL.backgroundColor = [UIColor clearColor];
        [self addSubview:bianhaoL];
        [bianhaoL release];
        
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(90, 30, 220, 20)];
        nameL.backgroundColor = [UIColor clearColor];
        [self addSubview:nameL];
        [nameL release];
        
        
        self.addressL = [[UILabel alloc]initWithFrame:CGRectMake(90, 55, 220, 30)];
        addressL.lineBreakMode = UILineBreakModeCharacterWrap;
        addressL.numberOfLines = 2;
        addressL.font = [UIFont systemFontOfSize:12];
        addressL.backgroundColor = [UIColor clearColor];
        [self addSubview:addressL];
        [addressL release];
        
        self.realNameL = [[UILabel alloc]initWithFrame:CGRectMake(90, 90, 220, 15)];
        realNameL.font = [UIFont systemFontOfSize:12];
        realNameL.backgroundColor = [UIColor clearColor];
        [self addSubview:realNameL];
        [realNameL release];
        
        self.phoneL = [[UILabel alloc]initWithFrame:CGRectMake(90, 110, 220, 15)];
        phoneL.font = [UIFont systemFontOfSize:12];
        phoneL.backgroundColor = [UIColor clearColor];
        [self addSubview:phoneL];
        [phoneL release];
        
        self.youBianL = [[UILabel alloc]initWithFrame:CGRectMake(90, 130, 220, 15)];
        youBianL.font = [UIFont systemFontOfSize:12];
        youBianL.backgroundColor = [UIColor clearColor];
        [self addSubview:youBianL];
        [youBianL release];
        
        self.liuYanL = [[UILabel alloc]initWithFrame:CGRectMake(90, 150, 220, 15)];
        liuYanL.font = [UIFont systemFontOfSize:12];
        liuYanL.backgroundColor = [UIColor clearColor];
        [self addSubview:liuYanL];
        [liuYanL release];
        
        self.yunfeiL = [[UILabel alloc]initWithFrame:CGRectMake(90, 170, 220, 15)];
        yunfeiL.font = [UIFont systemFontOfSize:12];
        yunfeiL.backgroundColor = [UIColor clearColor];
        [self addSubview:yunfeiL];
        [yunfeiL release];
        
        self.kuaidiL = [[UILabel alloc]initWithFrame:CGRectMake(90, 190, 220, 15)];
        kuaidiL.font = [UIFont systemFontOfSize:12];
        kuaidiL.backgroundColor = [UIColor clearColor];
        [self addSubview:kuaidiL];
        [kuaidiL release];
        
        self.danhaoL = [[UILabel alloc]initWithFrame:CGRectMake(90, 210, 220, 15)];
        danhaoL.font = [UIFont systemFontOfSize:12];
        danhaoL.backgroundColor = [UIColor clearColor];
        [self addSubview:danhaoL];
        [danhaoL release];
        
    }
    return self;
}

-(void)dealloc{
    [gdimg release];
    [nameL release];
    [bianhaoL release];
    [addressL release];
    [realNameL release];
    [phoneL release];
    [youBianL release];
    [liuYanL release];
    [yunfeiL release];
    [kuaidiL release];
    [danhaoL release];
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
