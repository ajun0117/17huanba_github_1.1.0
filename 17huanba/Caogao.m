//
//  Caogao.m
//  17huanba
//
//  Created by Chen Hao on 13-3-5.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "Caogao.h"
#import "DataBase.h"
#import <sqlite3.h>

@implementation Caogao
@synthesize cid,pic1,pic2,pic3,pic4,pic5;
@synthesize title,miaoshu,price,yuanPrice,fangshi,yunfei,fenlei,chengse,weizhi,phone;

//插入新草稿
+(void) insertCaogaoWithpic1:(NSData *)image1 pic2:(NSData *)image2 pic3:(NSData *)image3 pic4:(NSData *)image4 pic5:(NSData *)image5 title:(NSString *)title miaoshu:(NSString *)miaoshu price:(NSString *)price yuanPrice:(NSString *)yuanPrice fangshi:(NSString *)fangshi yunfei:(NSString *)yunfei fenlei:(NSString *)fenlei chengse:(NSString *)chengse weizhi:(NSString *)weizhi phone:(NSString *)phone
{
    sqlite3 *sqlite=[DataBase OpenDB];//打开数据库
    sqlite3_stmt *stmt=nil;//定义sql语句对象
    int flag=sqlite3_prepare_v2(sqlite, "insert into Caogaoxiang(pic1,pic2,pic3,pic4,pic5,title,miaoshu,price,yuanPrice,fangshi,yunfei,fenlei,chengse,weizhi,phone) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", -1, &stmt, nil);//调用预处理函数将sql语句赋值给stmt对象  多值绑定逗号隔开
    if (flag==SQLITE_OK)
    {
        sqlite3_bind_blob(stmt, 1, [image1 bytes], [image1 length], nil);//对二进制类型数据的绑定  数据的字节数（-1 针对字符串的长度比较准）
        sqlite3_bind_blob(stmt, 2, [image2 bytes], [image2 length], nil);
        sqlite3_bind_blob(stmt, 3, [image3 bytes], [image3 length], nil);
        sqlite3_bind_blob(stmt, 4, [image4 bytes], [image4 length], nil);
        sqlite3_bind_blob(stmt, 5, [image5 bytes], [image5 length], nil);
        sqlite3_bind_text(stmt, 6, [title UTF8String],-1,nil);//给问号占位符赋值
        sqlite3_bind_text(stmt, 7, [miaoshu UTF8String],-1,nil);
        sqlite3_bind_text(stmt, 8, [price UTF8String],-1,nil);
        sqlite3_bind_text(stmt, 9, [yuanPrice UTF8String],-1,nil);
        sqlite3_bind_text(stmt, 10, [fangshi UTF8String],-1,nil);
        sqlite3_bind_text(stmt, 11, [yunfei UTF8String],-1,nil);
        sqlite3_bind_text(stmt, 12, [fenlei UTF8String],-1,nil);
        sqlite3_bind_text(stmt, 13, [chengse UTF8String],-1,nil);
        sqlite3_bind_text(stmt, 14, [weizhi UTF8String],-1,nil);
        sqlite3_bind_text(stmt, 15, [phone UTF8String],-1,nil);
        if(sqlite3_step(stmt)==SQLITE_ERROR)//执行insert动作
        {
            NSLog(@"insert error");
        }
    }
    sqlite3_finalize(stmt);//回收stmt对象
}

//按草稿ID删除草稿
+(void) deletebycid:(int)cid
{
    sqlite3 *sqlite=[DataBase OpenDB];//打开数据库
    sqlite3_stmt *stmt=nil;//定义sql语句对象
    int flag=sqlite3_prepare_v2(sqlite, "delete from Caogaoxiang where cid=?", -1, &stmt, nil);//调用预处理函数将sql语句赋值给stmt对象
    if (flag==SQLITE_OK)
    {
        sqlite3_bind_int(stmt, 1, cid);//给问号占位符赋值  1.语句2.占位符的序号3.给占位符赋得值
        //执行delete动作
        if(sqlite3_step(stmt)==SQLITE_ERROR)//未执行成功
        {
            NSLog(@"delete error");
        }
    }
    sqlite3_finalize(stmt);//回收stmt对象
    
    NSLog(@"删除了第%d条草稿",cid);
}

