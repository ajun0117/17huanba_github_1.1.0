//
//  DataBase.m
//  MyTableView
//
//  Created by Ibokan on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataBase.h"

@implementation DataBase
static sqlite3*db=nil;
+(sqlite3*)OpenDB;
{
    if (db)//判断数据库是否 以打开
    {
        return db;
    }
    //获取原路径
    NSString*sourcepath=[[NSBundle mainBundle]pathForResource:@"CaogaoXiang" ofType:@"sqlite"];
    //获取document
    NSString*docpath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"%@",docpath);
    
    //创建doc上对应数据库文件
    NSString*targetpath=[docpath stringByAppendingPathComponent:@"CaogaoXiang.sqlite"];
    NSFileManager*fm=[NSFileManager defaultManager];
    if ([fm fileExistsAtPath:targetpath]==NO) 
    {
        [fm copyItemAtPath:sourcepath toPath:targetpath error:nil];
    }
    sqlite3_open([targetpath UTF8String], &db);
    return db;

   //创建文件到指定目录 [fm CreateDirectoryAtPath:() withIntormediateDirectory:false];
}
+(void)CloseDB
{
    if (db)
    {
        sqlite3_close(db);
    }
}
@end
