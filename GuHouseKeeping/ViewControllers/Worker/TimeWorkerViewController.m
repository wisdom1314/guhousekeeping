//
//  TimeWorkerViewController.m
//  GuHouseKeeping
//
//  Created by David on 7/24/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "TimeWorkerViewController.h"
#import "TimeWorkerTableViewCell.h"
#import "TimeWorkerDifferTableViewCell.h"
#import "AuntDetailViewController.h"
#import "StandardFeeViewController.h"
#import "AuntInfoModel.h"
#import <CoreLocation/CoreLocation.h>
#import "UIImageView+AFNetworking.h"

@interface TimeWorkerViewController ()
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *switchBackGroundView;
@property (nonatomic, strong) UIView *switchDotView;
@property (nonatomic, assign) BOOL isSwitchOn;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) BOOL hasNext;
@property (nonatomic, strong) UILabel *footLabel;
@property (nonatomic, strong) UIImageView *animateImageView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation TimeWorkerViewController
@synthesize dataArr = _dataArr;
@synthesize switchBackGroundView = _switchBackGroundView;
@synthesize switchDotView = _switchDotView;
@synthesize isSwitchOn = _isSwitchOn;
@synthesize page = _page;
@synthesize hasNext = _hasNext;
@synthesize footLabel = _footLabel;
@synthesize animateImageView = _animateImageView;
@synthesize locationManager = _locationManager;
@synthesize auntInfoDic = _auntInfoDic;

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
    // Do any additional setup after loading the view from its nib.

    _switchBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(241, 21/2.0, 32, 18)];
    [_switchBackGroundView setBackgroundColor:SWITCHENDBG];
    _switchBackGroundView.layer.cornerRadius = CGRectGetHeight(_switchBackGroundView.frame) / 2.0;
    _switchBackGroundView.layer.masksToBounds = YES;
    
    _switchDotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [_switchDotView setBackgroundColor:[UIColor whiteColor]];
    _switchDotView.layer.cornerRadius = CGRectGetHeight(_switchDotView.frame) / 2.0;
    _switchDotView.layer.masksToBounds = YES;
    [_switchBackGroundView addSubview:_switchDotView];
    
    [_subTitleView insertSubview:_switchBackGroundView belowSubview:_standardLabel];
    
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    [header setBackgroundColor:[UIColor clearColor]];
    UIImageView *pop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    [pop setImage:[UIImage imageNamed:@"worker_pop.png"]];
    [header addSubview:pop];
    header.clipsToBounds = YES;
    [_myTableView setTableHeaderView:header];
    
    _dataArr = [[NSMutableArray alloc] init];
    _page = 1;

    _footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [_footLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_footLabel setText:@""];
    [_footLabel setTextAlignment:NSTextAlignmentCenter];
    [_footLabel setBackgroundColor:[UIColor clearColor]];
    [_footLabel setTextColor:[UIColor blackColor]];
    [_myTableView setTableFooterView:_footLabel];
    
    [self setIsSwitchOn:YES];
    [self startLocation];
}

