//
//  Fabu.m
//  17huanba
//
//  Created by Chen Hao on 13-1-25.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "Fabu.h"
#import "BaseViewController.h"
#import "ShouYe.h"
#import "FenleiSelect.h"
#import "WeizhiSelect.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "Caogao.h"
#import "SVProgressHUD.h"

#define FIELDS_COUNT 13
#define JIAOYIFANGSHI @"以物易物",@"人民币 + 换币",@"两种方式均可"
#define CHENGSE @"全新",@"二手"
#define UPGOODS @"/phone/plogined/Upgoods.html"

@interface Fabu ()

@end

@implementation Fabu
@synthesize fabuTableView;
@synthesize picScrollView;
@synthesize biaotiTV,miaoshuTV;
@synthesize RMBTF,huanbiTF,yuanjiaTF,tongchengTF,yidiTF,wuwuTF;
@synthesize fangshiTF,fenleiTF,chengseTF,weizhiTF;
//@synthesize fangshiPV,fenleiPV,chengsePV,weizhiPV;
@synthesize chengsePV;
@synthesize keyboardToolbar;
@synthesize fangshiArray,chengseArray;
@synthesize proviceArray,cityArray,regionArray;
@synthesize theFenleiDic;
@synthesize shouTF,addrID;
@synthesize baoyouSeg,sellTypeSeg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //注册键盘出现和消失的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
        
        self.fangshiArray = [NSArray arrayWithObjects:JIAOYIFANGSHI, nil];
        self.chengseArray =[NSArray arrayWithObjects:CHENGSE, nil];
//        sectionNumber = 5;
//        imgCount = 0;
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    NSLog(@"%s",__FUNCTION__);
    [fabuTableView release];
    [picScrollView release];
    [biaotiTV release];
    [miaoshuTV release];
    [yuanjiaTF release];
    [tongchengTF release];
    RELEASE_SAFELY(yidiTF);
    RELEASE_SAFELY(wuwuTF);
    RELEASE_SAFELY(RMBTF);
    RELEASE_SAFELY(huanbiTF);
    [fangshiTF release];
    [fenleiTF release];
    [chengseTF release];
    [weizhiTF release];
    [keyboardToolbar release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil]; //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [fangshiArray release];
    [chengseArray release];
    RELEASE_SAFELY(theFenleiDic);
    RELEASE_SAFELY(shouTF);
    RELEASE_SAFELY(addrID);
    RELEASE_SAFELY(proviceArray);
    RELEASE_SAFELY(cityArray);
    RELEASE_SAFELY(regionArray);
    RELEASE_SAFELY(chengsePV);
//    RELEASE_SAFELY)
}

-(void)viewDidUnload{
    [super viewDidUnload];
    NSLog(@"%s",__FUNCTION__);
    self.fabuTableView = nil;
    self.picScrollView = nil;
    self.biaotiTV = nil;
    self.miaoshuTV = nil;
    self.yuanjiaTF = nil;
    self.tongchengTF = nil;
    RELEASE_SAFELY(yidiTF);
    RELEASE_SAFELY(wuwuTF);
    RELEASE_SAFELY(RMBTF);
    RELEASE_SAFELY(huanbiTF);
    self.fangshiTF = nil;
    self.fenleiTF = nil;
    self.chengseTF = nil;
    self.weizhiTF = nil;
    self.keyboardToolbar = nil;
    RELEASE_SAFELY(theFenleiDic);
    RELEASE_SAFELY(shouTF);
    RELEASE_SAFELY(addrID);
    RELEASE_SAFELY(baoyouSeg);
}

