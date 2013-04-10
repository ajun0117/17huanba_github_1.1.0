//
//  EditGerenXinxi.m
//  17huanba
//
//  Created by Chen Hao on 13-3-4.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "EditGerenXinxi.h"
#import <QuartzCore/QuartzCore.h>
#import "WeizhiSelect.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "SVProgressHUD.h"

#define THESEX @"男",@"女"
#define GETMY @"/phone/plogined/Getusinfo.html"
#define EDIT @"/phone/plogined/Editinfo.html"

@interface EditGerenXinxi ()

@end

@implementation EditGerenXinxi
@synthesize xinxiTableView;
@synthesize nichengF,trueNameF,nichengL,trueNameL,sexL,addressL;
//@synthesize manBtn,womenBtn;
@synthesize sexF,addressF;
@synthesize proviceArray,cityArray,regionArray;
@synthesize sexArray;
@synthesize head;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { 
        // Custom initialization
        //注册键盘出现和消失的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
        self.sexArray = [NSArray arrayWithObjects:THESEX, nil];
    } 
    return self;
}

-(void)dealloc{
    [super dealloc];
    [xinxiTableView release];
    [nichengL release];
    [trueNameL release];
    [sexL release];
    [addressL release];
    [nichengF release];
    [trueNameF release];
    RELEASE_SAFELY(sexF);
    RELEASE_SAFELY(addressF);
    RELEASE_SAFELY(proviceArray);
    RELEASE_SAFELY(cityArray);
    RELEASE_SAFELY(regionArray);
    RELEASE_SAFELY(sexArray);
    RELEASE_SAFELY(head);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil]; //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    self.xinxiTableView = nil;
    self.nichengL = nil;
    self.trueNameL = nil;
    self.sexL = nil;
    self.addressL = nil;
    self.nichengF  = nil;
    self.trueNameF = nil;
    RELEASE_SAFELY(sexF);
    RELEASE_SAFELY(addressF);
    RELEASE_SAFELY(proviceArray);
    RELEASE_SAFELY(cityArray);
    RELEASE_SAFELY(regionArray);
    RELEASE_SAFELY(sexArray);
    RELEASE_SAFELY(head);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImageView *navIV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_nav.png"]];
    navIV.userInteractionEnabled=YES;
    navIV.frame = CGRectMake(0, 0, 320, 44);
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(5, 10, 57, 27);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_gray_btn.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:backBtn];
    
    UILabel *nameL=[[UILabel alloc]initWithFrame:CGRectMake(90, 10, 140, 24)];
    nameL.font=[UIFont boldSystemFontOfSize:20];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.textAlignment = UITextAlignmentCenter;
    nameL.textColor = [UIColor whiteColor];
    nameL.text = @"基本信息";
    [navIV addSubview:nameL];
    [nameL release];
    [self.view addSubview:navIV];
    [navIV release];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(258, 10, 57, 27);
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"] forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(toSaveTheEdit) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:saveBtn];
    
    self.xinxiTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-44) style:UITableViewStyleGrouped];
    xinxiTableView.delegate = self;
    xinxiTableView.dataSource = self;
    [self.view addSubview:xinxiTableView];
    [xinxiTableView release];
//    xinxiTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg.png"]];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg.png"]];
    xinxiTableView.backgroundView = view;
    [view release];
    
    UIImageView *bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"edit_top_bg.png"]];
    bgIV.frame = CGRectMake(0, 0, 320, 100);
