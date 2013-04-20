//
//  WriteSixin.m
//  17huanba
//
//  Created by Chen Hao on 13-3-15.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "WriteSixin.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "SVProgressHUD.h"

@interface WriteSixin ()

@end

@implementation WriteSixin
@synthesize myTextView,textCountL,sendBtn,toolView;
@synthesize friendsTableView,friendsArray,refreshing;
@synthesize toF;
@synthesize jiluArray,jiluTableView;
@synthesize uname,rmid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //注册键盘出现和消失的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        self.friendsArray = [NSMutableArray array];
        self.jiluArray = [NSMutableArray array];
        page = 0;
        isJilu  = NO;
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    RELEASE_SAFELY(myTextView);
    RELEASE_SAFELY(textCountL);
    RELEASE_SAFELY(sendBtn);
    RELEASE_SAFELY(toolView);
    RELEASE_SAFELY(friendsTableView);
    RELEASE_SAFELY(friendsArray);
    RELEASE_SAFELY(toF);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil]; //移除监听
}

-(void)viewDidUnload{
    [super viewDidUnload];
    RELEASE_SAFELY(myTextView);
    RELEASE_SAFELY(textCountL);
    RELEASE_SAFELY(sendBtn);
    RELEASE_SAFELY(toolView);
    RELEASE_SAFELY(friendsTableView);
    RELEASE_SAFELY(friendsArray);
    RELEASE_SAFELY(toF);
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
    [self.view addSubview:navIV];
    [navIV release];
    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(130, 10, 80, 24)];
    titleL.font = [UIFont boldSystemFontOfSize:17];
    titleL.backgroundColor=[UIColor clearColor];
    titleL.textColor = [UIColor whiteColor];
    titleL.text = @"发私信";
    [navIV addSubview:titleL];
    [titleL release];
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(280, 5, 33, 33);
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"send_icon.png"] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(toSendtheSixin) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:sendBtn];
    sendBtn.enabled = NO; //初始发送按钮不可用
    
    self.myTextView = [[CPTextViewPlaceholder alloc]initWithFrame:CGRectMake(0, 44, 320, 150-44)];
    myTextView.delegate=self;
    myTextView.font=[UIFont systemFontOfSize:17];
    myTextView.placeholder = @"说点什么吧。。";
    [self.view addSubview:myTextView];
    [myTextView release];
    
    self.toolView=[[UIImageView alloc]init];
    toolView.image = [UIImage imageNamed:@"speak_bar_bg.png"];
    toolView.userInteractionEnabled=YES;
    [self.view addSubview:toolView];
    [toolView release];
    toolView.hidden = YES;
    
    UILabel *toL = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    toL.textColor = [UIColor whiteColor];
    toL.backgroundColor = [UIColor clearColor];
    toL.text = @"To:";
    [toolView addSubview:toL];
    [toL release];
    
    self.toF = [[UITextField alloc]initWithFrame:CGRectMake(40, 7, 120, 30)];
    toF.borderStyle = UITextBorderStyleRoundedRect;
    [toolView addSubview:toF];
    [toF release];
    
    UIButton *atBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [atBtn setBackgroundImage:[UIImage imageNamed:@"send_btn.png"] forState:UIControlStateNormal];
    atBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [atBtn setTitle:@"好友" forState:UIControlStateNormal];
    [atBtn addTarget:self action:@selector(showFriends) forControlEvents:UIControlEventTouchUpInside];
    atBtn.frame = CGRectMake(170, 10, 40, 24);
    [toolView addSubview:atBtn];
    
    UIButton *jiluBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [jiluBtn setBackgroundImage:[UIImage imageNamed:@"send_btn.png"] forState:UIControlStateNormal];
    jiluBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [jiluBtn setTitle:@"记录" forState:UIControlStateNormal];
    [jiluBtn addTarget:self action:@selector(toJilu) forControlEvents:UIControlEventTouchUpInside];
    jiluBtn.frame = CGRectMake(215, 10, 40, 24);
    [toolView addSubview:jiluBtn];
    
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.friendsTableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 150+44, kDeviceWidth, 100) pullingDelegate:self];
    friendsTableView.delegate = self;
    friendsTableView.dataSource = self;
    [self.view addSubview:friendsTableView];
    [friendsTableView release];
    
    
    self.jiluTableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 150+44, kDeviceWidth, 100) pullingDelegate:self];
    jiluTableView.delegate = self;
    jiluTableView.dataSource = self;
    [self.view addSubview:jiluTableView];
    [jiluTableView release];
}

