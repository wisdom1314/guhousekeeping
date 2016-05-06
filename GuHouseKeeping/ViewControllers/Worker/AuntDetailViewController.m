//
//  AuntDetailViewController.m
//  GuHouseKeeping
//
//  Created by David on 7/24/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "AuntDetailViewController.h"
#import "AuntDetailView.h"
#import "AuntDetailTableViewCell.h"
#import "WorkExhibitionViewController.h"
#import "LoginViewController.h"
#import "AuntCommitView.h"
#import "ReviewModel.h"
#import "UIImageView+AFNetworking.h"
#import "NewHomeViewController.h"

typedef enum {
    isContract = 0,
    isCallService,
    isCommit
}LoginAction;

@interface AuntDetailViewController ()
@property (nonatomic, assign) BOOL hasNext;
@property (nonatomic, assign) BOOL didLoginAction;
@property (nonatomic, assign) LoginAction loginAction;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *alterView;
@property (nonatomic, strong) AuntCommitView *commitView;
@property (nonatomic, assign) int page;
@property (nonatomic, strong) UILabel *footLabel;
@property (nonatomic, strong) UIImageView *animateImageView;
@property (nonatomic, strong) AuntInfoModel *info;
@end

@implementation AuntDetailViewController
@synthesize hasNext = _hasNext;
@synthesize didLoginAction = _didLoginAction;
@synthesize loginAction = _loginAction;
@synthesize dataArr = _dataArr;
@synthesize alterView = _alterView;
@synthesize commitView = _commitView;
@synthesize page = _page;
@synthesize footLabel = _footLabel;
@synthesize animateImageView = _animateImageView;
@synthesize info = _info;

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
    _dataArr = [[NSMutableArray alloc] init];
    _page = 1;
    
    _hasNext = NO;
    [HHM postAuntServiceFindAuntByIdForMember:@{@"memberId":HDM.memberId ? HDM.memberId : @"",
                                                @"auntId":_auntID} success:^(AuntInfoModel *info) {
        if (info) {
            DLog(@"%@", info.description);
            _info = info;
            
            AuntDetailView *headView = [[[NSBundle mainBundle] loadNibNamed:@"AuntDetailView" owner:self options:nil] objectAtIndex:0];
            
            headView.avataImageView.layer.borderWidth = 1.0f;
            headView.avataImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
            headView.avataImageView.layer.cornerRadius = CGRectGetHeight(headView.avataImageView.frame) / 2.0;
            headView.avataImageView.layer.masksToBounds = YES;
            if (_info.imageUrl) {
                [headView.avataImageView setImageWithURL:[NSURL URLWithString:_info.imageUrl] placeholderImage:[UIImage imageNamed:@"worker_icon.png"]];
            }else{
                [headView.avataImageView setImage:[UIImage imageNamed:@"worker_icon.png"]];
            }
//            @"李阿姨"
            
            if (info.userName) {
                CGSize nameSize = [HDM getContentFromString:info.userName WithFont:[UIFont systemFontOfSize:17.0] ToSize:CGSizeMake(80, MAXFLOAT)];
                
                [headView.nameLabel setText:info.userName];
                [headView.nameLabel setFrame:CGRectMake(headView.nameLabel.frame.origin.x, headView.nameLabel.frame.origin.y, nameSize.width, CGRectGetHeight(headView.nameLabel.frame))];
                [headView.certificateImageView setFrame:CGRectMake(headView.nameLabel.frame.origin.x + CGRectGetWidth(headView.nameLabel.frame) + 8, headView.certificateImageView.frame.origin.y, CGRectGetWidth(headView.certificateImageView.frame), CGRectGetHeight(headView.certificateImageView.frame))];
                
                
                [headView.certificateLabel setFrame:CGRectMake(headView.certificateImageView.frame.origin.x + CGRectGetWidth(headView.certificateImageView.frame) + 2, headView.certificateLabel.frame.origin.y, CGRectGetWidth(headView.certificateLabel.frame), CGRectGetHeight(headView.certificateLabel.frame))];

            }
            
            
            
            if (_info.identityCard && [_info.identityCard length]) {
                
            }else{
                [headView.certificateImageView setImage:[UIImage imageNamed:@"certificate_normal.png"]];
            }
            if ([_info.integrityAuth integerValue]) {
                
            }else{
                [headView.certificateLabel setBackgroundColor:[UIColor lightGrayColor]];
            }

            CGSize year = [HDM getContentFromString:info.workYear WithFont:[UIFont systemFontOfSize:15.0] ToSize:CGSizeMake(30, MAXFLOAT)];
            
            [headView.yearLabel setText:info.workYear];
            [headView.yearLabel setFrame:CGRectMake(headView.yearLabel.frame.origin.x, headView.yearLabel.frame.origin.y, year.width, CGRectGetHeight(headView.yearLabel.frame))];
            [headView.yearStatusLabel setFrame:CGRectMake(headView.yearLabel.frame.origin.x + year.width + 3, headView.yearStatusLabel.frame.origin.y, CGRectGetWidth(headView.yearStatusLabel.frame), CGRectGetHeight(headView.yearStatusLabel.frame))];

            
            
//            @"45岁  巨蟹座 B型血 山西人"
            [headView.descLabel setText:[NSString stringWithFormat:@"%@岁  %@ %@型血 %@人", info.age, info.constellation, info.bloodType, info.nativePlace]];
            
            [headView starLevel:[info.start integerValue]];
            
            
            if ([info.userCollected  integerValue]) {
                [headView.contactButton setTitle:@"已添加到联系人" forState:UIControlStateNormal];
            }
            
            [headView.contactButton addTarget:self action:@selector(contactButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            

//            UIImage *image = [UIImage imageNamed:@"AuntDetail_button.png"];
//            [headView.callService setBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(24, 70, 24, 70) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];

//            headView.callService.layer.borderColor = [COLORRGBA(129, 129, 129, 1.0) CGColor];
//            headView.callService.layer.borderWidth = 1.0;
//            [headView.callService setBackgroundColor:COLORRGBA(248, 248, 248, 1.0)];
            [headView.callService addTarget:self action:@selector(callServiceClick:) forControlEvents:UIControlEventTouchUpInside];
//            [headView.cleanButton setUserInteractionEnabled:NO];
            [headView.cleanButton addTarget:self action:@selector(cleanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//            [headView.laundryButton setUserInteractionEnabled:NO];
            [headView.laundryButton addTarget:self action:@selector(laundryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//            [headView.cookButton setUserInteractionEnabled:NO];
            [headView.cookButton addTarget:self action:@selector(cookButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
//            [info.caseList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                CaseInfoModel *model = (CaseInfoModel *)obj;
//                if ([model.description isEqualToString:@"保洁"]) {
//                    [headView.cleanButton setUserInteractionEnabled:YES];
//                }else if ([model.description isEqualToString:@"洗熨"]){
//                    [headView.laundryButton setUserInteractionEnabled:YES];
//                }else if ([model.description isEqualToString:@"做饭"]){
//                    [headView.cookButton setUserInteractionEnabled:YES];
//                }
//            }];
            
            
            [headView.commitButton addTarget:self action:@selector(commitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_myTableView setTableHeaderView:headView];
            
            
            [_myTableView setHidden:NO];

            NSString *page = [NSString stringWithFormat:@"{\"pageNo\": %d, \"pageSize\":10}", _page];
            [HHM postAuntServiceFindReviewByAuntId:@{@"reviewTag":@"ALL",
                                                     @"auntId": _auntID,
                                                     @"page":page} success:^(NSArray *info, BOOL hasNext) {
                                                         if (info) {
                                                             _dataArr = [NSMutableArray arrayWithArray:info];
                                                             _page ++;
                                                         }
                                                         _hasNext = hasNext;
                                                         [_myTableView reloadData];
                                                     } failure:^(NSError *error) {
                                                         [HDM errorPopMsg:error];
                                                     }];

        }
    } failure:^(NSError *error) {
        [HDM errorPopMsg:error];
    }];


    
    _footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [_footLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_footLabel setText:@""];
    [_footLabel setTextAlignment:NSTextAlignmentCenter];
    [_footLabel setBackgroundColor:[UIColor clearColor]];
    [_footLabel setTextColor:[UIColor blackColor]];
    [_myTableView setTableFooterView:_footLabel];
    [_myTableView setHidden:YES];
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
}
- (void)loginViewControllerDidSuccessLogin{
    _didLoginAction = YES;
}


- (void)customButtonAction{
    if ([HDM memberId]) {
        if (_loginAction == isContract) {
            DLog(@"添加联系人");
            [HHM postCollectAuntServiceAddCollect:@{@"memberId":HDM.memberId,
                                                    @"auntId":_auntID} success:^(AddCollectionModel *info) {
                                                        if (info) {
                                                            DLog(@"%@", info);
                                                            if ([info.collectResult isEqualToString:@"COLLECTED"]) {
                                                                [HDM popHlintMsg:@"已经收藏!"];
                                                            }else if ([info.collectResult isEqualToString:@"SUCCESS"]){
                                                                [HDM popHlintMsg:@"收藏成功!"];
                                                            }else{
                                                                [HDM popHlintMsg:@"收藏失败!"];
                                                            }
                                                        }else{
                                                            [HDM popHlintMsg:@"添加联系人失败！"];
                                                        }
                                                    } failure:^(NSError *error) {
                                                        [HDM errorPopMsg:error];
                                                    }];
        } else if (_loginAction == isCallService) {

        } else if (_loginAction == isCommit) {
            [self commitAction];
        }
    }else{
        LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [login setDelegate:(id<LoginViewControllerDelegate>)self];
        [self.navigationController pushViewController:login animated:YES];
    }
}



- (void)contactButtonClick:(id)sender{
    DLog(@"添加联系人");
    _loginAction = isContract;
    [self customButtonAction];
}

- (void)callServiceClick:(id)sender{
    DLog(@"让她来服务");
    NewHomeViewController *newHome = [[NewHomeViewController alloc] initWithNibName:@"NewHomeViewController" bundle:nil];
    newHome.isNewHome = NO;
    newHome.auntID = _info.auntId;
    [self.navigationController pushViewController:newHome animated:YES];

}

- (void)cleanButtonClick:(id)sender{
    DLog(@"清洁");
    if (_info) {
       __block NSString *caseID = nil;
        [_info.caseList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CaseInfoModel *model = (CaseInfoModel *)obj;
            if ([model.description rangeOfString:@"保洁"].location != NSNotFound) {
                caseID = model.caseId;
            }else if ([model.description isEqualToString:@"洗熨"]){
            }else if ([model.description isEqualToString:@"做饭"]){
            }
        }];
        
        if (caseID) {
            WorkExhibitionViewController *exhibitonVC = [[WorkExhibitionViewController alloc] initWithNibName:@"WorkExhibitionViewController" bundle:nil];
            [exhibitonVC setCaseID:caseID];
            [self.navigationController pushViewController:exhibitonVC animated:YES];
        }else{
            [HDM popHlintMsg:@"暂无工作效果展示"];
        }
    }
}

- (void)laundryButtonClick:(id)sender{
    DLog(@"洗熨");
    if (_info) {
        __block NSString *caseID = nil;
        [_info.caseList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CaseInfoModel *model = (CaseInfoModel *)obj;
            if ([model.description isEqualToString:@"保洁"]) {
            }else if ([model.description rangeOfString:@"洗熨"].location != NSNotFound){
                caseID = model.caseId;
            }else if ([model.description isEqualToString:@"做饭"]){
            }
        }];
        
        if (caseID) {
            WorkExhibitionViewController *exhibitonVC = [[WorkExhibitionViewController alloc] initWithNibName:@"WorkExhibitionViewController" bundle:nil];
            [exhibitonVC setCaseID:caseID];
            [self.navigationController pushViewController:exhibitonVC animated:YES];
        }else{
            [HDM popHlintMsg:@"暂无工作效果展示"];
        }
    }}

- (void)cookButtonClick:(id)sender{
    DLog(@"做饭");
    if (_info) {
        __block NSString *caseID = nil;
        [_info.caseList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CaseInfoModel *model = (CaseInfoModel *)obj;
            if ([model.description isEqualToString:@"保洁"]) {
            }else if ([model.description isEqualToString:@"洗熨"]){
            }else if ([model.description rangeOfString:@"做饭"].location != NSNotFound){
                caseID = model.caseId;
            }
        }];
        
        if (caseID) {
            WorkExhibitionViewController *exhibitonVC = [[WorkExhibitionViewController alloc] initWithNibName:@"WorkExhibitionViewController" bundle:nil];
            [exhibitonVC setCaseID:caseID];
            [self.navigationController pushViewController:exhibitonVC animated:YES];
        }else{
            [HDM popHlintMsg:@"暂无工作效果展示"];
        }
    }}

- (void)commitButtonClick:(id)sender{
    DLog(@"评论");
    _loginAction = isCommit;
    [self customButtonAction];
}

- (void)commitAction {
    _alterView = [[UIView alloc] initWithFrame:self.view.bounds];
    [_alterView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_alterView];
    
    UIView * alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    [alphaView setBackgroundColor:[UIColor blackColor]];
    [alphaView setAlpha:0.3];
    [_alterView addSubview:alphaView];
    
    _commitView = [[[NSBundle mainBundle] loadNibNamed:@"AuntCommitView" owner:self options:nil] objectAtIndex:0];
    [_commitView.perfectLabel setBackgroundColor:LIGHTGRAY];
    [_commitView.perfectLabel setTextColor:[UIColor blackColor]];
    
    [_commitView.fineLabel setBackgroundColor:LIGHTGRAY];
    [_commitView.fineLabel setTextColor:[UIColor blackColor]];
    
    [_commitView.badLabel setBackgroundColor:LIGHTGRAY];
    [_commitView.badLabel setTextColor:[UIColor blackColor]];
    
    
    _commitView.perfectLabel.layer.borderWidth = 1.0f;
    _commitView.perfectLabel.layer.cornerRadius = 3.0f;
    _commitView.perfectLabel.layer.borderColor = [DARKGRAY CGColor];
    _commitView.perfectLabel.layer.masksToBounds = YES;
    
    
    _commitView.fineLabel.layer.borderWidth = 1.0f;
    _commitView.fineLabel.layer.cornerRadius = 3.0f;
    _commitView.fineLabel.layer.borderColor = [DARKGRAY CGColor];
    _commitView.fineLabel.layer.masksToBounds = YES;
    
    
    _commitView.badLabel.layer.borderWidth = 1.0f;
    _commitView.badLabel.layer.cornerRadius = 3.0f;
    _commitView.badLabel.layer.borderColor = [DARKGRAY CGColor];
    _commitView.badLabel.layer.masksToBounds = YES;
    
    [_commitView.perfectButton addTarget:self action:@selector(commitButton:) forControlEvents:UIControlEventTouchUpInside];
    [_commitView.fineButton addTarget:self action:@selector(commitButton:) forControlEvents:UIControlEventTouchUpInside];
    [_commitView.badButton addTarget:self action:@selector(commitButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_commitView.myTextView setDelegate:(id<UITextViewDelegate>)self];
    [_commitView.perfectButton setSelected:YES];
    [_alterView addSubview:_commitView];
    [_commitView setCenter:CGPointMake(CGRectGetWidth(_alterView.frame)/2.0, CGRectGetHeight(_alterView.frame)/2.0)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    [tap setDelegate:(id<UIGestureRecognizerDelegate>)self];
    tap.numberOfTouchesRequired = 1;
    [_alterView addGestureRecognizer:tap];
}

- (void)commitButton:(id)sender{
    UIButton *btn = (id)sender;
    if (_commitView) {
        [_commitView.perfectButton setSelected:(btn == _commitView.perfectButton ? YES : NO)];
        [_commitView.fineButton setSelected:(btn == _commitView.fineButton ? YES : NO)];
        [_commitView.badButton setSelected:(btn == _commitView.badButton ? YES : NO)];
        [_commitView.myTextView becomeFirstResponder];
        
        if (btn == _commitView.perfectButton) {
            [_commitView.perfectLabel setTextColor:[UIColor whiteColor]];
            [_commitView.perfectLabel setBackgroundColor:GREENCOLO];
            
            [_commitView.fineLabel setTextColor:[UIColor blackColor]];
            [_commitView.fineLabel setBackgroundColor:LIGHTGRAY];

            [_commitView.badLabel setTextColor:[UIColor blackColor]];
            [_commitView.badLabel setBackgroundColor:LIGHTGRAY];
            
        }else if (btn == _commitView.fineButton){
            [_commitView.perfectLabel setTextColor:[UIColor blackColor]];
            [_commitView.perfectLabel setBackgroundColor:LIGHTGRAY];
            
            [_commitView.fineLabel setTextColor:[UIColor whiteColor]];
            [_commitView.fineLabel setBackgroundColor:GREENCOLO];
            
            [_commitView.badLabel setTextColor:[UIColor blackColor]];
            [_commitView.badLabel setBackgroundColor:LIGHTGRAY];

        }else{
            [_commitView.perfectLabel setTextColor:[UIColor blackColor]];
            [_commitView.perfectLabel setBackgroundColor:LIGHTGRAY];
            
            [_commitView.fineLabel setTextColor:[UIColor blackColor]];
            [_commitView.fineLabel setBackgroundColor:LIGHTGRAY];
            
            [_commitView.badLabel setTextColor:[UIColor whiteColor]];
            [_commitView.badLabel setBackgroundColor:GREENCOLO];

        }
    }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSLog(@"%@",[[touch view] class]);
    if ([[touch view] isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}

- (void)tap:(UITapGestureRecognizer *)recognizer{
    if (_alterView) {
        [_alterView removeFromSuperview];
        _alterView = nil;
    }
    if (_commitView) {
        [_commitView removeFromSuperview];
        _commitView = nil;
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [textView setText:@""];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        if ([_commitView.myTextView isFirstResponder]) {
            [_commitView.myTextView resignFirstResponder];
        }
        
        //    2014-07-30 15:48:31
        //    NBs
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *commit = [HDM jsonStringFromOjb:@{@"auntId": _auntID,
                                                    @"createUserId": HDM.memberId,
                                                    @"optTime":[formatter stringFromDate:[NSDate date]],
                                                    @"reviewContent": textView.text,
                                                    @"reviewTag": ([_commitView.perfectButton isSelected] ? @"VERY_SATISFY" : ([_commitView.fineButton isSelected] ? @"SATISFY" : @"NOT_SATISFY"))}];
        
        
        [HHM postReviewServiceAddReview:@{@"review":commit} success:^(ReviewModel *info) {
            DLog(@"info:%@", info);
            if (info) {
                if (!_dataArr) {
                    _dataArr = [[NSMutableArray alloc] init];
                }
                [_dataArr insertObject:info atIndex:0];
                [_myTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [HDM popHlintMsg:@"评论成功"];
            }else{
                [HDM popHlintMsg:@"评论失败"];
            }
        } failure:^(NSError *error) {
            [HDM errorPopMsg:error];
        }];

        if (_alterView) {
            [_alterView removeFromSuperview];
            _alterView = nil;
        }
        if (_commitView) {
            [_commitView removeFromSuperview];
            _commitView = nil;
        }
        
    }
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReviewModel *model = _dataArr[indexPath.row];
    float height = 24;
    CGSize size = [HDM getContentFromString:model.reviewContent WithFont:[UIFont systemFontOfSize:13.0] ToSize:CGSizeMake(285, MAXFLOAT)];
    height += size.height;
    height += 6;
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%d%d",indexPath.section,indexPath.row];//@"Cell";
    
    AuntDetailTableViewCell *cell = (AuntDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"AuntDetailTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.contentLabel setNumberOfLines:0];
        [cell.contentLabel setLineBreakMode:NSLineBreakByWordWrapping];

    }
    
    ReviewModel *model = _dataArr[indexPath.row];
    
    NSString *name = [NSString stringWithFormat:@"来自 %@", model.createUserName];
    
    CGSize nameSize = [HDM getContentFromString:name WithFont:[UIFont systemFontOfSize:9.0] ToSize:CGSizeMake(150.0, 20)];
    [cell.nameLabel setText:name];
    [cell.nameLabel setFrame:CGRectMake(cell.nameLabel.frame.origin.x, cell.nameLabel.frame.origin.y, nameSize.width , 20)];
    
    if ([model.reviewTag isEqualToString:@"VERY_SATISFY"]) {
        [cell.satisfactionImageView setFrame:CGRectMake(cell.nameLabel.frame.origin.x + CGRectGetWidth(cell.nameLabel.frame) + 10, cell.satisfactionImageView.frame.origin.y, 39, 12)];
        [cell.satisfactionImageView setImage:[UIImage imageNamed:@"worker_perfect.png"]];
    }else if ([model.reviewTag isEqualToString:@"SATISFY"]){
        [cell.satisfactionImageView setFrame:CGRectMake(cell.nameLabel.frame.origin.x + CGRectGetWidth(cell.nameLabel.frame) + 10, cell.satisfactionImageView.frame.origin.y, 25, 12)];
        [cell.satisfactionImageView setImage:[UIImage imageNamed:@"worker_fine.png"]];
    }else{
        [cell.satisfactionImageView setFrame:CGRectMake(cell.nameLabel.frame.origin.x + CGRectGetWidth(cell.nameLabel.frame) + 10, cell.satisfactionImageView.frame.origin.y, 35, 12)];
        [cell.satisfactionImageView setImage:[UIImage imageNamed:@"worker_bad.png"]];
    }
    
    [cell.timeLabel setText:model.optTime];
    float height = 24;

    CGSize size = [HDM getContentFromString:model.reviewContent WithFont:[UIFont systemFontOfSize:13.0] ToSize:CGSizeMake(285, MAXFLOAT)];

    [cell.contentLabel setText:model.reviewContent];
    [cell.contentLabel setFrame:CGRectMake(cell.contentLabel.frame.origin.x, cell.contentLabel.frame.origin.y, 285, size.height)];
    
    
    
    height += size.height;
    height += 6;

    [cell.lineView setFrame:CGRectMake((CGRectGetWidth(cell.frame) - 285) /2.0, height - 0.5, 285, 0.5)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    [HHM postAuntServiceFindReviewByAuntId:@{@"reviewTag":@"ALL",
                                             @"auntId": _auntID,
                                             @"page":page} success:^(NSArray *info, BOOL hasNext) {
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
            
        default:
            break;
    }
}
@end
