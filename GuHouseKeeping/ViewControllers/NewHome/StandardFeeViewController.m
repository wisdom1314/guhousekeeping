//
//  StandardFeeViewController.m
//  GuHouseKeeping
//
//  Created by David on 7/30/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "StandardFeeViewController.h"
#import "StandardFeeHeaderView.h"
#import "StandardFeeTableViewCell.h"

@interface StandardFeeViewController ()
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation StandardFeeViewController
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
    StandardFeeHeaderView *headerView = (StandardFeeHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"StandardFeeHeaderView" owner:self options:nil] objectAtIndex:0];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    if (_isNewHome) {
        [_titleLabel setText:@"新居开荒标准费用"];
        [_subTitlelabel setText:@"标准费用 ¥6.00/m²"];
        [headerView.serviceLabel setText:@"新居开荒服务"];
        [headerView.feeLabel setText:@"¥6/m²"];
        [headerView.markLabel setText:@"50m²起做"];
        _dataArr = @[
                     @{
                         @"title":@"1.窗户",
                         @"subTitle":@"边框、推拉轨道不得有污渍、水印、灰尘；玻璃要光洁透明，不能有模糊或有水印。",
                         @"image":@"standard_new_00.png"},
                     
                     @{
                         @"title":@"2.房门",
                         @"subTitle":@"门框、门头必须擦拭，凹凸处须用吸尘器或毛刷彻底清洁干净，无灰尘、水印",
                         @"image":@"standard_new_01.png"},
                     @{
                         @"title":@"3.墙壁",
                         @"subTitle":@"墙角、地角必须清洁，墙壁清洁后不得有水印、灰尘。",
                         @"image":@"standard_new_02.png"},
                     @{
                         @"title":@"4.地面",
                         @"subTitle":@"清洁后的地板应该干净、无尘土、无印痕，光洁、明亮。客户验收后，应该再用干净的地拖把脚印擦去",
                         @"image":@"standard_new_03.png"}
                     ];
    }else{
        [_titleLabel setText:@"小时工标准费用"];
        [_subTitlelabel setText:@"标准费用 ¥30.00/h"];
        [headerView.serviceLabel setText:@"钟点工服务"];
        [headerView.feeLabel setText:@"¥30/h"];
        [headerView.markLabel setText:@"2小时起做"];
        
        _dataArr = @[
                     @{
                         @"title":@"1.厨房",
                         @"subTitle":@"抹渍布分开，锅、碗洗干净，灶面、脱排、墙砖无油渍，台面、冰箱、微波炉烤箱、洗碗机外表无油。",
                         @"image":@"standard_time_00.png"},
                     
                     @{
                         @"title":@"2.卫生间",
                         @"subTitle":@"抹布分开，镜面保持干净，洗脸盆光亮、台面整齐，浴缸、墙砖干净，毛巾架整齐抽水马桶光亮如新、无臭味，地面干净无毛发。",
                         @"image":@"standard_time_01.png"},
                     @{
                         @"title":@"3.卧室",
                         @"subTitle":@"打扫前敲门进房，床单、被单、枕套拉直铺平，定期更换清洗，电视柜、电视机、床头柜、梳妆台、梳妆镜、衣柜无尘，保持室内清洁。",
                         @"image":@"standard_time_02.png"},
                     @{
                         @"title":@"4.客厅",
                         @"subTitle":@"电视机、电视柜、音像、沙发、茶几、花架、餐桌、厅柜、酒柜无尘灰，地毯定期清洗消毒，地板干净无杂物定期打腊。",
                         @"image":@"standard_time_03.png"}
                     ];
    }
    
    [_myTableView setTableHeaderView:headerView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%d%d",indexPath.section,indexPath.row];//@"Cell";
    
    StandardFeeTableViewCell *cell = (StandardFeeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"StandardFeeTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    
    [cell.iconImageView setImage:[UIImage imageNamed:_dataArr[indexPath.row][@"image"]]];
    [cell.titleLabel setText:_dataArr[indexPath.row][@"title"]];
    NSString *string = _dataArr[indexPath.row][@"subTitle"];
    CGSize size = [HDM getContentFromString:string WithFont:[UIFont systemFontOfSize:10.0] ToSize:CGSizeMake(153.0, MAXFLOAT)];
    if (size.height > 64) {
        size.height = 64;
    }
    [cell.subTitleLabel setFrame:CGRectMake(cell.subTitleLabel.frame.origin.x, cell.subTitleLabel.frame.origin.y, size.width, size.height)];
    [cell.subTitleLabel setText:string];
    
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
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}
@end
