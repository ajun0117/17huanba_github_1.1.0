//
//  DetailFenlei.m
//  17huanba
//
//  Created by Chen Hao on 13-2-1.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "DetailFenlei.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "ThirdFen.h"
#import "SVProgressHUD.h"

@interface DetailFenlei ()

@end

@implementation DetailFenlei
@synthesize detailFenleiTableView;
@synthesize navTitleL,idStr,secondArray,secondDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.secondArray = [NSMutableArray array];
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    [detailFenleiTableView release];
    RELEASE_SAFELY(idStr);
    RELEASE_SAFELY(navTitleL);
    RELEASE_SAFELY(secondArray);
}

-(void)viewDidUnload{
    [super viewDidUnload];
    self.detailFenleiTableView = nil;
    RELEASE_SAFELY(idStr);
    RELEASE_SAFELY(navTitleL);
    RELEASE_SAFELY(secondArray);
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
    
    self.navTitleL=[[UILabel alloc]initWithFrame:CGRectMake(90, 10, 160, 24)];
    navTitleL.font=[UIFont systemFontOfSize:17];
    navTitleL.backgroundColor = [UIColor clearColor];
    navTitleL.textAlignment = UITextAlignmentCenter;
    navTitleL.textColor = [UIColor whiteColor];
    navTitleL.text = @"详细分类";
    [navIV addSubview:navTitleL];
    [navTitleL release];
    [self.view addSubview:navIV];
    [navIV release];
    
    self.detailFenleiTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-44) style:UITableViewStylePlain];
    detailFenleiTableView.delegate = self;
    detailFenleiTableView.dataSource = self;
    detailFenleiTableView.bounces =NO;
    [self.view addSubview:detailFenleiTableView];
    [detailFenleiTableView release];
    
    [self getSecondfenlei];
}

-(void)getSecondfenlei{
    [SVProgressHUD showWithStatus:@"加载中.."];
    NSURL *newUrl = [NSURL URLWithString:THEURL(FENLEI)];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:idStr forKey:@"id"];
    [form_request setDidFinishSelector:@selector(finishGetSecondfenlei:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}

-(void)finishGetSecondfenlei:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"二级分类  str    is   %@",str);
    self.secondDic = [str JSONValue];
    [str release];
    [secondDic removeObjectForKey:@"0"];
    NSArray *tempArray = [[secondDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [self.secondArray addObjectsFromArray:tempArray];
    [detailFenleiTableView reloadData];
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

#pragma mark - UItableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [secondArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indef = @"fenleiCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indef];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indef] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    NSString *keyStr = [secondArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [secondDic objectForKey:keyStr];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ThirdFen *thirdVC = [[ThirdFen alloc]init];
    NSString *key = [secondArray objectAtIndex:indexPath.row];
    thirdVC.idStr = key;
    thirdVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:thirdVC animated:YES];
    thirdVC.navTitleL.text = cell.textLabel.text;
    [thirdVC release];
}


#pragma mark - MyMethods
-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.detailFenleiTableView = nil;
    RELEASE_SAFELY(navTitleL);
}

@end
