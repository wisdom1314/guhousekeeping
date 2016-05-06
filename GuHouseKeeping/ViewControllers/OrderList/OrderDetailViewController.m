//
//  OrderDetailViewController.m
//  GuHouseKeeping
//
//  Created by David on 7/28/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailTableViewCell.h"
#import "OrderDetailFootView.h"
#import "OrderDetailAlertView.h"
#import "NetWorkPurchaseViewController.h"

#import "Order.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@interface OrderDetailViewController ()
@property (nonatomic, assign) AliPayAction alipayAction;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) OrderDetailFootView *footView;
@property (nonatomic, strong) UIView *alterView;
@property (nonatomic, strong) OrderDetailAlertView *chooseAlterView;
@property (nonatomic, strong) UserOrderModel *info;
//@property (nonatomic, strong)UILabel *remindLabel;
@end

@implementation OrderDetailViewController
@synthesize alipayAction = _alipayAction;
@synthesize dataArr = _dataArr;
@synthesize footView = _footView;
@synthesize alterView = _alterView;
@synthesize chooseAlterView = _chooseAlterView;
@synthesize orderId = _orderId;
@synthesize info = _info;
//@synthesize remindLabel=_remindLabel;

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
    _alipayAction = isAliPayDefault;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appScheme:) name:@"appScheme" object:nil];
    
    [HHM postUserServiceFindMemberByMemberId:@{@"memberId": HDM.memberId} success:^(MemberInfoModel *infoModel) {
        if (infoModel) {
            DLog(@"%@", infoModel);
            [HDM setInfoModel:infoModel];
            
            if (_footView) {
                if ([HDM.infoModel.couponUseCounts integerValue] < 1) {
                    [_footView.useButton setUserInteractionEnabled:NO];
                }
            }
        }
    } failure:^(NSError *error) {
        [HDM errorPopMsg:error];
    }];
    [self checkOrder];
}

