//
//  NewAddress.m
//  17huanba
//
//  Created by Chen Hao on 13-3-13.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "NewAddress.h"
#import "ASIFormDataRequest.h"


#define ADD_Edit @"/phone/plogined/Optmyaddress.html"

@interface NewAddress ()

@end

@implementation NewAddress
@synthesize addressTableView;
@synthesize nameL,addressL,youbianL,phoneL;
@synthesize nameF,addressF,youbianF,phoneF;
@synthesize isNew,aid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //注册键盘出现和消失的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
        isNew = NO;
    }
    return self;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil]; //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    RELEASE_SAFELY(addressTableView);
    RELEASE_SAFELY(nameL);
    RELEASE_SAFELY(addressL);
    RELEASE_SAFELY(youbianL);
    RELEASE_SAFELY(phoneL);
    RELEASE_SAFELY(nameF);
    RELEASE_SAFELY(addressF);
    RELEASE_SAFELY(youbianF);
    RELEASE_SAFELY(phoneF);
    RELEASE_SAFELY(aid);
    [super dealloc];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    RELEASE_SAFELY(addressTableView);
    RELEASE_SAFELY(nameL);
    RELEASE_SAFELY(addressL);
    RELEASE_SAFELY(youbianL);
    RELEASE_SAFELY(phoneL);
    RELEASE_SAFELY(nameF);
    RELEASE_SAFELY(addressF);
    RELEASE_SAFELY(youbianF);
    RELEASE_SAFELY(phoneF);
    RELEASE_SAFELY(aid);
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
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(90, 10, 140, 24)];
    title.font=[UIFont boldSystemFontOfSize:20];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = UITextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.text = @"添加新地址";
    [navIV addSubview:title];
    [title release];
    [self.view addSubview:navIV];
    [navIV release];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(258, 10, 57, 27);
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"] forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(toSaveTheEdit) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:saveBtn];
    
    self.addressTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-44) style:UITableViewStyleGrouped];
    addressTableView.delegate = self;
    addressTableView.dataSource = self;
    [self.view addSubview:addressTableView];
    [addressTableView release];
//    addressTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg.png"]];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg.png"]];
    addressTableView.backgroundView = view;
    [view release];
    
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
    
    self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    nameL.textAlignment = UITextAlignmentCenter;
    nameL.backgroundColor = [UIColor clearColor];
    nameL.font = [UIFont systemFontOfSize:15];
    nameL.text = @"收货人姓名";
    
    self.nameF = [[UITextField alloc]initWithFrame:CGRectMake(90, 10, 220, 40)];
    nameF.placeholder = @"";
    nameF.inputAccessoryView = keyboardToolbar;
    nameF.delegate = self;
    nameF.tag = 1;
    [keyboardToolbar release];
    
    self.addressL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    addressL.textAlignment = UITextAlignmentCenter;
    addressL.backgroundColor = [UIColor clearColor];
    addressL.font = [UIFont systemFontOfSize:15];
    addressL.text = @"详细地址";
    
    self.addressF = [[UITextField alloc]initWithFrame:CGRectMake(90, 10, 220, 40)];
    addressF.inputAccessoryView = keyboardToolbar;
    addressF.delegate = self;
    addressF.tag = 2;
    [keyboardToolbar release];
    
    self.youbianL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    youbianL.textAlignment = UITextAlignmentCenter;
    youbianL.backgroundColor = [UIColor clearColor];
    youbianL.font = [UIFont systemFontOfSize:15];
    youbianL.text = @"邮政编码";
    
    self.youbianF = [[UITextField alloc]initWithFrame:CGRectMake(90, 10, 220, 40)];
    youbianF.inputAccessoryView = keyboardToolbar;
    youbianF.delegate = self;
    youbianF.tag = 3;
    [keyboardToolbar release];
    
    self.phoneL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    phoneL.textAlignment = UITextAlignmentCenter;
    phoneL.backgroundColor = [UIColor clearColor];
    phoneL.font = [UIFont systemFontOfSize:15];
    phoneL.text = @"联系电话";
    
    self.phoneF = [[UITextField alloc]initWithFrame:CGRectMake(90, 10, 220, 40)];
    phoneF.inputAccessoryView = keyboardToolbar;
    phoneF.delegate = self;
    phoneF.tag = 4;
    [keyboardToolbar release];
    
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
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
            if (indexPath.row == 0) {
            UIImageView *cellIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"release_list_top_.png"]];
            cell.backgroundView = cellIV;
            [cellIV release];
            
            [cell.contentView addSubview:nameL];
            [cell.contentView addSubview:nameF];
        }
            else if (indexPath.row == 1) {
        
            UIImageView *cellIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"release_list_bottom1_.png"]];
            cell.backgroundView = cellIV;
            [cellIV release];
            
            [cell.contentView addSubview:addressL];
            [cell.contentView addSubview:addressF];
        }
    }
    else{
            if (indexPath.row == 0) {
            UIImageView *cellIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"release_list_top_.png"]];
            cell.backgroundView = cellIV;
            [cellIV release];
            
            [cell.contentView addSubview:youbianL];
            [cell.contentView addSubview:youbianF];
        }
        else if (indexPath.row == 1) {
            UIImageView *cellIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"release_list_bottom1_.png"]];
            cell.backgroundView = cellIV;
            [cellIV release];
            
            [cell.contentView addSubview:phoneL];
            [cell.contentView addSubview:phoneF];
        }
    }
    
    return cell;
}

