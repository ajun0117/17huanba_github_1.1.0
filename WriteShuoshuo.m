//
//  WriteShuoshuo.m
//  17huanba
//
//  Created by Chen Hao on 13-2-18.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "WriteShuoshuo.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#define SENDSAY @"/phone/logined/Sensay.html"  //发表说说

@interface WriteShuoshuo ()

@end

@implementation WriteShuoshuo
@synthesize myTextView,toolView,textCountL;
@synthesize sendBtn;
@synthesize placeL;
@synthesize mEmojiDic1,mEmojiDic2,pageC;
@synthesize aScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //注册键盘出现和消失的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    [myTextView release];
    [toolView release];
    [textCountL release];
    [sendBtn release];
    [placeL release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil]; //移除监听
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    self.myTextView = nil;
    self.toolView = nil;
    self.textCountL = nil;
    self.sendBtn = nil;
    self.placeL = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView *navIV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_nav.png"]];
    navIV.userInteractionEnabled=YES;
    navIV.frame = CGRectMake(0, 0, 320, 44);
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(10, 5, 33, 33);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:backBtn];
    
//    UIButton *dingweiBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    dingweiBtn.frame=CGRectMake(45, 5, 33, 33);
//    [dingweiBtn setBackgroundImage:[UIImage imageNamed:@"mark_map.png"] forState:UIControlStateNormal];
//    [dingweiBtn addTarget:self action:@selector(toDingwei) forControlEvents:UIControlEventTouchUpInside];
//    [navIV addSubview:dingweiBtn];
    
    [self.view addSubview:navIV];
    [navIV release];
    
    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(130, 10, 80, 24)];
    titleL.font = [UIFont boldSystemFontOfSize:17];
    titleL.backgroundColor=[UIColor clearColor];
    titleL.textColor = [UIColor whiteColor];
    titleL.text = @"发表说说";
    [navIV addSubview:titleL];
    [titleL release];
    
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(280, 5, 33, 33);
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"send_icon.png"] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(toSendtheShuoshuo) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:sendBtn];
    sendBtn.enabled = NO; //初始发送按钮不可用
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.myTextView=[[UITextView alloc]init];
    myTextView.delegate=self;
    self.myTextView.frame=CGRectMake(0, 44, 320, 150-44);
    myTextView.font=[UIFont systemFontOfSize:17];
    [myTextView becomeFirstResponder];
    [self.view addSubview:myTextView];
    [myTextView release];
    
    self.placeL=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 17)];
    placeL.backgroundColor=[UIColor clearColor];
//    placeL.textColor = [UIColor grayColor];
    placeL.text=@"说点儿什么吧......";
    [self.myTextView addSubview:placeL];
    [placeL release];
    
    self.toolView=[[UIImageView alloc]init];
    toolView.image = [UIImage imageNamed:@"speak_bar_bg.png"];
    toolView.userInteractionEnabled=YES;
    [self.view addSubview:toolView];
    [toolView release];
    toolView.hidden = YES;
    
    UIButton *biaoqingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [biaoqingBtn setImage:[UIImage imageNamed:@"smile_icon.png"] forState:UIControlStateNormal];
    [biaoqingBtn addTarget:self action:@selector(showBiaoqing) forControlEvents:UIControlEventTouchUpInside];
    biaoqingBtn.frame = CGRectMake(220, 5, 30, 30);
    [toolView addSubview:biaoqingBtn];
    
    self.textCountL=[[UILabel alloc]initWithFrame:CGRectMake(255, 10, 40, 20)];
    textCountL.font=[UIFont systemFontOfSize:17];
    textCountL.text=@"140";
    [textCountL setBackgroundColor:[UIColor clearColor]];
    [textCountL setTextColor:[UIColor whiteColor]];
    [textCountL setTextAlignment:UITextAlignmentCenter];
    [self.toolView addSubview:textCountL];
    [textCountL release];
    
    UIButton *clearTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearTextButton setShowsTouchWhenHighlighted:YES];
    [clearTextButton setFrame:CGRectMake(295, 5, 20, 20)];
    [clearTextButton setContentMode:UIViewContentModeCenter];
    [clearTextButton setImage:[UIImage imageNamed:@"delete-icon.png"] forState:UIControlStateNormal];
    [clearTextButton addTarget:self action:@selector(clearText) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:clearTextButton];
    
    
    //表情键盘部分
    NSString *filePath1 = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"emotion.plist"];//表情属性列表的路径
    self.mEmojiDic1 = [[NSDictionary alloc] initWithContentsOfFile:filePath1];//通过属性列表创建字典 第一个
    
    NSString *filePath2 = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"emotionImage.plist"];//表情属性列表的路径
    self.mEmojiDic2 = [[NSDictionary alloc] initWithContentsOfFile:filePath2];//通过属性列表创建字典 第二个
    
    self.aScrollView=[[UIScrollView alloc]init];
    aScrollView.backgroundColor=[UIColor grayColor];
    aScrollView.pagingEnabled=YES;
    aScrollView.delegate=self;
    //    aScrollView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:aScrollView];
    aScrollView.contentSize=CGSizeMake(320*3, 180);
    
    self.pageC=[[UIPageControl alloc]init];
    pageC.frame=CGRectMake(60, 170, 100, 30);
    pageC.currentPage=0;
    [aScrollView addSubview:pageC];
    
    int f=1;
    for (int i=0; i<3; i++) {
        for (int j=0; j<5; j++) {
            for (int k=0; k<7; k++) {
                
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                button.frame=CGRectMake(25+40*k+320*i, 43*j+10, 25, 25);
                //                [button setTag:(i*35+j*7+(k+1))];
                button.tag=f++;
                NSString *value=[mEmojiDic1 objectForKey:[NSString stringWithFormat:@"%d",button.tag]];
                NSString *name=[mEmojiDic2 objectForKey:value];
                [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(selectBiaoqing:) forControlEvents:UIControlEventTouchUpInside];
                [aScrollView addSubview:button];
            }
        }
    }
}

