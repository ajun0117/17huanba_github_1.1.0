//
//  Zhuce.m
//  17huanba
//
//  Created by Chen Hao on 13-2-28.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "Zhuce.h"

@interface Zhuce ()

@end

@implementation Zhuce
@synthesize email,password,rePassword,nameF,sexF,zhuce_request,tongyiBtn;
@synthesize sexArray,bgIV;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //注册键盘出现和消失的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
        self.sexArray = [NSArray arrayWithObjects:@"男",@"女", nil];
        
    }
    return self;
}

-(void)dealloc{
    [zhuce_request clearDelegatesAndCancel];
    RELEASE_SAFELY(zhuce_request);
    RELEASE_SAFELY(email);
    RELEASE_SAFELY(password);
    RELEASE_SAFELY(rePassword);
    RELEASE_SAFELY(nameF);
    RELEASE_SAFELY(sexF);
    RELEASE_SAFELY(sexArray);
    RELEASE_SAFELY(bgIV);
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImageView *navIV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_nav.png"]];
    navIV.userInteractionEnabled=YES;
    navIV.frame = CGRectMake(0, 0, 320, 44);
    [self.view addSubview:navIV];
    [navIV release];
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(5, 10, 57, 27);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [backBtn setTitle:@"去登陆" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:backBtn];
    
    UILabel *nameL=[[UILabel alloc]initWithFrame:CGRectMake(90, 10, 140, 24)];
    nameL.font=[UIFont boldSystemFontOfSize:17];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.textAlignment = UITextAlignmentCenter;
    nameL.textColor = [UIColor whiteColor];
    nameL.text = @"注册";
    [navIV addSubview:nameL];
    [nameL release];
    
    UIButton *zhuceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    zhuceBtn.frame=CGRectMake(258, 10, 57, 27);
    [zhuceBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"] forState:UIControlStateNormal];
    zhuceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [zhuceBtn setTitle:@"注册" forState:UIControlStateNormal];
    [zhuceBtn addTarget:self action:@selector(toZhuce) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:zhuceBtn];
    
    self.bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_bg.png"]];
    bgIV.frame = CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-44);
    bgIV.userInteractionEnabled = YES;
    [self.view addSubview:bgIV];
    [bgIV release];
    
    UIImageView *whiteIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_gray2_bg.png"]];
    whiteIV.frame = CGRectMake(5, 10, 310, 325);
    whiteIV.userInteractionEnabled = YES;
    whiteIV.tag = 100;
    [bgIV addSubview:whiteIV];
    [whiteIV release];
    
    sexPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0,155+44*2+1 , kDeviceWidth, KDeviceHeight-20-150-44)];
    sexPicker.delegate = self;
    sexPicker.dataSource = self;
    sexPicker.showsSelectionIndicator = YES;
    
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
    
    self.email = [[UITextField alloc]initWithFrame:CGRectMake(50, 30, 210, 30)];
    email.delegate = self;
    email.clearButtonMode = UITextFieldViewModeWhileEditing;
    email.borderStyle = UITextBorderStyleRoundedRect;
    email.font = [UIFont systemFontOfSize:15];
    email.placeholder = @"邮箱";
    email.tag = 1;
    email.inputAccessoryView = keyboardToolbar;
    email.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [whiteIV addSubview:email];
    [email release];
    email.keyboardType = UIKeyboardTypeEmailAddress;
    
    self.password = [[UITextField alloc]initWithFrame:CGRectMake(50, 65, 210, 30)];
    password.delegate = self;
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    password.secureTextEntry = YES;
    password.borderStyle = UITextBorderStyleRoundedRect;
    password.font = [UIFont systemFontOfSize:15];
    password.placeholder = @"密码";
    password.tag = 2;
    password.inputAccessoryView = keyboardToolbar;
    password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [whiteIV addSubview:password];
    [password release];
    
    self.rePassword = [[UITextField alloc]initWithFrame:CGRectMake(50, 100, 210, 30)];
    rePassword.delegate = self;
    rePassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    rePassword.secureTextEntry = YES;
    rePassword.borderStyle = UITextBorderStyleRoundedRect;
    rePassword.font = [UIFont systemFontOfSize:15];
    rePassword.placeholder = @"确认密码";
    rePassword.tag = 3;
    rePassword.inputAccessoryView = keyboardToolbar;
    rePassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [whiteIV addSubview:rePassword];
    [rePassword release];
    
    self.nameF = [[UITextField alloc]initWithFrame:CGRectMake(50, 135, 210, 30)];
    nameF.delegate = self;
    nameF.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameF.borderStyle = UITextBorderStyleRoundedRect;
    nameF.font = [UIFont systemFontOfSize:15];
    nameF.placeholder = @"用户名";
    nameF.tag = 4;
    nameF.inputAccessoryView = keyboardToolbar;
    nameF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [whiteIV addSubview:nameF];
    [nameF release];
    
    self.sexF = [[UITextField alloc]initWithFrame:CGRectMake(50, 170, 210, 30)];
    sexF.delegate = self;
    sexF.clearButtonMode = UITextFieldViewModeWhileEditing;
    sexF.borderStyle = UITextBorderStyleRoundedRect;
    sexF.font = [UIFont systemFontOfSize:15];
    sexF.placeholder = @"性别";
    sexF.tag = 5;
    sexF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    sexF.inputView = sexPicker;
    sexF.inputAccessoryView = keyboardToolbar;
    [keyboardToolbar release];
    [whiteIV addSubview:sexF];
    [sexF release];
    
