//
//  FindYourFriends.m
//  17huanba
//
//  Created by Chen Hao on 13-2-5.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "FindYourFriends.h"
#import "FriendsCell.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "SVProgressHUD.h"
#import "WriteSixin.h"

#define DELETE @"/phone/default/Delfrd.html"

@interface FindYourFriends ()

@end

@implementation FindYourFriends
@synthesize myFriendsTableView;
@synthesize friendsArray;
@synthesize refreshing,changeIV,kindsBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.friendsArray = [NSMutableArray array];
        page = 0;
        type = 0; //代表好友列表
    }
    return self;
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
    
    [self.view addSubview:navIV];
    [navIV release];
    
    self.kindsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    kindsBtn.frame = CGRectMake(80, 10, 150, 24);
    kindsBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [kindsBtn setImage:[UIImage imageNamed:@"arrow_down.png"] forState:UIControlStateNormal];
    [kindsBtn setImage:[UIImage imageNamed:@"arrow_up.png"] forState:UIControlStateSelected];
    [kindsBtn setTitle:@" 我的好友" forState:UIControlStateNormal];
    [kindsBtn addTarget:self action:@selector(toChangeKinds:) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:kindsBtn];
    
    UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleBtn.frame = CGRectMake(258, 10, 57, 27);
    deleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [deleBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"] forState:UIControlStateNormal];
    [deleBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleBtn setTitle:@"完成" forState:UIControlStateSelected];
    [deleBtn addTarget:self action:@selector(toDelete:) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:deleBtn];
    
    self.myFriendsTableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-44-20) pullingDelegate:self];
    myFriendsTableView.delegate = self;
    myFriendsTableView.dataSource = self;
    myFriendsTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg.png"]];
    [self.view addSubview:myFriendsTableView];
    [myFriendsTableView release];
    
    
    self.changeIV = [[UIImageView alloc]initWithFrame:CGRectMake(104, 44, 112, 124)];
    changeIV.image = [UIImage imageNamed:@"drop_menu.png"];
    changeIV.userInteractionEnabled = YES;
    [self.view addSubview:changeIV];
    [changeIV release];
    changeIV.hidden = YES;
    
    UIButton *friendsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendsBtn.frame = CGRectMake(0, 15, 112, 20);
    friendsBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [friendsBtn setTitle:@"我的好友" forState:UIControlStateNormal];
    [friendsBtn addTarget:self action:@selector(changeToFriendsList:) forControlEvents:UIControlEventTouchUpInside];
    [changeIV addSubview:friendsBtn];
    
    UIButton *shouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shouBtn.frame = CGRectMake(0, 55, 112, 20);
    shouBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [shouBtn setTitle:@"收到的申请" forState:UIControlStateNormal];
    [shouBtn addTarget:self action:@selector(changeToShoudao:) forControlEvents:UIControlEventTouchUpInside];
    [changeIV addSubview:shouBtn];
    
    UIButton *faBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    faBtn.frame = CGRectMake(0, 95, 112, 20);
    faBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [faBtn setTitle:@"发出的申请" forState:UIControlStateNormal];
    [faBtn addTarget:self action:@selector(changeToFachu:) forControlEvents:UIControlEventTouchUpInside];
    [changeIV addSubview:faBtn];
    
    [self getThefriendsWithPage:0];
    
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

-(void)changeToFriendsList:(UIButton *)sender{
    NSString *title = [NSString stringWithFormat:@" %@",sender.titleLabel.text];
    [kindsBtn setTitle:title forState:UIControlStateNormal];
    kindsBtn.selected = NO;
    changeIV.hidden = YES;
    page = 0;
    type = 0;
    [friendsArray removeAllObjects];
    [self getThefriendsWithPage:0];

}

-(void)changeToShoudao:(UIButton *)sender{
    NSString *title = [NSString stringWithFormat:@" %@",sender.titleLabel.text];
    [kindsBtn setTitle:title forState:UIControlStateNormal];
    kindsBtn.selected = NO;
    changeIV.hidden = YES;
    page = 0;
    type = 1;
    [friendsArray removeAllObjects];
    [self getTheTongzhiWithStye:@"1" andPage:0];
    [myFriendsTableView reloadData];

}