//    bgIV.backgroundColor = [UIColor grayColor];
    bgIV.userInteractionEnabled = YES;
    
    self.head = [[AsyncImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
    head.layer.cornerRadius = 5;
    head.image = DEFAULTIMG;
    [head addTarget:self action:@selector(changeHeadImage) forControlEvents:UIControlEventTouchUpInside];
    [bgIV addSubview:head];
    [head release];
    
    xinxiTableView.tableHeaderView = bgIV;
    [bgIV release];
    
    
    cityPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, KDeviceHeight-20-216, kDeviceWidth, 216)];
    cityPicker.dataSource = self;
    cityPicker.delegate = self;
    cityPicker.showsSelectionIndicator = YES;      // 这个弄成YES, picker中间就会有个条, 被选中的样子
    cityPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [self.view addSubview:cityPicker];
    service = [[sqlService alloc]init];
    self.proviceArray = [service getCityListByProvinceCode:@"0"];
    self.cityArray = [service getCityListByProvinceCode:[[proviceArray objectAtIndex:0] objectForKey:@"sCode"]];
    self.regionArray = [service getCityListByProvinceCode:[[cityArray objectAtIndex:0] objectForKey:@"sCode"]];
    proviceStr = [[proviceArray objectAtIndex:0] objectForKey:@"sName"];
    cityStr = [[cityArray objectAtIndex:0] objectForKey:@"sName"];
    regionStr = [[regionArray objectAtIndex:0] objectForKey:@"sName"];
    
    sexPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0,155+44*2+1 , kDeviceWidth, KDeviceHeight-20-150-44)];
    sexPicker.delegate = self;
    sexPicker.dataSource = self;
    sexPicker.showsSelectionIndicator = YES;
    sexPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
    keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", @"")
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(resignKeyboard)];
    [keyboardToolbar setItems:[NSArray arrayWithObjects:spaceBarItem,doneBarItem, nil]];
    [spaceBarItem release];
    [doneBarItem release];
    
    self.nichengL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    nichengL.textAlignment = UITextAlignmentCenter;
    nichengL.backgroundColor = [UIColor clearColor];
    nichengL.text = @"*昵称";
    
    self.nichengF = [[UITextField alloc]initWithFrame:CGRectMake(90, 10, 220, 40)];
    nichengF.inputAccessoryView = keyboardToolbar;
    nichengF.delegate = self;
    nichengF.tag = 1;
    [keyboardToolbar release];
    
    self.trueNameL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    trueNameL.textAlignment = UITextAlignmentCenter;
    trueNameL.backgroundColor = [UIColor clearColor];
    trueNameL.text = @"真实姓名";
    
    self.trueNameF = [[UITextField alloc]initWithFrame:CGRectMake(90, 10, 220, 40)];
    trueNameF.inputAccessoryView = keyboardToolbar;
    trueNameF.delegate = self;
    trueNameF.tag = 2;
    [keyboardToolbar release];
    
    self.sexL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    sexL.textAlignment = UITextAlignmentCenter;
    sexL.backgroundColor = [UIColor clearColor];
    sexL.text = @"*性别";
    
    self.sexF = [[UITextField alloc]initWithFrame:CGRectMake(90, 10, 220, 40)];
    sexF.placeholder = @"请选择性别";
    sexF.inputView = sexPicker;
    sexF.inputAccessoryView = keyboardToolbar;
    sexF.delegate = self;
    sexF.tag = 3;
    [keyboardToolbar release];
    
    self.addressL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    addressL.textAlignment = UITextAlignmentCenter;
    addressL.backgroundColor = [UIColor clearColor];
    addressL.text = @"*现居地";
    
    self.addressF = [[UITextField alloc]initWithFrame:CGRectMake(90, 10, 220, 40)];
    addressF.placeholder = @"请选择居住地";
    addressF.inputView = cityPicker;
    addressF.inputAccessoryView = keyboardToolbar;
    addressF.delegate = self;
    addressF.tag = 4;
    [keyboardToolbar release];
    
    [self getMyXinxi];
}

#pragma mark - 获取当前用户信息
-(void)getMyXinxi{
    [SVProgressHUD showWithStatus:@"加载中.."];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSURL *newUrl = [NSURL URLWithString:THEURL(GETMY)];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:token forKey:@"token"];
    [form_request setDidFinishSelector:@selector(finishGetMyXinxi:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}

-(void)finishGetMyXinxi:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"个人信息  str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSDictionary *dataDic = [dic objectForKey:@"data"];
    NSDictionary *userInfoDic = [dataDic objectForKey:@"usinfo"];
    
    NSString *urlStr = [userInfoDic objectForKey:@"headimg"];
    if (![urlStr isEqualToString:@" "]) {
        head.urlString = THEURL(urlStr);
    }
    nichengF.text = [userInfoDic objectForKey:@"uname"];
    trueNameF.text = [userInfoDic objectForKey:@"realname"];
    NSString *sexStr = [userInfoDic objectForKey:@"sex"];
    if ([sexStr isEqualToString:@"1"]) {
        sexF.text = @"男";
    }
    else{
        sexF.text = @"女";
    }
    addressF.text = SHENG_SHI_XIAN([userInfoDic objectForKey:@"sheng"], [userInfoDic objectForKey:@"shi"], [userInfoDic objectForKey:@"xian"]);
    
    NSLog(@"00000111110000%@",[userInfoDic objectForKey:@"localaddress"]);
    [SVProgressHUD dismiss];
}

#pragma mark - 请求失败代理
-(void)loginFailed:(ASIHTTPRequest *)formRequest{
    NSLog(@"formRequest.error-------------%@",formRequest.error);
    NSString *errorStr = [NSString stringWithFormat:@"%@",formRequest.error];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorStr delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)resignKeyboard{
    [nichengF resignFirstResponder];
    [trueNameF resignFirstResponder];
    [sexF resignFirstResponder];
    [addressF resignFirstResponder];
}