-(void)toSendtheSixin{
    NSLog(@"%s",__FUNCTION__);
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/logined/Sendlett.html")];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:toF.text forKey:@"uname"]; //成功加为好友的列表
    [form_request setPostValue:token forKey:@"token"];
    [form_request setPostValue:myTextView.text forKey:@"content"];
    [form_request setDidFinishSelector:@selector(finishSendTheSixin:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startSynchronous];
}

-(void)finishSendTheSixin:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"发送私信 str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
//    NSLog(@"dic is %@",dic);
    NSString *info = [dic objectForKey:@"info"];
//    NSLog(@"%@",info);
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

-(void)showFriends{
    isJilu = NO;
    page = 0;
    [myTextView resignFirstResponder];
    [toF resignFirstResponder];
    [friendsArray removeAllObjects];
    [self getThefriendsWithPage:0];
}

-(void)toJilu{
    isJilu = YES;
    page = 0;
    [myTextView resignFirstResponder];
    [toF resignFirstResponder];
    [jiluArray removeAllObjects];
    [self getTheJiluWithPage:0];
}

#pragma mark - 获取用户列表申请列表
-(void)getThefriendsWithPage:(int)p{ //获取登录用户好友的动态列表
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/logined/Frdsuc.html")];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:@"1" forKey:@"mid"]; //成功加为好友的列表
    [form_request setPostValue:token forKey:@"token"];
    [form_request setPostValue:[NSString stringWithFormat:@"%d",p] forKey:@"p"];
    [form_request setDidFinishSelector:@selector(finishGetThefriends:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}


-(void)finishGetThefriends:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"还有列表 str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
//    NSLog(@"dic is %@",dic);
    NSArray *array = [dic objectForKey:@"data"];
    [self.friendsArray addObjectsFromArray:array];
    [friendsTableView reloadData];
}


#pragma mark - 获取用户聊天记录
-(void)getTheJiluWithPage:(int)p{ //获取登录用户好友的动态列表
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/default/Letthis.html")];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:rmid forKey:@"mid"]; //成功加为好友的列表
//    NSLog(@"%@",rmid);
    [form_request setPostValue:[NSString stringWithFormat:@"%d",p] forKey:@"p"];
    [form_request setDidFinishSelector:@selector(finishGetTheJilu:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}

-(void)finishGetTheJilu:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"私信记录 str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
//    NSLog(@"dic is %@",dic);
    NSString *info = [dic objectForKey:@"state"];
    NSLog(@"info is %@",info);
    NSArray *array = [dic objectForKey:@"data"];
    [self.jiluArray addObjectsFromArray:array];
    [jiluTableView reloadData];
}


#pragma mark - Scroll
//会在视图滚动时收到通知。包括一个指向被滚动视图的指针，从中可以读取contentOffset属性以确定其滚动到的位置。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.friendsTableView tableViewDidScroll:scrollView];
}


//当用户抬起拖动的手指时得到通知。还会得到一个布尔值，知名报告滚动视图最后位置之前，是否需要减速。
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.friendsTableView tableViewDidEndDragging:scrollView];
}
#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    refreshing = YES;
    [self performSelector:@selector(refreshPage) withObject:nil afterDelay:1.f];
}
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

-(void)loadData
{
    refreshing = NO;
    page++;
    if (isJilu) {
        [self getTheJiluWithPage:page];
        [jiluTableView tableViewDidFinishedLoading];
    }
    else{
        [self getThefriendsWithPage:page];
        [friendsTableView tableViewDidFinishedLoading];
    }
}

