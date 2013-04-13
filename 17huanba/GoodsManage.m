//
//  GoodsManage.m
//  一起换吧
//
//  Created by Chen Hao on 13-4-13.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "GoodsManage.h"
#import "JSON.h"
#import "SVProgressHUD.h"
#import "Xiangxi.h"
#import "GoodsCell.h"

#define XIAJIA @"/phone/goods/Onsale.html"  //商品下架操作
@interface GoodsManage () 

@end

@implementation GoodsManage

@synthesize changeIV,kindsBtn,goodsTableView,goodsArray,goods_request;
@synthesize refreshing;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.goodsArray = [NSMutableArray array];
        page = 0;
        type = 1; //默认是已上架商品列表
    }
    return self;
}

-(void)dealloc{
    [goods_request clearDelegatesAndCancel];
    [goods_request release];
    
    [changeIV release];
    [kindsBtn release];
    [goodsTableView release];
    [goodsArray release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.goodsTableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-44-20) pullingDelegate:self];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg.png"]];
    goodsTableView.backgroundView = view;
    [view release];
    goodsTableView.delegate = self;
    goodsTableView.dataSource = self;
    [self.view addSubview:goodsTableView];
    [goodsTableView release];
    
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
    [kindsBtn setTitle:@" 好友动态" forState:UIControlStateNormal];
    [kindsBtn addTarget:self action:@selector(toChangeKinds:) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:kindsBtn];
    
    UIButton *writeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    writeBtn.frame = CGRectMake(280, 5, 33, 33);
    [writeBtn setBackgroundImage:[UIImage imageNamed:@"write_btn.png"] forState:UIControlStateNormal];
    [writeBtn addTarget:self action:@selector(toWrite) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:writeBtn];
    
    self.changeIV = [[UIImageView alloc]initWithFrame:CGRectMake(104, 44, 112, 164)];
    changeIV.image = [UIImage imageNamed:@"drop_menu_big.png"];
    changeIV.userInteractionEnabled = YES;
    [self.view addSubview:changeIV];
    [changeIV release];
    changeIV.hidden = YES;
    
    UIButton *shangjiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shangjiaBtn.frame = CGRectMake(0, 15, 112, 20);
    shangjiaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [shangjiaBtn setTitle:@"已上架" forState:UIControlStateNormal];
    [shangjiaBtn addTarget:self action:@selector(changeToShangjia:) forControlEvents:UIControlEventTouchUpInside];
    [changeIV addSubview:shangjiaBtn];
    
    UIButton *zaikuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zaikuBtn.frame = CGRectMake(0, 55, 112, 20);
    zaikuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [zaikuBtn setTitle:@"在库" forState:UIControlStateNormal];
    [zaikuBtn addTarget:self action:@selector(changeToZaiku:) forControlEvents:UIControlEventTouchUpInside];
    [changeIV addSubview:zaikuBtn];
    
    UIButton *maidaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    maidaoBtn.frame = CGRectMake(0, 95, 112, 20);
    maidaoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [maidaoBtn setTitle:@"买到的" forState:UIControlStateNormal];
    [maidaoBtn addTarget:self action:@selector(changeToMaidao:) forControlEvents:UIControlEventTouchUpInside];
    [changeIV addSubview:maidaoBtn];
    
    UIButton *shenheBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shenheBtn.frame = CGRectMake(0, 135, 112, 20);
    shenheBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [shenheBtn setTitle:@"审核中" forState:UIControlStateNormal];
    [shenheBtn addTarget:self action:@selector(changeToShenhe:) forControlEvents:UIControlEventTouchUpInside];
    [changeIV addSubview:shenheBtn];
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

