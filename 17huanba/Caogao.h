//
//  Caogao.h
//  17huanba
//
//  Created by Chen Hao on 13-3-5.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Caogao : NSObject
@property(assign,nonatomic)int cid; //草稿ID
@property(retain,nonatomic)NSData *pic1; //商品展示图片
@property(retain,nonatomic)NSData *pic2;
@property(retain,nonatomic)NSData *pic3;
@property(retain,nonatomic)NSData *pic4;
@property(retain,nonatomic)NSData *pic5;
@property(retain,nonatomic)NSString *title; //标题
@property(retain,nonatomic)NSString *miaoshu; //描述
@property(retain,nonatomic)NSString *price; //价格
@property(retain,nonatomic)NSString *yuanPrice; //原价
@property(retain,nonatomic)NSString *fangshi; //方式
@property(retain,nonatomic)NSString *yunfei; //运费
@property(retain,nonatomic)NSString *fenlei; //分类
@property(retain,nonatomic)NSString *chengse; //成色
@property(retain,nonatomic)NSString *weizhi; //位置
@property(retain,nonatomic)NSString *phone; //手机


+(void) insertCaogaoWithpic1:(NSData *)image1 pic2:(NSData *)image2 pic3:(NSData *)image3 pic4:(NSData *)image4 pic5:(NSData *)image5 title:(NSString *)title miaoshu:(NSString *)miaoshu price:(NSString *)price yuanPrice:(NSString *)yuanPrice fangshi:(NSString *)fangshi yunfei:(NSString *)yunfei fenlei:(NSString *)fenlei chengse:(NSString *)chengse weizhi:(NSString *)weizhi phone:(NSString *)phone;
+(void) deletebycid:(int)cid;
+(void) updateCaogao:(Caogao *) caogao;
+(Caogao *) findbycid:(int)cid;
+(NSMutableArray *) findall;//返回表中所有记录
@end
