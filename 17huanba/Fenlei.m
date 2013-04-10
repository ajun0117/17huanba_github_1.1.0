//
//  Fenlei.m
//  17huanba
//
//  Created by Chen Hao on 13-1-25.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "Fenlei.h"
#import "DetailFenlei.h"
#import "List.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "SVProgressHUD.h"

//#define FRISTFENLEI @"二手电脑",@"二手手机/数码产品",@"家具家装",@"二手家用电器",@"母婴/玩具乐器",@"个户化妆",@"服装/鞋帽/礼品/箱包",@"图书/影像/软件",@"食品饮料/保健品",@"办公用品/通讯设备",@"运动/户外",@"二手车/汽车配件"

@interface Fenlei ()

@end

@implementation Fenlei
@synthesize fenleiTableView,searchDis,mySearchBar;
@synthesize fenleiArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        fenleiArray = [[NSArray alloc]initWithObjects:FRISTFENLEI, nil];
        self.fenleiArray = [NSMutableArray array];
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    [fenleiTableView release];
    [mySearchBar release];
    [searchDis release];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    self.fenleiTableView = nil;
    self.mySearchBar = nil;
    self.searchDis = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    UIImageView *navIV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bar_background.png"]];
    navIV.userInteractionEnabled=YES;
    navIV.frame=CGRectMake(0, 0, 320, 44);
    
    self.mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    mySearchBar.backgroundImage = [UIImage imageNamed:@"searchbar_bg.png"];
    mySearchBar.delegate = self;
    mySearchBar.placeholder = @"亲，想搜啥搜啥吧！";
    [navIV addSubview:mySearchBar];
    searchDis = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    [mySearchBar release];
    [self.view addSubview:navIV];
    [navIV release];
    
    self.fenleiTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-44*2) style:UITableViewStylePlain];
    fenleiTableView.separatorStyle =UITableViewCellSeparatorStyleSingleLineEtched;
    fenleiTableView.delegate = self;
    fenleiTableView.dataSource = self;
    fenleiTableView.bounces =NO;
    [self.view addSubview:fenleiTableView];
    [fenleiTableView release];
    
    [self getFristfenlei];
}

-(void)getFristfenlei{
    [SVProgressHUD showWithStatus:@"加载分类信息.."];
    NSURL *newUrl = [NSURL URLWithString:THEURL(FENLEI)];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:@"00" forKey:@"id"];
    [form_request setDidFinishSelector:@selector(finishGetFristfenlei:)];
    [form_request setDidFailSelector:@selector(loginFenleiFailed:)];
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
        [self.fenleiArray addObjectsFromArray:fristFenlei];
    }
    else{
        [fristFenlei removeObjectForKey:@"0"];
        [self.fenleiArray addObjectsFromArray:[fristFenlei allValues]];
    }
    [fenleiTableView reloadData];
    [SVProgressHUD dismiss];
}

-(void)loginFenleiFailed:(ASIHTTPRequest *)request{
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"失败   %@",str);
    [str release];
    [SVProgressHUD dismissWithError:@"请检查网络连接后重试！"];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%s",__FUNCTION__);
    
    NSString *keyword = searchBar.text;
    List *listVC = [[List alloc]init];
    listVC.isKeySearch = YES;
    listVC.keyword = keyword;
    
    [self.navigationController pushViewController:listVC animated:YES];
    [listVC release];
    listVC.nameL.text = searchBar.text;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIView *button = [self.tabBarController.view viewWithTag:100];//找出tabar中间的相机Button
    [UIView animateWithDuration:0.2 animations:^{
        button.alpha = 1;
    }];
}

#pragma mark - UItableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"-----%d",[fenleiArray count]);
    return [fenleiArray count];
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
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"cate%d.png",indexPath.row]];
    cell.textLabel.text = [fenleiArray objectAtIndex:indexPath.row];
//    cell.textLabel.text = [NSString stringWithFormat:@"商品分类 %d",indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DetailFenlei *detailFenleiVC = [[DetailFenlei alloc]init];
    detailFenleiVC.idStr = [NSString stringWithFormat:@"%d",indexPath.row+1];
    detailFenleiVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailFenleiVC animated:YES];
    detailFenleiVC.navTitleL.text = cell.textLabel.text;
    [detailFenleiVC release];
    detailFenleiVC.navigationController.navigationBarHidden = YES;
    
    
    UIView *button = [self.tabBarController.view viewWithTag:100];//找出tabar中间的相机Button
    [UIView animateWithDuration:0.2 animations:^{
        button.alpha = 0;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.fenleiTableView = nil;
    self.mySearchBar = nil;
    self.searchDis = nil;
}

@end
