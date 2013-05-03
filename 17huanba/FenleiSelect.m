//
//  FenleiSelect.m
//  17huanba
//
//  Created by Chen Hao on 13-2-21.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "FenleiSelect.h"
#import "secondFenlei.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"



@interface FenleiSelect ()

@end

@implementation FenleiSelect
@synthesize fenleiTableView;
@synthesize fristArray;
@synthesize backFabuDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.fristArray = [NSMutableArray array];
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    [fenleiTableView release];
    RELEASE_SAFELY(fristArray);
}

-(void)viewDidUnload{
    [super viewDidUnload];
    self.fenleiTableView = nil;
    RELEASE_SAFELY(fristArray);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView *navIV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_nav.png"]];
    navIV.userInteractionEnabled=YES;
    navIV.frame=CGRectMake(0, 0, 320, 44);
    
    UILabel *nameL=[[UILabel alloc]initWithFrame:CGRectMake(130, 10, 80, 24)];
    nameL.font=[UIFont boldSystemFontOfSize:17];
    nameL.textColor = [UIColor whiteColor];
    nameL.backgroundColor=[UIColor clearColor];
    nameL.text=@"17换吧";
    [navIV addSubview:nameL];
    [nameL release];
    
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
    
    [self getFristfenlei];
}

-(void)getFristfenlei{
    NSURL *newUrl = [NSURL URLWithString:THEURL(FENLEI)];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:@"00" forKey:@"id"];
    [form_request setDidFinishSelector:@selector(finishGetFristfenlei:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}

-(void)finishGetFristfenlei:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"一级分类  str    is   %@",str);
    id fristFenlei = [str JSONValue];
    [str release];
    if ([fristFenlei isKindOfClass:[NSArray class]]) {
        [fristFenlei removeObjectAtIndex:0];
        [self.fristArray addObjectsFromArray:fristFenlei];
    }
    else{
        [fristFenlei removeObjectForKey:@"0"];
        [self.fristArray addObjectsFromArray:[fristFenlei allValues]];
    }
    [fenleiTableView reloadData];
}



#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [fristArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indef = @"firstCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indef];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indef] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
//    cell.textLabel.text = [NSString stringWithFormat:@"一级分类列表 %d",indexPath.row];
    cell.textLabel.text = [fristArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    secondFenlei *secondVC = [[secondFenlei alloc]init];
    secondVC.idStr = [NSString stringWithFormat:@"%d",indexPath.row+1];
    secondVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:secondVC animated:YES];
    secondVC.navTitleL.text = cell.textLabel.text;
    [secondVC release];
    secondVC.backFristDelegate = self;
}

-(void)backToFrist:(NSDictionary *)fenleiDic{
    [self.backFabuDelegate backToFabu:fenleiDic];
}

-(void)toBack{
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.fenleiTableView = nil;
}

@end
