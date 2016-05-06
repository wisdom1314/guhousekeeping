//
//  WorkExhibitionViewController.m
//  GuHouseKeeping
//
//  Created by David on 7/28/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "WorkExhibitionViewController.h"
#import "ImageModel.h"
#import "UIImageView+AFNetworking.h"

@interface WorkExhibitionViewController ()

@end

@implementation WorkExhibitionViewController
@synthesize caseID = _caseID;

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
    DLog(@"_caseID:%@", _caseID);
    [HHM postAuntServiceFindCaseById:@{@"caseId": _caseID} success:^(CaseInfoModel *info) {
        if (info) {
            DLog(@"%@", info.description);
            
            __block float ox = 7.0;
            __block float oy = 7.0;
            __block float bOy = 0.0;
            if (info.images && [info.images count]) {
                [info.images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    ImageModel *image = (ImageModel *)obj;
//                    if (idx == 0) {
//                        image.hpixel = @"500";
//                        image.wpixel = @"690";
//                    }else{
//                        image.hpixel = @"500";
//                        image.wpixel = @"638";
//                    }
                    if (ox == 7.0) { //塞 或者压缩塞
                        if ([image.wpixel floatValue] /2.0 >= (320 - 14)) {
                            CGRect rect = CGRectMake(ox, oy,  (320 - 14), (320 - 14) * [image.hpixel floatValue] / [image.wpixel floatValue]);
                            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
                            [imageView setImageWithURL:[NSURL URLWithString:image.imageUrl]];
                            [_myScrollView addSubview:imageView];
                            oy += (CGRectGetHeight(imageView.frame) + 7.0);
                            bOy = 0;
                            ox = 7.0;
                        }else{
                            CGRect rect = CGRectMake(ox, oy,  [image.wpixel floatValue] / 2.0, [image.hpixel floatValue] / 2.0);
                            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
                            [imageView setImageWithURL:[NSURL URLWithString:image.imageUrl]];
                            [_myScrollView addSubview:imageView];
                            bOy = ([image.hpixel floatValue] / 2.0 + 7.0);
                            ox += ( [image.wpixel floatValue] / 2.0 + 7.0);
                        }
                    }else{
                        if ([image.wpixel floatValue] / 2.0 > (320 - 7.0 - ox)) {
                            oy += bOy;
                            ox = 7.0;
                            
                            if ([image.wpixel floatValue] /2.0 >= (320 - 14)) {
                                CGRect rect = CGRectMake(ox, oy,  (320 - 14), (320 - 14) * [image.hpixel floatValue] / [image.wpixel floatValue]);
                                UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
                                [imageView setImageWithURL:[NSURL URLWithString:image.imageUrl]];
                                [_myScrollView addSubview:imageView];
                                oy += (CGRectGetHeight(imageView.frame) + 7.0);
                                ox = 7.0;
                            }else{
                                CGRect rect = CGRectMake(ox, oy,  [image.wpixel floatValue] / 2.0, [image.hpixel floatValue] / 2.0);
                                UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
                                [imageView setImageWithURL:[NSURL URLWithString:image.imageUrl]];
                                [_myScrollView addSubview:imageView];
                                bOy += ( oy + [image.hpixel floatValue] / 2.0 + 7.0);
                                ox += ( [image.wpixel floatValue] / 2.0 + 7.0);
                            }
                        }else{
                            CGRect rect = CGRectMake(ox, oy,  [image.wpixel floatValue] / 2.0, [image.hpixel floatValue] / 2.0);
                            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
                            [imageView setImageWithURL:[NSURL URLWithString:image.imageUrl]];
                            [_myScrollView addSubview:imageView];
                            bOy += ( oy + [image.hpixel floatValue] / 2.0 + 7.0);
                            ox += ( [image.wpixel floatValue] / 2.0 + 7.0);
                        }
                    }
                    
                }];
            }
            ox = 7.0;
            oy += bOy;
            
            
            CGSize size = [HDM getContentFromString:info.description WithFont:[UIFont systemFontOfSize:12.0] ToSize:CGSizeMake(320 - 28, MAXFLOAT)];
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ox, oy, 320 - 14 , 7 + size.height + 7)];
            [view setBackgroundColor:COLORRGBA(255, 255, 255, 1.0)];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(7, 7, size.width, size.height)];
            [label setFont:[UIFont systemFontOfSize:12.0]];
            [label setNumberOfLines:0];
            [label setTextColor:[UIColor darkGrayColor]];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setText:info.description];
            [view addSubview:label];
            [_myScrollView addSubview:view];
            
            [_myScrollView setContentSize:CGSizeMake(CGRectGetWidth(_myScrollView.frame), view.frame.origin.y + CGRectGetHeight(view.frame) + 7.0)];

        }
    } failure:^(NSError *error) {
        [HDM errorPopMsg:error];
    }];
    
    [_myScrollView setContentSize:CGSizeMake(CGRectGetWidth(_myScrollView.frame), 504)];
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
