//
//  Sets.m
//  17huanba
//
//  Created by Chen Hao on 13-1-24.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "Sets.h"
#import "FankuiYijian.h"
#import "BanbenxinxiVC.h"
#import "HelpVC.h"
#import "Denglu.h"

@interface Sets ()

@end

@implementation Sets
@synthesize setTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    UILabel *nameL=[[UILabel alloc]initWithFrame:CGRectMake(100, 10, 120, 24)];
    nameL.font=[UIFont systemFontOfSize:17];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.textAlignment = UITextAlignmentCenter;
    nameL.textColor = [UIColor whiteColor];
    nameL.text = @"设置";
    [navIV addSubview:nameL];
    [nameL release];
    [self.view addSubview:navIV];
    [navIV release];
    
    self.setTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-44) style:UITableViewStyleGrouped];
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg.png"]];
    setTableView.backgroundView = view;
    [view release];
    
    setTableView.delegate = self;
    setTableView.dataSource = self;
    [self.view addSubview:setTableView];
    [setTableView release];
}

-(void)viewDidAppear:(BOOL)animated{
    [setTableView reloadData];
}

#pragma mark = UITableViewDelegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 40;
    }
    else{
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else if (section == 1){
        return 3;
    }
    else
        return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indef = @"setCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indef];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indef] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    if (indexPath.section == 0){
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.text = @"清除本地缓存";
    }
    
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"17换吧，换客新体验！";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == 1){
            cell.textLabel.text = @"意见反馈！";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == 2){
            cell.textLabel.text = @"关于17换吧V1.0";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else {
        BOOL isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"] boolValue];
        cell.backgroundColor = [UIColor darkGrayColor];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        if (isLogin) { //如果已登陆
            cell.textLabel.text = @"注销登陆";
        }
        else{
            cell.textLabel.text = @"登陆";
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {  //清除本地缓存
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [paths objectAtIndex:0];
        NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:documentPath];
        NSString *fileName = @"";
        while (fileName = [dirEnum nextObject])
        {
            NSString *path = [documentPath stringByAppendingPathComponent:fileName];
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"缓存清理完毕！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        alert.delegate = self;
        [alert show];
        [alert release];
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            FankuiYijian *yijianVC = [[FankuiYijian alloc]init];
            [self.navigationController pushViewController:yijianVC animated:YES];
            [yijianVC release];
        }
        else if(indexPath.row == 2){
            BanbenxinxiVC *banbenVC = [[BanbenxinxiVC alloc]init];
            [self.navigationController pushViewController:banbenVC animated:YES];
            [banbenVC release];
        }
        else{
            HelpVC *helpVC = [[HelpVC alloc]init];
            [self presentModalViewController:helpVC animated:YES];
            [helpVC release];
        }
    }
    else{
        //注销登陆
        BOOL isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"] boolValue];
        if (isLogin) { //如果已登陆
        UIAlertView *exitAlert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"真的要注销登陆么？" delegate:self cancelButtonTitle:@"不" otherButtonTitles:@"是",nil];
        [exitAlert show];
        [exitAlert release];
        }
        else{
            Denglu *dengluVC = [[Denglu alloc]init];
            UINavigationController *dengluNav = [[UINavigationController alloc]initWithRootViewController:dengluVC];
            [dengluVC release];
            [self presentModalViewController:dengluNav animated:YES];
            [dengluNav release];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        if (buttonIndex == 0) {
            //
        }
        else{
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"logined"]; //登陆状态改为未登陆
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"autoLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [setTableView reloadData];
        }
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