- (void)startLocation{
    if ([CLLocationManager locationServicesEnabled]) {
        DLog(@"[CLLocationManager locationServicesEnabled]");
        
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusNotDetermined:{
                DLog(@"kCLAuthorizationStatusNotDetermined");
            }
                break;
            case kCLAuthorizationStatusRestricted:{
                DLog(@"kCLAuthorizationStatusRestricted");
            }
                break;
            case kCLAuthorizationStatusDenied:{
                DLog(@"kCLAuthorizationStatusDenied");
                [HDM popHlintMsg:@"请在设置－隐私-定位服务\n 开启居忧家政"];
            }
                break;
            case kCLAuthorizationStatusAuthorized:{
                DLog(@"kCLAuthorizationStatusAuthorized");
            }
                break;
            default:
                break;
        }
        
       
        
        if (!_locationManager) {
            _locationManager = [[CLLocationManager alloc] init];
            [_locationManager setDelegate:(id<CLLocationManagerDelegate>)self];
            [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        }
        [_locationManager stopUpdatingLocation];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_locationManager startUpdatingLocation];
            if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [_locationManager requestAlwaysAuthorization];
            }
            
        });
    }else{
        [HDM popHlintMsg:@"该设备无法使用定位服务\n 请在设置－隐私中开启定位服务"];
        
        NSString *page = [NSString stringWithFormat:@"{\"pageNo\": %d, \"pageSize\":10}", _page];
        [HHM postSearchAuntByCondition:@{@"page" : page,
                                         @"auntInfo": [HDM jsonStringFromOjb:_auntInfoDic]} success:^(NSArray *info, BOOL hasNext) {
                                             if (info) {
                                                 _dataArr = [NSMutableArray arrayWithObject:info];
                                                 _page ++;
                                             }
                                             [self customData];
                                             _hasNext = hasNext;
                                             [_myTableView reloadData];
                                             [_myTableView setContentOffset:CGPointMake(0, 0) animated:YES];
                                         } failure:^(NSError *error) {
                                             [HDM errorPopMsg:error];
                                         }];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    if (![[_auntInfoDic allKeys] containsObject:@"latitude"] || ([[_auntInfoDic allKeys] containsObject:@"latitude"] && [[_auntInfoDic objectForKey:@"latitude"] isKindOfClass:[NSString class]])) {
        NSString *page = [NSString stringWithFormat:@"{\"pageNo\": %d, \"pageSize\":10}", _page];
       

        [_auntInfoDic setObject:[NSNumber numberWithFloat:newLocation.coordinate.latitude] forKey:@"latitude"];
         [_auntInfoDic setObject:[NSNumber numberWithFloat:newLocation.coordinate.longitude] forKey:@"longitude"];
        
        [HHM postSearchAuntByCondition:@{@"page" : page,
                                         @"auntInfo": [HDM jsonStringFromOjb:_auntInfoDic]} success:^(NSArray *info, BOOL hasNext) {
                                             if (info) {
                                                 _dataArr = [NSMutableArray arrayWithObject:info];
                                                 _page ++;
                                             }
                                             [self customData];
                                             _hasNext = hasNext;
                                             [_myTableView setContentOffset:CGPointMake(0, 0)];
                                             [_myTableView reloadData];
                                         } failure:^(NSError *error) {
                                             [HDM errorPopMsg:error];
                                         }];
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ( [error code] == kCLErrorDenied ) {

        
    } else if ([error code] == kCLErrorHeadingFailure) {
        
    }
    [manager stopUpdatingLocation];
    
    [self setIsSwitchOn:NO];
}


- (void)setIsSwitchOn:(BOOL)isSwitchOn{
    _isSwitchOn = isSwitchOn;
    _page = 1;
    [_footLabel setText:@""];

    if (_animateImageView) {
        [_animateImageView removeFromSuperview];
        _animateImageView = nil;
    }
    [_auntInfoDic removeObjectForKey:@"latitude"];
    [_auntInfoDic removeObjectForKey:@"longitude"];

    
    if (_isSwitchOn) {
    
        [_switchBackGroundView setBackgroundColor:SWITCHONBG];
        [UIView animateWithDuration:0.2 animations:^{
            [_switchDotView setCenter:CGPointMake(CGRectGetWidth(_switchBackGroundView.frame) - CGRectGetWidth(_switchDotView.frame) / 2.0, _switchDotView.center.y)];
        }];
        
        [self startLocation];
        
    }else{
        
        [_switchBackGroundView setBackgroundColor:SWITCHENDBG];
        [UIView animateWithDuration:0.2 animations:^{
            [_switchDotView setCenter:CGPointMake(CGRectGetWidth(_switchDotView.frame) / 2.0, _switchDotView.center.y)];
        }];
        NSString *page = [NSString stringWithFormat:@"{\"pageNo\": %d, \"pageSize\":10}", _page];
        [HHM postSearchAuntByCondition:@{@"page" : page,
                                         @"auntInfo": [HDM jsonStringFromOjb:_auntInfoDic]} success:^(NSArray *info, BOOL hasNext) {
                                             if (info) {
                                                 _dataArr = [NSMutableArray arrayWithObject:info];
                                                 _page ++;
                                             }
                                             [self customData];
                                             _hasNext = hasNext;
                                             [_myTableView setContentOffset:CGPointMake(0, 0)];
                                             [_myTableView reloadData];
                                         } failure:^(NSError *error) {
                                             [HDM errorPopMsg:error];
                                         }];
        
    }
}

- (void)customData{
    if (_isSwitchOn) {
        NSMutableArray *oneKilo = [[NSMutableArray alloc] init];
        NSMutableArray *fiveKilo = [[NSMutableArray alloc] init];
        NSMutableArray *tenKilo = [[NSMutableArray alloc] init];
        NSMutableArray *elevenKilo = [[NSMutableArray alloc] init];
        
        DLog(@"%@", _dataArr);
        [_dataArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSArray *arr  = (NSArray *)obj;
            [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[AuntInfoModel class]]) {
                    AuntInfoModel *model = (AuntInfoModel *)obj;
                    if ([model.distanceMeter floatValue] <= 1000) {
                        [oneKilo addObject:model];
                    }else if ([model.distanceMeter floatValue] > 1000 && [model.distanceMeter floatValue] <= 5000){
                        [fiveKilo addObject:model];
                    }else if ([model.distanceMeter floatValue] > 5000 && [model.distanceMeter floatValue] <= 10000){
                        [tenKilo addObject:model];
                    }else{
                        [elevenKilo addObject:model];
                    }
                }else{
                    DLog(@"%@", [[obj class] description]);
                }
            }];
        }];
        
        [_dataArr removeAllObjects];
        
        if ([oneKilo count]) {
            [oneKilo addObject:@"1km"];
            [_dataArr addObject:oneKilo];
        }
        
        if ([fiveKilo count]) {
            [fiveKilo addObject:@"5km"];
            [_dataArr addObject:fiveKilo];
        }
        if ([tenKilo count]) {
            [tenKilo addObject:@"10km"];
            [_dataArr addObject:tenKilo];
        }
        if ([elevenKilo count]) {
            [elevenKilo addObject:@"10km以上"];
            [_dataArr addObject:elevenKilo];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isSwitchOn) {
        NSArray *tempArr = _dataArr[indexPath.section];
        if (indexPath.row == [tempArr count] - 1) {
            return 39;
        }
        return 80;
    }else{
        return 80;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%d%d",indexPath.section,indexPath.row];//@"Cell";
    NSArray *tempArr = _dataArr[indexPath.section];
    if (_isSwitchOn) {
        
        if (indexPath.row == [tempArr count] - 1) {
            TimeWorkerDifferTableViewCell *cell = (TimeWorkerDifferTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell=[[[NSBundle mainBundle] loadNibNamed:@"TimeWorkerDifferTableViewCell" owner:self options:nil] objectAtIndex:0];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                [cell setBackgroundColor:[UIColor clearColor]];
            }
            NSString *kilo = tempArr[indexPath.row];
            
            CGSize size = [HDM getContentFromString:kilo WithFont:[UIFont systemFontOfSize:14.0] ToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            [cell.kiloLabel setFrame:CGRectMake(cell.kiloLabel.frame.origin.x, cell.kiloLabel.frame.origin.y, size.width, CGRectGetHeight(cell.kiloLabel.frame))];
            [cell.kiloLabel setText:kilo];
            
            [cell.greenLineView setFrame:CGRectMake(cell.kiloLabel.frame.origin.x + size.width, cell.greenLineView.frame.origin.y, 320 - (cell.kiloLabel.frame.origin.x + size.width), CGRectGetHeight(cell.greenLineView.frame))];
            
            return cell;
        }else{
            TimeWorkerTableViewCell *cell = (TimeWorkerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell=[[[NSBundle mainBundle] loadNibNamed:@"TimeWorkerTableViewCell" owner:self options:nil] objectAtIndex:0];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                [cell setBackgroundColor:[UIColor clearColor]];
            }
            
            AuntInfoModel *model = tempArr[indexPath.row];
            
            if (model.identityCard && [model.identityCard length]) {
                
            }else{
                [cell.certificateImageView setImage:[UIImage imageNamed:@"certificate_normal.png"]];
            }
            if ([model.integrityAuth integerValue]) {
                
            }else{
                [cell.certificateLabel setBackgroundColor:[UIColor lightGrayColor]];
            }
            if (model.imageUrl) {
                [cell.avataImageView setImageWithURL:[NSURL URLWithString:model.imageUrl]];
            }else{
                [cell.avataImageView setImage:[UIImage imageNamed:@"worker_icon.png"]];
                
            }
            
            CGSize nameSize = [HDM getContentFromString:model.userName WithFont:[UIFont systemFontOfSize:17.0] ToSize:CGSizeMake(80, MAXFLOAT)];
            
            [cell.nameLabel setText:model.userName];
            
            [cell.nameLabel setFrame:CGRectMake(cell.nameLabel.frame.origin.x, cell.nameLabel.frame.origin.y, nameSize.width, CGRectGetHeight(cell.nameLabel.frame))];
            
            [cell.certificateImageView setFrame:CGRectMake(cell.nameLabel.frame.origin.x + CGRectGetWidth(cell.nameLabel.frame) + 5, cell.certificateImageView.frame.origin.y, CGRectGetWidth(cell.certificateImageView.frame), CGRectGetHeight(cell.certificateImageView.frame))];
            
            
            [cell.certificateLabel setFrame:CGRectMake(cell.certificateImageView.frame.origin.x + CGRectGetWidth(cell.certificateImageView.frame) + 2, cell.certificateLabel.frame.origin.y, CGRectGetWidth(cell.certificateLabel.frame), CGRectGetHeight(cell.certificateLabel.frame))];
            
            [cell starLevel:[model.start integerValue]];
            [cell.noticeLabel setText:[NSString stringWithFormat:@"关注数：%@", model.browseCounts]];
            [cell.dealLabel setText:[NSString stringWithFormat:@"已成交数：%@", model.totalOrderCounts]];
            return cell;
        }
    }else{
        TimeWorkerTableViewCell *cell = (TimeWorkerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"TimeWorkerTableViewCell" owner:self options:nil] objectAtIndex:0];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        
        AuntInfoModel *model = tempArr[indexPath.row];
        
        if (model.identityCard && [model.identityCard length]) {
            
        }else{
            [cell.certificateImageView setImage:[UIImage imageNamed:@"certificate_normal.png"]];
        }
        if ([model.integrityAuth integerValue]) {
            
        }else{
            [cell.certificateLabel setBackgroundColor:[UIColor lightGrayColor]];
        }
        if (model.imageUrl) {
            [cell.avataImageView setImageWithURL:[NSURL URLWithString:model.imageUrl]];
        }else{
            [cell.avataImageView setImage:[UIImage imageNamed:@"worker_icon.png"]];
            
        }
        
        CGSize nameSize = [HDM getContentFromString:model.userName WithFont:[UIFont systemFontOfSize:17.0] ToSize:CGSizeMake(80, MAXFLOAT)];
        
        [cell.nameLabel setText:model.userName];
        
        [cell.nameLabel setFrame:CGRectMake(cell.nameLabel.frame.origin.x, cell.nameLabel.frame.origin.y, nameSize.width, CGRectGetHeight(cell.nameLabel.frame))];
        
        [cell.certificateImageView setFrame:CGRectMake(cell.nameLabel.frame.origin.x + CGRectGetWidth(cell.nameLabel.frame) + 5, cell.certificateImageView.frame.origin.y, CGRectGetWidth(cell.certificateImageView.frame), CGRectGetHeight(cell.certificateImageView.frame))];
        
        
        [cell.certificateLabel setFrame:CGRectMake(cell.certificateImageView.frame.origin.x + CGRectGetWidth(cell.certificateImageView.frame) + 2, cell.certificateLabel.frame.origin.y, CGRectGetWidth(cell.certificateLabel.frame), CGRectGetHeight(cell.certificateLabel.frame))];
        
        [cell starLevel:[model.start integerValue]];
        [cell.noticeLabel setText:[NSString stringWithFormat:@"关注数：%@", model.browseCounts]];
        [cell.dealLabel setText:[NSString stringWithFormat:@"已成交数：%@", model.totalOrderCounts]];
        return cell;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AuntDetailViewController *aunt = [[AuntDetailViewController alloc] initWithNibName:@"AuntDetailViewController" bundle:nil];
    AuntInfoModel *model = nil;
    NSArray *tempArr = _dataArr[indexPath.section];
    model = tempArr[indexPath.row];
    [aunt setAuntID:model.auntId];
    [self.navigationController pushViewController:aunt animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _myTableView && scrollView.contentOffset.y + CGRectGetHeight(scrollView.frame) >= scrollView.contentSize.height) {
        if (_hasNext) {
            if (!_animateImageView) {
                _animateImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 85) / 2.0, 25/2.0, 85, 25)];
                [_animateImageView setImage:[UIImage imageNamed:@"load00.png"]];
                [_animateImageView setAnimationImages:@[[UIImage imageNamed:@"load00.png"],
                                                        [UIImage imageNamed:@"load01.png"],
                                                        [UIImage imageNamed:@"load02.png"],
                                                        [UIImage imageNamed:@"load03.png"],
                                                        [UIImage imageNamed:@"load04.png"],
                                                        [UIImage imageNamed:@"load03.png"],
                                                        [UIImage imageNamed:@"load02.png"],
                                                        [UIImage imageNamed:@"load01.png"]
                                                        ]];
                [_animateImageView setAnimationRepeatCount:0];
                [_animateImageView setAnimationDuration:2];
                [_footLabel addSubview:_animateImageView];
            }
            
            if (![_animateImageView isAnimating]) {
                [_footLabel setText:@""];
                [_animateImageView startAnimating];
                [_animateImageView setHidden:NO];
                [self performSelector:@selector(pullToAddData:) withObject:nil afterDelay:2];
            }
        }else if ([_dataArr count]){
            [_footLabel setText:@"已加载全部"];
            
        }
        
    }
}