//更新草稿
+(void) updateCaogao:(Caogao *)caogao
{
    sqlite3 *sqlite=[DataBase OpenDB];//打开数据库
    sqlite3_stmt *stmt=nil;//定义sql语句对象
    int flag=sqlite3_prepare_v2(sqlite, "update Caogaoxiang set pic1=?,pic2=?,pic3=?,pic4=?,pic5=?,title=?,miaoshu=?,price=?,yuanPrice=?,fangshi=?,yunfei=?,fenlei=?,chengse=?,weizhi=?,phone=? where cid=?", -1, &stmt, nil);//调用预处理函数将sql语句赋值给stmt对象
    if (flag==SQLITE_OK)
    {
        sqlite3_bind_blob(stmt, 1, [caogao.pic1 bytes], [caogao.pic1 length], nil);
        sqlite3_bind_blob(stmt, 2, [caogao.pic2 bytes], [caogao.pic2 length], nil);
        sqlite3_bind_blob(stmt, 3, [caogao.pic3 bytes], [caogao.pic3 length], nil);
        sqlite3_bind_blob(stmt, 4, [caogao.pic4 bytes], [caogao.pic4 length], nil);
        sqlite3_bind_blob(stmt, 5, [caogao.pic5 bytes], [caogao.pic5 length], nil);
        
        sqlite3_bind_text(stmt, 6, [caogao.title UTF8String],-1,nil);//给问号占位符赋值
        sqlite3_bind_text(stmt, 7, [caogao.miaoshu UTF8String],-1,nil);
        sqlite3_bind_text(stmt, 8, [caogao.price UTF8String],-1,nil);
        sqlite3_bind_text(stmt, 9, [caogao.yuanPrice UTF8String],-1,nil);
        sqlite3_bind_text(stmt, 10, [caogao.fangshi UTF8String],-1,nil);
        sqlite3_bind_text(stmt, 11, [caogao.yunfei UTF8String],-1,nil);
        sqlite3_bind_text(stmt, 12, [caogao.fenlei UTF8String],-1,nil);
        sqlite3_bind_text(stmt, 13, [caogao.chengse UTF8String],-1,nil);
        sqlite3_bind_text(stmt, 14, [caogao.weizhi UTF8String],-1,nil);
        sqlite3_bind_text(stmt, 15, [caogao.phone UTF8String],-1,nil);

        if(sqlite3_step(stmt)==SQLITE_ERROR)//执行update动作
        {
            NSLog(@"update error");
        }
        sqlite3_finalize(stmt);//回收stmt对象
    }
}

//通过ID查询草稿
+(Caogao*) findbycid:(int)cid
{
    Caogao *caogao = nil;//用于返回的草稿对象
    sqlite3 *sqlite=[DataBase OpenDB];//打开数据库
    sqlite3_stmt *stmt=nil;//定义sql语句对象
    int flag=sqlite3_prepare_v2(sqlite, "select * from Caogaoxiang where cid=?", -1, &stmt, nil);//调用预处理函数将sql语句赋值给stmt对象
    if (flag==SQLITE_OK)
    {
        sqlite3_bind_int(stmt, 1, cid);//给问号占位符赋值
        while (sqlite3_step(stmt)==SQLITE_ROW)
        {
            //根据列顺序（从零开始）
            int cidd=sqlite3_column_int(stmt, 0);//取整型数据
            
            int length1=sqlite3_column_bytes(stmt,1);//获取二进制数据的长度
            NSData *img1=[NSData dataWithBytes:sqlite3_column_blob(stmt, 1) length:length1]; //将二进制数据转换位NSData对象
            
            int length2=sqlite3_column_bytes(stmt,2);
            NSData *img2=[NSData dataWithBytes:sqlite3_column_blob(stmt, 2) length:length2];
            
            int length3=sqlite3_column_bytes(stmt,3);
            NSData *img3=[NSData dataWithBytes:sqlite3_column_blob(stmt, 3) length:length3];
            
            int length4=sqlite3_column_bytes(stmt,4);
            NSData *img4=[NSData dataWithBytes:sqlite3_column_blob(stmt, 4) length:length4];
            
            int length5=sqlite3_column_bytes(stmt,5);
            NSData *img5=[NSData dataWithBytes:sqlite3_column_blob(stmt, 5) length:length5];
            
            NSString *ctitle=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];//取nsstring数据
            NSString *cmiaoshu=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 7)];
            NSString *cprice=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 8)];
            NSString *cyuanPrice=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 9)];
            NSString *cfangshi=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 10)];
            NSString *cyunfei=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 11)];
            NSString *cfenlei=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 12)];
            NSString *cchengse=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 13)];
            NSString *cweizhi=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 14)];
            NSString *cphone=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 15)];

            caogao = [[Caogao alloc]init];//此时开辟空间节省内存
            caogao.cid = cidd;
            caogao.pic1 = img1;
            caogao.pic2 = img2;
            caogao.pic3 = img3;
            caogao.pic4 = img4;
            caogao.pic5 = img5;
            caogao.title = ctitle;
            caogao.miaoshu = cmiaoshu;
            caogao.price = cprice;
            caogao.yuanPrice = cyuanPrice;
            caogao.fangshi = cfangshi;
            caogao.yunfei = cyunfei;
            caogao.fenlei = cfenlei;
            caogao.chengse = cchengse;
            caogao.weizhi = cweizhi;
            caogao.phone = cphone;
            
        }
    }
    sqlite3_finalize(stmt);//回收stmt对象
    return [caogao autorelease];//返回包含草稿信息的数组
}


