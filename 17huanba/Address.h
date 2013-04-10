//
//  Address.h
//  17huanba
//
//  Created by Chen Hao on 13-3-11.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectTheAddress <NSObject>

-(void)SelectTheAddress:(NSDictionary *)addrDic;
//-(void)SelectTheAddress:(NSDictionary *)addrDic andID:(NSString *)addressID;
@end

@interface Address : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(retain,nonatomic)UITableView *addrTableView;
@property(retain,nonatomic)UIButton *selectedBtn;
@property(assign,nonatomic)BOOL isSelecte; //是否订单页面推出的选择收货地址页面  
@property(retain,nonatomic)NSMutableArray *addrArray;
@property(assign,nonatomic)id <SelectTheAddress>delegate;

@end
