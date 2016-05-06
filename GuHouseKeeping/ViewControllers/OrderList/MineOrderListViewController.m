//
//  MineOrderListViewController.m
//  GuHouseKeeping
//
//  Created by David on 7/10/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "MineOrderListViewController.h"
#import "OrderListTableViewCell.h"
#import "OrderDetailViewController.h"
#import "UserOrderModel.h"
#import "UIImageView+AFNetworking.h"

@interface MineOrderListViewController ()
@property (nonatomic, assign) BOOL hasNext;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UILabel *footLabel;
@property (nonatomic, assign) int page;
//@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIImageView *animateImageView;
@end

@implementation MineOrderListViewController
@synthesize dataArr = _dataArr;
@synthesize footLabel = _footLabel;
//@synthesize indicatorView = _indicatorView;
@synthesize animateImageView = _animateImageView;

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
//    self.view.backgroundColor = [UIColor colorWithRed:220.f/255.f green:220.f/255.f blue:220.f/255.f alpha:1.0];
    
    
    [_noPayButton setSelected:YES];
    [self firstOrderList];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 17)];
    [header setBackgroundColor:[UIColor clearColor]];
    [_myTableView setTableHeaderView:header];
    
    //    UIView *foot = [[UIView alloc] init];
    //    [foot setBackgroundColor:[UIColor clearColor]];
    //    [_myTableView setTableFooterView:foot];
    
    
    _footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [_footLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_footLabel setText:@""];
    [_footLabel setTextAlignment:NSTextAlignmentCenter];
    [_footLabel setBackgroundColor:[UIColor clearColor]];
    [_footLabel setTextColor:[UIColor blackColor]];
    [_myTableView setTableFooterView:_footLabel];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)firstOrderList{
    _page = 1;

    NSString *page = [NSString stringWithFormat:@"{\"pageNo\": %d, \"pageSize\":10}", _page];
    
    [HHM postOrderServiceFindOrderList:@{@"memberId":HDM.memberId,
                                         @"orderType": @"NOT_PAY",
                                         @"page":page
                                         } success:^(NSArray *info, BOOL hasNext) {
                                             DLog(@"info:%@", info);
                                             if ([_noPayButton isSelected]) {
                                                 if (info) {
                                                     _dataArr = [NSMutableArray arrayWithArray:info];
                                                     _page ++;
                                                 }
                                                 _hasNext = hasNext;
                                                 [_myTableView reloadData];
                                             }
                                         } failure:^(NSError *error) {
                                             [HDM errorPopMsg:error];
                                         }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 97;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%d%d",indexPath.section,indexPath.row];//@"Cell";
    
    OrderListTableViewCell *cell = (OrderListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"OrderListTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    
    
    UserOrderModel *model = _dataArr[indexPath.row];
    if (model.imageUrl) {
        [cell.iconIV setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"OrderList_icon.png"]];
    }else{
        [cell.iconIV setImage:[UIImage imageNamed:@"OrderList_icon.png"]];
    }
    
    
    if ([model.orderUse isEqualToString:@"HOURLY_WORKER"]) {
        [cell.titleLabel setText:@"小时工"];
    }else if ([model.orderUse isEqualToString:@"NEW_HOUSE"]){
        [cell.titleLabel setText:@"新居开荒"];
    }
    if ([model.orderStatus isEqualToString:@"ONLINE_PAYED"]) {
        [cell.statusImageView setImage:[UIImage imageNamed:@"order_payed.png"]];
    }else{
        [cell.statusImageView setImage:[UIImage imageNamed:@"order_none_payed.png"]];
    }
    [cell.orderNumLabel setText:[NSString stringWithFormat:@"订单号：%@", model.orderNo]];
    [cell.timeLabel setText:model.optTime];

    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArr) {
//        UserOrderModel *model = _dataArr[indexPath.row];
//        if (![model.orderStatus isEqualToString:@"NOT_PAY"]) {
//            return NO;
//        }else{
//            return YES;
//        }
        
        if ([_noPayButton isSelected]) {
            return NO;
        }
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UserOrderModel *model = _dataArr[indexPath.row];

        [HHM postOrderServiceDeleteOrder:@{@"memberId":HDM.memberId,
                                           @"orderId":model.orderId} success:^(NSString *info) {
                                               DLog(@"info:%@", info);
                                               if ([info isEqualToString:@"SUCCESS"]) {
                                                   //先行删除阵列中的物件
                                                   [_dataArr removeObjectAtIndex:indexPath.row];
                                                   
                                                   //删除 UITableView 中的物件，并设定动画模式
                                                   [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                                   [HDM popHlintMsg:@"订单删除成功！"];
                                               }else{
                                                   [HDM popHlintMsg:@"订单删除失败！"];
                                               }
                                           } failure:^(NSError *error) {
                                               [HDM errorPopMsg:error];
                                           }];

        
   
    }   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailViewController *detail = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
    UserOrderModel *model = _dataArr[indexPath.row];
    detail.orderId = model.orderId;
    [detail setDelegate:(id<OrderDetailViewControllerDelegate>)self];
    [self.navigationController pushViewController:detail animated:YES];
}


- (void)OrderDetailViewControllerUpdateRefresh{
    [self firstOrderList];
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
    [HHM postOrderServiceFindOrderList:@{@"memberId":HDM.memberId,
                                         @"orderType": ([_noPayButton isSelected] ? @"NOT_PAY" : @"ALL") ,
                                         @"page":page
                                         } success:^(NSArray *info, BOOL hasNext) {
                                             DLog(@"info:%@", info);
                                             if (info) {
                                                 _hasNext = hasNext;
                                                 
                                                 [_dataArr addObjectsFromArray:info];
                                                 _page ++;
                                                 if (![info count]) {
                                                     _hasNext = NO;
                                                     [_animateImageView removeFromSuperview];
                                                     [_footLabel setText:@"已加载全部"];
                                                 }
                                             }
                                             [_animateImageView stopAnimating];
                                             [_animateImageView setHidden:YES];
                                             [_myTableView reloadData];
                                         } failure:^(NSError *error) {
                                             [_animateImageView stopAnimating];
                                             [_animateImageView setHidden:YES];
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
            [_myTableView setDelegate:nil];
            [_myTableView setDataSource:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 1:{
            if ([btn isSelected]) {
                [btn setSelected:NO];
            }else{
                [btn setSelected:YES];
            }
            [_myTableView setEditing:YES animated:YES];
        }
        default:
            break;
    }
}

- (IBAction)payButton:(id)sender {
    
    if (_animateImageView) {
        [_footLabel setText:@""];
        [_animateImageView stopAnimating];
        [_animateImageView setHidden:YES];
    }
    [_myTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    UIButton *btn = (UIButton *)sender;
    if ([btn tag] == 0) {
        [_noPayLabel setTextColor:[UIColor whiteColor]];
        [_noPayLabel setBackgroundColor:COLORRGBA(136, 193, 4, 1.0)];
        
        [_totalLabel setBackgroundColor:COLORRGBA(237, 237, 237, 1.0)];
        [_totalLabel setTextColor:[UIColor blackColor]];
        
        [_noPayButton setSelected:YES];
        
        _page = 1;
        NSString *page = [NSString stringWithFormat:@"{\"pageNo\": %d, \"pageSize\":10}", _page];
        
        [HHM postOrderServiceFindOrderList:@{@"memberId":HDM.memberId,
                                             @"orderType": @"NOT_PAY",
                                             @"page":page
                                             } success:^(NSArray *info, BOOL hasNext) {
                                                 DLog(@"info:%@", info);
                                                 if ([_noPayButton isSelected]) {
                                                     if (info) {
                                                         _dataArr = [NSMutableArray arrayWithArray:info];
                                                         _page ++;
                                                     }
                                                     _hasNext = hasNext;
                                                     [_myTableView reloadData];
                                                 }
                                             } failure:^(NSError *error) {
                                                 [HDM errorPopMsg:error];
                                             }];
        
        
    }else{
        [_noPayLabel setBackgroundColor:COLORRGBA(237, 237, 237, 1.0)];
        [_noPayLabel setTextColor:[UIColor blackColor]];
        
        [_totalLabel setTextColor:[UIColor whiteColor]];
        [_totalLabel setBackgroundColor:COLORRGBA(136, 193, 4, 1.0)];
        
        [_noPayButton setSelected:NO];
        
        _page = 1;
        NSString *page = [NSString stringWithFormat:@"{\"pageNo\": %d, \"pageSize\":10}", _page];
        
        [HHM postOrderServiceFindOrderList:@{@"memberId":HDM.memberId,
                                             @"orderType": @"ONLINE_PAYED",
                                             @"page":page
                                             } success:^(NSArray *info, BOOL hasNext) {
                                                 DLog(@"info:%@", info);
                                                 if (![_noPayButton isSelected]) {
                                                     if (info) {
                                                         _dataArr = [NSMutableArray arrayWithArray:info];
                                                         _page ++;
                                                     }
                                                     _hasNext = hasNext;
                                                     [_myTableView reloadData];
                                                 }
                                             } failure:^(NSError *error) {
                                                 [HDM errorPopMsg:error];
                                             }];
    }
}

- (IBAction)cancelClick:(id)sender {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://10086"]]) {
        if ([@"10086" isKindOfClass:[NSNull class]] || @"10086".length < 1) {
            [HDM popHlintMsg:@"没有号码"];
        }else{
            UIWebView *web=[[UIWebView alloc]init];
            [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", @"4000309180"]]]];
            [self.view addSubview:web];
        }
    }else{
        [HDM popHlintMsg:@"该设备不能打电话"];
    }

}
@end
