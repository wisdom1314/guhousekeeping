//
//  HomeViewController.m
//  GuHouseKeeping
//
//  Created by David on 7/10/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "HomeViewController.h"
#import "MineInfoViewController.h"
#import "MineOrderListViewController.h"
#import "CouponsViewController.h"
#import "SearchViewController.h"
#import "MoreViewController.h"
#import "ViPViewController.h"
#import "LoginViewController.h"
#import "TimeWorkerViewController.h"
#import "TimeAuntServiceView.h"
#import "NewHomeViewController.h"
#import "SearchAuntView.h"
#import "AuntDetailViewController.h"
#import "UIImageView+AFNetworking.h"

typedef enum {
    isMemberCenter = 0,         //个人中心
    isMineOrderList,            //我的订单
    isHourWorker,               //小时工
    isNewHome,
    isMineAunt,                 //找阿姨
    isUserResearch,              //用户调查
    isVip
}LoginAction;


@interface HomeViewController ()
@property (strong, nonatomic) CycleScrollView *cycleView;
@property (strong, nonatomic) NSArray *imageArr;
@property (strong, nonatomic) CycleScrollView *sysInfoView;
@property (strong, nonatomic) NSArray *sysInfoArr;
@property (strong, nonatomic) UIView *sysInfoShadow;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL didLoginAction;
@property (nonatomic, assign) LoginAction loginAction;
@property (nonatomic, strong) UIView *alterView;
@property (nonatomic, strong) TimeAuntServiceView *timeAuntServiceView;
@property (nonatomic, strong) SearchAuntView *searchAuntView;
@property (nonatomic, strong) UILabel *moreFunction;
@property (nonatomic, strong) UIImageView *ideaImageView;
@property (nonatomic, strong) NSString *pushAuntInfo;

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation HomeViewController
@synthesize didLoginAction = _didLoginAction;
@synthesize loginAction = _loginAction;
@synthesize alterView = _alterView;
@synthesize timeAuntServiceView = _timeAuntServiceView;
@synthesize searchAuntView = _searchAuntView;
@synthesize moreFunction = _moreFunction;
@synthesize ideaImageView = _ideaImageView;
@synthesize pushAuntInfo = _pushAuntInfo;

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

//    [super viewDidLoad];
//    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    
//    NSLog(@"path=====%@",path);
    //#define HHM ((GuHouseHTTPManager *)[GuHouseHTTPManager sharedInstance])
    [HHM postSystemServiceFindSystemManageSuccess:^(SystemManagerModel *info) {
        NSLog(@"%@",info);
        if (info) {
//            [_topLogo setImageWithURL:[NSURL URLWithString:info.appLogo]];
//            NSMutableString *mainPageTip = [[NSMutableString alloc] initWithString:info.mainPageTip];
//            [mainPageTip replaceOccurrencesOfString:@"$#" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mainPageTip length])];
//            CGSize size = [HDM getContentFromString:mainPageTip WithFont:[UIFont systemFontOfSize:15.0] ToSize:CGSizeMake(80, MAXFLOAT)];
//            [_systemLabel setText:mainPageTip];
//
//            [_systemLabel setFrame:CGRectMake(_systemLabel.frame.origin.x, _systemLabel.frame.origin.y, size.width, size.height)];
//            [_sysScrollView setContentSize:CGSizeMake(CGRectGetWidth(_sysScrollView.frame), size.height)];
            
            _sysInfoArr = [info.mainPageTip componentsSeparatedByString:@"$#"];
                //#define HHM ((GuHouseHTTPManager *)[GuHouseHTTPManager sharedInstance])
            [HDM  setSearchKeys:[info.searchKey componentsSeparatedByString:@"|"]];

            NSLog(@"_sysInfoArr===%@",_sysInfoArr);
            
              if (_sysInfoArr  && [_sysInfoArr count]) {
                if (IS_IOS7) {
                    _sysInfoView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 00, _topView.bounds.size.width, 20)];
                }else{
                    _sysInfoView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 00, _topView.bounds.size.width, 20)];
                }
                [_sysInfoView setBackgroundColor:[UIColor clearColor]];
                DLog(@"%@", _sysInfoView);