#pragma mark - 键盘通知
-(void)keyboardWasShown:(NSNotification *) notif{
    
//    [self._tableV setContentOffset:CGPointMake(0,textField.tag*30) animated:YES];
    
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"----%@",NSStringFromCGSize(keyboardSize));
    xinxiTableView.frame = CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-keyboardSize.height);
}

- (void) keyboardWasHidden:(NSNotification *) notif{
    xinxiTableView.frame = CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-44);
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [xinxiTableView setContentOffset:CGPointMake(0,textField.tag*50) animated:YES];
}

#pragma mark - UItableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 30;
    }
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *headV = [[UIView alloc]init];
        headV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"section_bar.png"]];
        
        UILabel *noticeL = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 150, 20)];
        noticeL.backgroundColor = [UIColor clearColor];
        noticeL.font = [UIFont systemFontOfSize:15];
        noticeL.text = @"带*号的为必填项";
        [headV addSubview:noticeL];
        [noticeL release];

        return [headV autorelease];
    }
    return nil;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
        UIImageView *cellIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"release_list_top_.png"]];
        cell.backgroundView = cellIV;
        [cellIV release];
        
        [cell.contentView addSubview:nichengL];
        [cell.contentView addSubview:nichengF];
        }
        else {
            
            UIImageView *cellIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"release_list_bottom1_.png"]];
            cell.backgroundView = cellIV;
            [cellIV release];
            
            [cell.contentView addSubview:trueNameL];
            [cell.contentView addSubview:trueNameF];
        }
    }
    else{
        if (indexPath.row == 0) {
        UIImageView *cellIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"release_list_top_.png"]];
        cell.backgroundView = cellIV;
        [cellIV release];
        
        [cell.contentView addSubview:sexL];
        [cell.contentView addSubview:sexF];
    }
        else if (indexPath.row == 1) {
            UIImageView *cellIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"release_list_bottom1_.png"]];
            cell.backgroundView = cellIV;
            [cellIV release];
            
            [cell.contentView addSubview:addressL];
            [cell.contentView addSubview:addressF];
        }
    }
    return cell;
}


-(void)changeHeadImage{
    NSLog(@"更改头像");
        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"请选择照片获取方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"图片库", nil];
        action.actionSheetStyle = UIActionSheetStyleBlackTranslucent;//样式黑色半透明
        [action showInView:self.view];
        [action release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 0)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//照片来源为相机
            imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            
            [self presentModalViewController:imagePicker animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该设备没有照相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
    if(buttonIndex == 1)
    {
        imagePicker = [[UIImagePickerController alloc] init];//图像选取器
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//打开相册
        imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;//过渡类型,有四种
        imagePicker.allowsEditing = YES;//开启对图片进行编辑
        
        [self presentModalViewController:imagePicker animated:YES];//打开模态视图控制器选择图像
    }
}

#pragma mark - UIImagePickerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self dismissModalViewControllerAnimated:YES];//关闭模态视图控制器
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage *theImage = [self yasuoCameraImage:image];
        
        head.image = theImage;
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//将拍到的图片保存到相册
    }
    else{
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        UIImage *theImage = [self yasuoCameraImage:image];
        head.image = theImage;
    }
}

-(UIImage *)yasuoCameraImage:(UIImage *)image{
    int size = 204800;
    int current_size = 0;
    int actual_size = 0;
    NSData *imgData1 = UIImageJPEGRepresentation(image, 1.0);
    current_size = [imgData1 length];
    if (current_size > size) {
        actual_size = size/current_size;
        imgData1 = UIImageJPEGRepresentation(image, actual_size);
    }
    UIImage *theImage = [UIImage imageWithData:imgData1];
    return theImage; //返回压缩后的图片
}