//    self.phoneF = [[UITextField alloc]initWithFrame:CGRectMake(50, 205, 210, 30)];
//    phoneF.delegate = self; 
//    phoneF.clearButtonMode = UITextFieldViewModeWhileEditing;
//    phoneF.keyboardType = UIKeyboardTypeNumberPad;
//    phoneF.borderStyle = UITextBorderStyleRoundedRect;
//    phoneF.font = [UIFont systemFontOfSize:15];
//    phoneF.placeholder = @"手机号码";
//    phoneF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    [whiteIV addSubview:phoneF];
//    [phoneF release];
    
    self.tongyiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tongyiBtn.frame = CGRectMake(50, 205, 15, 15);
    [tongyiBtn setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    [tongyiBtn setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateSelected];
    [tongyiBtn addTarget:self action:@selector(tongyiBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
    [whiteIV addSubview:tongyiBtn];
    
    UILabel *rememberL = [[UILabel alloc]initWithFrame:CGRectMake(65, 205, 200, 13)];
    rememberL.font = [UIFont systemFontOfSize:13];
    rememberL.backgroundColor = [UIColor clearColor];
    rememberL.text = @"已经阅读并同意《一起换吧条款》";
    [whiteIV addSubview:rememberL];
    [rememberL release];
    
    UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(50, 220, 210, 80)];
    [bgIV addSubview:scrollV];
    [scrollV release];
}

-(void)tongyiBtnSelect:(UIButton *)sender{
    NSLog(@"rememberBtnSelect:");
    if (sender.selected) {
        sender.selected = NO;
    }
    else{
        sender.selected = YES; //同意条款
    }
}


-(void)toZhuce{
    NSLog(@"注册按钮！");
    if (tongyiBtn.selected) {
        NSURL *loginUrl = [NSURL URLWithString:THEURL(@"     ")];
        
        self.zhuce_request = [ASIFormDataRequest requestWithURL:loginUrl];
        [zhuce_request setDelegate:self];
        [zhuce_request setPostValue:email.text forKey:@"email"];
        [zhuce_request setPostValue:password.text forKey:@"password"];
        [zhuce_request setPostValue:nameF.text forKey:@"name"];
        [zhuce_request setPostValue:sexF.text forKey:@"sex"];
        [zhuce_request setDidFinishSelector:@selector(loginSucceed:)];
        [zhuce_request setDidFailSelector:@selector(loginFailed:)];
        [zhuce_request startAsynchronous];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"您必须阅读并同意《一起换吧条款》才能继续！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void)loginSucceed:(ASIHTTPRequest *) formRequest
{
    NSLog(@"Succe login  ! ");
}

-(void)loginFailed:(ASIHTTPRequest *)formRequest{
    NSLog(@"formRequest.error-------------%@",formRequest.error);
    NSString *errorStr = [NSString stringWithFormat:@"%@",formRequest.error];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorStr delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
    [alert release];
}


#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
        return [sexArray objectAtIndex:row];
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
        sexF.text = [sexArray objectAtIndex:row];
}
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
        return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
        return [sexArray count];
}

#pragma mark - 文本框代理方法
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == email) {
        BOOL isEmail = [self validateEmail:email.text];
        if (! isEmail) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"邮箱格式不正确！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    else if(textField == rePassword){
        if (! [password.text isEqualToString:rePassword.text]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"两次输入的密码不一致！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
//    else if(textField == phoneF){
//        BOOL isPhone = [self validatePhone:phoneF.text];
//        if (! isPhone) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"手机号码格式不正确！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
//            [alert show];
//            [alert release];
//        }
//    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    bgIV.frame = CGRectMake(0, 44-textField.tag*15, kDeviceWidth, KDeviceHeight-20-44);
}

#pragma mark - 键盘通知
-(void)keyboardWasShown:(NSNotification *) notif{
//
//    //    [self._tableV setContentOffset:CGPointMake(0,textField.tag*30) animated:YES];
//    
//    NSDictionary *info = [notif userInfo];
//    
//    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
//    CGSize keyboardSize = [value CGRectValue].size;
//    NSLog(@"----%@",NSStringFromCGSize(keyboardSize));
//    bgIV.frame = CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-keyboardSize.height);
}

- (void) keyboardWasHidden:(NSNotification *) notif{
    bgIV.frame = CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-44);
}

-(void)resignKeyboard{
    [email resignFirstResponder];
    [password resignFirstResponder];
    [rePassword resignFirstResponder];
    [nameF resignFirstResponder];
    [sexF resignFirstResponder];
}


#pragma mark - 邮箱正则验证
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

#pragma mark - 电话号码正则验证
-(BOOL)validatePhone:(NSString *)phone {
    NSString *phoneRegex = @"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [emailTest evaluateWithObject:phone];
}


-(void)fanhui{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
