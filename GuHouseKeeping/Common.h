//
//  Common.h
//  FamilyAunt
//
//  Created by David on 7/5/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#ifndef FamilyAunt_Common_h
#define FamilyAunt_Common_h

#import "AppDelegate.h"
#import "GuHouseDataManager.h"
#import "GuHouseHTTPManager.h"
#import "TMCache.h"
/**
 *  Data Http Request
 */
#define HTTPDataAnalysisError @"数据错误"
#define HTTPConnectSeverError @"无网络，请连接网络"
#define HTTPConnectOutOfTime  @"网络异常，请求超时"
#define HTTPConnectFaildError @"网络异常，请求失败"

#define IS_IPHONE5 CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 1136))

#define IS_IOS7 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 7)
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"\n\n%s [Line %d]" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#define HTTPBaseURL @"http://115.29.246.202:8080/hw/"
#define ImageBaseURL(path) [NSString stringWithFormat:@"http://115.29.246.202:8080/hw/images/%@",path]

#define COLORRGBA(r,g,b,a) [UIColor colorWithRed:(r) / 255.0f           \
green:(g) / 255.0f           \
blue:(b) / 255.0f           \
alpha:(a)]
#define TMC (TMCache *)[TMCache sharedCache]
#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define HDM ((GuHouseDataManager *)[GuHouseDataManager sharedInstance])
#define HHM ((GuHouseHTTPManager *)[GuHouseHTTPManager sharedInstance])

#define PURPLECOLOR COLORRGBA(175,16,105,1.0)
#define GREENCOLO COLORRGBA(136, 193, 4, 1)
#define DARKGRAY COLORRGBA(185, 185, 185, 1.0)
#define LIGHTGRAY COLORRGBA(216, 216, 216, 1.0)
#define SWITCHONBG COLORRGBA(133,183,12,1.0)
#define SWITCHENDBG COLORRGBA(129,129,129,1.0)

#define FIRSTLAUNCH @"firstLaunch"
#define MEMBERID @"memberid"

#endif
