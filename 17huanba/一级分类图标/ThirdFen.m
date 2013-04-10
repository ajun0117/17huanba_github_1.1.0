//
//  ThirdFen.m
//  17huanba
//
//  Created by Chen Hao on 13-3-21.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "ThirdFen.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "List.h"
#import "SVProgressHUD.h"

@interface ThirdFen ()

@end

@implementation ThirdFen
@synthesize fenleiTableView;
@synthesize navTitleL;
@synthesize idStr,thirdArray,thirdDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.thirdArray = [NSMutableArray array];
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    [fenleiTableView release];
    [navTitleL release];
    RELEASE_SAFELY(idStr);
    RELEASE_SAFELY(thirdArray);
    RELEASE_SAFELY(thirdDic);
}

-(void)viewDidUnload{
    [super viewDidUnload];
    self.fenleiTableView = nil;
    self.navTitleL = nil;
    RELEASE_SAFELY(idStr);
    RELEASE_SAFELY(thirdArray);
    RELEASE_SAFELY(thirdDic);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImageView *navIV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_nav.png"]];
    navIV.userInteractionEnabled = YES;
    navIV.frame=CGRectMake(0, 0, 320, 44);
    
    self.navTitleL=[[UILabel alloc]initWithFrame:CGRectMake(80, 10, 160, 24)];
    navTitleL.font=[UIFont boldSystemFontOfSize:17];
    navTitleL.textColor = [UIColor whiteColor];
    navTitleL.textAlignment = UITextAlignmentCenter;
    navTitleL.backgroundColor=[UIColor clearColor];
    navTitleL.text=@"17换吧";
    [navIV addSubview:navTitleL];
    [navTitleL release];
    
    [self.view addSubview:navIV];
    [navIV release];
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(5, 10, 57, 27);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_gray_btn.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:backBtn];
    
    self.fenleiTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-44) style:UITableViewStylePlain];
    fenleiTableView.delegate = self;
    fenleiTableView.dataSource = self;
    [self.view addSubview:fenleiTableView];
    [fenleiTableView release];
    
    [self getThirdfenlei];
}

-(void)getThirdfenlei{
    [SVProgressHUD showWithStatus:@"加载中.."];
    NSURL *newUrl = [NSURL URLWithString:THEURL(FENLEI)];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    
    [form_request setPostValue:idStr forKey:@"id"];
    [form_request setDidFinishSelector:@selector(finishGetThirdfenlei:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}

-(void)finishGetThirdfenlei:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"二级分类  str    is   %@",str);
    self.thirdDic = [str JSONValue];
    [str release];
    [thirdDic removeObjectForKey:@"0"];
    NSArray *tempArray = [[thirdDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [self.thirdArray addObjectsFromArray:tempArray];
    [fenleiTableView reloadData];
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

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [thirdArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indef = @"thirdCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indef];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indef] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *key = [thirdArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [thirdDic objectForKey:key];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *key = [thirdArray objectAtIndex:indexPath.row];
    NSString *value = [thirdDic objectForKey:key];
    List *listVC = [[List alloc]init];
    listVC.isKeySearch = NO;
    listVC.cidStr = key;
    listVC.nameL.text = value;
    [self.navigationController pushViewController:listVC animated:YES];
    [listVC release];
}



-(void)toBack{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.fenleiTableView = nil;
    self.navTitleL = nil;
}

@end
