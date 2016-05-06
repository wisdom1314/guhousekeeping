//
//  SearchViewController.m
//  GuHouseKeeping
//
//  Created by David on 7/10/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "SearchViewController.h"
#import "ZWYPopKeyWordsView.h"
#import "SearchChoosePopView.h"
#import "TimeWorkerViewController.h"

@interface SearchViewController ()
@property (nonatomic, strong) ZWYPopKeyWordsView *popKeyWordsView;
@property (nonatomic, strong) SearchChoosePopView *searchPopView;

@end

@implementation SearchViewController
@synthesize searchPopView = _searchPopView;

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
        
    self.businessBtn.layer.borderColor = DARKGRAY.CGColor;
    self.businessBtn.layer.borderWidth = 1.0f;
    self.businessBtn.layer.cornerRadius = 3.0f;
    self.businessBtn.layer.masksToBounds = YES;
    
    self.constellationBtn.layer.borderColor = DARKGRAY.CGColor;
    self.constellationBtn.layer.borderWidth = 1.0f;
    self.constellationBtn.layer.cornerRadius = 3.0f;
    self.constellationBtn.layer.masksToBounds = YES;
    
    self.booldTypeBtn.layer.borderColor = DARKGRAY.CGColor;
    self.booldTypeBtn.layer.borderWidth = 1.0f;
    self.booldTypeBtn.layer.cornerRadius = 3.0f;
    self.booldTypeBtn.layer.masksToBounds = YES;
    
//    self.searchBtn.backgroundColor = COLORRGBA(241, 241, 241, 1.0);
//    self.searchBtn.backgroundColor = [UIColor colorWithRed:241.0f/255.0f green:241.0f/255.0f blue:241.0f/255.0f alpha:1.0];
//    [self.searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.searchBtn.layer.borderColor = DARKGRAY.CGColor;
//    self.searchBtn.layer.borderWidth = 1.0f;
//    self.searchBtn.layer.cornerRadius = 3.0f;
//    self.searchBtn.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)searchBtnClick:(id)sender {
    TimeWorkerViewController *worker = [[TimeWorkerViewController alloc] initWithNibName:@"TimeWorkerViewController" bundle:nil];
//            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"latitude": @"",
//                                                                                       @"longitude": @""}];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([_constellationLbl.text length] && ![_constellationLbl.text isEqualToString:@"星座"]) {
        [dic setObject:_constellationLbl.text forKey:@"constellation"];
    }
    if ([_booldTypeLbl.text length] && ![_booldTypeLbl.text isEqualToString:@"血型"]) {
        [dic setObject:_booldTypeLbl.text forKey:@"bloodtype"];
    }
    [worker setAuntInfoDic:dic];
    [self.navigationController pushViewController:worker animated:YES];
}

- (IBAction)businessBtnClick:(id)sender {
    
    
    
}

