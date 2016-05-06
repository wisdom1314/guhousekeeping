//
//  AppDelegate.h
//  GuHouseKeeping
//
//  Created by David on 7/5/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "WeiboApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate, WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) WeiboApi *wbapi;
@end
