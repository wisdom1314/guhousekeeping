//
//  AppDelegate.m
//  GuHouseKeeping
//
//  Created by David on 7/5/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "AppDelegate.h"
#import "LaunchViewController.h"
#import "HomeViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <AlipaySDK/AlipaySDK.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //28 == 21201
//    NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@"icon_114x114.png"], 1.0) ;
//    DLog(@"%d", [data length]);
    
    
//    [ShareSDK registerApp:@"2e99dfe6f67f"];
//    [ShareSDK connectSinaWeiboWithAppKey:@"296423405"
//                               appSecret:@"2a4a27b8cbf1269871ee68eec2f5fad2"
//                             redirectUri:@"http://api.weibo.com/oauth2/default.html"];
    
//    [ShareSDK connectTencentWeiboWithAppKey:@"801537163"
//                                  appSecret:@"62f558f793b7d0e76bfdcf60c6bb64ef"
//                                redirectUri:@"http://www.sharesdk.cn"];
    
//    [ShareSDK connectTencentWeiboWithAppKey:@"801537163"
//                                  appSecret:@"62f558f793b7d0e76bfdcf60c6bb64ef"
//                                redirectUri:@"http://www.sharesdk.cn"
//                                   wbApiCls:[WeiboApi class]];

//    [ShareSDK connectWeChatWithAppId:@"wx9bdc862e3364df31" wechatCls:[WXApi class]];
//    [ShareSDK connectWeChatTimelineWithAppId:@"wx4868b35061f87885" wechatCls:[WXApi class]];
//    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
//                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"
//                           wechatCls:[WXApi class]];
//    ShareSDK con

//    [ShareSDK ssoEnabled:YES];


//    DLog(@"%@", NSStringFromCGSize([HDM getContentFromString:@"来自 9f0e1c48030142df960083c825246a0e" WithFont:[UIFont systemFontOfSize:9.0] ToSize:CGSizeMake(150.0, 20)]))
    
    [WXApi registerApp:@"wx9bdc862e3364df31" withDescription:@"居优家政"];
   
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:@"296423405"];

    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:FIRSTLAUNCH]) {
        // 这里判断是否第一次
        LaunchViewController *launch = [[LaunchViewController alloc] initWithNibName:@"LaunchViewController" bundle:nil];
        [HDM.nav setViewControllers:@[launch]];
    }else{
        
        NSString *memberID = [TMC restoreWithKey:MEMBERID];
        if (memberID) {
            [HDM setMemberId:memberID];
        }
        HomeViewController *home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        [HDM.nav setViewControllers:@[home]];
    }
    [self.window setRootViewController:HDM.nav];
    [self.window makeKeyAndVisible];
    
    
//    [HHM postAuntServiceFindAuntByIdForAunt:@{@"auntId": @"1"} success:^(AuntInfoModel *info) {
//        if (info) {
//            DLog(@"%@", info.description);
//        }
//    } failure:^(NSError *error) {
//        [HDM errorPopMsg:error];
//    }];
    
    
    [HHM postSystemServiceUpdateAPK:@{@"currentVersionCode":@"1.0.1"} success:^(SignModel *info) {
        
    } failure:^(NSError *error) {
        [HDM errorPopMsg:error];
    }];



    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//- (BOOL)application:(UIApplication *)application
//      handleOpenURL:(NSURL *)url
//{
//    
//    [self parse:url application:application];
//    return YES;
//
////    return [ShareSDK handleOpenURL:url
////                        wxDelegate:self];
//}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processAuth_V2Result:url
                                         standbyCallback:^(NSDictionary *resultDic) {
                                             NSLog(@"result = %@",resultDic);
                                             NSString *resultStr = resultDic[@"result"];
                                         }];
        
    }

//    NSString *textScheme = [[url scheme] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    DLog(@"text=======%@",textScheme);
//    if ([textScheme caseInsensitiveCompare:@"GuHouseKeeping"] == NSOrderedSame) {
////        return [[self getSinaWeibo] handleOpenURL:url];
//        [self parse:url application:application];
//
//        
//    }else if ([textScheme caseInsensitiveCompare:@"wx9bdc862e3364df31"] == NSOrderedSame){
//        return [WXApi handleOpenURL:url delegate:self];;
//
//    }else if ([textScheme caseInsensitiveCompare:@"wb801537163"] == NSOrderedSame){
//        return [_wbapi handleOpenURL:url];
//        
//    }else if ([textScheme caseInsensitiveCompare:@"wb296423405"] == NSOrderedSame){
//        return [WeiboSDK handleOpenURL:url delegate:(id<WeiboSDKDelegate>)self];
//    }
    return YES;
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
//        NSString *title = @"发送结果";
//        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
        [HDM popHlintMsg:((int)response.statusCode == 0 ? @"分享成功" : @"分享失败")];
    }
}

-(void) onReq:(BaseReq*)req{
    if([req isKindOfClass:[GetMessageFromWXReq class]]){
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        //        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        //        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        //
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        alert.tag = 1000;
        //        [alert show];
        
    }else if([req isKindOfClass:[ShowMessageFromWXReq class]]){
        //        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        //        WXMediaMessage *msg = temp.message;
        //
        //        //显示微信传过来的内容
        //        WXAppExtendObject *obj = msg.mediaObject;
        //
        //        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        //        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
        //
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }else if([req isKindOfClass:[LaunchFromWXReq class]]){
        //        //从微信启动App
        //        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        //        NSString *strMsg = @"这是从微信启动的消息";
        //
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];
    }
}

-(void) onResp:(BaseResp*)resp{
    if([resp isKindOfClass:[SendMessageToWXResp class]]){
        //        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        //        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        //
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:(resp.errCode == 0 ? @"发送成功" : @"发送失败") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        
        [HDM popHlintMsg:(resp.errCode == 0 ? @"分享成功" : @"分享失败")];
    }
}





@end