/*
 @property(nonatomic,retain)NSMutableArray *proviceArray,*cityArray,*regionArray;
 
 @property(retain,nonatomic)UITableView *fabuTableView;
 @property(retain,nonatomic)UIScrollView *picScrollView;
 @property(retain,nonatomic)CPTextViewPlaceholder *biaotiTV;
 @property(retain,nonatomic)CPTextViewPlaceholder *miaoshuTV;
 @property(retain,nonatomic)UITextField *RMBTF; //金币
 @property(retain,nonatomic)UITextField *huanbiTF; //换币
 @property(retain,nonatomic)UITextField *yuanjiaTF;
 @property(retain,nonatomic)UITextField *fangshiTF;
 @property(retain,nonatomic)UIPickerView *fangshiPV;
 @property(retain,nonatomic)UITextField *tongchengTF; //同城运费
 @property(retain,nonatomic)UITextField *yidiTF; //异地运费
 @property(retain,nonatomic)UITextField *fenleiTF;
 @property(retain,nonatomic)UIPickerView *fenleiPV;
 @property(retain,nonatomic)UITextField *chengseTF;
 @property(retain,nonatomic)UIPickerView *chengsePV;
 @property(retain,nonatomic)UITextField *weizhiTF;
 @property(retain,nonatomic)UIPickerView *weizhiPV;
 @property(retain,nonatomic)UITextField *wuwuTF;
 @property(nonatomic, retain) UIToolbar *keyboardToolbar;
 
 @property(retain,nonatomic)UITextField *shouTF; //物品收获地址
 
 @property(nonatomic,retain)NSArray *fangshiArray;
 @property(nonatomic,retain)NSArray *chengseArray;
 
 @property(nonatomic,retain)NSDictionary *theFenleiDic;
 
 @property(nonatomic,retain)NSString *addrID;
 
 @property(nonatomic,retain)MCSegmentedControl *baoyouSeg;
 @property(nonatomic,retain)MCSegmentedControl *sellTypeSeg;
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *navIV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_nav.png"]];
    navIV.userInteractionEnabled=YES;
    navIV.frame=CGRectMake(0, 0, 320, 44);
    
    UILabel *nameL=[[UILabel alloc]initWithFrame:CGRectMake(130, 10, 80, 24)];
    nameL.font=[UIFont boldSystemFontOfSize:17];
    nameL.textColor = [UIColor whiteColor];
    nameL.backgroundColor=[UIColor clearColor];
    nameL.text=@"发布宝贝";
    [navIV addSubview:nameL];
    [nameL release];
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(5, 10, 57, 27);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_gray_btn.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:backBtn];
    
    UIButton *moreBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame=CGRectMake(258, 10, 57, 27);
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"] forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [moreBtn setTitle:@"发布" forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(toFabu) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:moreBtn];
    [self.view addSubview:navIV];
    [navIV release];
    
    self.fabuTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-44) style:UITableViewStyleGrouped];
//    fabuTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg_0.png"]];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg.png"]];
    fabuTableView.backgroundView = view;
    [view release];
    fabuTableView.delegate = self;
    fabuTableView.dataSource = self;
    [self.view addSubview:fabuTableView];
    [fabuTableView release];
    
    self.picScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 70)];
    picScrollView.contentSize = CGSizeMake(kDeviceWidth+50, 60);
    picScrollView.showsHorizontalScrollIndicator= NO;
    fabuTableView.tableHeaderView = picScrollView;
    [picScrollView release];
    
    for (int i = 0; i<5; i++) {
        UIButton *picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        picBtn.frame = CGRectMake(10+70*i, 10, 60, 60);
        [picBtn setBackgroundImage:[UIImage imageNamed:@"defalut_upload_img_.png"] forState:UIControlStateNormal];
        [picBtn addTarget:self action:@selector(toAddNewImage:) forControlEvents:UIControlEventTouchUpInside];
        picBtn.tag = i+1;
        [picScrollView addSubview:picBtn];
        
        UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleBtn.frame = CGRectMake(-10, -10, 30, 30);
        [deleBtn setImage:[UIImage imageNamed:@"delete-icon.png"] forState:UIControlStateNormal];
        [deleBtn addTarget:self action:@selector(deleteTheImage:) forControlEvents:UIControlEventTouchUpInside];
        deleBtn.tag = 10;
        [picBtn addSubview:deleBtn];
        deleBtn.hidden = YES;
    }
    
    
    self.chengsePV = [[UIPickerView alloc]initWithFrame:CGRectMake(0,155+44*2+1 , kDeviceWidth, KDeviceHeight-20-150-44)];
    chengsePV.delegate = self;
    chengsePV.dataSource = self;
    chengsePV.showsSelectionIndicator = YES;
    
    
    cityPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, KDeviceHeight-20-216, kDeviceWidth, 216)];
    cityPicker.dataSource = self;
    cityPicker.delegate = self;
    cityPicker.showsSelectionIndicator = YES;      // 这个弄成YES, picker中间就会有个条, 被选中的样子
    cityPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    service = [[sqlService alloc]init];
    self.proviceArray = [service getCityListByProvinceCode:@"0"];
    self.cityArray = [service getCityListByProvinceCode:[[proviceArray objectAtIndex:0] objectForKey:@"sCode"]];
    self.regionArray = [service getCityListByProvinceCode:[[cityArray objectAtIndex:0] objectForKey:@"sCode"]];
    proviceStr = [[proviceArray objectAtIndex:0] objectForKey:@"sName"];
    cityStr = [[cityArray objectAtIndex:0] objectForKey:@"sName"];
    regionStr = [[regionArray objectAtIndex:0] objectForKey:@"sName"];
    
    self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
    keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", @"")
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(resignKeyboard)];
    [keyboardToolbar setItems:[NSArray arrayWithObjects:spaceBarItem,doneBarItem, nil]];
    
    self.biaotiTV = [[CPTextViewPlaceholder alloc]initWithFrame:CGRectMake(63, 1, 220, 39)];
    biaotiTV.backgroundColor = [UIColor clearColor];
    biaotiTV.font = [UIFont systemFontOfSize:13];
    biaotiTV.placeholder = @"1-30个字符";
    biaotiTV.delegate = self;
    biaotiTV.tag = 1;
    biaotiTV.inputAccessoryView = keyboardToolbar;
    [keyboardToolbar release];
    
    self.miaoshuTV = [[CPTextViewPlaceholder alloc]initWithFrame:CGRectMake(63, 1, 220, 78)];
    miaoshuTV.font = [UIFont systemFontOfSize:13];
    miaoshuTV.placeholder = @"描述一下你的宝贝";
    miaoshuTV.delegate = self;
    miaoshuTV.tag = 2;
    miaoshuTV.inputAccessoryView = keyboardToolbar;
    [keyboardToolbar release];
    
    self.RMBTF = [[UITextField alloc]initWithFrame:CGRectMake(70, 1, 220, 39)];
    RMBTF.backgroundColor = [UIColor clearColor];
    RMBTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    RMBTF.font = [UIFont systemFontOfSize:13];
    RMBTF.placeholder = @"请输入金币数量";
    RMBTF.delegate = self;
    RMBTF.tag = 10;
    RMBTF.inputAccessoryView = keyboardToolbar;
    [keyboardToolbar release];
    
    self.huanbiTF = [[UITextField alloc]initWithFrame:CGRectMake(70, 1, 220, 39)];
    huanbiTF.backgroundColor = [UIColor clearColor];
    huanbiTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    huanbiTF.font = [UIFont systemFontOfSize:13];
    huanbiTF.placeholder = @"请输入换币数量";
    huanbiTF.delegate = self;
    huanbiTF.tag = 11;
    huanbiTF.inputAccessoryView = keyboardToolbar;
    [keyboardToolbar release];
    
    
    self.yuanjiaTF = [[UITextField alloc]initWithFrame:CGRectMake(70, 1, 220, 39)];
    yuanjiaTF.backgroundColor = [UIColor clearColor];
    yuanjiaTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    yuanjiaTF.font = [UIFont systemFontOfSize:13];
    yuanjiaTF.placeholder = @"宝贝原价（元）";
    yuanjiaTF.delegate = self;
    yuanjiaTF.tag = 7;
    yuanjiaTF.inputAccessoryView = keyboardToolbar;
    [keyboardToolbar release];
    
    self.tongchengTF = [[UITextField alloc]initWithFrame:CGRectMake(70, 1, 220, 39)];
    tongchengTF.backgroundColor = [UIColor clearColor];
    tongchengTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tongchengTF.font = [UIFont systemFontOfSize:13];
    tongchengTF.placeholder = @"请填写同城邮费（元）";
    tongchengTF.delegate = self;
    tongchengTF.tag = 5;
    tongchengTF.inputAccessoryView = keyboardToolbar;
    [keyboardToolbar release];
    
    self.yidiTF = [[UITextField alloc]initWithFrame:CGRectMake(70, 1, 220, 39)];
    yidiTF.backgroundColor = [UIColor clearColor];
    yidiTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    yidiTF.font = [UIFont systemFontOfSize:13];
    yidiTF.placeholder = @"请填写异地邮费（元）";
    yidiTF.delegate = self;
    yidiTF.tag = 6;
    yidiTF.inputAccessoryView = keyboardToolbar;
    [keyboardToolbar release];
    
    
    self.fenleiTF = [[UITextField alloc]initWithFrame:CGRectMake(70, 1, 220, 39)];
    fenleiTF.backgroundColor = [UIColor clearColor];
    fenleiTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    fenleiTF.font = [UIFont systemFontOfSize:13];
    fenleiTF.placeholder = @"点击选择分类";
    fenleiTF.delegate = self;
    fenleiTF.tag = 3;
//    fenleiTF.inputAccessoryView = keyboardToolbar;
//    fenleiTF.inputView = fenleiPV;
//    [keyboardToolbar release];
//    [fenleiPV release];
    
    self.chengseTF = [[UITextField alloc]initWithFrame:CGRectMake(70, 1, 220, 39)];
    chengseTF.backgroundColor = [UIColor clearColor];
    chengseTF.font = [UIFont systemFontOfSize:13];
    chengseTF.contentVerticalAlignment = 0; //垂直居中显示
    chengseTF.placeholder = @"请选择成色";
    chengseTF.delegate = self;
    chengseTF.tag = 8;
    chengseTF.inputAccessoryView = keyboardToolbar;
    chengseTF.inputView = chengsePV;
    [keyboardToolbar release];
    [chengsePV release];
    
    self.weizhiTF = [[UITextField alloc]initWithFrame:CGRectMake(70, 1, 220, 39)];
    weizhiTF.backgroundColor = [UIColor clearColor];
    weizhiTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    weizhiTF.font = [UIFont systemFontOfSize:13];
    weizhiTF.placeholder = @"点击选择您的位置";
    weizhiTF.delegate = self;
    weizhiTF.tag = 4;
    weizhiTF.inputAccessoryView = keyboardToolbar;
    weizhiTF.inputView = cityPicker;
    [keyboardToolbar release];
    [cityPicker release];
    
    self.wuwuTF = [[UITextField alloc]initWithFrame:CGRectMake(70, 1, 220, 39)];
    wuwuTF.delegate = self;
    wuwuTF.tag = 9;
    wuwuTF.backgroundColor = [UIColor clearColor];
    wuwuTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    wuwuTF.font = [UIFont systemFontOfSize:13];
    wuwuTF.placeholder = @"请输入可交换的物品名称";
    wuwuTF.inputAccessoryView = keyboardToolbar;
    [keyboardToolbar release];
    
    self.shouTF = [[UITextField alloc]initWithFrame:CGRectMake(70, 1, 220, 39)];
    shouTF.backgroundColor = [UIColor clearColor];
    shouTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    shouTF.font = [UIFont systemFontOfSize:13];
    shouTF.placeholder = @"请选择交换物品的收货地址";
    shouTF.delegate = self;
    shouTF.tag = 12;
    shouTF.enabled = NO;
    
    
    self.baoyouSeg = [[MCSegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"是",@"否",nil]];
    [baoyouSeg addTarget:self action:@selector(baoyou:) forControlEvents:UIControlEventValueChanged];
    baoyouSeg.selectedSegmentIndex = 1; //默认不包邮
    baoyouSeg.tintColor = [UIColor colorWithRed:.0 green:.3 blue:.0 alpha:1.0];
    baoyouSeg.selectedItemColor = [UIColor whiteColor];
    baoyouSeg.unselectedItemColor = [UIColor darkGrayColor];
    baoyouSeg.frame = CGRectMake(230, 0, 80, 25);

    
    self.sellTypeSeg = [[MCSegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"物物",@"金银币",@"均可",nil]];
    [sellTypeSeg addTarget:self action:@selector(jiaohuanfangshi:) forControlEvents:UIControlEventValueChanged];
    sellTypeSeg.frame = CGRectMake(140, 0, 170, 25);
    sellTypeSeg.tintColor = [UIColor colorWithRed:.0 green:.3 blue:.0 alpha:1.0];
    sellTypeSeg.selectedItemColor = [UIColor whiteColor];
    sellTypeSeg.unselectedItemColor = [UIColor darkGrayColor];
    sellTypeSeg.selectedSegmentIndex = 2; //默认均可
}

-(void)addNewImage:(UIImage *)image{
    UIButton *picBtn = (UIButton *)[picScrollView viewWithTag:1];
    if (!picBtn.currentImage) {
        [picBtn setImage:image forState:UIControlStateNormal];
        UIButton *deleBtn = (UIButton *)[picBtn viewWithTag:10];
        deleBtn.hidden = NO;
    }
}

-(void)toAddNewImage:(UIButton *)sender{
    if (!sender.currentImage) { //当button没有设置图片时才触发方法
        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"请选择照片获取方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"图片库", nil];
        action.actionSheetStyle = UIActionSheetStyleBlackTranslucent;//样式黑色半透明
        [action showInView:self.view];
        [action release];
    }
    else
        sender.highlighted = NO;//关闭高亮状态效果
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 0)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//照片来源为相机
            imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            
            [self presentModalViewController:imagePicker animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该设备没有照相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
    if(buttonIndex == 1)
    {
        imagePicker = [[UIImagePickerController alloc] init];//图像选取器
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//打开相册
        imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;//过渡类型,有四种
        imagePicker.allowsEditing = YES;//开启对图片进行编辑
        
        [self presentModalViewController:imagePicker animated:YES];//打开模态视图控制器选择图像
    }
}

#pragma mark - UIImagePickerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];//关闭模态视图控制器
    //    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];//获取图片
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage *myImage = [self yasuoCameraImage:image];
        for (int i = 1; i<6; ++i) {
            UIButton *picBtn = (UIButton *)[picScrollView viewWithTag:i];
            if (!picBtn.currentImage) {
                [picBtn setImage:myImage forState:UIControlStateNormal];
                UIButton *deleBtn = (UIButton *)[picBtn viewWithTag:10];
                deleBtn.hidden = NO;
                break;//跳出整个循环
            } 
        }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//将拍到的图片保存到相册
    }
    else{
            UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
            UIImage *myImage = [self yasuoCameraImage:image];
            for (int i = 1; i<6; ++i) {
                UIButton *picBtn = (UIButton *)[picScrollView viewWithTag:i];
                if (!picBtn.currentImage) {
                    [picBtn setImage:myImage forState:UIControlStateNormal];
                    UIButton *deleBtn = (UIButton *)[picBtn viewWithTag:10];
                    deleBtn.hidden = NO;
                    break;//跳出整个循环
                }
            }
    }
}

-(UIImage *)yasuoCameraImage:(UIImage *)image{
    int size = 102400;
    int current_size = 0;
    int actual_size = 0;
    NSData *imgData1 = UIImageJPEGRepresentation(image, 1.0);
    current_size = [imgData1 length];
    if (current_size > size) {
        actual_size = size/current_size;
        imgData1 = UIImageJPEGRepresentation(image, actual_size);
    }
    UIImage *theImage = [UIImage imageWithData:imgData1];
    return theImage; //返回压缩后的图片
}

-(UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContext(newSize);//根据当前大小创建一个基于位图图形的环境
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];//根据新的尺寸画出传过来的图片
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();//从当前环境当中得到重绘的图片
    
    UIGraphicsEndImageContext();//关闭当前环境
    
    return newImage;
}

-(void)save
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
    alert.delegate = self;
    [alert show];
    [alert release];
}

-(void)deleteTheImage:(UIButton *)sender{
    UIButton *picBtn = (UIButton *)sender.superview;
    [picBtn setImage:nil forState:UIControlStateNormal];
    sender.hidden = YES;
     
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 4) {
//        return 4;
//    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 40;
        }
        else
            return 80;
    }
    else
        return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2 | section == 4) {
        return 25;
    }
    else if(section == 0){
        return 20;
    }
    else{
        return 2;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        UIView *headV = [[UIView alloc]init];
        headV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"section_bar.png"]];
        UILabel *noticeL = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, 150, 15)];
        noticeL.backgroundColor = [UIColor clearColor];
        noticeL.font = [UIFont boldSystemFontOfSize:15];
        noticeL.text = @"是否包邮？";
        [headV addSubview:noticeL];
        [noticeL release];
        
        [headV addSubview:baoyouSeg];
        
        return [headV autorelease];
    }
    else if (section == 4){
        UIView *headV = [[UIView alloc]init];
        headV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"section_bar.png"]];
        UILabel *noticeL = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, 150, 20)];
        noticeL.backgroundColor = [UIColor clearColor];
        noticeL.font = [UIFont boldSystemFontOfSize:15];
        noticeL.text = @"支付方式";
        [headV addSubview:noticeL];
        [noticeL release];
        
        
        [headV addSubview:sellTypeSeg];
        
        return [headV autorelease];
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIImageView *cellIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"release_list_top.png"]];
            cell.backgroundView = cellIV;
            [cellIV release];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"名称";
            cell.textLabel.backgroundColor = [UIColor clearColor];
            
            [cell.contentView addSubview:biaotiTV];
        }
        else{
            UIImageView *cellIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"release_list_bottom2.png"]];
            cell.backgroundView = cellIV;
            [cellIV release];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.text = @"描述";
            
            [cell.contentView addSubview:miaoshuTV];
        }
    }
    else if(indexPath.section == 1){
        if (indexPath.row ==0) {
            
            UIImageView *cellIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"release_list_top.png"]];
            cell.backgroundView = cellIV;
            [cellIV release];
            
            UIImageView *moreIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_more_0.png"]];
            cell.accessoryView = moreIV;
            [moreIV release];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.text = @"分类";
            
            fenleiTF.enabled = NO;
            [cell.contentView addSubview:fenleiTF];
        }
        else{
            
            UIImageView *cellIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"release_list_bottom1.png"]];
            cell.backgroundView = cellIV;
            [cellIV release];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.text = @"地区";
            
            [cell.contentView addSubview:weizhiTF];
        }
    }

    else if (indexPath.section == 2){
        if(indexPath.row ==0){
            UIImageView *cellIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"release_list_top.png"]];
            cell.backgroundView = cellIV;
            [cellIV release];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.text = @"同城";
            
            [cell.contentView addSubview:tongchengTF];
            
        }
        else{
            UIImageView *cellIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"release_list_bottom1.png"]];
            cell.backgroundView = cellIV;
            [cellIV release];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.text = @"异地";
            
            [cell.contentView addSubview:yidiTF];
        }
    }
    else if(indexPath.section == 3){
        if (indexPath.row == 0) {
            
            UIImageView *cellIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"release_list_top.png"]];
            cell.backgroundView = cellIV;
            [cellIV release];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.text = @"原价";
            
            [cell.contentView addSubview:yuanjiaTF];

        }
        else{
            UIImageView *cellIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"release_list_bottom1.png"]];
            cell.backgroundView = cellIV;
            [cellIV release];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.text = @"成色";
            
            [cell.contentView addSubview:chengseTF];
        }
    }
    else if(indexPath.section == 4){
        if (indexPath.row == 0) {
            
            UIImageView *cellIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"release_list_top.png"]];
            cell.backgroundView = cellIV;
            [cellIV release];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.text = @"物物";
            
            [cell.contentView addSubview:wuwuTF];
            
        }
        else if(indexPath.row == 1){
            
            UIImageView *cellIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"release_list_bottom1.png"]];
            cell.backgroundView = cellIV;
            [cellIV release];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.text = @"金币";
            
            [cell.contentView addSubview:RMBTF];
        }
    }
    else if(indexPath.section == 5){
        if(indexPath.row == 0){
            UIImageView *cellIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"release_list_top.png"]];
            cell.backgroundView = cellIV;
            [cellIV release];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.text = @"换币";
            
            [cell.contentView addSubview:huanbiTF];
        }
        else if(indexPath.row == 1){
            UIImageView *cellIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"release_list_bottom1.png"]];
            cell.backgroundView = cellIV;
            [cellIV release];
            
            UIImageView *moreIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_more_0.png"]];
            cell.accessoryView = moreIV;
            [moreIV release];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.text = @"收货";
            
            [cell.contentView addSubview:shouTF];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self resignKeyboard];
    NSLog(@"点击了第%d列，%d行",indexPath.section,indexPath.row);
    if (indexPath.section == 1 && indexPath.row == 0) {
        FenleiSelect *firstFenleiVC = [[FenleiSelect alloc]init];
        firstFenleiVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:firstFenleiVC animated:YES];
        [firstFenleiVC release];
        firstFenleiVC.backFabuDelegate = self;
    }
    else if(indexPath.section == 1 && indexPath.row == 1){
        WeizhiSelect *weizhiVC = [[WeizhiSelect alloc]init];
        weizhiVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:weizhiVC animated:YES];
        [weizhiVC release];
    }
    else if(indexPath.section == 5 && indexPath.row == 1){
        if (sellTypeSeg.selectedSegmentIndex == 0 || sellTypeSeg.selectedSegmentIndex == 2) {
            Address *addrVC = [[Address alloc]init];
            addrVC.isSelecte = YES;
            [self.navigationController pushViewController:addrVC animated:YES];
            [addrVC release];
            addrVC.delegate = self;
        }
    }
}

-(void)SelectTheAddress:(NSDictionary *)addrDic{
    NSString *realNameStr = [addrDic objectForKey:@"realname"];
    NSString *telStr = [addrDic objectForKey:@"tel"];
    NSString *detail_infoStr = [addrDic objectForKey:@"detail_info"];
    NSString *postcodeStr = [addrDic objectForKey:@"postcode"];
    shouTF.text = [NSString stringWithFormat:@"%@,%@,%@,%@",realNameStr,telStr,detail_infoStr,postcodeStr];
    self.addrID = [addrDic objectForKey:@"mid"];
    
}

-(void)resignKeyboard{ //回收键盘
    id firstResponder = [self getFirstResponder];
        [firstResponder resignFirstResponder];
}

- (id)getFirstResponder
{
    NSUInteger index = 0;
    while (index <= FIELDS_COUNT) {
        id responder = [self.view viewWithTag:index];
        if ([responder isFirstResponder]) {
            return responder;
        }
        index++;
    }
    return NO;
}

//-(void)toFangshi{
//    fangshiPV.hidden = NO;
//}

//-(void)toFenlei{
//    self.fenleiPV = [[UIPickerView alloc]initWithFrame:CGRectMake(0,150+44*2+1 , kDeviceWidth, KDeviceHeight-20-150-44)];
//    fenleiPV.delegate = self;
//    fenleiPV.dataSource = self;
//    fenleiPV.showsSelectionIndicator = YES;
//    [self.view addSubview:fenleiPV];
//    [fenleiPV release];
//}

-(void)toChengse{
    self.chengsePV = [[UIPickerView alloc]initWithFrame:CGRectMake(0,150+44*2+1 , kDeviceWidth, KDeviceHeight-20-150-44)];
    chengsePV.delegate = self;
    chengsePV.dataSource = self;
    chengsePV.showsSelectionIndicator = YES;
    [self.view addSubview:chengsePV];
    [chengsePV release];
}

//-(void)toWeizhi{
//    self.weizhiPV = [[UIPickerView alloc]initWithFrame:CGRectMake(0,150+44*2+1 , 320, KDeviceHeight-20-150-44)];
//    weizhiPV.delegate = self;
//    weizhiPV.dataSource = self;
//    weizhiPV.showsSelectionIndicator = YES;
//    [self.view addSubview:weizhiPV];
//    [weizhiPV release];
//}


-(void)backToFabu:(NSDictionary *)fenleiDic{
    self.theFenleiDic = fenleiDic;
//    NSString *key = [[fenleiDic allKeys] objectAtIndex:0];
    fenleiTF.text = [[theFenleiDic allValues] objectAtIndex:0];
}

-(void)toBack{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)toFabu{
    NSLog(@"我是 发布宝贝按钮！");
    /*
     cat_id 分类ID   
     is_new 成色
     user_id 用户ID
     sell_type 交易种类
     gold 金币
     silver 银币
     sheng 省	shi 市	xian 县
     memo 交换物品
     free_delivery 包邮
     freight_townsman 同城运费	
     freight_allopatry 异地运费
     goods_name 商品名称
     market_price 市场价
     goods_desc 详细描述
     add_time 添加时间
     */
    [SVProgressHUD showWithStatus:@"正在上传图片.."];
    
    NSString *fenleiID = [[theFenleiDic allKeys] objectAtIndex:0];
    
    NSString *isNew = nil;
    if ([chengseTF.text isEqualToString:@"全新"]) {
        isNew = @"0"; //全新
    }
    else{
        isNew = @"1"; //二手
    }
    
    NSString *sellType = nil;
    if (sellTypeSeg.selectedSegmentIndex == 0) {
        sellType = @"1";
    }
    else if (sellTypeSeg.selectedSegmentIndex == 1){
        sellType = @"2";
    }
    else{
        sellType = @"3";
    }
    
    NSString *goidStr = RMBTF.text;
    NSString *silverStr = huanbiTF.text;
    
    NSArray *weizhiArray = [weizhiTF.text componentsSeparatedByString:@" "];
    NSString *shengStr = [weizhiArray objectAtIndex:0];
    NSString *shiStr = [weizhiArray objectAtIndex:1];
    NSString *xianStr = [weizhiArray objectAtIndex:2];
   
    NSString *memoStr = wuwuTF.text;
    
    NSString *freeDelivery = nil;
    if (baoyouSeg.selectedSegmentIndex == 0) {
        freeDelivery = @"1";
    }
    else{
        freeDelivery = @"0";
    }
    
    NSString *townsman = tongchengTF.text;
    NSString *allopatry = yidiTF.text;
    
    NSString *nameStr = biaotiTV.text;
    NSString *marketPrice = yuanjiaTF.text;
    NSString *desc = miaoshuTV.text;
    NSDate *date = [NSDate date];
    NSString *dateStr = [NSString stringWithFormat:@"%@",date];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];

    NSURL *newUrl = [NSURL URLWithString:THEURL(UPGOODS)];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:token forKey:@"token"];

    
    UIButton *picBtn1 = (UIButton *)[picScrollView viewWithTag:1];
    UIButton *picBtn2 = (UIButton *)[picScrollView viewWithTag:2];
    UIButton *picBtn3 = (UIButton *)[picScrollView viewWithTag:3];
    UIButton *picBtn4 = (UIButton *)[picScrollView viewWithTag:4];
    UIButton *picBtn5 = (UIButton *)[picScrollView viewWithTag:5];
    
    int imgCount = 0;
    if (picBtn1.currentImage) {
        imgCount++;
        NSData *imgData1 = UIImageJPEGRepresentation(picBtn1.currentImage, 1.0);
        [form_request addData:imgData1 withFileName:@"gdimg1.jpg" andContentType:@"image/jpeg" forKey:@"gdimg1"];
    }
    if (picBtn2.currentImage) {
        imgCount++;
        NSData *imgData2 = UIImageJPEGRepresentation(picBtn2.currentImage, 1.0);
        [form_request addData:imgData2 withFileName:@"gdimg2.jpg" andContentType:@"image/jpeg" forKey:@"gdimg2"];
    }
    if (picBtn3.currentImage) {
        imgCount++;
        NSData *imgData3 = UIImageJPEGRepresentation(picBtn3.currentImage, 1.0);
        [form_request addData:imgData3 withFileName:@"gdimg3.jpg" andContentType:@"image/jpeg" forKey:@"gdimg3"];
    }
    if (picBtn4.currentImage) {
        imgCount++;
        NSData *imgData4 = UIImageJPEGRepresentation(picBtn4.currentImage, 1.0);
        [form_request addData:imgData4 withFileName:@"gdimg4.jpg" andContentType:@"image/jpeg" forKey:@"gdimg4"];
    }
    if (picBtn5.currentImage) {
        imgCount++;
        NSData *imgData5 = UIImageJPEGRepresentation(picBtn5.currentImage, 1.0);
        [form_request addData:imgData5 withFileName:@"gdimg5.jpg" andContentType:@"image/jpeg" forKey:@"gdimg5"];
    }
    
    NSString *imgCountStr = [NSString stringWithFormat:@"%d",imgCount];
    
    [form_request setPostValue:imgCountStr forKey:@"imgcount"];
    
    [form_request setPostValue:fenleiID forKey:@"cat_id"];
    [form_request setPostValue:isNew forKey:@"is_new"];
    [form_request setPostValue:sellType forKey:@"sell_type"];
    [form_request setPostValue:goidStr forKey:@"gold"];
    [form_request setPostValue:silverStr forKey:@"silver"];
    [form_request setPostValue:shengStr forKey:@"sheng"];
    [form_request setPostValue:shiStr forKey:@"shi"];
    [form_request setPostValue:xianStr forKey:@"xian"];
    [form_request setPostValue:memoStr forKey:@"memo"];
    [form_request setPostValue:freeDelivery forKey:@"free_delivery"];
    [form_request setPostValue:townsman forKey:@"freight_townsman"];
    [form_request setPostValue:allopatry forKey:@"freight_allopatry"];
    [form_request setPostValue:nameStr forKey:@"goods_name"];
    [form_request setPostValue:marketPrice forKey:@"market_price"];
    [form_request setPostValue:desc forKey:@"goods_desc"];
    [form_request setPostValue:dateStr forKey:@"add_time"];
    [form_request setPostValue:addrID forKey:@"shipaddress"];
    
    [form_request setDidFinishSelector:@selector(finishFabu:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}


-(void)finishFabu:(ASIHTTPRequest *)request{ //请求成功后的方法
    [SVProgressHUD dismiss];
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"发布结果 str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSLog(@"dic is %@",dic);
    
    NSString *info = [dic objectForKey:@"info"];
    NSLog(@"%@",info);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜" message:info delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark - 请求失败代理
-(void)loginFailed:(ASIHTTPRequest *)formRequest{
    NSLog(@"formRequest.error-------------%@",formRequest.error);
    NSString *errorStr = [NSString stringWithFormat:@"%@",formRequest.error];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorStr delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 弹出键盘通知
-(void)keyboardWasShown:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"----%@",NSStringFromCGSize(keyboardSize));
    fabuTableView.frame = CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-keyboardSize.height);
}

