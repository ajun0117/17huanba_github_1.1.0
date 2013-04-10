//
//  FriendsCell.h
//  17huanba
//
//  Created by Chen Hao on 13-3-1.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface FriendsCell : UITableViewCell
@property(retain,nonatomic)AsyncImageView *head;
@property(retain,nonatomic)UILabel *nameL;
@property(retain,nonatomic)UILabel *genderL;
@property(retain,nonatomic)UIImageView *list_bgIV; //好友列表
@property(retain,nonatomic)UIImageView *fa_bgIV; //发出的申请
@property(retain,nonatomic)UIImageView *shou1_bgIV; //收到的申请
@property(retain,nonatomic)UIImageView *shou2_bgIV; //收到的申请
@property(retain,nonatomic)UILabel *weizhiL;

@end