- (void)checkOrder{
    [HHM postOrderServiceFindOrderById:@{@"orderId":_orderId} success:^(UserOrderModel *info) {
        DLog(@"info:%@", info);
        _dataArr = @[
                     @{
                         @"image": [UIImage imageNamed:@"order_serial.png"],
                         @"title": [NSString stringWithFormat:@"订单号：%@", info.orderNo]
                         },
                     @{
                         @"image": [UIImage imageNamed:@"order_time.png"],
                         @"title": [NSString stringWithFormat:@"服务时间：%@", info.optTime]
                         
                         },
                     @{
                         @"image": ([info.orderUse isEqualToString:@"HOURLY_WORKER"] ? [UIImage imageNamed:@"order_duration.png"] : [UIImage imageNamed:@"order_room.png"]),
                         @"title": ([info.orderUse isEqualToString:@"HOURLY_WORKER"] ? [NSString stringWithFormat:@"服务时长：%@小时", info.workLength] : [NSString stringWithFormat:@"房屋面积：%@m²", info.floorSpace])
                         },
                     @{
                         @"image": [UIImage imageNamed:@"order_address.png"],
                         @"title": [NSString stringWithFormat:@"地址：%@", info.address]
                         },
                     @{
                         @"image": [UIImage imageNamed:@"order_mark.png"],
                         @"title": [NSString stringWithFormat:@"备注：%@", info.specialNeed]
                         },
                     @{
                         @"image": [UIImage imageNamed:@"order_price.png"],
                         @"title": ([info.orderUse isEqualToString:@"HOURLY_WORKER"] ? [NSString stringWithFormat:@"单价：¥%@/小时", info.unitPrice] : [NSString stringWithFormat:@"单价：¥%@/m²", info.unitPrice])
                         },
                     ];
        DLog(@"%@", _dataArr);
        _footView =  (OrderDetailFootView *)[[[NSBundle mainBundle] loadNibNamed:@"OrderDetailFootView" owner:self options:nil] objectAtIndex:0];
        
        if ([info.useCouponCount integerValue]) {
            [_footView.useButton setSelected:YES];
        }
        [_footView.priceLabel setText:[NSString stringWithFormat:@"¥%@", info.totalPrice]];
        
        if ([info.orderStatus isEqualToString:@"ONLINE_PAYED"]) {
            [_footView.useButton setHidden:YES];
            [_footView.useLabel setHidden:YES];
            [_footView.pausePurchaseButton setHidden:YES];
            [_footView.networkPurchaseButton setHidden:YES];
        }else{
//            [_footView.useButton addTarget:self action:@selector(footViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_footView.pausePurchaseButton addTarget:self action:@selector(footViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_footView.networkPurchaseButton addTarget:self action:@selector(footViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
//            if ([HDM.infoModel.couponCounts integerValue] < 1  && ![_footView.useButton isSelected]) {
//                [_footView.useButton setUserInteractionEnabled:NO];
//            } else {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setTag:0];
                
                [button setFrame:CGRectMake(92, 36, 101, 51)];
                [button setBackgroundColor:[UIColor clearColor]];
                [button addTarget:self action:@selector(footViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];

                [_footView addSubview:button];
//            }
        }
        [_myTableView setTableFooterView:_footView];
        [_myTableView reloadData];
    } failure:^(NSError *error) {
        [HDM errorPopMsg:error];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_alipayAction == isAliPaySuccess) {
        [HDM popHlintMsg:@"交易成功!"];
        if (_delegate && [_delegate respondsToSelector:@selector(OrderDetailViewControllerUpdateRefresh)]) {
            [_delegate OrderDetailViewControllerUpdateRefresh];
        }
        [self checkOrder];
    }else if (_alipayAction == isAliPayFail){
        [HDM popHlintMsg:@"交易失败!"];
    }
    _alipayAction = isAliPayDefault;
}



- (void)footViewButtonClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    switch ([btn tag]) {
        case 0:{
            
            if (![_footView.useButton isSelected] && [HDM.infoModel.couponCounts integerValue] <= 0) {
                return;
            }
            [_footView.useButton setSelected:![_footView.useButton isSelected]];
            [HHM postOrderServicePayment:@{@"orderId":_orderId,
                                           @"useCouponCount": ([_footView.useButton isSelected] ? @"1" : @"0")} success:^(PaymentModel *info) {
                                               if (info) {
                                                   [_footView.priceLabel setText:[NSString stringWithFormat:@"¥%@", info.total_fee]];
                                               }
                                               [HHM postUserServiceFindMemberByMemberId:@{@"memberId": HDM.memberId} success:^(MemberInfoModel *infoModel) {
                                                   if (infoModel) {
                                                       DLog(@"%@", infoModel);
                                                       [HDM setInfoModel:infoModel];
                                                   }
                                               } failure:^(NSError *error) {
                                                   [HDM errorPopMsg:error];
                                               }];
                                           } failure:^(NSError *error) {
                                               [HDM errorPopMsg:error];
                                           }];

        }
            break;
        case 1:{
            DLog(@"暂不支付");
            [self createAlphaView];
            
                
//        
//            _remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 200, 250, 150)];
//            _remindLabel.text=@"订单已经生成,可在我的订单中查询";
//            _remindLabel.textAlignment=NSTextAlignmentCenter;
//            [_remindLabel setNumberOfLines:2];
//            _remindLabel.layer.cornerRadius=15;
//            _remindLabel.layer.masksToBounds = YES;
//            _remindLabel.backgroundColor = [UIColor whiteColor];
//            //_remindLabel.alpha = 0.6;
//            _remindLabel.font = [UIFont systemFontOfSize:15];
//            _remindLabel.textColor = PURPLECOLOR;
//        
//            [_alterView addSubview:_remindLabel];
            
            //[self.navigationController popViewControllerAnimated:YES];
          
            
        }
            break;
        case 2:{
            DLog(@"网上支付");
//            NetWorkPurchaseViewController *vc = [[NetWorkPurchaseViewController alloc] initWithNibName:@"NetWorkPurchaseViewController" bundle:nil];
//            [self.navigationController pushViewController:vc animated:YES];
            /*
             *生成订单信息及签名
             *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
             */
            [HHM postOrderServicePayment:@{@"orderId":_orderId,
                                           @"useCouponCount": ([_footView.useButton isSelected] ? @"1" : @"0")} success:^(PaymentModel *info) {
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
                }
                    
                else{
                    [HDM popHlintMsg:HTTPDataAnalysisError];
                }
            } failure:^(NSError *error) {
                [HDM errorPopMsg:error];
            }];
        }
            break;
        default:
            break;
    }
}