-(void)resignKeyboard{
    [nameF resignFirstResponder];
    [addressF resignFirstResponder];
    [youbianF resignFirstResponder];
    [phoneF resignFirstResponder];
}

#pragma mark - 键盘通知
-(void)keyboardWasShown:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
//    NSLog(@"----%@",NSStringFromCGSize(keyboardSize));
    addressTableView.frame = CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-keyboardSize.height);
}

- (void) keyboardWasHidden:(NSNotification *) notif{
    addressTableView.frame = CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-44);
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [addressTableView setContentOffset:CGPointMake(0,textField.tag*30) animated:YES];
}

#pragma mark - 编辑个人信息页面导航栏
-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 电话号码正则验证
-(BOOL)validatePhone:(NSString *)phone {
    NSString *phoneRegex = @"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [emailTest evaluateWithObject:phone];
}

#pragma mark - 邮政编码正则验证
-(BOOL)validateYoubian:(NSString *)youbian {
    NSString *youbianRegex = @"[1-9]\\d{5}(?!\\d)";
    NSPredicate *youbianTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", youbianRegex];
    return [youbianTest evaluateWithObject:youbian];
}

-(void)toSaveTheEdit{
    NSLog(@"保存提交更改过的个人信息");
    BOOL isPhone = [self validatePhone:phoneF.text];
    BOOL isYoubian = [self validateYoubian:youbianF.text];
    if (isPhone && isYoubian) {
        if (isNew) {
            [self submitTheNewAddressWithAction:@"add" isEdit:NO];
        }
        else{
            [self submitTheNewAddressWithAction:@"edit" isEdit:YES];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"邮编或联系电话格式不正确！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"是",nil];
        [alert show];
        [alert release];
    }
}

-(void)submitTheNewAddressWithAction:(NSString *)action isEdit:(BOOL)isEdit{
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSURL *newUrl = [NSURL URLWithString:THEURL(ADD_Edit)];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:token forKey:@"token"];
    [form_request setPostValue:action forKey:@"action"];
    if (isEdit) {
        [form_request setPostValue:aid forKey:@"aid"];
    }
    [form_request setPostValue:addressF.text forKey:@"address"];
    [form_request setPostValue:youbianF.text forKey:@"postcode"];
    [form_request setPostValue:phoneF.text forKey:@"tel"];
    [form_request setPostValue:nameF.text forKey:@"realname"];
    [form_request setDidFinishSelector:@selector(finishSubmitTheNewAddress:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startSynchronous];
}

-(void)finishSubmitTheNewAddress:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"修改后提交str     is     %@",str);
    [str release];

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求失败代理
-(void)loginFailed:(ASIHTTPRequest *)formRequest{
//    NSLog(@"formRequest.error-------------%@",formRequest.error);
    NSString *errorStr = [NSString stringWithFormat:@"%@",formRequest.error];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorStr delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