//                [_sysInfoView.pageControl setHidden:YES];
                [_sysInfoView setDelegate:(id<CycleScrollViewDelegate>)self];
                [_sysInfoView setDatasource:(id<CycleScrollViewDataSource>)self];
                [_topView addSubview:_sysInfoView];
                [_topView sendSubviewToBack:_sysInfoView];
                
                if (IS_IOS7) {
                    _sysInfoShadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];//修改
                }else{
                    _sysInfoShadow = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 0)];//修改
                }
                [_sysInfoShadow setAlpha:0.3];
                [_sysInfoShadow setBackgroundColor:[UIColor blackColor]];
                [_topView addSubview:_sysInfoShadow];
                [_topView sendSubviewToBack:_sysInfoShadow];


            }
            
            
            //图片问题的位置
            if ([info.images count]) {
                DLog(@"%@", info.images);
                _imageArr = [NSArray arrayWithArray:info.images];
                if (IS_IOS7) {
                    //_cycleView = [[CycleScrollView alloc] initWithFrame:_topView.bounds];
                    _cycleView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 22, _topView.bounds.size.width, _topView.bounds.size.height)];
                }else{
                    _cycleView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 20+22, _topView.bounds.size.width, _topView.bounds.size.height-20)];
                }
                [_cycleView setBackgroundColor:[UIColor clearColor]];
                DLog(@"%@", _cycleView);
                [_cycleView setDelegate:(id<CycleScrollViewDelegate>)self];
                [_cycleView setDatasource:(id<CycleScrollViewDataSource>)self];
                
//                if (!IS_IPHONE5) {
//                    [_cycleView.pageControl setCenter:CGPointMake(_cycleView.pageControl.center.x, _cycleView.pageControl.center.y + 9)];
//                }else{
//                    [_cycleView.pageControl setCenter:CGPointMake(_cycleView.pageControl.center.x, _cycleView.pageControl.center.y + 9)];
//                }
                [_topView addSubview:_cycleView];
                [_topView sendSubviewToBack:_cycleView];
                
                _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_topView.frame) - 30, CGRectGetWidth(_topView.frame), 22)];
             
             //   NSLog(@"_topView  ==%f hight=%f",_topView.bounds.size.width,_topView.bounds.size.height);
                _pageControl.userInteractionEnabled = NO;
                [_pageControl setNumberOfPages:[info.images count]];
                [_pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
                [_pageControl setCurrentPageIndicatorTintColor:PURPLECOLOR];
                [_pageControl setCurrentPage:0];
                
                [_topView addSubview:_pageControl];

            }
            
        }
//        [_topView sendSubviewToBack:_topBottomView];

    } failure:^(NSError *error) {
        [HDM errorPopMsg:error];
    }];
    
    // Do any additional setup after loading the view from its nib.

//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfViewTap:)];
//    tap.numberOfTapsRequired = 1;
//    [tap setDelegate:(id<UIGestureRecognizerDelegate>)self];
//    tap.numberOfTouchesRequired = 1;
//    [_topView addGestureRecognizer:tap];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.f
                                                  target:self
                                                selector:@selector(cycleStartMove)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ( _timer && [_timer isValid]) {
        [_timer  invalidate];
        _timer = nil;
    }
}

- (void)cycleStartMove{
    if (_imageArr && [_imageArr count]) {
        [_cycleView.scrollView setContentOffset:CGPointMake(_cycleView.scrollView.contentOffset.x + CGRectGetWidth(_cycleView.frame), _cycleView.scrollView.contentOffset.y) animated:YES];
    }
    if (_sysInfoArr && [_sysInfoArr count]) {
        [_sysInfoView.scrollView setContentOffset:CGPointMake(_sysInfoView.scrollView.contentOffset.x + CGRectGetWidth(_sysInfoView.frame), _sysInfoView.scrollView.contentOffset.y) animated:YES];
    }
}
- (void)CycleScrollViewCurrent:(int)current{
    [_pageControl setCurrentPage:current];
}

- (void)cycleScrollViewAction{
    
}

- (void)willBeginDraggingWithView:(CycleScrollView *)cycleScrollView{
    
}

- (void)didEndDeceleratingWithView:(CycleScrollView *)cycleScrollView{

}

- (void)didClickPage:(CycleScrollView *)cycleScrollView atIndex:(NSInteger)index{
    NSLog(@"didClickPage:%ld", (long)index);
}

- (NSInteger)numberOfPagesWithView:(CycleScrollView *)cycleScrollView{
    if (cycleScrollView == _cycleView) {
        return [_imageArr count];
    }else{
        return [_sysInfoArr count];
    }
}

