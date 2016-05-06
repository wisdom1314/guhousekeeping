//
//  ViPViewController.m
//  GuHouseKeeping
//
//  Created by luyun on 14-7-13.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import "ViPViewController.h"
#import "ViPDetailViewController.h"
#import "ViPTableViewCell.h"
#import "NetWorkPurchaseViewController.h"


#import "Order.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@interface ViPViewController ()
@property (nonatomic, assign) AliPayAction alipayAction;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation ViPViewController
@synthesize alipayAction = _alipayAction;
@synthesize dataArr = _dataArr;

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
    

    _dataArr = @[
                 @"vipCard_gold.png",
                 @"vipCard_platinum.png",
                 @"vipCard_diamond.png"
                 ];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 21)];
    [header setBackgroundColor:[UIColor clearColor]];
    [_myTableView setTableHeaderView:header];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appScheme:) name:@"appScheme" object:nil];

    
    if (_alipayAction == isAliPaySuccess) {
        [HDM popHlintMsg:@"交易成功!"];
    }else if (_alipayAction == isAliPayFail){
        [HDM popHlintMsg:@"交易失败!"];
    }
    _alipayAction = isAliPayDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 168;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%d%d",indexPath.section,indexPath.row];//@"Cell";
    
    ViPTableViewCell *cell = (ViPTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"ViPTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.vipCardPurchaseButton addTarget:self action:@selector(buyNowBtn: event:) forControlEvents:UIControlEventTouchUpInside];
        [cell bringSubviewToFront:cell.vipCardPurchaseButton];
    }
    
    [cell.vipCardImageView setImage:[UIImage imageNamed:_dataArr[indexPath.row]]];
    return cell;
}

- (void)buyNowBtn:(id)sender event:(id)event{
    NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:_myTableView];
    NSIndexPath *indexPath =[_myTableView indexPathForRowAtPoint:currentTouchPosition];
    DLog(@"%@", indexPath);
    
    [HHM postOrderServiceToPayMentUserInfo:@{@"userId": HDM.memberId,
                                             @"card": (indexPath.row == 0 ? @"GOLD" : (indexPath.row == 1 ? @"WHITE_GOLD" : @"DIAMOND"))} success:^(PaymentModel *info) {
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

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    DLog(@"%d", buttonIndex);
//    if (buttonIndex == 1) {
//        NetWorkPurchaseViewController *vc = [[NetWorkPurchaseViewController alloc] initWithNibName:@"NetWorkPurchaseViewController" bundle:nil];
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ViPDetailViewController *vc = [[ViPDetailViewController alloc] initWithNibName:@"ViPDetailViewController" bundle:nil];
    vc.indexRow = indexPath.row;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"appScheme" object:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)backBtn:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"appScheme" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
