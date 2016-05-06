//
//  SearchViewController.h
//  GuHouseKeeping
//
//  Created by David on 7/10/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchViewController : BaseViewController
- (IBAction)buttonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *preciseSearchView;//精确搜多view
@property (strong, nonatomic) IBOutlet UIView *keywordView;//关键字搜索view

@property (strong, nonatomic) IBOutlet UILabel *preciseSearchLabel;
@property (strong, nonatomic) IBOutlet UIButton *preciseSearchBtn;
@property (strong, nonatomic) IBOutlet UILabel *keywordLabel;
@property (strong, nonatomic) IBOutlet UIButton *keywordBtn;
@property (strong, nonatomic) IBOutlet UILabel *lineLbl;
@property (strong, nonatomic) IBOutlet UIButton *businessBtn;
@property (strong, nonatomic) IBOutlet UIButton *constellationBtn;
@property (strong, nonatomic) IBOutlet UIButton *booldTypeBtn;
@property (strong, nonatomic) IBOutlet UILabel *businessLbl;
@property (strong, nonatomic) IBOutlet UILabel *constellationLbl;
@property (strong, nonatomic) IBOutlet UILabel *booldTypeLbl;
@property (nonatomic, strong) IBOutlet UIButton *searchBtn;


- (IBAction)searchBtnClick:(id)sender;
- (IBAction)businessBtnClick:(id)sender;
- (IBAction)booldTypeBtnClick:(id)sender;
- (IBAction)constellationBtnClick:(id)sender;
- (IBAction)clickBtn:(id)sender;

@end