- (UIView *)pageAtIndex:(NSInteger)index WithView:(CycleScrollView *)cycleScrollView{
    if (cycleScrollView == _cycleView) {
        
        UIView *tmp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_cycleView.frame), CGRectGetHeight(_cycleView.frame))];
        
        [tmp setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_cycleView.frame), CGRectGetHeight(_cycleView.frame))];
       // UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320,135)];//修改
        
        __weak UIImageView *imagexx = imageView;
        
        [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_imageArr[index]]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            if (image) {
                if (image.size.width / image.size.height == CGRectGetWidth(_cycleView.frame) / CGRectGetHeight(_cycleView.frame)) {
                    
                }else if (image.size.width / image.size.height >= CGRectGetWidth(_cycleView.frame) / CGRectGetHeight(_cycleView.frame)){
                    [imagexx setFrame:CGRectMake(0, (CGRectGetHeight(_cycleView.frame) - CGRectGetWidth(_cycleView.frame) * image.size.height / image.size.width) / 2.0, CGRectGetWidth(_cycleView.frame), CGRectGetWidth(_cycleView.frame) * image.size.height / image.size.width)];
                }else{
                    [imagexx setFrame:CGRectMake((CGRectGetWidth(_cycleView.frame) - CGRectGetHeight(_cycleView.frame) * image.size.width / image.size.height) / 2.0, 0, CGRectGetHeight(_cycleView.frame) * image.size.width / image.size.height, CGRectGetHeight(_cycleView.frame))];
                    
                }
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
        [tmp addSubview:imageView];
        
        return tmp;
    }else{
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:_sysInfoArr[index]];
        return label;
    }
}


