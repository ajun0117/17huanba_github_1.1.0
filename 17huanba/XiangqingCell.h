//
//  XiangqingCell.h
//  一起换吧
//
//  Created by Chen Hao on 13-4-19.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface XiangqingCell : UITableViewCell
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

@end
