//
//  Dingdan.m
//  17huanba
//
//  Created by Chen Hao on 13-1-24.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.


#import "Dingdan.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "Address.h"
#import "SVProgressHUD.h"

#define GETMY @"/phone/plogined/Getusinfo.html"

@interface Dingdan ()

@end

@implementation Dingdan
@synthesize dingdanTableView;
@synthesize goodsImg,goodsL,youfeiF,youfeiL,zhifufangshiF,zhifufangshiL,querenL,addressL,beizhuF,beizhuL,jiaoyimaF,jiaoyimaL,sendBtn;
@synthesize youfeiArray,zhifufangshiArray;
@synthesize sureBtn;
@synthesize goodsDic,userDic,gidStr;
@synthesize jiaoyimaStr,memoArray;
@synthesize memoID,devali;
@synthesize addressID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //注册键盘出现和消失的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
        self.zhifufangshiArray = [NSMutableArray array];
    }
    return self;
}

-(void)dealloc{
    
//    RELEASE_SAFELY(dingdanTableView);
    RELEASE_SAFELY(goodsImg);
    RELEASE_SAFELY(goodsL);
    RELEASE_SAFELY(youfeiL);
    RELEASE_SAFELY(youfeiF);
    RELEASE_SAFELY(zhifufangshiF);
    RELEASE_SAFELY(zhifufangshiL);
    RELEASE_SAFELY(querenL);
    RELEASE_SAFELY(addressL);
    RELEASE_SAFELY(beizhuL);
    RELEASE_SAFELY(beizhuF);
    RELEASE_SAFELY(jiaoyimaL);
    RELEASE_SAFELY(jiaoyimaF);
    RELEASE_SAFELY(sendBtn);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil]; //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    RELEASE_SAFELY(goodsDic);
    RELEASE_SAFELY(userDic);
    RELEASE_SAFELY(gidStr);
    RELEASE_SAFELY(jiaoyimaStr);
    RELEASE_SAFELY(memoArray);
    RELEASE_SAFELY(memoID);
    RELEASE_SAFELY(devali);
    RELEASE_SAFELY(addressID);
    [super dealloc];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    RELEASE_SAFELY(dingdanTableView);
    RELEASE_SAFELY(goodsImg);
    RELEASE_SAFELY(goodsL);
    RELEASE_SAFELY(youfeiL);
    RELEASE_SAFELY(youfeiF);
    RELEASE_SAFELY(zhifufangshiF);
    RELEASE_SAFELY(zhifufangshiL);
    RELEASE_SAFELY(querenL);
    RELEASE_SAFELY(addressL);
    RELEASE_SAFELY(beizhuL);
    RELEASE_SAFELY(beizhuF);
    RELEASE_SAFELY(jiaoyimaL);
    RELEASE_SAFELY(jiaoyimaF);
    RELEASE_SAFELY(sendBtn);
    RELEASE_SAFELY(goodsDic);
    RELEASE_SAFELY(userDic);
    RELEASE_SAFELY(gidStr);
    RELEASE_SAFELY(jiaoyimaStr);
    RELEASE_SAFELY(memoArray);
    RELEASE_SAFELY(memoID);
    RELEASE_SAFELY(devali);
    RELEASE_SAFELY(addressID);
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
    nameL.font=[UIFont systemFontOfSize:17];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.textAlignment = UITextAlignmentCenter;
    nameL.textColor = [UIColor whiteColor];
    nameL.text = @"确认订单";
    [navIV addSubview:nameL];
    [nameL release];
    
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(258, 10, 57, 27);
    sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(toShenqing) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:sureBtn];
