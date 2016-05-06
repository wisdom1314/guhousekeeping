//
//  ViPDetailViewController.m
//  GuHouseKeeping
//
//  Created by luyun on 14-7-13.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import "ViPDetailViewController.h"
#import "NetWorkPurchaseViewController.h"

#import "Order.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>


@interface ViPDetailViewController ()
@property (nonatomic, assign) AliPayAction alipayAction;

@end

@implementation ViPDetailViewController
@synthesize alipayAction = _alipayAction;
@synthesize indexRow = _indexRow;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appScheme:) name:@"appScheme" object:nil];

    
    [_myScrollView setContentSize:CGSizeMake(3 * CGRectGetWidth(_myScrollView.frame), CGRectGetHeight(_myScrollView.frame))];
    
    
    UIView *first_view = [[UIView alloc] initWithFrame:_myScrollView.bounds];
    [self createView:first_view];
    
    UIView *second_view = [[UIView alloc] initWithFrame:_myScrollView.bounds];
    [second_view setCenter:CGPointMake(CGRectGetWidth(_myScrollView.frame) * 1.5, second_view.center.y)];
    [self createView:second_view];
    
    UIView *third_view = [[UIView alloc] initWithFrame:_myScrollView.bounds];
    [third_view setCenter:CGPointMake(CGRectGetWidth(_myScrollView.frame) * 5 / 2.0, third_view.center.y)];
    [self createView:third_view];
    
    [_myScrollView setContentOffset:CGPointMake(_indexRow * CGRectGetWidth(_myScrollView.frame), 0) animated:NO];
    [self resetButtonState];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (_alipayAction == isAliPaySuccess) {
        [HDM popHlintMsg:@"交易成功!"];
    }else if (_alipayAction == isAliPayFail){
        [HDM popHlintMsg:@"交易失败!"];
    }
    _alipayAction = isAliPayDefault;
}

- (void)createView:(UIView *)view{
    UIImageView *topCardImageView;
    if (IS_IPHONE5) {
        topCardImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(20, 42, 280, 144)];
    }else{
        topCardImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(20, 22, 280, 144)];
    }
    int tag = 0;
    NSArray *titleArr = nil;
    switch ((int)(view.frame.origin.x / view.frame.size.width)) {
        case 0:{
            tag = 0;
            titleArr = @[@"独家权限:",
                         @"1.享受本公司金卡会员待遇",
                         @"2.立即返回价值RMB100元优惠券",
                         @"3.常用阿姨可添加至2人",
                         @"4.更多特权，敬请期待"];
            [topCardImageView setImage:[UIImage imageNamed:@"vipCard_gold.png"]];
        }
            break;
        case 1:{
            tag = 1;
            titleArr = @[@"独家权限:",
                         @"1.享受本公司金卡会员待遇",
                         @"2.立即返回价值RMB200元优惠券",
                         @"3.常用阿姨可添加至3人",
                         @"4.更多特权，敬请期待"];
            [topCardImageView setImage:[UIImage imageNamed:@"vipCard_platinum.png"]];
        }
            break;
        case 2:{
            tag = 2;
            titleArr = @[@"独家权限:",
                         @"1.享受本公司金卡会员待遇",
                         @"2.立即返回价值RMB300元优惠券",
                         @"3.常用阿姨可添加至5人",
                         @"4.更多特权，敬请期待"];
            [topCardImageView setImage:[UIImage imageNamed:@"vipCard_diamond.png"]];
        }
            break;
        default:
            break;
    }
    [view addSubview:topCardImageView];
    
   
    __block float oy;
    if (IS_IPHONE5) {
        oy = 218.0;
    }else{
        oy = 178.0;
    }
    
    [titleArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, oy, 240, 28)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        [titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [titleLabel setText:obj];
        [titleLabel setTextColor:[UIColor darkGrayColor]];
        [view addSubview:titleLabel];
        oy += 28;
        
    }];
    
    
    UIButton *purchaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IS_IPHONE5) {
        [purchaseButton setFrame:CGRectMake(18, 409, 284, 52)];
    }else{
        [purchaseButton setFrame:CGRectMake(18, 409 - 80, 284, 52)];
    }
    [purchaseButton setTag:tag];
    [purchaseButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [purchaseButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [purchaseButton setBackgroundImage:[UIImage imageNamed:@"vipCard_purchase_large.png"] forState:UIControlStateNormal];
    [purchaseButton addTarget:self action:@selector(purchaseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:purchaseButton];

    [_myScrollView addSubview:view];
}


- (void)purchaseButtonClick:(id)sender{
//    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"是否要购买此卡？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alter show];
    /*
     *生成订单信息及签名
     *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
     */
    
    UIButton *btn = (UIButton *)sender;
    [HHM postOrderServiceToPayMentUserInfo:@{@"userId": HDM.memberId,
                                             @"card": ([btn tag] == 0 ? @"GOLD" : ([btn tag] == 1 ? @"WHITE_GOLD" : @"DIAMOND"))} success:^(PaymentModel *info) {
                                                 DLog(@"%@", info);
                                                 if (info) {
                                                     /*
                                                      *点击获取prodcut实例并初始化订单信息
                                                      */
                                                     Order *order = [[Order alloc] init];
                                                     order.partner = PartnerID;
                                                     order.seller = SellerID;
                                                     order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
                                                     order.productName = info.subject; //商品标题
                                                     order.productDescription = info.body; //商品描述
                                                     order.amount = [NSString stringWithFormat:@"%.2f",[info.total_fee floatValue]]; //商品价格
                                                     order.notifyURL =  info.return_url; //回调URL
                                                     
                                                     
                                                     
                                                     //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
                                                     NSString *appScheme = @"GuHouseKeeping";
                                                     
                                                     //将商品信息拼接成字符串
                                                     NSString* orderInfo = [order description];
                                                     NSLog(@"orderSpec = %@",orderInfo);
                                                     
                                                     //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
                                                     id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
                                                     NSString *signedString = [signer signString:orderInfo];
                                                     
                                                     
                                                     //将签名成功字符串格式化为订单字符串,请严格按照该格式
                                                     NSString *orderString = nil;
                                                     if (signedString != nil) {
                                                         orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                                                        orderInfo, signedString, @"RSA"];
                                                         
                                                         /**
                                                          *  支付接口
                                                          *
                                                          *  @param orderStr       订单信息
                                                          *  @param schemeStr      调用支付的app注册在info.plist中的scheme
                                                          *  @param compltionBlock 支付结果回调Block
                                                          */
                                                         [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                                                             NSLog(@"reslut = %@",resultDic);
                                                         }];
                                                     }
                                                 

                                                 }else{
                                                     [HDM popHlintMsg:HTTPDataAnalysisError];
                                                 }
                                             } failure:^(NSError *error) {
                                                 [HDM errorPopMsg:error];
                                             }];

    
    
//    NSString *appScheme = @"GuHouseKeeping";
//    NSString* orderInfo = [self getOrderInfo];
//    NSString* signedStr = [self doRsa:orderInfo];
//    
//    NSLog(@"%@",signedStr);
//    
//    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                             orderInfo, signedStr, @"RSA"];
//    
//    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:@selector(paymentResult:) target:self];
//    
}

