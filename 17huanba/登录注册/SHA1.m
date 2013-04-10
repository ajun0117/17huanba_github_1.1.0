//
//  SHA1.m
//  17huanba
//
//  Created by Chen Hao on 13-3-6.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "SHA1.h"
#import <CommonCrypto/CommonDigest.h>

@implementation SHA1

+ (NSString *)sha1Digest:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1( cStr, strlen(cStr), result);
    return [[NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
             result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15],
             result[16], result[17], result[18], result[19]] uppercaseString];
}

@end
