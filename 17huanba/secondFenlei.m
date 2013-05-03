//
//  secondFenlei.m
//  17huanba
//
//  Created by Chen Hao on 13-2-21.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "secondFenlei.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "ThirdFenlei.h"

@interface secondFenlei ()

@end

@implementation secondFenlei
@synthesize fenleiTableView;
@synthesize navTitleL;
@synthesize idStr,secondArray,secondDic;
@synthesize backFristDelegate;

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
    [fenleiTableView release];
    [navTitleL release];
    RELEASE_SAFELY(idStr);
    RELEASE_SAFELY(secondArray);
    RELEASE_SAFELY(secondDic);
}

-(void)viewDidUnload{
    [super viewDidUnload];
    self.fenleiTableView = nil;
    self.navTitleL = nil;
    RELEASE_SAFELY(idStr);
    RELEASE_SAFELY(secondArray);
    RELEASE_SAFELY(secondDic);
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
    
    [self getSecondfenlei];
}

-(void)getSecondfenlei{
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
    NSLog(@"二级分类  str    is   %@",str);
    self.secondDic = [str JSONValue];
    [str release];
        [secondDic removeObjectForKey:@"0"];
        NSArray *tempArray = [[secondDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
        [self.secondArray addObjectsFromArray:tempArray];
    [fenleiTableView reloadData];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [secondArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indef = @"secondCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indef];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indef] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    NSString *keyStr = [secondArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [secondDic objectForKey:keyStr];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ThirdFenlei *thirdVC = [[ThirdFenlei alloc]init];
    NSString *key = [secondArray objectAtIndex:indexPath.row];
    thirdVC.idStr = key;
    thirdVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:thirdVC animated:YES];
    thirdVC.navTitleL.text = cell.textLabel.text;
    [thirdVC release];
    thirdVC.backSecondDelegate = self;
}

-(void)backToSecond:(NSDictionary *)fenleiDic{
    [self.backFristDelegate backToFrist:fenleiDic];
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
