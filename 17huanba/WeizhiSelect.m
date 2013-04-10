//
//  WeizhiSelect.m
//  17huanba
//
//  Created by Chen Hao on 13-3-4.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "WeizhiSelect.h"
#import "Dijishi.h"

@interface WeizhiSelect ()

@end

@implementation WeizhiSelect
@synthesize weizhiTableView;


-(void)dealloc{
    [super dealloc];
    [weizhiTableView release];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    self.weizhiTableView = nil;
}

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
    navIV.frame=CGRectMake(0, 0, 320, 44);
    
    UILabel *nameL=[[UILabel alloc]initWithFrame:CGRectMake(130, 10, 80, 24)];
    nameL.font=[UIFont boldSystemFontOfSize:17];
    nameL.textColor = [UIColor whiteColor];
    nameL.backgroundColor=[UIColor clearColor];
    nameL.text=@"省份";
    [navIV addSubview:nameL];
    [nameL release];
    
    [self.view addSubview:navIV];
    [navIV release];
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(5, 10, 57, 27);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_gray_btn.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:backBtn];
    
    self.weizhiTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-44) style:UITableViewStylePlain];
    weizhiTableView.delegate = self;
    weizhiTableView.dataSource = self;
    [self.view addSubview:weizhiTableView];
    [weizhiTableView release];
}


#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indef = @"firstCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indef];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indef] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = [NSString stringWithFormat:@"一级分类列表 %d",indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Dijishi *dijishiVC = [[Dijishi alloc]init];
    dijishiVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dijishiVC animated:YES];
    dijishiVC.navTitleL.text = cell.textLabel.text;
    [dijishiVC release];
    
}

-(void)toBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.weizhiTableView = nil;
}

@end