-(NSString*)getOrderInfo{
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
    Order *order = [[Order alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
	order.productName = @"话费充值"; //商品标题
	order.productDescription = @"[四钻信誉]北京移动30元 电脑全自动充值 1到10分钟内到账"; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f",1.0]; //商品价格
	order.notifyURL =  @"http%3A%2F%2Fwwww.xxx.com"; //回调URL
	
	return [order description];
}

- (NSString *)generateTradeNO{
	const int N = 15;
	
	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *result = [[NSMutableString alloc] init] ;
	srand(time(0));
	for (int i = 0; i < N; i++){
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
	return result;
}

//-(NSString*)doRsa:(NSString*)orderInfo{
//    id<DataSigner> signer;
//    signer = CreateRSADataSigner(PartnerPrivKey);
//    NSString *signedString = [signer signString:orderInfo];
//    return signedString;
//}

-(void)paymentResultDelegate:(NSString *)result{
    NSLog(@"%@",result);
}

- (void)appScheme:(NSNotification *)noti{
    _alipayAction = [[noti object] integerValue];
    if (_alipayAction == isAliPaySuccess) {
        [HDM popHlintMsg:@"交易成功!"];
    }else if (_alipayAction == isAliPayFail){
        [HDM popHlintMsg:@"交易失败!"];
    }
    _alipayAction = isAliPayDefault;
}

//
////wap回调函数
//-(void)paymentResult:(NSString *)resultd
//{
//    //结果处理
//#if ! __has_feature(objc_arc)
//    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
//#else
//    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
//#endif
//	if (result){
//		if (result.statusCode == 9000){
//			/*
//			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
//			 */
//            //交易成功
//            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
//			id<DataVerifier> verifier;
//            verifier = CreateRSADataVerifier(key);
//            
//			if ([verifier verifyString:result.resultString withSign:result.signString]){
//                //验证签名成功，交易结果无篡改
//                _alipayAction = isAliPaySuccess;
//			}else{
//                _alipayAction = isAliPayFail;
//            }
//        }else{
//            //交易失败
//            _alipayAction = isAliPayFail;
//        }
//    }else{
//        //失败
//        _alipayAction = isAliPayFail;
//    }
//}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    DLog(@"%d", buttonIndex);
    if (buttonIndex == 1) {
        NetWorkPurchaseViewController *vc = [[NetWorkPurchaseViewController alloc] initWithNibName:@"NetWorkPurchaseViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self resetButtonState];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self resetButtonState];
    }
}

- (void)resetButtonState{
    int tag = (int)(_myScrollView.contentOffset.x / CGRectGetWidth(_myScrollView.frame));
    
    UIImage *hover = [UIImage imageNamed:@"vip_dot_hover.png"];
    UIImage *normal = [UIImage imageNamed:@"vip_dot_normal.png"];
    
    switch (tag) {
        case 0:{
            [_first_dot setImage:hover];
            [_second_dot setImage:normal];
            [_third_dot setImage:normal];

        }
            break;
        case 1:{
            [_first_dot setImage:normal];
            [_second_dot setImage:hover];
            [_third_dot setImage:normal];
        }
            break;
        case 2:{
            [_first_dot setImage:normal];
            [_second_dot setImage:normal];
            [_third_dot setImage:hover];
            
        }
            break;
            
        default:
            break;
    }


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"appScheme" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