#pragma mark - 编辑个人信息页面导航栏
-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)toSaveTheEdit{
    [SVProgressHUD showWithStatus:@"正在保存修改到服务器.."];
    NSLog(@"保存提交更改过的个人信息");
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
   
    NSURL *newUrl = [NSURL URLWithString:THEURL(EDIT)];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    
    int size = 204800;
    int current_size = 0;
    int actual_size = 0;
    
    NSData *data = UIImageJPEGRepresentation(head.image, 1.0); //头像
    current_size = [data length];
    if (current_size > size) {
        actual_size = size/current_size;
        data = UIImageJPEGRepresentation(head.image, actual_size);
    }
//    [form_request addData:data forKey:@"headimg"];
    [form_request addData:data withFileName:@"headimg.jpg" andContentType:@"image/jpeg" forKey:@"headimg"];

    
    [form_request setPostValue:token forKey:@"token"];
    [form_request setPostValue:nichengF.text forKey:@"name"];
    [form_request setPostValue:trueNameF.text forKey:@"realname"];
    if ([sexF.text isEqualToString:@"男"]) {
        [form_request setPostValue:@"1" forKey:@"sex"];
    }
    else{
        [form_request setPostValue:@"2" forKey:@"sex"];
    }
    
    NSArray *weizhiArray = [addressF.text componentsSeparatedByString:@" "];
    NSString *shengStr = [weizhiArray objectAtIndex:0];
    NSString *shiStr = [weizhiArray objectAtIndex:1];
    NSString *xianStr = [weizhiArray objectAtIndex:2];
    
    [form_request setPostValue:shengStr forKey:@"sheng"];
    [form_request setPostValue:shiStr forKey:@"shi"];
    [form_request setPostValue:xianStr forKey:@"xian"];
    [form_request setDidFinishSelector:@selector(finishEdit:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}

-(void)finishEdit:(ASIHTTPRequest *)request{ //请求成功后的方法
    [SVProgressHUD dismiss];
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"str     is     %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSLog(@"array is %@",dic);
    NSString *info = [dic objectForKey:@"info"];
    NSLog(@"info-----%@",info);
//    NSArray *array = [str JSONValue];
//    NSLog(@"array is %@",array);
//    [timeLineArray addObjectsFromArray:array];
//    [timeLineTable reloadData];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:info delegate:self cancelButtonTitle:nil otherButtonTitles:@"是",nil];
    [alert show];
    [alert release];
}


#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == cityPicker) {
        NSString *str = @"";
        if (component == 0) {
            return [[proviceArray objectAtIndex:row] objectForKey:@"sName"];
        }
        if (component == 1) {
            return [[cityArray objectAtIndex:row]objectForKey:@"sName"];
        }
        if (component == 2) {
            if ([regionArray count]>0) {
                return regionStr = [[regionArray objectAtIndex:row] objectForKey:@"sName"];
            }
            else{
                return @"";
            }
        }
        return str;
    }
    else{
        return [sexArray objectAtIndex:row];
    }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == cityPicker) {
        if (component == 0) {
            self.cityArray = [service getCityListByProvinceCode:[[proviceArray objectAtIndex:row] objectForKey:@"sCode"]];
            [cityPicker reloadComponent:1];
            self.regionArray = [service getCityListByProvinceCode:[[cityArray objectAtIndex:0] objectForKey:@"sCode"]];
            [cityPicker reloadComponent:2];
            
            proviceStr = [[proviceArray objectAtIndex:row] objectForKey:@"sName"];
            cityStr = [[cityArray objectAtIndex:0] objectForKey:@"sName"];
            
            [cityPicker selectRow:0 inComponent:1 animated:YES];
            if ([cityArray count]>1) {
                [cityPicker selectRow:0 inComponent:2 animated:YES];
            }
            if ([regionArray count]>0) {
                regionStr = [[regionArray objectAtIndex:0] objectForKey:@"sName"];
            }
            else{
                regionStr = @"";
            }
        }
        else if (component == 1) {
            self.regionArray = [service getCityListByProvinceCode:[[cityArray objectAtIndex:row] objectForKey:@"sCode"]];
            [cityPicker reloadComponent:2];
            cityStr = [[cityArray objectAtIndex:row] objectForKey:@"sName"];
            if ([cityArray count]>1) {
                [cityPicker selectRow:0 inComponent:2 animated:YES];
            }
            if ([regionArray count]>0) {
                regionStr = [[regionArray objectAtIndex:0] objectForKey:@"sName"];
            }
            
        }
        else{
            if ([regionArray count]>0) {
                regionStr = [[regionArray objectAtIndex:row] objectForKey:@"sName"];
            }
            //第三栏可能没有数据  
        }
        addressF.text = [NSString stringWithFormat:@"%@ %@ %@",proviceStr,cityStr,regionStr];
    }
    else{
        sexF.text = [sexArray objectAtIndex:row];
    }
}
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == cityPicker) {
        return 3;
    }
    else
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == cityPicker) {
        if (component == 0) {
            return [proviceArray count];
        }
        if (component == 1) {
            return [cityArray count];
        }
        if (component == 2) {
            return [regionArray count];
        }
        return 0;
    }
    else{
        return [sexArray count];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