#pragma mark = NSNotification
-(void)keyboardWasShown:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"----%@",NSStringFromCGSize(keyboardSize));
    toolView.frame = CGRectMake(0, 460-44-keyboardSize.height, 320, 44);
    toolView.hidden = NO;
    aScrollView.frame = CGRectMake(0, 460-keyboardSize.height, 320, keyboardSize.height);
}

-(void)showBiaoqing{
    NSLog(@"显示表情键盘");
    [self.myTextView resignFirstResponder];
}

-(void)selectBiaoqing:(UIButton *)sender{
    self.placeL.hidden=YES;
    self.sendBtn.enabled=YES;
    NSString *text=[self.mEmojiDic1 objectForKey:[NSString stringWithFormat:@"%d",sender.tag]];
    self.myTextView.text=[NSString stringWithFormat:@"%@%@",self.myTextView.text,text];
}


-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toSendtheShuoshuo{
    NSLog(@"发表说说！！");
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSURL *sendUrl = [NSURL URLWithString:THEURL(SENDSAY)];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:sendUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:myTextView.text forKey:@"content"]; //说说的内容
    [form_request setPostValue:token forKey:@"token"];
    [form_request setDidFinishSelector:@selector(finishSendTheSay:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startSynchronous];
}

-(void)finishSendTheSay:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"说说str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSLog(@"dic is %@",dic);
    NSString *info = [dic objectForKey:@"info"];
    NSLog(@"%@",info);
    BOOL isSuccess = [[dic objectForKey:@"state"] boolValue];
    if (isSuccess) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜" message:info delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)clearText{
    [self.myTextView setText:@""];
    [textCountL setTextColor:[UIColor whiteColor]];
	[self calculateTextLength];
}

- (void)calculateTextLength
{
    int wordcount = [self textLength:myTextView.text];
    NSInteger count  = 140 - wordcount;
    if (myTextView.text.length > 0)
	{
        if (count < 0)
        {
            [textCountL setTextColor:[UIColor redColor]];
            [sendBtn setEnabled:NO];
        }
        else
        {
            [textCountL setTextColor:[UIColor whiteColor]];
            [sendBtn setEnabled:YES];
            [sendBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
	}
	else
	{
		[sendBtn setEnabled:NO];
	}
	
	[textCountL setText:[NSString stringWithFormat:@"%i",count]];
}

#pragma mark - UITextViewDelegate Methods

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([myTextView.text length]!=0) {
        self.placeL.hidden=YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.placeL.hidden=YES;
    if ([textView.text isEqualToString:@""]) {
        self.placeL.hidden=NO;
    }
	[self calculateTextLength];
}


#pragma mark Text Length
- (int)textLength:(NSString *)text
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3){
            number++;
        }
        else{
            number = number + 0.5;
        }
    }
    return ceil(number);    //返回extern double ceil ( double )
}

-(void)weizhi{
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