//    sureBtn.enabled = NO;
    [sureBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    [self.view addSubview:navIV];
    [navIV release];
    
    
    self.dingdanTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-44) style:UITableViewStyleGrouped];
    dingdanTableView.delegate = self;
    dingdanTableView.dataSource = self;
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg.png"]];
    dingdanTableView.backgroundView = view;
    [view release];
    
    [self.view addSubview:dingdanTableView];
    [dingdanTableView release];
    
    youfeiPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0,155+44*2+1 , kDeviceWidth, KDeviceHeight-20-150-44)];
    youfeiPicker.delegate = self;
    youfeiPicker.dataSource = self;
    youfeiPicker.showsSelectionIndicator = YES;
    youfeiPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    zhifufangshiPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0,155+44*2+1 , kDeviceWidth, KDeviceHeight-20-150-44)];
    zhifufangshiPicker.delegate = self;
    zhifufangshiPicker.dataSource = self;
    zhifufangshiPicker.showsSelectionIndicator = YES;
    zhifufangshiPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
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
    
    
    self.goodsImg = [[AsyncImageView alloc]initWithFrame:CGRectMake(5, 5, 90, 90)];
    [goodsImg addTarget:self action:@selector(toGoodsDetailVC:) forControlEvents:UIControlEventTouchUpInside];
    
    self.goodsL = [[UILabel alloc]initWithFrame:CGRectMake(110, 10, 200, 30)];
    goodsL.backgroundColor = [UIColor clearColor];
    goodsL.lineBreakMode = UILineBreakModeWordWrap;
    goodsL.numberOfLines = 0;
    goodsL.font = [UIFont systemFontOfSize:17];
    goodsL.textColor = [UIColor blackColor];
    
    self.youfeiL = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 50, 30)];
    youfeiL.backgroundColor = [UIColor clearColor];
    youfeiL.text = @"邮费:";
    
    self.youfeiF = [[UITextField alloc]initWithFrame:CGRectMake(90, 5, 205, 30)];
    youfeiF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    youfeiF.backgroundColor = [UIColor clearColor];
    youfeiF.inputView = youfeiPicker;
    youfeiF.inputAccessoryView = keyboardToolbar;
    youfeiF.delegate = self;
    youfeiF.tag = 1;
    [keyboardToolbar release];
    
    self.zhifufangshiL = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 80, 30)];
    zhifufangshiL.backgroundColor = [UIColor clearColor];
    zhifufangshiL.text = @"支付方式:";
    
    self.zhifufangshiF = [[UITextField alloc]initWithFrame:CGRectMake(90, 5, 205, 30)];
    zhifufangshiF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    zhifufangshiF.backgroundColor = [UIColor clearColor];
    zhifufangshiF.inputView = zhifufangshiPicker;
    zhifufangshiF.inputAccessoryView = keyboardToolbar;
    zhifufangshiF.delegate = self;
    zhifufangshiF.tag = 2;
    [keyboardToolbar release];
    
    self.querenL = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 150, 20)];
    querenL.backgroundColor = [UIColor clearColor];
    querenL.text = @"确认收货信息:";
    
    self.addressL = [[UILabel alloc]initWithFrame:CGRectMake(5, 30, 290, 50)];
    addressL.backgroundColor = [UIColor clearColor];
    addressL.textAlignment = UITextAlignmentCenter;
    addressL.lineBreakMode = UILineBreakModeWordWrap;
    addressL.numberOfLines = 0;
    addressL.font = [UIFont systemFontOfSize:15];
    addressL.textColor = [UIColor blackColor];
    addressL.text = @"点击选择您的收获地址";
    
    self.beizhuL = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 40, 30)];
    beizhuL.backgroundColor = [UIColor clearColor];
    beizhuL.text = @"备注:";
    
    self.beizhuF = [[UITextField alloc]initWithFrame:CGRectMake(50, 5, 245, 30)];
    beizhuF.borderStyle = UITextBorderStyleRoundedRect;
    beizhuF.inputAccessoryView = keyboardToolbar;
    beizhuF.delegate = self;
    beizhuF.tag = 4;
    [keyboardToolbar release];
    
    self.jiaoyimaL = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 70, 30)];
    jiaoyimaL.backgroundColor = [UIColor clearColor];
    jiaoyimaL.text = @"交易码:";
    
    self.jiaoyimaF = [[UITextField alloc]initWithFrame:CGRectMake(70, 5, 150, 30)];
    jiaoyimaF.borderStyle = UITextBorderStyleRoundedRect;
    jiaoyimaF.inputAccessoryView = keyboardToolbar;
    jiaoyimaF.delegate = self;
    jiaoyimaF.tag = 5;
    [keyboardToolbar release];
    
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"send_btn.png"] forState:UIControlStateNormal];
    sendBtn.frame = CGRectMake(225, 5, 70, 30);
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sendBtn setTitle:@"点击获取" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(toJiaoyima) forControlEvents:UIControlEventTouchUpInside];
    
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
    self.userDic = [dic objectForKey:@"data"];
    [dingdanTableView reloadData];
    
    [self requestWithDetailGoods]; //请求商品信息
}

