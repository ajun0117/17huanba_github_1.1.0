//
//  BaseViewController.m
//  CustomTabBarNotification
//
//  Created by Peter Boctor on 3/7/11.
//
//  Copyright (c) 2011 Peter Boctor
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE

#import "BaseViewController.h"
#import "Fabu.h"
#import "Denglu.h"

@implementation BaseViewController
//@synthesize addNewImageDelegate;//用于往发布页面传值

// Create a view controller and setup it's tab bar item with a title and image
-(UIViewController*) viewControllerWithTabTitle:(NSString*) title image:(UIImage*)image
{
  UIViewController* viewController = [[[UIViewController alloc] init] autorelease];
  viewController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:title image:image tag:0] autorelease];
  return viewController;
}

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
  UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
  [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
  [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
  [button addTarget:self action:@selector(selectActionSheet) forControlEvents:UIControlEventTouchUpInside];

  CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
  if (heightDifference < 0)
    button.center = self.tabBar.center;
  else
  {
    CGPoint center = self.tabBar.center;
    center.y = center.y - heightDifference/2.0;
    button.center = center;
  }
  
    button.tag = 100;
  [self.view addSubview:button];
}

#pragma mark - ActionSheet
-(void)selectActionSheet{
    BOOL isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"] boolValue];
    if (isLogin) {  
        Fabu *fabuVC = [[Fabu alloc]init];
        fabuVC.hidesBottomBarWhenPushed = YES;//隐藏底部的tabbar
        UIView *button = [self.view viewWithTag:100];
    //    button.hidden = YES;//隐藏中间的相机Button
        [UIView animateWithDuration:0.2 animations:^{
            button.alpha = 0;
        }];
        [(UINavigationController *)self.selectedViewController pushViewController:fabuVC animated:YES];
        fabuVC.navigationController.navigationBarHidden = YES;//显示自定义的Nav
        [fabuVC release];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"您还没有登陆，登陆后继续！" delegate:self cancelButtonTitle:@"不" otherButtonTitles:@"是",nil];
        [alert show];
        [alert release];  
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }
    else{
        Denglu *dengluVC = [[Denglu alloc]init];
        [self presentModalViewController:dengluVC animated:YES];
        [dengluVC release];
    }
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
            imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            
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
        //        NSString *string = [[NSBundle mainBundle] pathForResource:@"1110" ofType:@"JPEG"];
        //        currentImage = [UIImage imageWithContentsOfFile:string];
        //        rootImageView.image = currentImage;
        //        seg.userInteractionEnabled = YES;
        //        [self.view addSubview:rootImageView];
        
        imagePicker = [[UIImagePickerController alloc] init];//图像选取器
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//打开相册
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;//过渡类型,有四种
        imagePicker.allowsEditing = YES;//开启对图片进行编辑
        
        [self presentModalViewController:imagePicker animated:YES];//打开模态视图控制器选择图像
    }
}

#pragma mark - UIImagePickerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    Fabu *fabuVC =[self.viewControllers objectAtIndex:2];//获取到tabBarController中的发布页面
//    self.selectedViewController = fabuVC;
//    Fabu *fabuVC = [[Fabu alloc]init];
//    fabuVC.hidesBottomBarWhenPushed = YES;//隐藏底部的tabbar
//     UIView *button = [self.view viewWithTag:100];
//    button.hidden = YES;//隐藏中间的相机Button
//    [(UINavigationController *)self.selectedViewController pushViewController:fabuVC animated:NO];
//    fabuVC.navigationController.navigationBarHidden = YES;//显示自定义的Nav
    
//    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];//获取图片
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//    [addNewImageDelegate addNewImage:image];
    
//    for (int i = 1; i<6; ++i) {
//        UIButton *picBtn = (UIButton *)[fabuVC.picScrollView viewWithTag:i]; 
//        if (!picBtn.currentImage) {
//            [picBtn setImage:image forState:UIControlStateNormal];
//            UIButton *deleBtn = (UIButton *)[picBtn viewWithTag:10];
//            deleBtn.hidden = NO;
//            break;//跳出整个循环
//        }
//    }
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//将拍到的图片保存到相册
    }
    
//    currentImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(260, 340)];
//    //    currentImage = image;
//    
//    //调用imageWithImageSimple:scaledToSize:方法
//    
//    [currentImage retain];
//    
//    rootImageView.image = currentImage;
//    
//    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 45, 50)];
//    rootImage = [UIImage imageNamed:@"110.png"];
//    imageView.image = rootImage;
//    [scrollerView addSubview:imageView];
//    [imageView release];
//    
//    seg.userInteractionEnabled = YES;
//    [self.view addSubview:rootImageView];
    [self dismissModalViewControllerAnimated:YES];//关闭模态视图控制器

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

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(buttonIndex == 1)
//    {
//        
//        //        NSData *newData = UIImageJPEGRepresentation(currentImage, 1);
//        //        NSString *docpath = @"/Users/ibokan/Desktop";
//        //        NSString *path = [docpath stringByAppendingPathComponent:@"aaa.jpg"];
//        //        [newData writeToFile:path atomically:YES];
//        
//        UIImage *img = rootImageView.image;// 要保存的图片
//        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);// 保存图片到相册中
//        
//        
//    }
//}
//
//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
//  contextInfo:(void *)contextInfo
//{
//    if (error != NULL)
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"保存失败,请重新保存" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
//        //        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
//        [alert show];
//        [alert release];
//        
//    }
//    else// 没有error
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"保存成功" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//    }
//}




//for (int i=0; i<[imgArray count]; i++) {
//    AsyncImageView *otherPicsImageView = [[AsyncImageView alloc]init];
//    otherPicsImageView.frame = CGRectMake(5+(77+5)*i, 5, 77, 54);
//    otherPicsImageView.backgroundColor = [[UIColor alloc]initWithRed:(225/255.0) green:(225/255.0) blue:(225/255.0) alpha:.8];
//    otherPicsImageView.userInteractionEnabled = YES;
//    otherPicsImageView.clipsToBounds = YES;
//    otherPicsImageView.layer.cornerRadius = 5;
//    otherPicsImageView.layer.borderWidth = 1.2;
//    otherPicsImageView.layer.borderColor = [[UIColor alloc]initWithRed:(225/255.0) green:(225/255.0) blue:(225/255.0) alpha:1].CGColor;
//    // self.otherPicsImageView.center = CGPointMake(45, 41);
//    otherPicsImageView.tag = (100+i);
//    NSString *thePicStr = [[imgArray objectAtIndex:i] objectForKey:@"ImgUrl"];
//    NSString *spicUrl = [NSString stringWithFormat:@"%@%@",FOODPIC,thePicStr];
//    otherPicsImageView.urlString = spicUrl;
//    [self.thePicsScrollView addSubview:otherPicsImageView];
//    // so Async is clickable
//    UIButton *clickableImageBtn = [UIBuilder button:CGRectMake(5+(77+5)*i, 5, 77, 54) andTitle:@"" andTitleColor:[UIColor grayColor] andNormalStateBGImage:@"" andHighlightedStateBGImage:@"" andTarget:self andAction:@selector(switchImage:)];
//    clickableImageBtn.tag = (520+i);
//    [self.thePicsScrollView addSubview:clickableImageBtn];
//}



@end
