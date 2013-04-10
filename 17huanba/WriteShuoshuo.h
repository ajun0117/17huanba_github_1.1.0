//
//  WriteShuoshuo.h
//  17huanba
//
//  Created by Chen Hao on 13-2-18.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteShuoshuo : UIViewController<UITextViewDelegate,UIAlertViewDelegate>
@property(retain,nonatomic)UITextView *myTextView; //说说文本视图
@property(retain,nonatomic)UIImageView *toolView; //工具栏
@property(retain,nonatomic)UILabel *textCountL;
@property(retain,nonatomic)UIButton *sendBtn;
@property(retain,nonatomic)UILabel *placeL;
@property(retain,nonatomic)NSDictionary *mEmojiDic1;
@property(retain,nonatomic)NSDictionary *mEmojiDic2;
@property(retain,nonatomic)UIPageControl *pageC;
@property(retain,nonatomic)UIScrollView *aScrollView;

@end
