//
//  Viewed.m
//  17huanba
//
//  Created by Chen Hao on 13-2-5.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "Viewed.h"
#import "ListCell.h"
#import "Seen.h"
#import "Xiangxi.h"

@interface Viewed ()

@end

@implementation Viewed
@synthesize liulanTableView;
@synthesize viewedArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.viewedArray = [NSMutableArray array];
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
    nameL.text = @"浏览过的宝贝";
    [navIV addSubview:nameL];
    [nameL release];
    [self.view addSubview:navIV];
    [navIV release];
    
    UIButton *emptyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    emptyBtn.frame = CGRectMake(225, 10, 40, 27);
    emptyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [emptyBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"] forState:UIControlStateNormal];
    [emptyBtn setTitle:@"清空" forState:UIControlStateNormal];
//    [emptyBtn setTitle:@"完成" forState:UIControlStateSelected];
    [emptyBtn addTarget:self action:@selector(toEmpty) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:emptyBtn];
    
    UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleBtn.frame = CGRectMake(270, 10, 40, 27);
    deleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [deleBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"] forState:UIControlStateNormal];
    [deleBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleBtn setTitle:@"完成" forState:UIControlStateSelected];
    [deleBtn addTarget:self action:@selector(toDelete:) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:deleBtn];
    
    self.liulanTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-44) style:UITableViewStylePlain];
    liulanTableView.delegate = self;
    liulanTableView.dataSource = self;
    [self.view addSubview:liulanTableView];
    [liulanTableView release];
    
    NSMutableArray *array = [Seen findall];
    [viewedArray addObjectsFromArray:array];
}

-(void)toDelete:(UIButton *)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
        liulanTableView.editing = YES;
    }
    else{
        sender.selected = NO;
        liulanTableView.editing = NO;
    }
}

-(void)toEmpty{  //清空浏览记录
    for (Seen *seen in viewedArray) {
        int sid = seen.sid;
        [Seen deletebysid:sid];
    }
    [viewedArray removeAllObjects];
    [liulanTableView reloadData];
}

#pragma mark = UITableViewDelegate methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [viewedArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indef = @"liulanCell";
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:indef];
    if (!cell) {
        cell = [[[ListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indef] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    Seen *seen = [viewedArray objectAtIndex:indexPath.row];
    cell.nameL.text = seen.title;
    if (![seen.picUrlStr isEqualToString:@" "]) {
        cell.imageV.urlString = seen.picUrlStr;
    }
    cell.valueL.text = seen.value;
    cell.yuanValueL.text = seen.yuanValue;
    cell.fangshiL.text = @"当面交易";
    cell.timeL.text = seen.time;
    cell.weizhiL.text = seen.weizhi;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"didSelect--didSelect--didSelect");
    Xiangxi *xiangxiVC = [[Xiangxi alloc]init];
    
    Seen *seen = [viewedArray objectAtIndex:indexPath.row];
    NSString *gdidStr = [NSString stringWithFormat:@"%d",seen.gid];
    NSLog(@"gdidStr   is     %@",gdidStr);
    xiangxiVC.gdid = gdidStr;
    
    [self.navigationController pushViewController:xiangxiVC animated:YES];
    xiangxiVC.navigationController.navigationBarHidden = YES;
    [xiangxiVC release];
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Seen *seen = [viewedArray objectAtIndex:indexPath.row];
    int sid = seen.sid;
    [Seen deletebysid:sid];
    [viewedArray removeObject:seen];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
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
