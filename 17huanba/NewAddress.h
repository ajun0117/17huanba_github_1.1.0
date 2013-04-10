//
//  NewAddress.h
//  17huanba
//
//  Created by Chen Hao on 13-3-13.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewAddress : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(retain,nonatomic)UITableView *addressTableView;
@property(retain,nonatomic)UILabel *nameL;
@property(retain,nonatomic)UILabel *addressL;
@property(retain,nonatomic)UILabel *youbianL;
@property(retain,nonatomic)UILabel *phoneL;

@property(retain,nonatomic)UITextField *nameF;
@property(retain,nonatomic)UITextField *addressF;
@property(retain,nonatomic)UITextField *youbianF;
@property(retain,nonatomic)UITextField *phoneF;

@property(retain,nonatomic)NSString *aid;
@property(assign,nonatomic)BOOL isNew;


@end
 