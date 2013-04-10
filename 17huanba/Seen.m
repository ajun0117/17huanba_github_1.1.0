//
//  Seen.m
//  17huanba
//
//  Created by Chen Hao on 13-3-5.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "Seen.h"
#import "DataBase.h"
#import <sqlite3.h>

@implementation Seen
@synthesize sid,gid,title,value,yuanValue,time,fangshi,weizhi;
+(void)insertSeenWithGid:(int)gid picStr:(NSString *)picUrlStr title:(NSString *)title value:(NSString *)value yuanValue:(NSString *)yuanValue time:(NSString *)time fangshi:(NSString *)fangshi weizhi:(NSString *)weizhi
{
    sqlite3 *sqlite=[DataBase OpenDB];//打开数据库
    sqlite3_stmt *stmt=nil;//定义sql语句对象
    int flag=sqlite3_prepare_v2(sqlite, "insert into Seen(gid,picUrlStr,title,value,yuanValue,time,fangshi,weizhi) values(?,?,?,?,?,?,?,?)", -1, &stmt, nil);//调用预处理函数将sql语句赋值给stmt对象  多值绑定逗号隔开
    if (flag==SQLITE_OK)
    {
        sqlite3_bind_int(stmt, 1, gid);//给问号占位符赋值  1.语句2.占位符的序号3.给占位符赋得值
        sqlite3_bind_text(stmt, 2, [picUrlStr UTF8String],-1,nil);//给问号占位符赋值
        sqlite3_bind_text(stmt, 3, [title UTF8String],-1,nil);
        sqlite3_bind_text(stmt, 4, [value UTF8String],-1,nil);
        sqlite3_bind_text(stmt, 5, [yuanValue UTF8String],-1,nil);
        sqlite3_bind_text(stmt, 6, [time UTF8String],-1,nil);
        sqlite3_bind_text(stmt, 7, [fangshi UTF8String],-1,nil);
        sqlite3_bind_text(stmt, 8, [weizhi UTF8String],-1,nil);
        if(sqlite3_step(stmt)==SQLITE_ERROR)//执行insert动作
        {
            NSLog(@"insert error");
        }
    }
    sqlite3_finalize(stmt);//回收stmt对象
}

+(void)deletebysid:(int)sid
{
    sqlite3 *sqlite=[DataBase OpenDB];//打开数据库
    sqlite3_stmt *stmt=nil;//定义sql语句对象
    int flag=sqlite3_prepare_v2(sqlite, "delete from Seen where sid=?", -1, &stmt, nil);//调用预处理函数将sql语句赋值给stmt对象
    if (flag==SQLITE_OK)
    {
        sqlite3_bind_int(stmt, 1, sid);//给问号占位符赋值  1.语句2.占位符的序号3.给占位符赋得值
        //执行delete动作
        if(sqlite3_step(stmt)==SQLITE_ERROR)//未执行成功
        {
            NSLog(@"delete error");
        }
    }
    sqlite3_finalize(stmt);//回收stmt对象
    
    NSLog(@"删除了第%d条商品信息",sid);
}


+(NSMutableArray *) findall //返回表中所有记录
{
    NSMutableArray* seenArray = nil;//存储查询结果  在这里只声明不开辟空间 等用的时候再开辟（节省空间）
    sqlite3 *sqlite=[DataBase OpenDB];//打开数据库  并且定义了一个指针sqlite指向dbpoint所指向的区域（数据库）
    sqlite3_stmt *stmt=nil;//定义一个指向sql语句的指针对象
    int flag=sqlite3_prepare_v2(sqlite, "select * from Seen", -1, &stmt, nil);//调用预处理函数将sql语句赋值给stmt对象  sqlite：数据库 -1：系统自动算出要存的sql语句的长度（也可以自己给出） &stmt：一个指向sql语句的内存的地址  nil：sql语句中没有用到的一部分（一般为空） 返回值为一个int(宏)SQLITE_OK 0  SQLITE_ERROR 1
    if (flag==SQLITE_OK) //预编译成功
    {
        seenArray = [[NSMutableArray alloc]init];//为数组开辟空间
        while (sqlite3_step(stmt)==SQLITE_ROW) //开始指向第一行的上面 判断下一行是否存在（存在：做准备指针移到下一行）（不存在：跳出循环）
        {
            int sidd=sqlite3_column_int(stmt, 0);//取整型数据
            
            int gidd=sqlite3_column_int(stmt, 1);//取整型数据

            NSString *gpicUrlStr=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            NSString *gtitle=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];//取nsstring数据
            NSString *gvalue=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
            NSString *gyuanValue=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
            NSString *gtime=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];
            NSString *gfangshi=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 7)];
            NSString *gweizhi=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 8)];
            
            Seen *seen = [[Seen alloc]init];//此时开辟空间节省内存
            seen.sid = sidd;
            seen.gid = gidd;
            seen.picUrlStr = gpicUrlStr;
            seen.title = gtitle;
            seen.value = gvalue;
            seen.yuanValue = gyuanValue;
            seen.time = gtime;
            seen.fangshi = gfangshi;
            seen.weizhi = gweizhi;
            
            [seenArray addObject:seen] ;//将一个对象存入数组
            [seen release];//释放对象
        }
    }
    sqlite3_finalize(stmt);//回收stmt对象
    return [seenArray autorelease];//返回包含学生信息的数组  并设为自动释放
}


@end
