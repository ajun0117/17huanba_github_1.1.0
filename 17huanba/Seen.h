//
//  Seen.h
//  17huanba
//
//  Created by Chen Hao on 13-3-5.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Seen : NSObject
@property(assign,nonatomic)int sid;
@property(assign,nonatomic)int gid;//商品ID
@property(retain,nonatomic)NSString *picUrlStr; //图片URL
@property(retain,nonatomic)NSString *title;
@property(retain,nonatomic)NSString *value;
@property(retain,nonatomic)NSString *yuanValue;
@property(retain,nonatomic)NSString *time;
@property(retain,nonatomic)NSString *fangshi;
@property(retain,nonatomic)NSString *weizhi;

+(void) insertSeenWithGid:(int)gid picStr:(NSString *)picUrlStr title:(NSString *)title value:(NSString *)value yuanValue:(NSString *)yuanValue time:(NSString *)time fangshi:(NSString *)fangshi weizhi:(NSString *)weizhi;
+(void) deletebysid:(int)sid;
//+(void) updateSeen:(Seen *) seen;
//+(Seen *) findbysid:(int)sid;
+(NSMutableArray *) findall;//返回表中所有记录

@end
