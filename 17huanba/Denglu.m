//
//  Denglu.m
//  17huanba
//
//  Created by Chen Hao on 13-2-28.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "Denglu.h"
#import "Zhuce.h"
#import "MD5.h"
#import "SHA1.h"
#import "JSON.h"
#import "Message.h"
#import "Zhuye.h"

//#define LOGIN @"http://192.168.0.104:801/phone/default/detail.html"

@interface Denglu ()

@end

@implementation Denglu
@synthesize email,password;
@synthesize rememberBtn,autoLoginBtn;
@synthesize login_request;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    [login_request clearDelegatesAndCancel];
    [login_request release];
    [email release];
    [password release];
    [rememberBtn release];
    [autoLoginBtn release];
    
    [super dealloc];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    self.email = nil;
    self.password = nil;
    self.rememberBtn = nil;
    self.autoLoginBtn = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES; //隐藏navigationBar
    
    BOOL isRemember = [[[NSUserDefaults standardUserDefaults] objectForKey:@"remember"] boolValue];
    BOOL isAutoLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"autoLogin"] boolValue];

    UIImageView *navIV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_nav.png"]];
    navIV.userInteractionEnabled=YES;
    navIV.frame = CGRectMake(0, 0, 320, 44);
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(5, 10, 57, 27);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [backBtn setTitle:@"暂不登陆" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:backBtn];
    
    UILabel *nameL=[[UILabel alloc]initWithFrame:CGRectMake(90, 10, 140, 24)];
    nameL.font=[UIFont boldSystemFontOfSize:17];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.textAlignment = UITextAlignmentCenter;
    nameL.textColor = [UIColor whiteColor];
    nameL.text = @"登陆";
    [navIV addSubview:nameL];
    [nameL release];
    [self.view addSubview:navIV];
    [navIV release];
    
    UIButton *zhuceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    zhuceBtn.frame=CGRectMake(258, 10, 57, 27);
    [zhuceBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"] forState:UIControlStateNormal];
    zhuceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [zhuceBtn setTitle:@"注册" forState:UIControlStateNormal];
    [zhuceBtn addTarget:self action:@selector(toZhuceVc) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:zhuceBtn];
    
    UIImageView *bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_bg.png"]];
    bgIV.frame = CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-44);
    bgIV.userInteractionEnabled = YES;
    [self.view addSubview:bgIV];
    [bgIV release];
    
    UIImageView *whiteIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_gray1_bg.png"]];
    whiteIV.frame = CGRectMake(5, 10, 310, 215);
    whiteIV.userInteractionEnabled = YES;
    whiteIV.tag = 100;
    [bgIV addSubview:whiteIV];
    [whiteIV release];
    
    self.email = [[UITextField alloc]initWithFrame:CGRectMake(50, 30, 210, 30)];
    email.clearButtonMode = UITextFieldViewModeWhileEditing;
    email.borderStyle = UITextBorderStyleRoundedRect;
    email.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    email.font = [UIFont systemFontOfSize:15];
    email.placeholder = @"邮箱";
    [whiteIV addSubview:email];
    [email release];
    email.keyboardType = UIKeyboardTypeEmailAddress;
    if (isRemember) {
        email.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    }
    
    self.password = [[UITextField alloc]initWithFrame:CGRectMake(50, 65, 210, 30)];
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    password.secureTextEntry = YES;
    password.borderStyle = UITextBorderStyleRoundedRect;
    password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    password.font = [UIFont systemFontOfSize:15];
    password.placeholder = @"密码";
    [whiteIV addSubview:password];
    [password release];
    if (isRemember) {
        password.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    }

    self.rememberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rememberBtn.frame = CGRectMake(65, 105, 15, 15);
    [rememberBtn setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    [rememberBtn setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateSelected];
    [rememberBtn addTarget:self action:@selector(rememberBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
    [whiteIV addSubview:rememberBtn];
    rememberBtn.selected = isRemember;
    
    UILabel *rememberL = [[UILabel alloc]initWithFrame:CGRectMake(80, 105, 60, 13)];
    rememberL.font = [UIFont systemFontOfSize:13];
    rememberL.backgroundColor = [UIColor clearColor];
    rememberL.text = @"记住密码";
    [whiteIV addSubview:rememberL];
    [rememberL release];
    
//    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
//    [forgetBtn addTarget:self action:@selector(toFindYourSecure) forControlEvents:UIControlEventTouchUpInside];
//    forgetBtn.frame = CGRectMake(185, 95, 60, 13);
//    [whiteIV addSubview:forgetBtn];
    
    self.autoLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    autoLoginBtn.frame = CGRectMake(175, 105, 15, 15);
    [autoLoginBtn setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    [autoLoginBtn setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateSelected];
    [autoLoginBtn addTarget:self action:@selector(autoLoginBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
    [whiteIV addSubview:autoLoginBtn];
    autoLoginBtn.selected = isAutoLogin;
    
    if (autoLoginBtn.selected) {
        [self login]; //自动登录
    }
    
    UILabel *autoLoginL = [[UILabel alloc]initWithFrame:CGRectMake(190, 105, 60, 13)];
    autoLoginL.font = [UIFont systemFontOfSize:13];
    autoLoginL.backgroundColor = [UIColor clearColor];
    autoLoginL.text = @"自动登陆";
    [whiteIV addSubview:autoLoginL];
    [autoLoginL release];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(65, 125, 180, 25);
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"loginButtonBg.png"] forState:UIControlStateNormal];
    
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [whiteIV addSubview:loginBtn];
    
    UIButton *zhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zhuBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [zhuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [zhuBtn setTitle:@"没有账号？去注册" forState:UIControlStateNormal];
    [zhuBtn addTarget:self action:@selector(toZhuceVc) forControlEvents:UIControlEventTouchUpInside];
    zhuBtn.frame = CGRectMake(90, 160, 130, 13);
    [whiteIV addSubview:zhuBtn];
    
}

#pragma mark - NSNotification
//-(void)keyboardWasShown:(NSNotification *) notif{
//    NSDictionary *info = [notif userInfo];
//    
//    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
//    CGSize keyboardSize = [value CGRectValue].size;
//    NSLog(@"----%@",NSStringFromCGSize(keyboardSize));
//    UIImageView *whiteIV = (UIImageView *)[self.view viewWithTag:100];
//    
//    whiteIV.frame = CGRectMake(5, 10-20, 310, 215);
//}
//
//- (void) keyboardWasHidden:(NSNotification *) notif{
//    UIImageView *whiteIV = (UIImageView *)[self.view viewWithTag:100];
//    whiteIV.frame = CGRectMake(5, 10, 310 ,215);
//}


#pragma mark - 邮箱正则验证
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

-(void)fanhui{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)toFindYourSecure{
    NSLog(@"找回密码！");
}

-(void)toZhuceVc{
    NSLog(@"注册！");
    Zhuce *zhuceVc = [[Zhuce alloc]init];
    [self.navigationController pushViewController:zhuceVc animated:YES];
    [zhuceVc release];
}

-(void)rememberBtnSelect:(UIButton *)sender{
    NSLog(@"rememberBtnSelect:");
    if (sender.selected) {
        sender.selected = NO;
    }
    else{
        sender.selected = YES; //记住密码
        
    }
}

-(void)autoLoginBtnSelect:(UIButton *)sender{
    NSLog(@"autoLoginBtnSelect:");
    if (sender.selected) {
        sender.selected = NO;
    }
    else{
        sender.selected = YES; //自动登录
    }
}

-(void)login{
    NSLog(@"login！");
    
    BOOL isEmail = [self validateEmail:email.text];
    if (isEmail) { //如果邮箱格式正确
        //将密码进行MD5加密 
    //    NSString *sign = [MD5 md5Digest:password.text];
    //    sign---is-----93ABA73734D75F11D94D122517D0227F
    //    setCookie----PHPSESSID=da4864bd49dcd9f0d3439dfb8ff8d4cd
        
        //将密码进行SHA1加密 
        NSString *sign = [SHA1 sha1Digest:password.text];
    //    sign---is-----2690FD24503CD871EDFAB0A7C7F2793095D4629B
    //    setCookie----PHPSESSID=6394a054a9ba99690e3abd7b75ba588a
        
        NSLog(@"sign---is-----%@",sign);
        
        NSURL *loginUrl = [NSURL URLWithString:THEURL(@"/phone/default/detail.html")];
        
        self.login_request = [ASIFormDataRequest requestWithURL:loginUrl];
        [login_request setDelegate:self];
        [login_request setPostValue:email.text forKey:@"email"];
        [login_request setPostValue:sign forKey:@"password"];
        [login_request setDidFinishSelector:@selector(loginSucceed:)];
        [login_request setDidFailSelector:@selector(loginFailed:)];
        [login_request startAsynchronous];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"您输入的邮箱格式不正确！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

//在loginSucceed函数里：
-(void)loginSucceed:(ASIHTTPRequest *) formRequest
{
    NSLog(@"Succe login  ! ");
    
    NSData *data = formRequest.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"str--------%@",str);
    
    NSDictionary *stateDic = [str JSONValue];
    [str release];
    NSLog(@"%@",stateDic);
    BOOL isExist = [[stateDic objectForKey:@"data"] boolValue];
    NSString *token = [stateDic objectForKey:@"token"];
    NSLog(@"token----000-------%@",token);
    NSString *uid = [stateDic objectForKey:@"uid"];
    NSLog(@"------%@",uid);
    NSString *uName = [stateDic objectForKey:@"uname"];
    BOOL state = [[stateDic objectForKey:@"state"] boolValue];
    if (isExist) { //登陆成功
        
//        NSString *appendStr = [NSString stringWithFormat:@"%@%@17h",email.text,password.text];
//        NSLog(@"00000%@",appendStr);
//        NSString *userStr = [MD5 md5Digest:appendStr];
//        NSLog(@"userStr----%@",userStr);
        
            if (rememberBtn.selected) { //如果点击记住密码，那么。。。
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"remember"]; //保存是否记住密码状态
            }
            else{
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"remember"];
            }
        
            if (autoLoginBtn.selected) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autoLogin"]; //保存是否自动登录状态
            }
            else{
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"autoLogin"];
            }
        
        [[NSUserDefaults standardUserDefaults] setObject:email.text forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] setObject:password.text forKey:@"password"];
//        [[NSUserDefaults standardUserDefaults] synchronize]; //同步进程
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"logined"]; //登陆状态为已登陆
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"]; //用户令牌
        [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"]; //登陆用户的ID
        [[NSUserDefaults standardUserDefaults] setObject:uName forKey:@"uname"]; //登陆用户的ID
        [[NSUserDefaults standardUserDefaults] setBool:state forKey:@"state"]; //邮箱认证状态
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self dismissModalViewControllerAnimated:YES];
//        [self getMessageCount];
    }
    else{ //登录失败
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"remember"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"autoLogin"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"logined"]; //登陆状态为未登陆
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"]; //删除用户令牌
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"]; //删除登陆用户的ID
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uname"]; //删除登陆用户的ID
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"用户名或密码错误" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    } 
    
}

-(void)loginFailed:(ASIHTTPRequest *)formRequest{
    NSLog(@"formRequest.error-------------%@",formRequest.error);
    NSString *errorStr = [NSString stringWithFormat:@"%@",formRequest.error];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorStr delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.email = nil;
    self.password = nil;
    self.rememberBtn = nil;
    self.autoLoginBtn = nil;
}

@end