#pragma mark - 获取用户通知列表（收到和申请）
-(void)getTheGoodsWithType:(NSString *)listType andPage:(int)p { //获取登录用户商品列表
    [SVProgressHUD showWithStatus:@"加载中.."];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/goods/showlist.html")];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:uid forKey:@"uid"]; //用户ID
    [form_request setPostValue:token forKey:@"token"];
    [form_request setPostValue:listType forKey:@"type"];
    [form_request setPostValue:[NSString stringWithFormat:@"%d",p] forKey:@"page"];
    [form_request setDidFinishSelector:@selector(finishGetTheGoods:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}

-(void)finishGetTheGoods:(ASIFormDataRequest *)request{
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"已上架 str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSLog(@"dic is %@",dic);
    id array = [dic objectForKey:@"state"];
    if ([array isKindOfClass:[NSArray class]]) {
        [goodsArray addObjectsFromArray:array];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"暂时没有数据哦！" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [goodsTableView reloadData];
    [goodsTableView tableViewDidFinishedLoading];
    [SVProgressHUD dismiss];
}

#pragma mark - 请求失败代理
-(void)loginFailed:(ASIHTTPRequest *)formRequest{
    NSLog(@"formRequest.error-------------%@",formRequest.error);
    NSString *errorStr = [NSString stringWithFormat:@"%@",formRequest.error];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorStr delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
    [alert release];
    [goodsTableView tableViewDidFinishedLoading];
}

#pragma mark - Scroll
//会在视图滚动时收到通知。包括一个指向被滚动视图的指针，从中可以读取contentOffset属性以确定其滚动到的位置。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    kindsBtn.selected = NO;
    changeIV.hidden = YES;
    
    [self.goodsTableView tableViewDidScroll:scrollView];
}


//当用户抬起拖动的手指时得到通知。还会得到一个布尔值，知名报告滚动视图最后位置之前，是否需要减速。
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.goodsTableView tableViewDidEndDragging:scrollView];
}
#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    self.refreshing = YES;
    [self performSelector:@selector(refreshPage) withObject:nil afterDelay:1.f];
}
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

-(void)loadData
{
    page++;
    refreshing = NO;
    NSLog(@"%d",page);
        if ([kindsBtn.currentTitle isEqualToString:@" 已上架"]) {
            [self getTheGoodsWithType:@"1" andPage:page];
        }
        else if ([kindsBtn.currentTitle isEqualToString:@" 在库"]){
            [self getTheGoodsWithType:@"2" andPage:page];
        }
        else if ([kindsBtn.currentTitle isEqualToString:@" 买到的"]){
            [self getTheGoodsWithType:@"3" andPage:page];
        }
        else if ([kindsBtn.currentTitle isEqualToString:@" 审核中"]){
            [self getTheGoodsWithType:@"4" andPage:page];
        }
    NSLog(@"loadData  loadData  loadData");
}

-(void)refreshPage{
    refreshing = NO;
    page = 0;
    [goodsArray removeAllObjects];
    if ([kindsBtn.currentTitle isEqualToString:@" 已上架"]) {
        [self getTheGoodsWithType:@"1" andPage:0];
    }
    else if ([kindsBtn.currentTitle isEqualToString:@" 在库"]){
        [self getTheGoodsWithType:@"2" andPage:0];
    }
    else if ([kindsBtn.currentTitle isEqualToString:@" 买到的"]){
        [self getTheGoodsWithType:@"3" andPage:0];
    }
    else if ([kindsBtn.currentTitle isEqualToString:@" 审核中"]){
        [self getTheGoodsWithType:@"4" andPage:0];
    }
    NSLog(@"refresh  refresh  refresh");
}

#pragma mark - 不同选项对应的不同方法
-(void)changeToShangjia:(UIButton *)sender{
    type = 1;
    page = 0;
    NSString *title = [NSString stringWithFormat:@" %@",sender.titleLabel.text];
    [kindsBtn setTitle:title forState:UIControlStateNormal];
    kindsBtn.selected = NO;
    changeIV.hidden = YES;
    [goodsArray removeAllObjects];
    [self getTheGoodsWithType:@"1" andPage:0];
}

