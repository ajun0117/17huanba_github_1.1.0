//
//  EditGerenXinxi.h
//  17huanba
//
//  Created by Chen Hao on 13-3-4.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlService.h"
#import "AsyncImageView.h"

@interface EditGerenXinxi : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    UIImagePickerController *imagePicker;
    UIPickerView *cityPicker;
    UIPickerView *sexPicker;
    NSMutableArray *proviceArray,*cityArray,*regionArray;
    sqlService *service;
    NSString *proviceStr,*cityStr,*regionStr;
}
@property(retain,nonatomic)UITableView *xinxiTableView;
@property(retain,nonatomic)AsyncImageView *head;
@property(retain,nonatomic)UILabel *nichengL;
@property(retain,nonatomic)UILabel *trueNameL;
@property(retain,nonatomic)UILabel *sexL;
@property(retain,nonatomic)UILabel *addressL;

@property(retain,nonatomic)UITextField *nichengF;
@property(retain,nonatomic)UITextField *trueNameF;
@property(retain,nonatomic)UITextField *sexF;
@property(retain,nonatomic)UITextField *addressF;
//@property(retain,nonatomic)UIButton *manBtn;
//@property(retain,nonatomic)UIButton *womenBtn;
//@property(retain,nonatomic)UIButton *addressBtn;

@property(nonatomic,retain)NSMutableArray *proviceArray,*cityArray,*regionArray;
@property(nonatomic,retain)NSArray *sexArray;

//@property(nonatomic,retain)NSDictionary *userInfoDic;

@end
