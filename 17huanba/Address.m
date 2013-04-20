//
//  Address.m
//  17huanba
//
//  Created by Chen Hao on 13-3-11.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "Address.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "NewAddress.h"
#import "SVProgressHUD.h"

#define GETADDRESS @"/phone/plogined/Myaddress.html"
#define DELETE @"/phone/plogined/Optmyaddress.html"

@interface Address ()

@end

@implementation Address
@synthesize addrTableView;
@synthesize isSelecte;
@synthesize addrArray;
@synthesize delegate;
//@synthesize selectedBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isSelecte = NO;
        self.addrArray = [NSMutableArray array];
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    RELEASE_SAFELY(addrTableView);
    RELEASE_SAFELY(addrArray);
//    RELEASE_SAFELY(selectedBtn);
}

-(void)viewDidUnload{
    [super viewDidUnload];
    RELEASE_SAFELY(addrTableView);
    RELEASE_SAFELY(addrArray);
//    RELEASE_SAFELY(selectedBtn);
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
    nameL.text = @"收货地址";
    [navIV addSubview:nameL];
    [nameL release];
    [self.view addSubview:navIV];
    [navIV release];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(258, 10, 57, 27);
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"] forState:UIControlStateNormal];
    [saveBtn setTitle:@"添加" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(toAddNewAddress) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:saveBtn];
    
    self.addrTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-44) style:UITableViewStyleGrouped];
    addrTableView.delegate = self;
    addrTableView.dataSource = self;
    [self.view addSubview:addrTableView];
    [addrTableView release];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg.png"]];
    addrTableView.backgroundView = view;
    [view release];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [addrArray removeAllObjects];
    [self getMyAddressWithpage:0];
}

#pragma mark - 获取当前用户信息
-(void)getMyAddressWithpage:(int)p{
    [SVProgressHUD showWithStatus:@"加载中.."];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSURL *newUrl = [NSURL URLWithString:THEURL(GETADDRESS)];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:token forKey:@"token"];
    [form_request setPostValue:[NSString stringWithFormat:@"%d",p] forKey:@"p"];
    [form_request setDidFinishSelector:@selector(finishGetMyAddress:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}

-(void)finishGetMyAddress:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"收获地址  str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSArray *dataArray = [dic objectForKey:@"data"];
    [self.addrArray addObjectsFromArray:dataArray];
    [addrTableView reloadData];
    [SVProgressHUD dismiss];
}

#pragma mark - 请求失败代理
-(void)loginFailed:(ASIHTTPRequest *)formRequest{
//    NSLog(@"formRequest.error-------------%@",formRequest.error);
    NSString *errorStr = [NSString stringWithFormat:@"%@",formRequest.error];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorStr delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark - TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [addrArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headV = [[UIView alloc]init];
//    headV.backgroundColor = [UIColor colorWithRed:0.2 green:0.5 blue:0.1 alpha:1];
    headV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"section_bar.png"]];
    
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectedBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"] forState:UIControlStateNormal];
    selectedBtn.frame = CGRectMake(5, 5, 40, 20);
    selectedBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [selectedBtn setTitle:@"选择" forState:UIControlStateNormal];
    [selectedBtn addTarget:self action:@selector(selectIt:) forControlEvents:UIControlEventTouchUpInside];
    selectedBtn.hidden = ! isSelecte;
    [headV addSubview:selectedBtn];
    selectedBtn.tag = section + 10; //按钮的tag是section + 10
    
    
    UILabel *noticeL = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 150, 20)];
    noticeL.backgroundColor = [UIColor clearColor];
    noticeL.font = [UIFont systemFontOfSize:15];
    noticeL.text = @"已保存的收货地址";
    [headV addSubview:noticeL];
    [noticeL release];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"] forState:UIControlStateNormal];
    deleteBtn.frame = CGRectMake(220, 5, 40, 20);
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [headV addSubview:deleteBtn];
    deleteBtn.tag = section + 30;
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"] forState:UIControlStateNormal];
    editBtn.frame = CGRectMake(270, 5, 40, 20);
    editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [editBtn setTitle:@"修改" forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [headV addSubview:editBtn];
    editBtn.tag = section + 20; //按钮的tag是section + 20
    
    return [headV autorelease];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *addrDic = [addrArray objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        NSString *realNameStr = [addrDic objectForKey:@"realname"];
        cell.textLabel.text = [NSString stringWithFormat:@"收货人:%@",realNameStr];
    }
    else if (indexPath.row == 1){
        NSString *telStr = [addrDic objectForKey:@"tel"];
        cell.textLabel.text = [NSString stringWithFormat:@"联系方式:%@",telStr];
    }
    else if (indexPath.row == 2){
        NSString *detail_infoStr = [addrDic objectForKey:@"detail_info"];
        cell.textLabel.text = [NSString stringWithFormat:@"收货地址:%@",detail_infoStr];
    }
    else if (indexPath.row == 3){
        NSString *postcodeStr = [addrDic objectForKey:@"postcode"];
        cell.textLabel.text = [NSString stringWithFormat:@"邮政编码:%@",postcodeStr];
    }
    
    return cell;
}


-(void)selectIt:(UIButton *)sender{
//    NSLog(@"选择该地址！");
    NSInteger theSection = sender.tag - 10;
    NSDictionary *addrDic = [addrArray objectAtIndex:theSection];
    
    [self.delegate SelectTheAddress:addrDic]; //把数据回传给订单页面
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)delete:(UIButton *)sender{
//    NSLog(@"删除地址！");
    NSInteger theSection = sender.tag - 30;
    NSDictionary *addrDic = [addrArray objectAtIndex:theSection];
    NSString *aidStr = [addrDic objectForKey:@"mid"];
    [self deleteTheAddress:aidStr];
    [addrArray removeObject:addrDic];
    [addrTableView reloadData];
}

-(void)deleteTheAddress:(NSString *)aid {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSURL *newUrl = [NSURL URLWithString:THEURL(DELETE)];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:token forKey:@"token"];
    [form_request setPostValue:aid forKey:@"aid"];
    [form_request setPostValue:@"del" forKey:@"action"];
    [form_request setDidFinishSelector:@selector(finishDeletedTheAddress:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}

-(void)finishDeletedTheAddress:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"修改后提交str     is     %@",str);
    [str release];
}

-(void)edit:(UIButton *)sender{
    NSLog(@"修改收货地址！");
    NewAddress *newAddressVC = [[NewAddress alloc]init];
    newAddressVC.isNew = NO;
    newAddressVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newAddressVC animated:YES];
    [newAddressVC release];
    
    NSInteger theSection = sender.tag - 20;
    NSDictionary *addrDic = [addrArray objectAtIndex:theSection];
    newAddressVC.nameF.text = [addrDic objectForKey:@"realname"];
    newAddressVC.phoneF.text = [addrDic objectForKey:@"tel"];
    newAddressVC.addressF.text = [addrDic objectForKey:@"detail_info"];
    newAddressVC.youbianF.text = [addrDic objectForKey:@"postcode"];
    newAddressVC.aid = [addrDic objectForKey:@"mid"];
}

-(void)toAddNewAddress{
    NSLog(@"添加新收货地址！");
    NewAddress *newAddressVC = [[NewAddress alloc]init];
    newAddressVC.isNew = YES;
    newAddressVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newAddressVC animated:YES];
    [newAddressVC release];
}


#pragma mark - 编辑收货地址页面导航栏
-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toSaveTheEdit{
    NSLog(@"保存提交更改过的收货地址");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