-(void)changeToZaiku:(UIButton *)sender{
    type = 2;
    page = 0;
    NSString *title = [NSString stringWithFormat:@" %@",sender.titleLabel.text];
    [kindsBtn setTitle:title forState:UIControlStateNormal];
    kindsBtn.selected = NO;
    changeIV.hidden = YES;
    [goodsArray removeAllObjects];
    [self getTheGoodsWithType:@"2" andPage:0];
    
}

-(void)changeToMaidao:(UIButton *)sender{
    type = 3;
    page = 0;
    NSString *title = [NSString stringWithFormat:@" %@",sender.titleLabel.text];
    [kindsBtn setTitle:title forState:UIControlStateNormal];
    kindsBtn.selected = NO;
    changeIV.hidden = YES;
    [goodsArray removeAllObjects];
    [self getTheGoodsWithType:@"3" andPage:0];
    
}

-(void)changeToShenhe:(UIButton *)sender{
    type = 4;
    page = 0;
    NSString *title = [NSString stringWithFormat:@" %@",sender.titleLabel.text];
    [kindsBtn setTitle:title forState:UIControlStateNormal];
    kindsBtn.selected = NO;
    changeIV.hidden = YES;
    [goodsArray removeAllObjects];
    [self getTheGoodsWithType:@"4" andPage:0];
}

