//
//  FriendTimeLineCell.m
//  17huanba
//
//  Created by Chen Hao on 13-3-12.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "FriendTimeLineCell.h"

@implementation FriendTimeLineCell
@synthesize head,uNameL,gNameL,titleL,gImage,timeL,shareBtn,pingBtn;
@synthesize sayWeb;


-(void)dealloc{
    [super dealloc];
    RELEASE_SAFELY(head);
    RELEASE_SAFELY(uNameL);
    RELEASE_SAFELY(gNameL);
    RELEASE_SAFELY(titleL);
    RELEASE_SAFELY(gImage);
    RELEASE_SAFELY(timeL);
    RELEASE_SAFELY(shareBtn);
    RELEASE_SAFELY(pingBtn);
    RELEASE_SAFELY(sayWeb);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.head = [[AsyncImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
        head.image = DEFAULTIMG;
        [self addSubview:head];
        [head release];
        
        self.uNameL = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 200, 20)];
        uNameL.backgroundColor = [UIColor clearColor];
        [self addSubview:uNameL];
        [uNameL release];
        
        self.gNameL = [[UILabel alloc]initWithFrame:CGRectZero];
        gNameL.backgroundColor = [UIColor clearColor];
        gNameL.font = [UIFont systemFontOfSize:13];
        [self addSubview:gNameL];
        [gNameL release];
        
        self.titleL = [[UILabel alloc]initWithFrame:CGRectZero];
        titleL.backgroundColor = [UIColor clearColor];
        titleL.font = [UIFont systemFontOfSize:13];
        [self addSubview:titleL];
        [titleL release];
        
        self.sayWeb = [[UIWebView alloc]initWithFrame:CGRectZero];
//        sayWeb.userInteractionEnabled = NO;
        sayWeb.backgroundColor = [UIColor clearColor];
        [self addSubview:sayWeb];
        [sayWeb release];
        
        self.gImage = [[AsyncImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:gImage];
        [gImage release];
        
        self.timeL = [[UILabel alloc]initWithFrame:CGRectZero];
        timeL.backgroundColor = [UIColor clearColor];
        timeL.font = [UIFont systemFontOfSize:12];
        [self addSubview:timeL];
        [timeL release];
        
        self.shareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self addSubview:shareBtn];
        
        self.pingBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self addSubview:pingBtn];
        
    }
    return self;
}

- (void)prepareForReuse //重用表单元格前调用的方法
{
    self.gNameL.frame = CGRectZero;
    self.titleL.frame = CGRectZero;
    self.sayWeb.frame = CGRectZero;
    self.gImage.frame = CGRectZero;
    self.timeL.frame = CGRectZero;
    self.shareBtn.frame = CGRectZero;
    self.pingBtn.frame = CGRectZero;
    [super prepareForReuse];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
