//
//  DingdanXiangqing.m
//  一起换吧
//
//  Created by Chen Hao on 13-4-19.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "DingdanXiangqing.h"
#import "SVProgressHUD.h"
#import "JSON.h"
#import "XiangqingCell.h"

@interface DingdanXiangqing ()

@end

@implementation DingdanXiangqing
@synthesize changeIV,kindsBtn,xiangqingTableView,xiangqingDic,dingdan_request;
@synthesize gdimgStr,gnameStr,oidStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        type = 1; //默认是我的商品
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.xiangqingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-44-20)];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg.png"]];
    xiangqingTableView.backgroundView = view;
    [view release];
    xiangqingTableView.delegate = self;
    xiangqingTableView.dataSource = self;
    [self.view addSubview:xiangqingTableView];
    [xiangqingTableView release];
    
    UIImageView *navIV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_nav.png"]];
    navIV.userInteractionEnabled=YES;
    navIV.frame = CGRectMake(0, 0, 320, 44);
    [self.view addSubview:navIV];
    [navIV release];
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(10, 5, 33, 33);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:backBtn];
    
    self.kindsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    kindsBtn.frame = CGRectMake(80, 10, 150, 24);
    kindsBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [kindsBtn setImage:[UIImage imageNamed:@"arrow_down.png"] forState:UIControlStateNormal];
    [kindsBtn setImage:[UIImage imageNamed:@"arrow_up.png"] forState:UIControlStateSelected];
    [kindsBtn setTitle:@" 我的商品" forState:UIControlStateNormal];
    [kindsBtn addTarget:self action:@selector(toChangeKinds:) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:kindsBtn];
    self.changeIV = [[UIImageView alloc]initWithFrame:CGRectMake(104, 44, 112, 83)];
    changeIV.image = [UIImage imageNamed:@"drop_menu_2.png"];
    changeIV.userInteractionEnabled = YES;
    [self.view addSubview:changeIV];
    [changeIV release];
    changeIV.hidden = YES;
    
    UIButton *mineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mineBtn.frame = CGRectMake(0, 15, 112, 20);
    mineBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [mineBtn setTitle:@"我的商品" forState:UIControlStateNormal];
    [mineBtn addTarget:self action:@selector(changeToMine:) forControlEvents:UIControlEventTouchUpInside];
    [changeIV addSubview:mineBtn];
    
    UIButton *hisBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hisBtn.frame = CGRectMake(0, 55, 112, 20);
    hisBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [hisBtn setTitle:@"对方商品" forState:UIControlStateNormal];
    [hisBtn addTarget:self action:@selector(changeToHis:) forControlEvents:UIControlEventTouchUpInside];
    [changeIV addSubview:hisBtn];
    
    [self getTheXiangqingWithType:@"1" andPage:0];
    
}

#pragma mark - 获取用户通知列表（收到和申请）
-(void)getTheXiangqingWithType:(NSString *)shenfenType andPage:(int)p { //获取登录用户商品列表
    [SVProgressHUD showWithStatus:@"加载中.."];
    //    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/goods/orderinfo.html")];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:uid forKey:@"uid"]; //用户ID
    [form_request setPostValue:oidStr forKey:@"oid"];
    [form_request setPostValue:shenfenType forKey:@"type"];
    
    [form_request setDidFinishSelector:@selector(finishGetTheDingdan:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}

-(void)finishGetTheDingdan:(ASIFormDataRequest *)request{
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"已上架 str    is   %@",str);
    
        NSDictionary *dic = [str JSONValue];
        if (type == 1) {
            self.xiangqingDic = [dic objectForKey:@"mymodel"];
        }
        else{
            self.xiangqingDic = [dic objectForKey:@"othermodel"];
        }
    if ([xiangqingDic isKindOfClass:[NSDictionary class]]) {
        [xiangqingTableView reloadData];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉！" message:@"改商品已下架！" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }

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


#pragma mark = UITableViewDelegate methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 230;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indef = @"goodsCell";
    XiangqingCell *cell = [tableView dequeueReusableCellWithIdentifier:indef];
    if (!cell) {
        cell = [[XiangqingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indef];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //关闭点击效果
    
    if (![gdimgStr isEqualToString:@" "]) {
        cell.gdimg.urlString = THEURL(gdimgStr);
    }
    cell.nameL.text = gnameStr;
    NSString *bianhaoStr = [xiangqingDic objectForKey:@"ordernumber"];
    cell.bianhaoL.text = [NSString stringWithFormat:@"订单编号：%@",bianhaoStr];
    
    NSString *addressStr = [xiangqingDic objectForKey:@"address"];
    cell.addressL.text = [NSString stringWithFormat:@"对方收货地址：%@",addressStr];
    
    NSString *toNameStr = [xiangqingDic objectForKey:@"realname"];
    cell.realNameL.text = [NSString stringWithFormat:@"收货人：%@",toNameStr];
    
    NSString *phoneStr = [xiangqingDic objectForKey:@"tel"];
    cell.phoneL.text = [NSString stringWithFormat:@"联系方式：%@",phoneStr];
    
    NSString *youbianStr = [xiangqingDic objectForKey:@"zipcode"];
    cell.youBianL.text = [NSString stringWithFormat:@"邮政编码：%@",youbianStr];
    
    NSString *liuyanStr = [xiangqingDic objectForKey:@"remarks"];
    cell.liuYanL.text = [NSString stringWithFormat:@"留言：%@",liuyanStr];
    
    NSString *yunfeiStr = [xiangqingDic objectForKey:@"defer"];
    cell.yunfeiL.text = [NSString stringWithFormat:@"运费：%@",yunfeiStr];
    
    NSString *kuaidiStr = [xiangqingDic objectForKey:@"devlname"];
    cell.kuaidiL.text = [NSString stringWithFormat:@"快递：%@",kuaidiStr];
    
    NSString *danhaoStr = [xiangqingDic objectForKey:@"devlnumber"];
    cell.danhaoL.text = [NSString stringWithFormat:@"单号：%@",danhaoStr];
    
    return cell;
}



-(void)toChangeKinds:(UIButton *)sender{
    NSLog(@"更换显示类别！");
    kindsBtn.highlighted = YES;
    if (sender.selected) {
        sender.selected = NO;
        changeIV.hidden = YES;
    }
    else{
        sender.selected = YES;
        changeIV.hidden = NO;
    }
}

-(void)changeToMine:(UIButton *)sender{
    type = 1; //我的商品
    NSString *title = [NSString stringWithFormat:@" %@",sender.titleLabel.text];
    [kindsBtn setTitle:title forState:UIControlStateNormal];
    kindsBtn.selected = NO;
    changeIV.hidden = YES;
    [self getTheXiangqingWithType:@"1" andPage:0];
}

-(void)changeToHis:(UIButton *)sender{
    type = 2; //对方商品
    NSString *title = [NSString stringWithFormat:@" %@",sender.titleLabel.text];
    [kindsBtn setTitle:title forState:UIControlStateNormal];
    kindsBtn.selected = NO;
    changeIV.hidden = YES;
    [self getTheXiangqingWithType:@"2" andPage:0];
}

-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