- (void)viewDidAppear:(BOOL)animated{
    if (animated) {
        DLog(@"HomeViewController animated");
        if (_didLoginAction) {
            _didLoginAction = NO;
            [self customButtonAction];
        }
    }else{
        DLog(@"HomeViewController");
    }
    if ([HDM memberId]) {
        [HHM postOrderServiceFindOrderCountsByMemberIdAndType:@{@"memberId": HDM.memberId,
                                                                @"orderType": @"NOT_PAY"} success:^(NSString *info) {
                                                                    if (info) {
                                                                        DLog(@"%@", info);
                                                                        int bubble = [info integerValue];
                                                                        if (bubble >= 99) {
                                                                            bubble = 99;
                                                                        }
                                                                        if (bubble == 0) {
                                                                            [_bubbleImageView setHidden:YES];
                                                                            [_bubbleLabel setHidden:YES];
                                                                        }else{
                                                                            
                                                                            [_bubbleImageView setHidden:NO];
                                                                            [_bubbleLabel setFrame:CGRectMake(111.5, 1, 14, 14)];
                                                                            [_bubbleLabel setHidden:NO];
                                                                            [_bubbleLabel setText:[NSString stringWithFormat:@"%d", bubble]];
                                                                        }
                                                                    }
                                                                } failure:^(NSError *error) {
                                                                    
                                                                }];
        
        _pushAuntInfo = nil;
        
        [HHM postUserServiceFindMemberByMemberId:@{@"memberId": HDM.memberId} success:^(MemberInfoModel *infoModel) {
            if (infoModel) {
                [HDM setInfoModel:infoModel];
                DLog(@"%@", infoModel);
                if ([infoModel.pushAuntInfo length]) {
                    _pushAuntInfo = infoModel.pushAuntInfo;
                }
                
            }
        } failure:^(NSError *error) {
            [HDM errorPopMsg:error];
        }];
    }else{
        [HDM setBubbleNum:0];
        [_bubbleImageView setHidden:YES];
        [_bubbleLabel setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)categoryButtonClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch ([btn tag]) {
        case 10:{
            DLog(@"小时工");
//            _loginAction = isHourWorker;
//            [self customButtonAction];

            TimeWorkerViewController *worker = [[TimeWorkerViewController alloc] initWithNibName:@"TimeWorkerViewController" bundle:nil];
            [worker setAuntInfoDic:[NSMutableDictionary dictionary]];
            [self.navigationController pushViewController:worker animated:YES];

        }
            break;
        case 11:{
            DLog(@"新局开荒");
//            _loginAction = isNewHome;
//            [self customButtonAction];
            NewHomeViewController *newHome = [[NewHomeViewController alloc] initWithNibName:@"NewHomeViewController" bundle:nil];
            newHome.isNewHome = YES;
            [self.navigationController pushViewController:newHome animated:YES];
        }
            break;
        case 12:{
            DLog(@"常用阿姨");
            _loginAction = isMineAunt;
            [self customButtonAction];
        }
            break;
        case 13:{
            DLog(@"用户调查");
            _loginAction = isUserResearch;
            [self customButtonAction];
        }
            break;
        case 14:{
            DLog(@"服务理念");
            [self createAlphaView];

            _ideaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (IS_IOS7 ? 0 : -20), 320, 1136/2.0)];
//            [_ideaImageView setContentMode:UIViewContentModeScaleAspectFill];
            [_ideaImageView setImage:[UIImage imageNamed:@"service-concept.png"]];
            
            [_alterView addSubview:_ideaImageView];
            
        }
            break;
        case 15:{
            DLog(@"更多期待");
//            [HDM popHlintMsg:@"更多功能，正在努力升级中，敬请期待待"];
//            [self createAlphaView];
//            if (!_moreFunction) {
//                _moreFunction = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 392 / 2.0 + 40, 270 /2.0)];
//                [_moreFunction setBackgroundColor:[UIColor whiteColor]];
//                [_moreFunction setTextColor:PURPLECOLOR];
//                [_moreFunction setNumberOfLines:2];
//                [_moreFunction setTextAlignment:NSTextAlignmentCenter];
//                [_moreFunction setCenter:CGPointMake(CGRectGetWidth(_alterView.frame) / 2.0, CGRectGetHeight(_alterView.frame) / 2.0)];
//                [_moreFunction setText:@"月嫂、长期钟点工，家居保养等服务马上推出，敬请期待 "];
//                _moreFunction.layer.cornerRadius=15;
//                _moreFunction.layer.masksToBounds = YES;
//                [_alterView addSubview:_moreFunction];
//            }
            
            
            _loginAction = isVip;
            [self customButtonAction];
            
            
            
            
            
        }
            break;
        default:
            break;
    }
}
- (void)createAlphaView{
    _alterView = [[UIView alloc] initWithFrame:self.view.bounds];
    [_alterView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_alterView];
    
    UIView * alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    [alphaView setBackgroundColor:[UIColor blackColor]];
    [alphaView setAlpha:0.3];
    [_alterView addSubview:alphaView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    [tap setDelegate:(id<UIGestureRecognizerDelegate>)self];
    tap.numberOfTouchesRequired = 1;
    [_alterView setTag:100000];
    [_alterView addGestureRecognizer:tap];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSLog(@"%@====%d",[[touch view] class], [[touch view] tag]);
    if ([[touch view] isKindOfClass:[UIButton class]]){
        return NO;
    }
//    if ([touch view] != _alterView) {
//        return NO;
//    }
//    DLog(@"%@=====%d", [gestureRecognizer view], [[gestureRecognizer view] tag]);
//    
//    if ([gestureRecognizer view] != _alterView) {
//        return NO;
//    }
    return YES;
}

- (void)tap:(UITapGestureRecognizer *)recognizer{
    if (_timeAuntServiceView) {
        [_timeAuntServiceView removeFromSuperview];
        _timeAuntServiceView = nil;
    }
    
    
    if (_ideaImageView) {
        [_ideaImageView removeFromSuperview];
        _ideaImageView = nil;
    }
    if (_searchAuntView) {
        [_searchAuntView removeFromSuperview];
        _searchAuntView = nil;
    }
    
    if (_moreFunction) {
        [_moreFunction removeFromSuperview];
        _moreFunction = nil;
    }
    if (_alterView) {
        [_alterView removeFromSuperview];
        _alterView = nil;
    }
}


//- (void)selfViewTap:(UITapGestureRecognizer *)recognizer{
//    if (_searchAuntView) {
//        [_searchAuntView setHidden:YES];
//    }
//}

- (void)createTimeAuntService{
    if (!_timeAuntServiceView) {
        _timeAuntServiceView = (TimeAuntServiceView *)[[[NSBundle mainBundle] loadNibNamed:@"TimeAuntServiceView" owner:self options:nil] objectAtIndex:0];
        [_timeAuntServiceView setBackgroundColor:[UIColor clearColor]];
        
        [_timeAuntServiceView setFrame:CGRectMake((CGRectGetWidth(_alterView.frame) - CGRectGetWidth(_timeAuntServiceView.frame)) / 2.0, 168, CGRectGetWidth(_timeAuntServiceView.frame), CGRectGetHeight(_timeAuntServiceView.frame))];
        if (!IS_IPHONE5) {
            [_timeAuntServiceView setCenter:CGPointMake(_timeAuntServiceView.center.x, _timeAuntServiceView.center.y - 40)];
        }
        [_timeAuntServiceView.selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_alterView addSubview:_timeAuntServiceView];
        if (_pushAuntInfo ) {
            if ([_pushAuntInfo integerValue]) {
                [_timeAuntServiceView.selectLabel setText:[NSString stringWithFormat:@"%@天", _pushAuntInfo]];
            }else{
                [_timeAuntServiceView.selectLabel setText:@"其他"];

            }
        }
    }
}

- (void)selectButtonClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (btn == _timeAuntServiceView.selectButton) {
        if ([btn isSelected]) {
            [btn setSelected:NO];
            if (_timeAuntServiceView.dropView) {
                [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [_timeAuntServiceView.containView setFrame:CGRectMake(0, 0, 244, 120)];
                    [_timeAuntServiceView.dropView setFrame:CGRectMake(54, 88, 136, 0)];
                    
                } completion:^(BOOL finished) {
                    
                }];
            }
        }else{
            [btn setSelected:YES];
            if (!_timeAuntServiceView.dropView) {
                _timeAuntServiceView.dropView = [[UIView alloc] initWithFrame:CGRectMake(54, 88, 136, 0)];
                [_timeAuntServiceView.dropView setBackgroundColor:PURPLECOLOR];
                [_timeAuntServiceView addSubview:_timeAuntServiceView.dropView];
                _timeAuntServiceView.dropView.clipsToBounds = YES;
                
                NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
                UIImage *hover = [UIImage imageNamed:@"aunt_servie_hover.png"];
                UIImage *normal = [UIImage imageNamed:@"aunt_servie_normal.png"];
                for (int i = 1; i < 9; i++) {
                    UIButton *tmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    if (i == 8) {
                        [tmpBtn setTitle:@"其他" forState:UIControlStateNormal];
                    }else{
                        [tmpBtn setTitle:[NSString stringWithFormat:@"%d天",i] forState:UIControlStateNormal];
                    }
                    [tmpBtn setFrame:CGRectMake(0, (i - 1) * 32, 136, 32)];
                    [tmpBtn setBackgroundImage:hover forState:UIControlStateSelected];
                    [tmpBtn setBackgroundImage:hover forState:UIControlStateHighlighted];
                    [tmpBtn setBackgroundImage:normal forState:UIControlStateNormal];
                    [tmpBtn setTag:i];
                    [tmpBtn addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    [tmpArr addObject:tmpBtn];
                    [_timeAuntServiceView.dropView addSubview:tmpBtn];
                }
                _timeAuntServiceView.selectItems = [NSArray arrayWithArray:tmpArr];
            }
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [_timeAuntServiceView.containView setFrame:CGRectMake(0, 0, 244, 162)];
                [_timeAuntServiceView.dropView setFrame:CGRectMake(54, 88, 136, 32 * 8)];
            } completion:^(BOOL finished) {
                
            }];
        }
    }else{
        [_timeAuntServiceView.selectItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton *tmpBtn = (UIButton *)obj;
            [tmpBtn setSelected:NO];
        }];
        [_timeAuntServiceView.selectLabel setTextColor:PURPLECOLOR];
        if (btn.tag == 8) {
            [_timeAuntServiceView.selectLabel setText:@"其他"];
        }else{
            [_timeAuntServiceView.selectLabel setText:[NSString stringWithFormat:@"%d天",btn.tag]];
        }
        [btn setSelected:YES];
        
        [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_timeAuntServiceView.containView setFrame:CGRectMake(0, 0, 244, 120)];
            [_timeAuntServiceView.dropView setFrame:CGRectMake(54, 88, 136, 0)];
        } completion:^(BOOL finished) {
            [_timeAuntServiceView.selectButton setSelected:NO];
            
            DLog(@"%@", (btn.tag == 8 ? @"其他" : [NSString stringWithFormat:@"%d", btn.tag] ));
            [HHM postUserServiceModifyPushAuntInfo:@{@"memberId":HDM.memberId,
                                                     @"days":(btn.tag == 8 ?  @"0" : [NSString stringWithFormat:@"%d", btn.tag])} success:^(MemberInfoModel *info) {
                                                         
                                                         if (info) {
                                                             _pushAuntInfo = info.pushAuntInfo;
                                                         }
                                                         
                                                     } failure:^(NSError *error) {
                                                         [HDM errorPopMsg:error];
                                                     }];

            
            
        }];
    }
}

