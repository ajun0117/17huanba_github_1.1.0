//
//  FankuiYijian.m
//  17huanba
//
//  Created by Chen Hao on 13-3-30.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "FankuiYijian.h"

@interface FankuiYijian ()

@end

@implementation FankuiYijian
@synthesize yijianTV,numberL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    RELEASE_SAFELY(yijianTV);
    RELEASE_SAFELY(numberL);
}

-(void)viewDidUnload{
    [super viewDidUnload];
    RELEASE_SAFELY(yijianTV);
    RELEASE_SAFELY(numberL);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg.png"]];
    
    
    UIImageView *navIV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_nav.png"]];
    navIV.userInteractionEnabled=YES;
    navIV.frame = CGRectMake(0, 0, 320, 44);
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(5, 10, 57, 27);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_gray_btn.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:backBtn];
    
    UILabel *nameL=[[UILabel alloc]initWithFrame:CGRectMake(100, 10, 120, 24)];
    nameL.font=[UIFont systemFontOfSize:17];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.textAlignment = UITextAlignmentCenter;
    nameL.textColor = [UIColor whiteColor];
    nameL.text = @"设置";
    [navIV addSubview:nameL];
    [nameL release];
    [self.view addSubview:navIV];
    [navIV release];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(258, 10, 57, 27);
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"] forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(toSubmitYijian:) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:submitBtn];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(161, 63, 137, 21)];
    label.text = @"还可以输入   个字";
    [self.view addSubview:label];
    [label release];
    
    self.numberL  = [[UILabel alloc]initWithFrame:CGRectMake(247, 63, 29, 21)];
    [self.view addSubview:numberL];
    [numberL release];
    
    UIImageView *yijianBg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 100, 280, 140)];
    yijianBg.image = [UIImage imageNamed:@"意见输入框.png"];
    [self.view addSubview:yijianBg];
    [yijianBg release];
    
    self.yijianTV = [[UITextView alloc]initWithFrame:CGRectMake(20, 105, 280, 130)];
    yijianTV.delegate = self;
    yijianTV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:yijianTV];
    [yijianTV release];
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
    keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", @"")
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(reginKey)];
    [keyboardToolbar setItems:[NSArray arrayWithObjects:spaceBarItem,doneBarItem, nil]];
    [spaceBarItem release];
    [doneBarItem release];
//    UIBarButtonItem *spaceBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    UIBarButtonItem *huishouBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"jianpan.png"] style:UIBarButtonItemStylePlain target:self action:@selector(reginKey)];
//    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
//    toolBar.barStyle=UIBarStyleBlackTranslucent;
//    toolBar.items=[NSArray arrayWithObjects:spaceBtn,huishouBtn, nil];
    self.yijianTV.inputAccessoryView = keyboardToolbar;
    [keyboardToolbar release];
    
    self.numberL.text=[NSString stringWithFormat:@"%d",500-self.yijianTV.text.length];
}

-(void)reginKey
{
    [self.yijianTV resignFirstResponder];
    self.view.frame=CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-20);
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame=CGRectMake(0, -44, kDeviceWidth, KDeviceHeight-20);
    }];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.numberL.text=[NSString stringWithFormat:@"%d",500-self.yijianTV.text.length];
}


-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toSubmitYijian:(UIButton *)sender{
    if ([MFMailComposeViewController canSendMail]) {//创建邮件发送的试图控制器
        MFMailComposeViewController *mail=[[MFMailComposeViewController alloc]init];
        //设置代理
        mail.mailComposeDelegate=self;
        [mail setSubject:@"意见反馈"];
        [mail setMessageBody:self.yijianTV.text isHTML:YES];
        //内容
        [mail setToRecipients:[NSArray arrayWithObjects:@"service@17huanba.com", nil]];
        //抄送对象
        [mail setCcRecipients:[NSArray arrayWithObjects:@"service@17huanba.com", nil]];
        //显示邮件视图控制器
        [self presentModalViewController:mail animated:YES];
        [mail release];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result==MFMailComposeResultSent) {
        UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:nil message:@"感谢您的宝贵意见！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertV show];
    }
    else if (result==MFMailComposeResultFailed) {
        UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:nil message:@"发送失败，请查看网络连接！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertV show];
    }
    [controller dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
