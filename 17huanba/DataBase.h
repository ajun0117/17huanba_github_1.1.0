//
//  DataBase.h
//  MyTableView
//
//  Created by Ibokan on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DataBase : NSObject

+(sqlite3*)OpenDB;
+(void)CloseDB;

@end