#pragma mark - 接口部分
-(void)requestWithDetailGoods{
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/default/Viewgd.html")];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:gidStr forKey:@"gdid"];
    [form_request setDidFinishSelector:@selector(finishTheDetailGoods:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}

-(void)finishTheDetailGoods:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSLog(@"goodsDic   is   %@",dic);
    self.goodsDic = [dic objectForKey:@"data"];
    [dingdanTableView reloadData];
    
    NSString *sell_type = [goodsDic objectForKey:@"sell_type"];
    NSString *gold = [goodsDic objectForKey:@"gold"];
    NSString *silver = [goodsDic objectForKey:@"silver"];
    if ([sell_type isEqualToString:@"1"]) {
        [self getKejiaohuanMemo];
    }
    else if ([sell_type isEqualToString:@"2"]) {
        NSString *gold_silver = [NSString stringWithFormat:@"￥%@+%@换币",gold,silver];
        NSDictionary *goldDic = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"gid",gold_silver,@"gname", nil];
        [self.zhifufangshiArray addObject:goldDic];
        zhifufangshiF.text = gold_silver;
        memoID = @"0";
        
    }
    else if ([sell_type isEqualToString:@"3"])
    {
        NSString *gold_silver = [NSString stringWithFormat:@"￥%@+%@换币",gold,silver];
        NSDictionary *goldDic = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"gid",gold_silver,@"gname", nil];
        [self.zhifufangshiArray addObject:goldDic];
        [self getKejiaohuanMemo];
    }
    
    NSString *isFree = [goodsDic objectForKey:@"free_delivery"];
    if([isFree isEqualToString:@"0"]){
        NSString *townsman = [NSString stringWithFormat:@"同城:￥%@",[goodsDic objectForKey:@"freight_townsman"]];
        NSString *allopatry = [NSString stringWithFormat:@"异地:￥%@",[goodsDic objectForKey:@"freight_allopatry"]];
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"devali",townsman,@"city", nil];
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"devali",allopatry,@"city", nil];
        self.youfeiArray = [NSArray arrayWithObjects:dic1,dic2, nil];
        
        youfeiF.text = townsman; //默认邮费
        devali = @"1";
        
    }
    else{
        youfeiF.text = @"包邮";
        youfeiF.enabled = NO;
    }
    [SVProgressHUD dismiss];
}


-(void)getKejiaohuanMemo{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/logined/Shoplist.html")];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:token forKey:@"token"];
    [form_request setDidFinishSelector:@selector(finishGetTheTanwei:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}

-(void)finishGetTheTanwei:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"摊位 str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSLog(@"dic is %@",dic);
    NSArray *array = [dic objectForKey:@"data"];
    NSMutableArray *nameArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        NSString *gid = [dic objectForKey:@"goods_id"];
        NSString *gname = [dic objectForKey:@"goods_name"];
        NSDictionary *memoDic = [NSDictionary dictionaryWithObjectsAndKeys:gid,@"gid",gname,@"gname", nil];
        [nameArray addObject:memoDic];
    }
    self.memoArray = nameArray;
    
    [self.zhifufangshiArray addObjectsFromArray:memoArray];
    
    zhifufangshiF.text = [[zhifufangshiArray objectAtIndex:0] objectForKey:@"gname"]; //默认支付方式
    memoID = [[zhifufangshiArray objectAtIndex:0] objectForKey:@"gid"];
    
    [zhifufangshiPicker reloadComponent:0]; //刷新显示可交换方式的内容
}