-(void)changeToFachu:(UIButton *)sender{
    NSString *title = [NSString stringWithFormat:@" %@",sender.titleLabel.text];
    [kindsBtn setTitle:title forState:UIControlStateNormal];
    kindsBtn.selected = NO;
    changeIV.hidden = YES;
    page = 0;
    type = 2;
    [friendsArray removeAllObjects];
    [self getTheTongzhiWithStye:@"2" andPage:0];

}

#pragma mark - 获取用户列表申请列表
-(void)getThefriendsWithPage:(int)p{ //获取登录用户好友的动态列表
    [SVProgressHUD showWithStatus:@"加载中.."];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/logined/Frdsuc.html")];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:@"1" forKey:@"state"]; //成功加为好友的列表
    [form_request setPostValue:token forKey:@"token"];
    [form_request setPostValue:[NSString stringWithFormat:@"%d",p] forKey:@"p"];
    [form_request setDidFinishSelector:@selector(finishGetThefriends:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}


-(void)finishGetThefriends:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"Gouwuche str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
//    NSLog(@"dic is %@",dic);
    NSArray *array = [dic objectForKey:@"data"];
    if ([array count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"您暂时还没有好友哦！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    [self.friendsArray addObjectsFromArray:array];
    [myFriendsTableView reloadData];
    
    [myFriendsTableView tableViewDidFinishedLoading];
    [SVProgressHUD dismiss];

}

#pragma mark - 获取用户通知列表（收到和申请）
-(void)getTheTongzhiWithStye:(NSString *)state andPage:(int)p { //获取登录用户好友的动态列表
    [SVProgressHUD showWithStatus:@"加载中.."];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/logined/Frd.html")];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:state forKey:@"state"]; //发出的申请
    [form_request setPostValue:token forKey:@"token"];
    [form_request setPostValue:[NSString stringWithFormat:@"%d",p] forKey:@"p"];
    [form_request setDidFinishSelector:@selector(finishGetThetongzhi:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}


-(void)finishGetThetongzhi:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [str JSONValue];
    [str release];
    
    NSArray *array = [dic objectForKey:@"data"];
    
    if ([array count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"您暂时还没有收到申请哦！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    [self.friendsArray addObjectsFromArray:array];
    
    NSString *name1 = [[array objectAtIndex:0] objectForKey:@"uname"];
    NSLog(@"%@",name1);
    
    [myFriendsTableView reloadData];
    
    [myFriendsTableView tableViewDidFinishedLoading];
    [SVProgressHUD dismiss];
}
 
#pragma mark - 请求失败代理
-(void)loginFailed:(ASIHTTPRequest *)formRequest{
//    NSLog(@"formRequest.error-------------%@",formRequest.error);
    NSString *errorStr = [NSString stringWithFormat:@"%@",formRequest.error];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorStr delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
    [alert release];
    [myFriendsTableView tableViewDidFinishedLoading];
}


#pragma mark = UITableViewDelegate methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [friendsArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indef = @"friendCell";
    FriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:indef];
    if (!cell) {
        cell = [[FriendsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indef];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //关闭点击效果
    NSDictionary *friendDic = [friendsArray objectAtIndex:indexPath.row];
    if (type == 1) { //收到的请求
        NSString *headStr = [friendDic objectForKey:@"headimg"];
        if (![headStr isEqualToString:@" "]) {
            cell.head.urlString = THEURL(headStr);
        }
        cell.nameL.text = [friendDic objectForKey:@"uname"];
        if ([[friendDic objectForKey:@"sex"] isEqualToString:@"1"]) {
            cell.genderL.text = @"男";
        }
        else{
            cell.genderL.text = @"女";
        }
        cell.weizhiL.text = SHENG_SHI_XIAN([friendDic objectForKey:@"sheng"], [friendDic objectForKey:@"shi"], [friendDic objectForKey:@"xian"]);
        
        cell.shou1_bgIV.frame = CGRectMake(240, 5, 60, 26);
        cell.shou1_bgIV.image = [UIImage imageNamed:@"friendListBtnBg3.png"]; // 接受
        cell.shou2_bgIV.frame = CGRectMake(180, 35, 120, 26);
        cell.shou2_bgIV.image = [UIImage imageNamed:@"friendListBtnBg2.png"]; //拒绝和忽略
        
        UIButton *yesBtn = (UIButton *)[cell viewWithTag:10];
        [yesBtn addTarget:self action:@selector(jieshou:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *noBtn = (UIButton *)[cell viewWithTag:100];
        [noBtn addTarget:self action:@selector(jujue:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *missBtn = (UIButton *)[cell viewWithTag:1000];
        [missBtn addTarget:self action:@selector(hulue:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if(type == 2){ //发出的请求
        NSString *headStr = [friendDic objectForKey:@"headimg"];
        if (![headStr isEqualToString:@" "]) {
            cell.head.urlString = THEURL(headStr);
        }
        cell.nameL.text = [friendDic objectForKey:@"uname"];
        if ([[friendDic objectForKey:@"sex"] isEqualToString:@"1"]) {
            cell.genderL.text = @"男";
        }
        else{
            cell.genderL.text = @"女";
        }
        cell.weizhiL.text = SHENG_SHI_XIAN([friendDic objectForKey:@"sheng"], [friendDic objectForKey:@"shi"], [friendDic objectForKey:@"xian"]);
        
        cell.fa_bgIV.frame = CGRectMake(240, 20, 60, 26);
        cell.fa_bgIV.image = [UIImage imageNamed:@"friendListBtnBg4.png"]; // 等待
    }
    else if(type == 0){ //好友列表
        NSString *headStr = [friendDic objectForKey:@"headimg"];
        if (![headStr isEqualToString:@" "]) {
            cell.head.urlString = THEURL(headStr);
        }
        cell.nameL.text = [friendDic objectForKey:@"uname"];
        if ([[friendDic objectForKey:@"sex"] isEqualToString:@"1"]) {
            cell.genderL.text = @"男";
        }
        else{
            cell.genderL.text = @"女";
        }
        cell.weizhiL.text = SHENG_SHI_XIAN([friendDic objectForKey:@"sheng"], [friendDic objectForKey:@"shi"], [friendDic objectForKey:@"xian"]);
        
        cell.list_bgIV.frame = CGRectMake(220, 20, 80, 26);
        cell.list_bgIV.image = [UIImage imageNamed:@"friendListBtnBg1.png"];
        
        UIButton *sixinBtn = (UIButton *)[cell viewWithTag:20];
        [sixinBtn addTarget:self action:@selector(sixin:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *shopBtn = (UIButton *)[cell viewWithTag:30];
        [shopBtn addTarget:self action:@selector(shop:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return cell;
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (type == 0) {
        return YES;
    }
        return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *friendDic = [friendsArray objectAtIndex:indexPath.row];
    NSString *tuidStr = [friendDic objectForKey:@"uid"];

    NSURL *newUrl = [NSURL URLWithString:THEURL(DELETE)];
    
    NSString *fuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]; //登陆用户的ID
//    NSLog(@"----%@",fuid);
    
    [SVProgressHUD showWithStatus:@"删除中.."];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:tuidStr forKey:@"tuid"]; //发出的申请
    [form_request setPostValue:fuid forKey:@"fuid"];
    [form_request setDidFinishSelector:@selector(finishDeleteTheFriend:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
    
    [friendsArray removeObject:friendDic];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];

}

-(void)finishDeleteTheFriend:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"删除情况 str    is   %@",str);
    [str release];
    [SVProgressHUD dismiss];
}

-(void)toDelete:(UIButton *)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
        myFriendsTableView.editing = YES;
    }
    else{
        sender.selected = NO;
        myFriendsTableView.editing = NO;
    }
}


#pragma mark - Scroll
//会在视图滚动时收到通知。包括一个指向被滚动视图的指针，从中可以读取contentOffset属性以确定其滚动到的位置。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.myFriendsTableView tableViewDidScroll:scrollView];
}


//当用户抬起拖动的手指时得到通知。还会得到一个布尔值，知名报告滚动视图最后位置之前，是否需要减速。
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.myFriendsTableView tableViewDidEndDragging:scrollView];
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
    refreshing = NO;
    page++;
    refreshing = NO;
    if (type == 0) { //好友列表
        [self getThefriendsWithPage:page];
    }
    else if (type == 1){
        [self getTheTongzhiWithStye:@"1" andPage:page];
    }
    else{
        [self getTheTongzhiWithStye:@"2" andPage:page];
    }
}

-(void)refreshPage{
    refreshing = NO;
    page = 0;
    [friendsArray removeAllObjects];
    if (type == 0) { //好友列表
        [self getThefriendsWithPage:0];
    }
    else if (type == 1){
        [self getTheTongzhiWithStye:@"1" andPage:0];
    }
    else{
        [self getTheTongzhiWithStye:@"2" andPage:0];
    }
}

-(void)jieshou:(UIButton *)sender{ //接受申请
    NSLog(@"%s",__FUNCTION__);
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    NSIndexPath *indexPath = [myFriendsTableView indexPathForCell:cell]; //获取相应的Cell的indexPath，之后从数组中取值得到该好友的ID
    NSDictionary *userDic = [friendsArray objectAtIndex:indexPath.row];
    NSString *uidStr = [userDic objectForKey:@"uid"];
    [self actionWithUid:uidStr andAction:@"1"];
}

-(void)jujue:(UIButton *)sender{ //拒绝申请（删除申请）
    NSLog(@"%s",__FUNCTION__);
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    NSIndexPath *indexPath = [myFriendsTableView indexPathForCell:cell]; //获取相应的Cell的indexPath，之后从数组中取值得到该好友的ID
    
    NSDictionary *friendDic = [friendsArray objectAtIndex:indexPath.row];
    NSString *tuidStr = [friendDic objectForKey:@"uid"];
    NSURL *newUrl = [NSURL URLWithString:THEURL(DELETE)];
    NSString *fuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]; //登陆用户的ID
    
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:tuidStr forKey:@"tuid"]; //发出的申请
    [form_request setPostValue:fuid forKey:@"fuid"];
    [form_request setDidFinishSelector:@selector(finishDeleteTheFriend:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
    
    [friendsArray removeObject:friendDic];
    [myFriendsTableView reloadData];
}

-(void)hulue:(UIButton *)sender{ //忽略申请（删除申请）
    NSLog(@"%s",__FUNCTION__);
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    NSIndexPath *indexPath = [myFriendsTableView indexPathForCell:cell]; //获取相应的Cell的indexPath，之后从数组中取值得到该好友的ID
    
    NSDictionary *friendDic = [friendsArray objectAtIndex:indexPath.row];
    NSString *tuidStr = [friendDic objectForKey:@"uid"];
    
    NSURL *newUrl = [NSURL URLWithString:THEURL(DELETE)];
    
    NSString *fuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]; //登陆用户的ID
    
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:tuidStr forKey:@"tuid"]; //发出的申请
    [form_request setPostValue:fuid forKey:@"fuid"];
    [form_request setDidFinishSelector:@selector(finishDeleteTheFriend:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
    
    [friendsArray removeObject:friendDic];
    [myFriendsTableView reloadData];
}

-(void)sixin:(UIButton *)sender{ //发私信
    NSLog(@"%s",__FUNCTION__);
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [myFriendsTableView indexPathForCell:cell]; //获取相应的Cell的indexPath，之后从数组中取值得到该好友的ID
    NSLog(@"%d",indexPath.row);
    NSDictionary *friendDic = [friendsArray objectAtIndex:indexPath.row];
    WriteSixin *writeSixinVC = [[WriteSixin alloc]init];
    [self.navigationController pushViewController:writeSixinVC animated:YES];
    [writeSixinVC release];
    writeSixinVC.uname = [friendDic objectForKey:@"uname"];
    [writeSixinVC.myTextView becomeFirstResponder];
}

-(void)shop:(UIButton *)sender{ //去他的店铺
    NSLog(@"%s",__FUNCTION__);
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    NSIndexPath *indexPath = [myFriendsTableView indexPathForCell:cell]; //获取相应的Cell的indexPath，之后从数组中取值得到该好友的ID
}

#pragma mark - 对好友申请执行相应操作
-(void)actionWithUid:(NSString *)uid andAction:(NSString *)action{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/logined/Frdoption.html")];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:uid forKey:@"uid"]; //发出的申请
    [form_request setPostValue:token forKey:@"token"];
    [form_request setPostValue:action forKey:@"action"];
    [form_request setDidFinishSelector:@selector(finishTheAction:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}

-(void)finishTheAction:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"Gouwuche str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
//    NSLog(@"array is %@",dic);
    NSString *info = [dic objectForKey:@"info"];
    NSLog(@"info-----%@",info);
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
