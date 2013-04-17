//
//  ShareConfig.h
//  KYGuideline
//
//  Created by chen xin on 12-8-21.
//  Copyright (c) 2012年 Kingyee. All rights reserved.
//

#ifndef KYGuideline_ShareConfig_h
#define KYGuideline_ShareConfig_h

#ifdef Debug
#define KY_ENABLE_SHARE TRUE
#else
//#define KY_ENABLE_SHARE FALSE
#define KY_ENABLE_SHARE TRUE
#endif

typedef enum {
    InvalidType = 0,
    SinaWeibo,
    Tencent,
    RenrenShare
} KYShareType;

#define kWeiboMaxWordCount  140

#define kDefaultText @"分享一下"

//新浪微博
// Define your AppKey & AppSecret here to eliminate the errors
#define kSinaAppKey @"3310247186"
#define kSinaAppSecret @"fd5c5e76154bef41fe4c1b1cc76bbc73"

#ifndef kSinaAppKey
#error
#endif

#ifndef kSinaAppSecret
#error
#endif

#define kWBAlertViewLogOutTag 100
#define kWBAlertViewLogInTag  101

//腾讯微博
#define oauthMode InWebView

/*
 * 获取oauth1.0票据的key
 */
#define oauth1TokenKey @"AccessToken"
#define oauth1SecretKey @"AccessTokenSecret"

/*
 * 获取oauth2.0票据的key
 */
#define oauth2TokenKey @"access_token="
#define oauth2OpenidKey @"openid="
#define oauth2OpenkeyKey @"openkey="
#define oauth2ExpireInKey @"expires_in="

#endif