//- (void)createAlphaView1{
//    _alterView = [[UIView alloc] initWithFrame:self.view.bounds];
//    [_alterView setBackgroundColor:[UIColor clearColor]];
//    [self.view addSubview:_alterView];
//    
//    UIView * alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
//    [alphaView setBackgroundColor:[UIColor blackColor]];
//    [alphaView setAlpha:0.3];
//    [_alterView addSubview:alphaView];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
//    tap.numberOfTapsRequired = 1;
//    [tap setDelegate:(id<UIGestureRecognizerDelegate>)self];
//    tap.numberOfTouchesRequired = 1;
//    [_alterView setTag:100000];
//    [_alterView addGestureRecognizer:tap];
//}



-(NSString*)getOrderInfo{
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
    Order *order = [[Order alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
	order.productName = @"居优家政话费充值"; //商品标题
	order.productDescription = @"居优家政[四钻信誉]北京移动30元 电脑全自动充值 1到10分钟内到账"; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
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
        if (_delegate && [_delegate respondsToSelector:@selector(OrderDetailViewControllerUpdateRefresh)]) {
            [_delegate OrderDetailViewControllerUpdateRefresh];
        }
        [self checkOrder];
    }else if (_alipayAction == isAliPayFail){
        [HDM popHlintMsg:@"交易失败!"];
    }
    _alipayAction = isAliPayDefault;
}

- (void)createAlphaView{
    if (_alterView) {
        return;
    }
    if (IS_IOS7) {
        _alterView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)];
    }else{
        _alterView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 44)];
    }
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
    
    _chooseAlterView  =  (OrderDetailAlertView *)[[[NSBundle mainBundle] loadNibNamed:@"OrderDetailAlertView" owner:self options:nil] objectAtIndex:0];

    [_chooseAlterView setBackgroundColor:PURPLECOLOR];
    _chooseAlterView.layer.cornerRadius=15;
    _chooseAlterView.layer.masksToBounds = YES;
    [_chooseAlterView.cancelButton addTarget:self action:@selector(alterViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    [_chooseAlterView.submitButton addTarget:self action:@selector(alterViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    [_alterView addSubview:_chooseAlterView];
    
    [_chooseAlterView setCenter:CGPointMake(CGRectGetWidth(_alterView.frame) / 2.0, CGRectGetHeight(_alterView.frame) / 2.0)];
}



- (void)alterViewButtonClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    switch ([btn tag]) {
        case 0:{
            [self.navigationController popViewControllerAnimated:YES];
            
        }
            break;
        case 1:{
            [_chooseAlterView removeFromSuperview];
            _chooseAlterView = nil;
            [self createAlterLabel:@"已保存至订单"];
        }
            break;
        default:
            break;
    }
}


- (void)createAlterLabel:(NSString *)alter{
    UILabel *alterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 392 / 2.0, 270 /2.0)];
    [alterLabel setBackgroundColor:GREENCOLO];
    alterLabel .layer.cornerRadius=15;
    alterLabel .layer.masksToBounds = YES;
    [alterLabel setTextColor:[UIColor whiteColor]];
    [alterLabel setTextAlignment:NSTextAlignmentCenter];
    [alterLabel setText:alter];
    [alterLabel setCenter:CGPointMake(CGRectGetWidth(_alterView.frame) / 2.0, CGRectGetHeight(_alterView.frame) / 2.0)];
    [_alterView addSubview:alterLabel];
    self.view.userInteractionEnabled = NO;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTag:0];
    [self performSelector:@selector(alterViewButtonClick:) withObject:btn afterDelay:0.3];
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSLog(@"%@",[[touch view] class]);
    if ([[touch view] isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}

- (void)tap:(UITapGestureRecognizer *)recognizer{
    [_alterView removeFromSuperview];
    _alterView = nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%d%d",indexPath.section,indexPath.row];//@"Cell";
    
    OrderDetailTableViewCell *cell = (OrderDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"OrderDetailTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
    }
    [cell.leftIcon setImage:_dataArr[indexPath.row][@"image"]];
    [cell.titleLabel setText:_dataArr[indexPath.row][@"title"]];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch ([btn tag]) {
        case 0:{
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"appScheme" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}
@end