- (void)loginViewControllerDidSuccessLogin{
    _didLoginAction = YES;
}

- (void)customButtonAction{
    if ([HDM memberId]) {
        if (_loginAction == isMemberCenter) {
            MineInfoViewController *mine = [[MineInfoViewController alloc] initWithNibName:@"MineInfoViewController" bundle:nil];
            [self.navigationController pushViewController:mine animated:YES];
        }else if (_loginAction == isMineOrderList){
            MineOrderListViewController *orderList = [[MineOrderListViewController alloc] initWithNibName:@"MineOrderListViewController" bundle:nil];
            [self.navigationController pushViewController:orderList animated:YES];
        }else if (_loginAction == isMineAunt){
            [self createAlphaView];

            if (!_searchAuntView) {
                _searchAuntView = (SearchAuntView *)[[[NSBundle mainBundle] loadNibNamed:@"SearchAuntView" owner:self options:nil] objectAtIndex:0];
                [_searchAuntView setDelegate:(id<SearchAuntViewDelegate>)self];
                [_searchAuntView initCollectionView];
                
                [_searchAuntView setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - CGRectGetHeight(_searchAuntView.frame) - 49, CGRectGetWidth(_searchAuntView.frame), CGRectGetHeight(_searchAuntView.frame))];
                [self.view addSubview:_searchAuntView];
            }
            
        }else if (_loginAction == isHourWorker){
            TimeWorkerViewController *worker = [[TimeWorkerViewController alloc] initWithNibName:@"TimeWorkerViewController" bundle:nil];
//            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"latitude": @"",
//                                                                                       @"longitude": @""}];
            [worker setAuntInfoDic:[NSMutableDictionary dictionary]];
            [self.navigationController pushViewController:worker animated:YES];
        }else if (_loginAction == isUserResearch){
            [self createAlphaView];
            [self createTimeAuntService];
        }else if (_loginAction == isNewHome){
            NewHomeViewController *newHome = [[NewHomeViewController alloc] initWithNibName:@"NewHomeViewController" bundle:nil];
            newHome.isNewHome = YES;
            [self.navigationController pushViewController:newHome animated:YES];
        }else if (_loginAction == isVip){
            ViPViewController *vipVC = [[ViPViewController alloc] initWithNibName:@"ViPViewController" bundle:nil];
            [self.navigationController pushViewController:vipVC animated:YES];
        }
    }else{
        LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [login setDelegate:(id<LoginViewControllerDelegate>)self];
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (void)SearchAuntViewSelectAunt:(AuntInfoModel *)info{
    if (info) {
        AuntDetailViewController *aunt = [[AuntDetailViewController alloc] initWithNibName:@"AuntDetailViewController" bundle:nil];
        [aunt setAuntID:info.auntId];
        [self.navigationController pushViewController:aunt animated:YES];

    }else{
        TimeWorkerViewController *worker = [[TimeWorkerViewController alloc] initWithNibName:@"TimeWorkerViewController" bundle:nil];
//            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"latitude": @"",
//                                                                                       @"longitude": @""}];
        [worker setAuntInfoDic:[NSMutableDictionary dictionary]];
        [self.navigationController pushViewController:worker animated:YES];
        [self tap:nil];

    }
}


- (IBAction)buttonClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    [UIView animateWithDuration:0.2 animations:^{
        [_bottomHoverImageView setCenter:CGPointMake(btn.center.x, _bottomHoverImageView.center.y)];
        
    } completion:^(BOOL finished) {
        switch ([btn tag]) {
            case 0:{
                DLog(@"个人中心");
                _loginAction = isMemberCenter;
                [self customButtonAction];
            }
                break;
            case 1:{
                DLog(@"我的订单");
                _loginAction = isMineOrderList;
                [self customButtonAction];
            }
                break;
            case 2:{
                DLog(@"优惠券");
                CouponsViewController *coupons = [[CouponsViewController alloc] initWithNibName:@"CouponsViewController" bundle:nil];
                [self.navigationController pushViewController:coupons animated:YES];
            }
                break;
            case 3:{
                DLog(@"搜索");
                SearchViewController *search = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
                [self.navigationController pushViewController:search animated:YES];
            }
                break;
            case 4:{
                DLog(@"更多");
                MoreViewController *more = [[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil];
                [self.navigationController pushViewController:more animated:YES];
            }
                break;
                
            default:
                break;
        }
    }];
}




@end