+(NSMutableArray*) findall//返回表中所有记录
{
    NSMutableArray* caogaoArray = nil;//存储查询结果  在这里只声明不开辟空间 等用的时候再开辟（节省空间）
    sqlite3 *sqlite=[DataBase OpenDB];//打开数据库  并且定义了一个指针sqlite指向dbpoint所指向的区域（数据库）
    sqlite3_stmt *stmt=nil;//定义一个指向sql语句的指针对象
    int flag=sqlite3_prepare_v2(sqlite, "select * from Caogaoxiang", -1, &stmt, nil);//调用预处理函数将sql语句赋值给stmt对象  sqlite：数据库 -1：系统自动算出要存的sql语句的长度（也可以自己给出） &stmt：一个指向sql语句的内存的地址  nil：sql语句中没有用到的一部分（一般为空） 返回值为一个int(宏)SQLITE_OK 0  SQLITE_ERROR 1
    if (flag == SQLITE_OK) //预编译成功
    {
        caogaoArray = [[NSMutableArray alloc]init];//为数组开辟空间
        while (sqlite3_step(stmt)==SQLITE_ROW) //开始指向第一行的上面 判断下一行是否存在（存在：做准备指针移到下一行）（不存在：跳出循环）
        {
            int cidd=sqlite3_column_int(stmt, 0);//取整型数据
            
            int length1=sqlite3_column_bytes(stmt,1);//获取二进制数据的长度
            NSData *img1=[NSData dataWithBytes:sqlite3_column_blob(stmt, 1) length:length1]; //将二进制数据转换位NSData对象
            
            int length2=sqlite3_column_bytes(stmt,2);
            NSData *img2=[NSData dataWithBytes:sqlite3_column_blob(stmt, 2) length:length2];
            
            int length3=sqlite3_column_bytes(stmt,3);
            NSData *img3=[NSData dataWithBytes:sqlite3_column_blob(stmt, 3) length:length3];
            
            int length4=sqlite3_column_bytes(stmt,4);
            NSData *img4=[NSData dataWithBytes:sqlite3_column_blob(stmt, 4) length:length4];
            
            int length5=sqlite3_column_bytes(stmt,5);
            NSData *img5=[NSData dataWithBytes:sqlite3_column_blob(stmt, 5) length:length5];
            
            NSString *ctitle=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];//取nsstring数据
            NSString *cmiaoshu=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 7)];
            NSString *cprice=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 8)];
            NSString *cyuanPrice=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 9)];
            NSString *cfangshi=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 10)];
            NSString *cyunfei=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 11)];
            NSString *cfenlei=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 12)];
            NSString *cchengse=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 13)];
            NSString *cweizhi=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 14)];
            NSString *cphone=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 15)];
            
            Caogao *caogao = [[Caogao alloc]init];//此时开辟空间节省内存
            caogao.cid = cidd;
            caogao.pic1 = img1;
            caogao.pic2 = img2;
            caogao.pic3 = img3;
            caogao.pic4 = img4;
            caogao.pic5 = img5;
            caogao.title = ctitle;
            caogao.miaoshu = cmiaoshu;
            caogao.price = cprice;
            caogao.yuanPrice = cyuanPrice;
            caogao.fangshi = cfangshi;
            caogao.yunfei = cyunfei;
            caogao.fenlei = cfenlei;
            caogao.chengse = cchengse;
            caogao.weizhi = cweizhi;
            caogao.phone = cphone;
            
            
            [caogaoArray addObject:caogao] ;//将一个对象存入数组
            [caogao release];//释放对象
        }
    }
    sqlite3_finalize(stmt);//回收stmt对象
    return [caogaoArray autorelease];//返回包含草稿信息的数组  并设为自动释放
}





@end