#pragma mark = UITableViewDelegate methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [goodsArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indef = @"goodsCell";
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:indef];
    if (!cell) {
        cell = [[GoodsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indef];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //关闭点击效果
    NSDictionary *goodsDic = [goodsArray objectAtIndex:indexPath.row];
    if (type == 1) { //已上架
        NSString *imgStr = [goodsDic objectForKey:@"midimg"];
        if (![imgStr isEqualToString:@" "]) {
            cell.gdimg.urlString = THEURL(imgStr);
        }
        cell.nameL.text = [goodsDic objectForKey:@"goodsname"];
        
        cell.catType.text = [goodsDic objectForKey:@"catname"];
        
        NSString *price = nil;
        NSString *sell_type = [goodsDic objectForKey:@"selltype"];
        NSString *gold = [goodsDic objectForKey:@"gold"];
        NSString *silver = [goodsDic objectForKey:@"silver"];
        NSString *memoStr = [goodsDic objectForKey:@"memo"];
        
        if ([sell_type isEqualToString:@"1"]) {
            price = [NSString stringWithFormat:@"接受%@交换",memoStr];
        }
        else if ([sell_type isEqualToString:@"2"]) {
            price = [NSString stringWithFormat:@"￥%@+%@换币",gold,silver];
            
        }
        else if ([sell_type isEqualToString:@"3"])
        {
            price = [NSString stringWithFormat:@"￥%@+%@换币或%@",gold,silver,memoStr];
        }
        cell.sell_type.text = price;
        
        cell.xiajiaBtn.frame = CGRectMake(240, 5, 60, 26); //下架按钮
        [cell.xiajiaBtn addTarget:self action:@selector(xiajia:) forControlEvents:UIControlEventTouchUpInside];
        
        
        cell.editBtn.frame = CGRectMake(180, 35, 60, 26); //编辑按钮
        [cell.editBtn addTarget:self action:@selector(editGoods:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.shareBtn.frame = CGRectMake(240, 35, 60, 26); //分享按钮
        [cell.shareBtn addTarget:self action:@selector(shareGoods:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if(type == 2){ //在库商品
        NSString *imgStr = [goodsDic objectForKey:@"midimg"];
        if (![imgStr isEqualToString:@" "]) {
            cell.gdimg.urlString = THEURL(imgStr);
        }
        cell.nameL.text = [goodsDic objectForKey:@"goodsname"];
        
        cell.catType.text = [goodsDic objectForKey:@"catname"];
        
        NSString *price = nil;
        NSString *sell_type = [goodsDic objectForKey:@"sell_type"];
        NSString *gold = [goodsDic objectForKey:@"gold"];
        NSString *silver = [goodsDic objectForKey:@"silver"];
        NSString *memoStr = [goodsDic objectForKey:@"memo"];
        
        if ([sell_type isEqualToString:@"1"]) {
            price = [NSString stringWithFormat:@"接受%@交换",memoStr];
        }
        else if ([sell_type isEqualToString:@"2"]) {
            price = [NSString stringWithFormat:@"￥%@+%@换币",gold,silver];
            
        }
        else if ([sell_type isEqualToString:@"3"])
        {
            price = [NSString stringWithFormat:@"￥%@+%@换币或%@",gold,silver,memoStr];
        }
        
        cell.shangjiaBtn.frame = CGRectMake(240, 5, 60, 26); //下架按钮
        [cell.shangjiaBtn addTarget:self action:@selector(shangjia:) forControlEvents:UIControlEventTouchUpInside];
        
        
        cell.editBtn.frame = CGRectMake(180, 35, 60, 26); //编辑按钮
        [cell.editBtn addTarget:self action:@selector(editGoods:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.shareBtn.frame = CGRectMake(240, 35, 60, 26); //分享按钮
        [cell.shareBtn addTarget:self action:@selector(shareGoods:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if(type == 3){ //买到的商品
        NSString *imgStr = [goodsDic objectForKey:@"midimg"];
        if (![imgStr isEqualToString:@" "]) {
            cell.gdimg.urlString = THEURL(imgStr);
        }
        cell.nameL.text = [goodsDic objectForKey:@"goodsname"];
        
        cell.catType.text = [goodsDic objectForKey:@"catname"];
        
        NSString *price = nil;
        NSString *sell_type = [goodsDic objectForKey:@"sell_type"];
        NSString *gold = [goodsDic objectForKey:@"gold"];
        NSString *silver = [goodsDic objectForKey:@"silver"];
        NSString *memoStr = [goodsDic objectForKey:@"memo"];
        
        if ([sell_type isEqualToString:@"1"]) {
            price = [NSString stringWithFormat:@"接受%@交换",memoStr];
        }
        else if ([sell_type isEqualToString:@"2"]) {
            price = [NSString stringWithFormat:@"￥%@+%@换币",gold,silver];
            
        }
        else if ([sell_type isEqualToString:@"3"])
        {
            price = [NSString stringWithFormat:@"￥%@+%@换币或%@",gold,silver,memoStr];
        }
        cell.shareBtn.frame = CGRectMake(240, 35, 60, 26); //分享按钮
        [cell.shareBtn addTarget:self action:@selector(shareGoods:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(type == 4){ //审核中的商品
        NSString *imgStr = [goodsDic objectForKey:@"midimg"];
        if (![imgStr isEqualToString:@" "]) {
            cell.gdimg.urlString = THEURL(imgStr);
        }
        cell.nameL.text = [goodsDic objectForKey:@"goodsname"];
        
        cell.catType.text = [goodsDic objectForKey:@"catname"];
        
        NSString *price = nil;
        NSString *sell_type = [goodsDic objectForKey:@"sell_type"];
        NSString *gold = [goodsDic objectForKey:@"gold"];
        NSString *silver = [goodsDic objectForKey:@"silver"];
        NSString *memoStr = [goodsDic objectForKey:@"memo"];
        
        if ([sell_type isEqualToString:@"1"]) {
            price = [NSString stringWithFormat:@"接受%@交换",memoStr];
        }
        else if ([sell_type isEqualToString:@"2"]) {
            price = [NSString stringWithFormat:@"￥%@+%@换币",gold,silver];
            
        }
        else if ([sell_type isEqualToString:@"3"])
        {
            price = [NSString stringWithFormat:@"￥%@+%@换币或%@",gold,silver,memoStr];
        }
        cell.editBtn.frame = CGRectMake(180, 35, 60, 26); //编辑按钮
        [cell.editBtn addTarget:self action:@selector(editGoods:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.shareBtn.frame = CGRectMake(240, 35, 60, 26); //分享按钮
        [cell.shareBtn addTarget:self action:@selector(shareGoods:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return cell;
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