-(void)refreshPage{
    refreshing = NO;
    if (isJilu) {
        [jiluArray removeAllObjects];
        [self getTheJiluWithPage:0];
        [jiluTableView tableViewDidFinishedLoading];
    }
    else{
        [friendsArray removeAllObjects];
        [self getThefriendsWithPage:0];
        [friendsTableView tableViewDidFinishedLoading];
    }
}


#pragma mark - NSNotification
-(void)keyboardWasShown:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
//    NSLog(@"----%@",NSStringFromCGSize(keyboardSize));
    toolView.frame = CGRectMake(0, KDeviceHeight-20-44-keyboardSize.height, kDeviceWidth, 44);
    toolView.hidden = NO;
    toF.text = uname;
    friendsTableView.frame = CGRectMake(0, KDeviceHeight-20-keyboardSize.height, kDeviceWidth, keyboardSize.height);
    jiluTableView.frame = CGRectMake(0, KDeviceHeight-20-keyboardSize.height, kDeviceWidth, keyboardSize.height);
}

-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDayaSoures
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == friendsTableView) {
        return [friendsArray count];
    }
    else{
        return [jiluArray count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == jiluTableView) {
        UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == friendsTableView) {
        static NSString *indef = @"friendsCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indef];
        if (!cell) {
            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indef] autorelease];
        }
            NSDictionary *friendDic = [friendsArray objectAtIndex:indexPath.row];
            cell.textLabel.text = [friendDic objectForKey:@"uname"];
        
        return cell;
    }
    else{
        static NSString *ind = @"jiluCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ind];
        if (!cell) {
            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ind] autorelease];
            UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 150, 20)];
            nameL.tag = 10;
            [cell.contentView addSubview:nameL];
            [nameL release];
            
            UILabel *timeL = [[UILabel alloc]initWithFrame:CGRectMake(200, 5, 100, 20)];
            timeL.font = [UIFont systemFontOfSize:12];
            timeL.tag = 20;
            [cell.contentView addSubview:timeL];
            [timeL release];
            
            UILabel *contentL = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 200, 20)];
            contentL.numberOfLines = 0;
            contentL.contentMode = UILineBreakModeWordWrap;
            contentL.tag = 30;
            [cell.contentView addSubview:contentL];
            [contentL release];
        }
        CGSize nameSize = CGSizeZero;
        CGSize contentSize = CGSizeZero;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSDictionary *jiluDic = [jiluArray objectAtIndex:indexPath.row];
        NSString *unameStr = [jiluDic objectForKey:@"funame"];
        UILabel *nameL = (UILabel *)[cell viewWithTag:10];
        nameL.text = unameStr;
        nameSize.height = 30;
        
        UILabel *timeL = (UILabel *)[cell viewWithTag:20];
        NSString *timeStr = [jiluDic objectForKey:@"addtime"];
        NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]];
        NSString *timeStrr = [NSString stringWithFormat:@"%@",timeDate];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss zzz"];   //zzz代表+0000 时区格式
        NSDate *date=[dateformatter dateFromString:timeStrr];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateString=[dateformatter stringFromDate:date];
        [dateformatter release];
        timeL.text = dateString;
        
        UILabel *contentL = (UILabel *)[cell viewWithTag:30];
        NSString *contentStr = [jiluDic objectForKey:@"msg"];
        CGSize textSize = [contentStr sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:UILineBreakModeWordWrap];
        contentSize.height = textSize.height;
        contentL.frame = CGRectMake(10, 30, 200, textSize.height);
        contentL.text = [jiluDic objectForKey:@"msg"];
        
        CGRect rect = cell.frame;
        rect.size.height = nameSize.height + contentSize.height;
        NSLog(@"%@",NSStringFromCGSize(rect.size));
        cell.frame = rect;
        
    return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s",__FUNCTION__);
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableView == friendsTableView) {
        toF.text = cell.textLabel.text;
    }
    else{
        NSLog(@"点击了私信记录");
    }
}


#pragma mark - UITextViewDelegate Methods

- (void)textViewDidChange:(UITextView *)textView
{
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

-(void)clearText{
    [self.myTextView setText:@""];
    [textCountL setTextColor:[UIColor whiteColor]];
	[self calculateTextLength];
    sendBtn.enabled = NO;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