- (void)pullToAddData:(id)sender{
    NSString *page = [NSString stringWithFormat:@"{\"pageNo\": %d, \"pageSize\":10}", _page];

    [HHM postSearchAuntByCondition:@{@"page" : page,
                                     @"auntInfo": [HDM jsonStringFromOjb:_auntInfoDic]} success:^(NSArray *info, BOOL hasNext) {
                                         if (info) {
                                             _hasNext = hasNext;
                                             [_dataArr addObject:info];
                                             _page ++;
                                             [self customData];

                                         }
                                         
                                         [_animateImageView stopAnimating];
                                         [_animateImageView setHidden:YES];
                                         [_myTableView reloadData];
                                         if (info && ![info count]) {
                                             _hasNext = NO;
                                             [_animateImageView removeFromSuperview];
                                             [_footLabel setText:@"已加载全部"];
                                         }
                                     } failure:^(NSError *error) {
                                         [HDM errorPopMsg:error];
                                     }];
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
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 1:{
            DLog(@"Sort");
        }
            break;
        case 2:{
            DLog(@"附近");
            [self setIsSwitchOn:!_isSwitchOn];
        }
            break;
        case 3:{
            StandardFeeViewController *stand = [[StandardFeeViewController alloc] initWithNibName:@"StandardFeeViewController" bundle:nil];
            stand.isNewHome = NO;
            [self.navigationController pushViewController:stand animated:YES];
        }
        default:
            break;
    }
}
@end
