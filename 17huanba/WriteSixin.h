//
//  WriteSixin.h
//  17huanba
//
//  Created by Chen Hao on 13-3-15.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTextViewPlaceholder.h"
#import "PullingRefreshTableView.h"

@interface WriteSixin : UIViewController<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate,UIAlertViewDelegate>
{
    int page;
    BOOL isJilu; //是否是显示聊天记录
}
@property(retain,nonatomic)CPTextViewPlaceholder *myTextView; //说说文本视图
@property(retain,nonatomic)UILabel *textCountL;
@property(retain,nonatomic)UIButton *sendBtn;
@property(retain,nonatomic)UIImageView *toolView; //工具栏
@property(retain,nonatomic)PullingRefreshTableView *friendsTableView; //好友列表
@property(assign,nonatomic)BOOL refreshing;
@property(retain,nonatomic)NSMutableArray *friendsArray;
@property(retain,nonatomic)UITextField *toF;

@property(retain,nonatomic)PullingRefreshTableView *jiluTableView; //好友列表
@property(retain,nonatomic)NSMutableArray *jiluArray;

@property(retain,nonatomic)NSString *uname;
@property(retain,nonatomic)NSString *rmid;


@end
