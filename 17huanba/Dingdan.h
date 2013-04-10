//
//  Dingdan.h
//  17huanba
//
//  Created by Chen Hao on 13-1-24.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "Address.h"


@interface Dingdan : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,SelectTheAddress,UITextFieldDelegate>
{
    UIPickerView *youfeiPicker;
    UIPickerView *zhifufangshiPicker;
//    NSDictionary *dataDic; //登陆用户信息
}
@property(retain,nonatomic)UITableView *dingdanTableView;
@property(retain,nonatomic)AsyncImageView *goodsImg;
@property(retain,nonatomic)UILabel *goodsL;
@property(retain,nonatomic)UILabel *youfeiL;
@property(retain,nonatomic)UITextField *youfeiF;
@property(retain,nonatomic)UILabel *zhifufangshiL;
@property(retain,nonatomic)UITextField *zhifufangshiF;
@property(retain,nonatomic)UILabel *querenL;
@property(retain,nonatomic)UILabel *addressL;
@property(retain,nonatomic)UILabel *beizhuL;
@property(retain,nonatomic)UITextField *beizhuF;
@property(retain,nonatomic)UILabel *jiaoyimaL;
@property(retain,nonatomic)UITextField *jiaoyimaF;
@property(retain,nonatomic)UIButton *sendBtn;
@property(retain,nonatomic)NSArray *youfeiArray;
@property(retain,nonatomic)NSMutableArray *zhifufangshiArray;
@property(retain,nonatomic)NSArray *memoArray;

@property(retain,nonatomic)UIButton *sureBtn;
@property(retain,nonatomic)NSDictionary *userDic;
@property(retain,nonatomic)NSDictionary *goodsDic;

@property(retain,nonatomic)NSString *gidStr; //商品ID
@property(retain,nonatomic)NSString *jiaoyimaStr;

@property(retain,nonatomic)NSString *memoID; //交换物品ID
@property(retain,nonatomic)NSString *devali; //邮费类型

@property(retain,nonatomic)NSString *addressID; //邮寄地址ID


@end
