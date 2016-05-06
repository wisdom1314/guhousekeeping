//
//  MoreViewController.m
//  GuHouseKeeping
//
//  Created by David on 7/10/14.
//  Copyright (c) 2014 David. All rights reserved.
//


#import "MoreViewController.h"
#import "MoreTableViewCell.h"
#import "WeiBoShareView.h"
#import "ContactUsView.h"
#import "FeedBackView.h"
#import "LoginViewController.h"
#import "WeiboApi.h"

@interface MoreViewController ()<WeiboRequestDelegate,WeiboAuthDelegate>
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UIView *switchBackGroundView;
@property (nonatomic, strong) UIView *switchDotView;
@property (nonatomic, assign) BOOL isSwitchOn;
@property (nonatomic, strong) UIView *alterView;
@property (nonatomic, strong) FeedBackView *feedback;
@property (nonatomic, assign) BOOL didLoginAction;
@property (nonatomic, strong) UIView *poweroffView;

@end

@implementation MoreViewController
@synthesize dataArr = _dataArr;
@synthesize switchBackGroundView = _switchBackGroundView;
@synthesize switchDotView = _switchDotView;
@synthesize isSwitchOn = _isSwitchOn;
@synthesize alterView = _alterView;
@synthesize feedback = _feedback;
@synthesize didLoginAction = _didLoginAction;
@synthesize poweroffView = _poweroffView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _switchBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(258, 23, 32, 18)];
    [_switchBackGroundView setBackgroundColor:SWITCHENDBG];
    _switchBackGroundView.layer.cornerRadius = CGRectGetHeight(_switchBackGroundView.frame) / 2.0;
    _switchBackGroundView.layer.masksToBounds = YES;
    
    _switchDotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [_switchDotView setBackgroundColor:[UIColor whiteColor]];
    _switchDotView.layer.cornerRadius = CGRectGetHeight(_switchDotView.frame) / 2.0;
    _switchDotView.layer.masksToBounds = YES;
    [_switchBackGroundView addSubview:_switchDotView];
    [self setIsSwitchOn:YES];
    
    _dataArr = @[@{@"icon": @"more_share.png",
                   @"title": @"分享到"},
                 @{@"icon": @"more_infor.png",
                   @"title": @"接收信息"},
                 @{@"icon": @"more_delete.png",
                   @"title": @"清除缓存"},
                 @{@"icon": @"more_Refresh.png",
                   @"title": @"检查更新"},
                 @{@"icon": @"more_idea.png",
                   @"title": @"意见反馈"},
                 @{@"icon": @"more_relation",
                   @"title": @"联系我们"},
                 @{@"icon": @"more_Star-v3.png",
                   @"title": @"关于软件"},
                 ];
    
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 17)];
    [header setBackgroundColor:[UIColor clearColor]];
    [_myTableView setTableHeaderView:header];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    if (animated) {
        DLog(@"HomeViewController animated");
        if (_didLoginAction) {
            _didLoginAction = NO;
            [self createFeebBackView];
        }
    }else{
        DLog(@"HomeViewController");
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)keyWillChange:(NSNotification *)noti{
    NSDictionary *userInfo = [noti userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    if (_feedback) {
        float dis = CGRectGetHeight(_alterView.frame) - _feedback.frame.origin.y - CGRectGetHeight(_feedback.frame) - CGRectGetHeight(keyboardRect);
        if (dis < 0) {
            CGPoint center = _feedback.center;
            center.y -= fabsf(dis);
            center.y -= 10;
            [UIView animateWithDuration:animationDuration animations:^{
                [_feedback setCenter:center];
            }];
            
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
}

- (void)setIsSwitchOn:(BOOL)isSwitchOn{
    _isSwitchOn = isSwitchOn;
    if (_isSwitchOn) {
        [_switchBackGroundView setBackgroundColor:SWITCHONBG];
        [UIView animateWithDuration:0.2 animations:^{
            [_switchDotView setCenter:CGPointMake(CGRectGetWidth(_switchBackGroundView.frame) - CGRectGetWidth(_switchDotView.frame) / 2.0, _switchDotView.center.y)];
        }];
    }else{
        [_switchBackGroundView setBackgroundColor:SWITCHENDBG];
        [UIView animateWithDuration:0.2 animations:^{
            [_switchDotView setCenter:CGPointMake(CGRectGetWidth(_switchDotView.frame) / 2.0, _switchDotView.center.y)];
        }];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%d%d",indexPath.section,indexPath.row];//@"Cell";
    
    MoreTableViewCell *cell = (MoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"MoreTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
    }
    
    [cell.leftIconIV setImage:[UIImage imageNamed:_dataArr[indexPath.row][@"icon"]]];
    [cell.titleLabel setText:_dataArr[indexPath.row][@"title"]];
    if ([cell.titleLabel.text isEqualToString:@"接收信息"]) {
        [cell.rightArrow setHidden:YES];
        [cell addSubview:_switchBackGroundView];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            DLog(@"分享到");
            [self createWeiShareView];
        }
            break;
        case 1:{
            DLog(@"接受消息");
            [self setIsSwitchOn:!_isSwitchOn];
        }
            break;
        case 2:{
            DLog(@"清楚缓存");
            [self createAlterLabel:@"清理成功"];
            
        }
            break;
        case 3:{
            DLog(@"检查更新");
            [self createAlterLabel:@"已是最新版本"];
        }
            break;
        case 4:{
            DLog(@"意见反馈");
            [self createFeebBackView];
        }
            break;
        case 5:{
            DLog(@"联系我们");
            [self createContractView];
        }
            break;
        case 6:{
            DLog(@"关于软件");
            [self createAlterLabel:@"当前版本V1.0"];

        }
            break;
            
        default:
            break;
    }
}

- (void)createAlphaView{
    _alterView = [[UIView alloc] initWithFrame:_myTableView.frame];
    [_alterView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_alterView];

    UIView * alphaView = [[UIView alloc] initWithFrame:_alterView.bounds];
    [alphaView setBackgroundColor:[UIColor blackColor]];
    [alphaView setAlpha:0.3];
    [_alterView addSubview:alphaView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    [tap setDelegate:(id<UIGestureRecognizerDelegate>)self];
    tap.numberOfTouchesRequired = 1;
    [_alterView addGestureRecognizer:tap];
}


- (void)createWeiShareView{
    [self createAlphaView];
    WeiBoShareView *share = (WeiBoShareView *)[[[NSBundle mainBundle] loadNibNamed:@"WeiBoShareView" owner:self options:nil] objectAtIndex:0];
    share.layer.cornerRadius=15;
    share.layer.masksToBounds = YES;
    [share setBackgroundColor:[UIColor whiteColor]];
    
    [share setCenter:CGPointMake(CGRectGetWidth(_alterView.frame) / 2.0, CGRectGetHeight(_alterView.frame) / 2.0)];
    [share.sinaButton addTarget:self action:@selector(sinaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [share.txButton addTarget:self action:@selector(txButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [share.friendButton addTarget:self action:@selector(friendButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    [_alterView addSubview:share];
    
}

- (void)sinaButtonClick:(id)sender{
    DLog(@"Sina 微博");
    [_alterView removeFromSuperview];
    _alterView = nil;
    
    if ([WeiboSDK getWeiboAppInstallUrl] && [WeiboSDK isWeiboAppInstalled] && [WeiboSDK isCanShareInWeiboAPP] && [WeiboSDK isCanSSOInWeiboApp]) {
        WBMessageObject *message = [WBMessageObject message];
        
        WBWebpageObject *webpage = [WBWebpageObject object];
        webpage.objectID = @"居优家政";
        webpage.title = @"居优家政";
        webpage.description = @"这里的小时工服务质量真的很好，一起来用一下吧！";
        webpage.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:@"icon_120x120.png"]);
        webpage.webpageUrl = @"http://www.52jyjz.com";
        message.mediaObject = webpage;
        
        WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
        authRequest.redirectURI = @"http://api.weibo.com/oauth2/default.html";
        authRequest.scope = @"all";
        
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
        request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        [WeiboSDK sendRequest:request];
    }else{
        [HDM popHlintMsg:@"请安装最新版新浪微博！"];
    }
   

//    //构造分享内容
////    [ShareSDK pngImageWithImage:[UIImage imageNamed:@"icon_114x114.png"]]
//    id<ISSContent> publishContent = [ShareSDK content:@"这里的小时工服务质量真的很好，一起来用一下吧！"
//                                       defaultContent:@"这里的小时工服务质量真的很好，一起来用一下吧！"
//                                                image:nil
//                                                title:nil
//                                                  url:nil
//                                          description:nil
//                                            mediaType:SSPublishContentMediaTypeNews];
//    
//    
//    [ShareSDK clientShareContent:publishContent type:ShareTypeSinaWeibo statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//        if (state == SSPublishContentStateBegan){
//            NSLog(@"分享开始");
//             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//            _poweroffView = [[UIView alloc] initWithFrame:CGRectMake(100, 20, 220, 44)];
//            [_poweroffView setBackgroundColor:[UIColor clearColor]];
//            [[[UIApplication sharedApplication] keyWindow] addSubview:_poweroffView];
//            
//        }else{
//            if (_poweroffView) {
//                [_poweroffView removeFromSuperview];
//                _poweroffView = nil;
//            }
//        }
//        if (state == SSPublishContentStateSuccess){
//            [HDM popHlintMsg:@"分享成功"];
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//        }else if (state == SSPublishContentStateFail){
//            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
//            if ([error errorCode] == -106) {
//                [HDM popHlintMsg:@"无网络"];
//            }else if ([error errorCode] != -103){
//                [HDM popHlintMsg:@"分享失败"];
//            }
//             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//        }else if (state == SSPublishContentStateCancel){
//            NSLog(@"分享取消");
//        }
//    }];
}

- (void)txButtonClick:(id)sender{
    DLog(@"腾讯 微博");
    [_alterView removeFromSuperview];
    _alterView = nil;
    [self shareTX];
    //创建分享内容
//    [ShareSDK pngImageWithImage:[UIImage imageNamed:@"icon_114x114.png"]]
//    id<ISSContent> publishContent = [ShareSDK content:@"这里的小时工服务质量真的很好，一起来用一下吧！"
//                                       defaultContent:@"这里的小时工服务质量真的很好，一起来用一下吧！"
//                                                image:nil
//                                                title:@"这里的小时工服务质量真的很好，一起来用一下吧！"
//                                                  url:nil
//                                          description:nil
//                                            mediaType:SSPublishContentMediaTypeText];
//    
//    
//    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                         allowCallback:YES
//                                                         authViewStyle:SSAuthViewStyleModal
//                                                          viewDelegate:nil
//                                               authManagerViewDelegate:nil];
//    
//    [ShareSDK clientShareContent:publishContent type:ShareTypeTencentWeibo authOptions:authOptions shareOptions:nil statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//        if (state == SSPublishContentStateBegan){
//            NSLog(@"分享开始");
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//            _poweroffView = [[UIView alloc] initWithFrame:CGRectMake(100, 20, 220, 44)];
//            [_poweroffView setBackgroundColor:[UIColor clearColor]];
//            [[[UIApplication sharedApplication] keyWindow] addSubview:_poweroffView];
//            
//        }else{
//            if (_poweroffView) {
//                [_poweroffView removeFromSuperview];
//                _poweroffView = nil;
//            }
//        }
//        if (state == SSPublishContentStateSuccess){
//            [HDM popHlintMsg:@"分享成功"];
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//        }else if (state == SSPublishContentStateFail){
//            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
//            if ([error errorCode] == -106) {
//                [HDM popHlintMsg:@"无网络"];
//            }else if ([error errorCode] != -103){
//                [HDM popHlintMsg:@"分享失败"];
//            }
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//        }else if (state == SSPublishContentStateCancel){
//            NSLog(@"分享取消");
//        }
//    }];
}


- (void)shareTX{
    if (!APPDELEGATE.wbapi) {
        APPDELEGATE.wbapi =  [[WeiboApi alloc]initWithAppKey:@"801537163" andSecret:@"62f558f793b7d0e76bfdcf60c6bb64ef" andRedirectUri:@"http://www.52jyjz.com" andAuthModeFlag:0 andCachePolicy:0] ;
    }
    [APPDELEGATE.wbapi checkAuthValid:TCWBAuthCheckServer andDelegete:self];
}


#pragma mark WeiboRequestDelegate

/**
 * @brief   接口调用成功后的回调
 * @param   INPUT   data    接口返回的数据
 * @param   INPUT   request 发起请求时的请求对象，可以用来管理异步请求
 * @return  无返回
 */
- (void)didReceiveRawData:(NSData *)data reqNo:(int)reqno
{
    NSString *strResult = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    //[NSString stringWithCharacters:[data bytes] length:[data length]];
    NSLog(@"result = %@",strResult);
    if ([strResult rangeOfString:@"\"errcode\":0"].location != NSNotFound) {
        [HDM popHlintMsg:@"分享成功"];
    }else if ([strResult rangeOfString:@"\"errcode\":75"].location != NSNotFound){
        [HDM popHlintMsg:@"重复分享"];
    }else{
        [HDM popHlintMsg:@"分享失败"];
    }
}
/**
 * @brief   接口调用失败后的回调
 * @param   INPUT   error   接口返回的错误信息
 * @param   INPUT   request 发起请求时的请求对象，可以用来管理异步请求
 * @return  无返回
 */
- (void)didFailWithError:(NSError *)error reqNo:(int)reqno
{
    NSString *str = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
    
    DLog(@"str:%@", str);
    [HDM popHlintMsg:@"分享失败"];
}



#pragma mark WeiboAuthDelegate

/**
 * @brief   重刷授权成功后的回调
 * @param   INPUT   wbapi 成功后返回的WeiboApi对象，accesstoken,openid,refreshtoken,expires 等授权信息都在此处返回
 * @return  无返回
 */
- (void)DidAuthRefreshed:(WeiboApiObject *)wbobj
{
    
    
    //UISwitch
    NSString *str = [[NSString alloc]initWithFormat:@"accesstoken = %@\r openid = %@\r appkey=%@ \r appsecret=%@\r",wbobj.accessToken, wbobj.openid, wbobj.appKey, wbobj.appSecret];
    
    NSLog(@"result = %@",str);
    
    
}

/**
 * @brief   重刷授权失败后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
- (void)DidAuthRefreshFail:(NSError *)error
{
    NSString *str = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
    NSLog(@"result = %@",str);

}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   wbapi 成功后返回的WeiboApi对象，accesstoken,openid,refreshtoken,expires 等授权信息都在此处返回
 * @return  无返回
 */
- (void)DidAuthFinished:(WeiboApiObject *)wbobj
{
    NSString *str = [[NSString alloc]initWithFormat:@"accesstoken = %@\r\n openid = %@\r\n appkey=%@ \r\n appsecret=%@ \r\n refreshtoken=%@ ", wbobj.accessToken, wbobj.openid, wbobj.appKey, wbobj.appSecret, wbobj.refreshToken];
    
    NSLog(@"＝＝＝＝＝＝＝result = %@",str);
    UIImage *pic = [UIImage imageNamed:@"icon_120x120.png"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",
                                   @"居优家政 这里的小时工服务质量真的很好，一起来用一下吧！", @"content",
                                   pic, @"pic",
                                   nil];
    [APPDELEGATE.wbapi requestWithParams:params apiName:@"t/add_pic" httpMethod:@"POST" delegate:self];
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   wbapi   weiboapi 对象，取消授权后，授权信息会被清空
 * @return  无返回
 */
- (void)DidAuthCanceled:(WeiboApi *)wbapi_
{
    
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
- (void)DidAuthFailWithError:(NSError *)error
{
    NSString *str = [[NSString alloc] initWithFormat:@"get token error, errcode = %@",error.userInfo];
    NSLog(@"＝＝＝＝＝＝＝＝str:%@", str);

    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
-(void)didCheckAuthValid:(BOOL)bResult suggest:(NSString *)strSuggestion
{
    NSString *str = [[NSString alloc] initWithFormat:@"ret=%d, suggestion = %@", bResult, strSuggestion];
    NSLog(@"＝＝＝＝＝＝＝＝＝str:%@", str);
    if (bResult) {
        UIImage *pic = [UIImage imageNamed:@"icon_120x120.png"];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",
                                       @"居优家政 这里的小时工服务质量真的很好，一起来用一下吧！", @"content",
                                       pic, @"pic",
                                       nil];
        [APPDELEGATE.wbapi requestWithParams:params apiName:@"t/add_pic" httpMethod:@"POST" delegate:self];
    }else{
        [APPDELEGATE.wbapi loginWithDelegate:self andRootController:self];
    }
}

- (void)friendButtonClick:(id)sender{
     DLog(@"朋友圈");
    [_alterView removeFromSuperview];
    _alterView = nil;
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"居优家政\n这里的小时工服务质量真的很好，一起来用一下吧！";
        message.description = @"居优家政\n这里的小时工服务质量真的很好，一起来用一下吧！";
        [message setThumbImage:[UIImage imageNamed:@"icon_120x120.png"]];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = @"http://www.52jyjz.com";
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;
        [WXApi sendReq:req];
    }else{
        [HDM popHlintMsg:@"请安装最新版微信！"];
    }
    

    
//    //发送内容给微信
////    [ShareSDK pngImageWithImage:[UIImage imageNamed:@"icon_120x120.png"]]
////    SSPublishContentMediaTypeApp
//    id<ISSContent> content = [ShareSDK content:@"这里的小时工服务质量真的很好，一起来用一下吧！"
//                                defaultContent:@"这里的小时工服务质量真的很好，一起来用一下吧！"
//                                         image:nil
//                                         title:@"这里的小时工服务质量真的很好，一起来用一下吧！"
//                                           url:nil
//                                   description:nil
//                                     mediaType:SSPublishContentMediaTypeText];
//    
//    
//    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                         allowCallback:YES
//                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                          viewDelegate:nil
//                                               authManagerViewDelegate:nil];
//    
//    [ShareSDK shareContent:content
//                      type:ShareTypeWeixiTimeline
//               authOptions:authOptions
//             statusBarTips:YES
//                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                        if (state == SSPublishContentStateBegan){
//                            NSLog(@"分享开始");
//                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//                            _poweroffView = [[UIView alloc] initWithFrame:CGRectMake(100, 20, 220, 44)];
//                            [_poweroffView setBackgroundColor:[UIColor clearColor]];
//                            [[[UIApplication sharedApplication] keyWindow] addSubview:_poweroffView];
//                            
//                        }else{
//                            if (_poweroffView) {
//                                [_poweroffView removeFromSuperview];
//                                _poweroffView = nil;
//                            }
//                        }
//                        if (state == SSPublishContentStateSuccess){
//                            [HDM popHlintMsg:@"分享成功"];
//                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//                        }else if (state == SSPublishContentStateFail){
//                            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
//                            if ([error errorCode] == -106) {
//                                [HDM popHlintMsg:@"无网络"];
//                            }else if ([error errorCode] == -22003){
//                                [HDM popHlintMsg:@"请安装微信"];
//                            }else if ([error errorCode] != -103){
//                                [HDM popHlintMsg:@"分享失败"];
//                            }
//                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//                        }else if (state == SSPublishContentStateCancel){
//                            NSLog(@"分享取消");
//                        }
//                    }];
}

- (void)createAlterLabel:(NSString *)alter{
    [self createAlphaView];
    UILabel *alterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 392 / 2.0, 270 /2.0)];
    alterLabel.layer.cornerRadius=15;
    alterLabel.layer.masksToBounds = YES;
    [alterLabel setBackgroundColor:[UIColor whiteColor]];
    [alterLabel setTextColor:PURPLECOLOR];
    [alterLabel setTextAlignment:NSTextAlignmentCenter];
    [alterLabel setText:alter];
    [alterLabel setCenter:CGPointMake(CGRectGetWidth(_alterView.frame) / 2.0, CGRectGetHeight(_alterView.frame) / 2.0)];
    
    [_alterView addSubview:alterLabel];
}

- (void)createContractView{
    [self createAlphaView];
    ContactUsView *contract = (ContactUsView *)[[[NSBundle mainBundle] loadNibNamed:@"ContactUsView" owner:self options:nil] objectAtIndex:0];
    [contract setBackgroundColor:[UIColor whiteColor]];
    contract.layer.cornerRadius=15;
    contract.layer.masksToBounds = YES;
    [contract setCenter:CGPointMake(CGRectGetWidth(_alterView.frame) / 2.0, CGRectGetHeight(_alterView.frame) / 2.0)];
    [_alterView addSubview:contract];
}

- (void)createFeebBackView{
    if ([HDM memberId]) {
        [self createAlphaView];
        if (!_feedback) {
            _feedback = (FeedBackView *)[[[NSBundle mainBundle] loadNibNamed:@"FeedBackView" owner:self options:nil] objectAtIndex:0];
            [_feedback setBackgroundColor:[UIColor whiteColor]];
            _feedback.layer.cornerRadius=15;
            _feedback.layer.masksToBounds = YES;
            [_feedback setCenter:CGPointMake(CGRectGetWidth(_alterView.frame) / 2.0, CGRectGetHeight(_alterView.frame) / 2.0)];
            [_feedback.cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_feedback.submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_feedback.tfView setDelegate:(id<UITextViewDelegate>)self];
            [_alterView addSubview:_feedback];
        }
    }else{
        LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [login setDelegate:(id<LoginViewControllerDelegate>)self];
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (void)loginViewControllerDidSuccessLogin{
    _didLoginAction = YES;
}
- (void)cancelButtonClick:(id)sender{
    DLog(@"cancelButtonClick");
    [_alterView removeFromSuperview];
    _alterView = nil;
    
    [_feedback removeFromSuperview];
    _feedback = nil;
}

- (void)submitButtonClick:(id)sender{
    DLog(@"submitButtonClick");
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    [HHM postSystemServiceSaveFeedBack:@{@"feedBack": [HDM jsonStringFromOjb:@{@"content": _feedback.tfView.text,
                                                                               @"memberId": HDM.memberId,
                                                                               @"optTime": [formatter stringFromDate:[NSDate date]]}]} success:^(FeedBackModel *info) {
        if (info) {
            [HDM popHlintMsg:@"反馈成功"];
        }else{
            [HDM popHlintMsg:@"反馈失败"];
        }
    } failure:^(NSError *error) {
        [HDM errorPopMsg:error];
    }];
    
    [_alterView removeFromSuperview];
    _alterView = nil;
    
    [_feedback removeFromSuperview];
    _feedback = nil;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSLog(@"%@",[[touch view] class]);
    if ([[touch view] isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}

- (void)tap:(UITapGestureRecognizer *)recognizer{
    if (_feedback) {
        [_feedback removeFromSuperview];
        _feedback = nil;
    }
    [_alterView removeFromSuperview];
    _alterView = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