#pragma mark - 键盘通知
-(void)keyboardWasShown:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"----%@",NSStringFromCGSize(keyboardSize));
    dingdanTableView.frame = CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-keyboardSize.height);
}

- (void) keyboardWasHidden:(NSNotification *) notif{
    dingdanTableView.frame = CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-44);
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [dingdanTableView setContentOffset:CGPointMake(0,textField.tag*65) animated:YES];
}


-(void)resignKeyboard{
    [youfeiF resignFirstResponder];
    [zhifufangshiF resignFirstResponder];
    [beizhuF resignFirstResponder];
    [jiaoyimaF resignFirstResponder];
}

-(void)toJiaoyima{
    NSLog(@"获取交易码！");
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]; //登陆用户的ID
    NSLog(@"----%@",token);
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/plogined/Sendcode.html")];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:token forKey:@"token"];
    [form_request setDidFinishSelector:@selector(finishGetTheJiao:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}

-(void)finishGetTheJiao:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"交易码    is   %@",str);
    
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSLog(@"dic is %@",dic);
    
    self.jiaoyimaStr = [dic objectForKey:@"data"]; //获取交易码  在确认订单时与输入的验证码比对
}



-(void)toGoodsDetailVC:(AsyncImageView *)sender{
    NSLog(@"推出商品详情页面！");
}

-(void)toShenqing{
    NSLog(@"确定申请！！");
    int cash_money = [[[userDic objectForKey:@"moneyinfo"] objectForKey:@"cash_money"] intValue];
    int gold_coin = [[[userDic objectForKey:@"moneyinfo"] objectForKey:@"gold_coin"] intValue];
    
    int gold = [[goodsDic objectForKey:@"gold"] intValue];
    int silver = [[goodsDic objectForKey:@"silver"] intValue];
    
    if (![memoID isEqualToString:@"0"] || (cash_money >= gold && gold_coin >= silver)) { //不是现金交易，或者账户余额大于支付金额时
        
        if (jiaoyimaF.text && [jiaoyimaF.text isEqualToString:jiaoyimaStr]) { //如果输入了交易码且输入的交易码与短信的一致，那么
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
            NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/order/ctorder.html")];
            ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
            [form_request setDelegate:self];
            [form_request setPostValue:token forKey:@"token"];
            [form_request setPostValue:gidStr forKey:@"gid"];
        
            if (![memoID isEqualToString:@"0"]) { //不是现金交易
                [form_request setPostValue:memoID forKey:@"changedgoods"];
                [form_request setPostValue:@"1" forKey:@"ordertype"];
            }
            else{
                [form_request setPostValue:@"2" forKey:@"ordertype"];
            }
            
            if (![youfeiF.text isEqualToString:@"包邮"]) {
                [form_request setPostValue:devali forKey:@"devali"];
            }
            
            
            [form_request setPostValue:addressID forKey:@"selectaddress"];
            if (beizhuF.text) {
                [form_request setPostValue:beizhuF.text forKey:@"orderremarks"]; //如果输入了备注，那么、、
            }
            else{
                [form_request setPostValue:@" " forKey:@"orderremarks"];
            }
            
            [form_request setDidFinishSelector:@selector(finishShenqing:)];
            [form_request setDidFailSelector:@selector(loginFailed:)];
            [form_request startAsynchronous];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"交易码不正确，请重新输入！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"您的可用余额不足，请在网页上充值！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void)finishShenqing:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"申请结果    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
    BOOL state = [[dic objectForKey:@"state"] boolValue];
    
    if (state) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

#pragma mark = UITableViewDelegate methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    if (indexPath.row == 0) {
        [cell.contentView addSubview:goodsImg];
        [cell.contentView addSubview:goodsL];
        
        if (goodsDic) {
            NSArray *urlStrArray= [goodsDic objectForKey:@"gdimg"]; //存放展示图片地址的数组
            if ([urlStrArray count] != 0) {
                NSDictionary *urlStDic = [urlStrArray objectAtIndex:0];
                NSString *goodImg = [urlStDic objectForKey:@"smallimg"];
                if (![goodImg isEqualToString:@" "]) {
                    goodsImg.urlString = THEURL(goodImg);
                }
            }
            NSString *nameStr = [goodsDic objectForKey:@"goods_name"];
            goodsL.text = nameStr;
            
            CGSize textSize = [goodsL.text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(190, 1000) lineBreakMode:UILineBreakModeWordWrap];
            goodsL.frame = CGRectMake(110, 10, 190, textSize.height);
        }
        
    }
    else if (indexPath.row == 1) {
        [cell.contentView addSubview:youfeiL];
        [cell.contentView addSubview:youfeiF];
    }
    else if (indexPath.row == 2) {
        [cell.contentView addSubview:zhifufangshiL];
        [cell.contentView addSubview:zhifufangshiF];
    }
    else if (indexPath.row == 3) {
        [cell.contentView addSubview:querenL];
        [cell.contentView addSubview:addressL];
    }
    else if (indexPath.row == 4) {
        [cell.contentView addSubview:beizhuL];
        [cell.contentView addSubview:beizhuF];
    }
    else if (indexPath.row == 5) {
        [cell.contentView addSubview:jiaoyimaL];
        [cell.contentView addSubview:jiaoyimaF];
        [cell.contentView addSubview:sendBtn];
    }
    else if (indexPath.row == 6) {
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [UIColor redColor];
        
        NSDictionary *moneyinfoDic = [userDic objectForKey:@"moneyinfo"];
        NSString *money = [moneyinfoDic objectForKey:@"cash_money"];
        NSString *coin = [moneyinfoDic objectForKey:@"gold_coin"];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.text = [NSString stringWithFormat:@"账户余额:人民币:%@+换币%@",money,coin];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 100;
    }
    else if (indexPath.row == 1){
        return 40;
    }
    else if (indexPath.row == 2){
        return 40;
    }
    else if (indexPath.row == 3){
        return 100;
    }
    else if (indexPath.row == 4){
        return 40;
    }
    else{
        return 40;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 3) {
        Address *addrVC = [[Address alloc]init];
        addrVC.isSelecte = YES;
        [self.navigationController pushViewController:addrVC animated:YES];
        [addrVC release];
        addrVC.delegate = self;
    }
}