- (IBAction)booldTypeBtnClick:(id)sender {
    
    NSArray *tempArr = [NSArray arrayWithObjects:@"不限",@"O型",@"A型",@"B型",@"AB型", nil];
    int select = 0;
    if ([tempArr containsObject:_booldTypeLbl.text]) {
        select = [tempArr indexOfObject:_booldTypeLbl.text];
    }
    _searchPopView = [[SearchChoosePopView alloc] initWithFrame:self.view.frame  withTableViewFram:CGRectMake((320 - 285)/2, (self.view.frame.size.height - 300)/2, 285, 300) tableViewArr:tempArr viewComeForm:@"血型" withIndex:select];
    [_searchPopView setSearchDelegate:(id<searchChooseDelegate>)self];
    [_searchPopView setBackgroundColor:[UIColor clearColor]];
    [_searchPopView setAlpha:0.f];
    [self.view addSubview:_searchPopView];
    
    [UIView animateWithDuration:.3 animations:^{
        [_searchPopView setAlpha:1.f];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (IBAction)constellationBtnClick:(id)sender {
    NSArray *tempArr = [NSArray arrayWithObjects:@"不限",@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座", nil];
    int select = 0;
    if ([tempArr containsObject:_constellationLbl.text]) {
        select = [tempArr indexOfObject:_constellationLbl.text];
    }
    _searchPopView = [[SearchChoosePopView alloc] initWithFrame:self.view.frame  withTableViewFram:CGRectMake((320 - 285)/2, (self.view.frame.size.height - 300)/2, 285, 300) tableViewArr:tempArr viewComeForm:@"星座" withIndex:select];
    [_searchPopView setSearchDelegate:(id<searchChooseDelegate>)self];
    [_searchPopView setBackgroundColor:[UIColor clearColor]];
    [_searchPopView setAlpha:0.f];
    [self.view addSubview:_searchPopView];
    
    [UIView animateWithDuration:.3 animations:^{
        [_searchPopView setAlpha:1.f];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (IBAction)clickBtn:(id)sender {
    
    UIButton *tempBtn = (UIButton *)sender;
    
    if (tempBtn.tag == 0) {
//        [self.preciseSearchBtn setBackgroundColor:COLORRGBA(122, 204, 0, 1.0)];
//        [self.keywordBtn setBackgroundColor:COLORRGBA(237, 237, 237, 1.0)];
        [_preciseSearchLabel setBackgroundColor:COLORRGBA(136, 193, 4, 1.0)];
        [_keywordLabel setBackgroundColor:COLORRGBA(237, 237, 237, 1.0)];
        
        [_preciseSearchLabel setTextColor:[UIColor whiteColor]];
        [_keywordLabel setTextColor:[UIColor blackColor]];
        
        self.preciseSearchView.hidden = NO;
        self.keywordView.hidden = YES;
        
        
        
    }else if (tempBtn.tag == 1){
        [_preciseSearchLabel setTextColor:[UIColor blackColor]];
        [_keywordLabel setTextColor:[UIColor whiteColor]];

        if (!_popKeyWordsView) {
            _popKeyWordsView = [[ZWYPopKeyWordsView alloc] initWithFrame:CGRectMake(0, 0, 320, self.preciseSearchView.frame.size.height)];
            if ([HDM searchKeys]) {
                _popKeyWordsView.keyWordArray = [NSMutableArray arrayWithArray:[HDM searchKeys]];
            }
//            _popKeyWordsView.keyWordArray = [NSMutableArray arrayWithObjects:@"赵纬宇",@"文明",@"数据库",@"一次", @"调n遍",@"热词", @"数组",@"文明", @"NSArray",@"遍历", @"on_Status",@"Hot_Taglib ", @"正确的",@"ON_STATUS_ADD", @"协议",@"命名", @"动词",@"接收者", @"获取",@"选举",  nil];
            [_popKeyWordsView setDelegate:(id<ZWYSearchShowViewDelegate>)self];
            
            _popKeyWordsView.backgroundColor = [UIColor clearColor];
            _keywordView.clipsToBounds = YES;
            [self.keywordView addSubview:_popKeyWordsView];
            [_popKeyWordsView changeSearchKeyWord];
        }
        
//        [self.preciseSearchBtn setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:237.f/255.f blue:237.f/255.f alpha:1.0]];
//        [self.keywordBtn setBackgroundColor:[UIColor colorWithRed:122.f/255.f green:204.f/255.f blue:0 alpha:1.0]];
        [_preciseSearchLabel setBackgroundColor:COLORRGBA(237, 237, 237, 1.0)];
        [_keywordLabel setBackgroundColor:COLORRGBA(136, 193, 4, 1.0)];
        self.preciseSearchView.hidden = YES;
        self.keywordView.hidden = NO;
    }
}

- (void)searchHotTaglibWithKeyWord:(NSString *)keyWords{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:keyWords delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [alert show];
    
    DLog(@"keyWords==========%@",keyWords);
    TimeWorkerViewController *worker = [[TimeWorkerViewController alloc] initWithNibName:@"TimeWorkerViewController" bundle:nil];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:keyWords forKey:@"description"];
    [worker setAuntInfoDic:dic];
    [self.navigationController pushViewController:worker animated:YES];
}

- (void) setChooseWithkey:(NSString *)selectKey viewComeForm:(NSString *)comeForm{
    DLog(@"selectKey=============%@",selectKey);
    
    if ([comeForm isEqualToString:@"血型"]) {
        [_booldTypeLbl setText:selectKey];
    }else if ([comeForm isEqualToString:@"星座"]){
        [_constellationLbl setText:selectKey];
    }
}
@end