- (void) keyboardWasHidden:(NSNotification *) notif{
    fabuTableView.frame = CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-44);
}


#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [fabuTableView setContentOffset:CGPointMake(0,textField.tag*55) animated:YES];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
     [fabuTableView setContentOffset:CGPointMake(0,textView.tag*55) animated:YES];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == cityPicker) {
        return 3;
    }
        return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
//    if (pickerView == fangshiPV) 
//        return [fangshiArray count];
    if (pickerView == chengsePV)
        return [chengseArray count];
    else{
        if (component == 0) {
            return [proviceArray count];
        }
        if (component == 1) {
            return [cityArray count];
        }
        if (component == 2) {
            return [regionArray count];
        }
        return 0;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    if (pickerView == fangshiPV) {
//        return [fangshiArray objectAtIndex:row];
//    }
    if (pickerView == chengsePV)
        return [chengseArray objectAtIndex:row];
    else{ //城市选择
        NSString *str = @"";
        if (component == 0) {
            return [[proviceArray objectAtIndex:row] objectForKey:@"sName"];
        }
        if (component == 1) {
            return [[cityArray objectAtIndex:row]objectForKey:@"sName"];
        }
        if (component == 2) {
            if ([regionArray count]>0) {
                return regionStr = [[regionArray objectAtIndex:row] objectForKey:@"sName"];
            }
            else{
                return @"";
            }
        }
        return str;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    if (pickerView == fangshiPV) {
//        fangshiTF.text = [fangshiArray objectAtIndex:row];
//    }
    if(pickerView == chengsePV)
        chengseTF.text = [chengseArray objectAtIndex:row];
    else{
        if (component == 0) {
            self.cityArray = [service getCityListByProvinceCode:[[proviceArray objectAtIndex:row] objectForKey:@"sCode"]];
            [cityPicker reloadComponent:1];
            self.regionArray = [service getCityListByProvinceCode:[[cityArray objectAtIndex:0] objectForKey:@"sCode"]];
            [cityPicker reloadComponent:2];
            
            proviceStr = [[proviceArray objectAtIndex:row] objectForKey:@"sName"];
            cityStr = [[cityArray objectAtIndex:0] objectForKey:@"sName"];
            
            [cityPicker selectRow:0 inComponent:1 animated:YES];
            if ([cityArray count]>1) {
                [cityPicker selectRow:0 inComponent:2 animated:YES];
            }
            if ([regionArray count]>0) {
                regionStr = [[regionArray objectAtIndex:0] objectForKey:@"sName"];
            }
            else{
                regionStr = @"";
            }
        }
        else if (component == 1) {
            self.regionArray = [service getCityListByProvinceCode:[[cityArray objectAtIndex:row] objectForKey:@"sCode"]];
            [cityPicker reloadComponent:2];
            cityStr = [[cityArray objectAtIndex:row] objectForKey:@"sName"];
            if ([cityArray count]>1) {
                [cityPicker selectRow:0 inComponent:2 animated:YES];
            }
            if ([regionArray count]>0) {
                regionStr = [[regionArray objectAtIndex:0] objectForKey:@"sName"];
            }
        }
        else{
            if ([regionArray count]>0) {
                regionStr = [[regionArray objectAtIndex:row] objectForKey:@"sName"];
            }
            //第三栏可能没有数据 
        }
        weizhiTF.text = [NSString stringWithFormat:@"%@ %@ %@",proviceStr,cityStr,regionStr];
    }
    NSLog(@"我是UIPickView！选中了第%d行",row);
}

-(void)baoyou:(MCSegmentedControl *)seg{
    NSLog(@"%s",__FUNCTION__);
    switch (seg.selectedSegmentIndex) {
        case 0:
        {
            tongchengTF.enabled = NO;
            yidiTF.enabled = NO;
            break;
        }
            
        case 1:{
            tongchengTF.enabled = YES;
            yidiTF.enabled = YES;
            break;
        }
            
        default:
            break;
    }
    
}

-(void)jiaohuanfangshi:(MCSegmentedControl *)seg{
    NSLog(@"%s",__FUNCTION__);
    switch (seg.selectedSegmentIndex) {
        case 0:
        {
            wuwuTF.enabled = YES;
            RMBTF.enabled = NO;
            huanbiTF.enabled = NO;
            break;
        }
            
        case 1:{
            wuwuTF.enabled = NO;
            RMBTF.enabled = YES;
            huanbiTF.enabled = YES;
            shouTF.text = @"";
            break;
        }
        case 2:{
            wuwuTF.enabled = YES;
            RMBTF.enabled = YES;
            huanbiTF.enabled = YES;
            break;
        }
            
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
//    self.fabuTableView = nil;
//    self.picScrollView = nil;
//    self.biaotiTV = nil;
//    self.miaoshuTV = nil;
//    self.yuanjiaTF = nil;
//    self.tongchengTF = nil;
//    self.yidiTF = nil;
//    self.wuwuTF = nil;
//    self.RMBTF = nil;
//    self.huanbiTF = nil;
//    self.fangshiTF = nil;
//    self.fenleiTF = nil;
//    self.chengseTF = nil;
//    self.weizhiTF = nil;
//    self.keyboardToolbar = nil;
//    self.shouTF = nil;
//    self.baoyouSeg = nil;
}

@end