-(void)SelectTheAddress:(NSDictionary *)addrDic{
    NSString *realNameStr = [addrDic objectForKey:@"realname"];
    NSString *telStr = [addrDic objectForKey:@"tel"];
    NSString *detail_infoStr = [addrDic objectForKey:@"detail_info"];
    NSString *postcodeStr = [addrDic objectForKey:@"postcode"];
    addressL.text = [NSString stringWithFormat:@"%@,%@,%@,%@",realNameStr,telStr,detail_infoStr,postcodeStr];
    self.addressID = [addrDic objectForKey:@"mid"];
}

#pragma mark - MyMethods
-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == youfeiPicker) {
        NSDictionary *youfeiDic = [youfeiArray objectAtIndex:row];
        return [youfeiDic objectForKey:@"city"];
    }
    else{
        NSDictionary *memoDic = [zhifufangshiArray objectAtIndex:row];
        return [memoDic objectForKey:@"gname"];
    }
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
        return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == youfeiPicker) {
        return [youfeiArray count];
    }
    else{
        return [zhifufangshiArray count];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == zhifufangshiPicker) {
        NSDictionary *memoDic = [zhifufangshiArray objectAtIndex:row];
        zhifufangshiF.text = [memoDic objectForKey:@"gname"];
        self.memoID = [memoDic objectForKey:@"gid"];
        NSLog(@"%@",memoID);
    }
    else{
        NSDictionary *youfeiDic = [youfeiArray objectAtIndex:row];
        youfeiF.text = [youfeiDic objectForKey:@"city"];
        self.devali = [youfeiDic objectForKey:@"devali"];
        NSLog(@"%@",devali);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
