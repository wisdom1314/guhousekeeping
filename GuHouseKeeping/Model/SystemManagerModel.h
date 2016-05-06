//
//  SystemManagerModel.h
//  GuHouseKeeping
//
//  Created by David on 8/20/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseModel.h"

@interface SystemManagerModel : BaseModel
@property (nonatomic, strong) NSString *corpId;
@property (nonatomic, strong) NSString *optTime;
@property (nonatomic, strong) NSString *mainPageTip;
@property (nonatomic, strong) NSString *hourlyUnitPrice;
@property (nonatomic, strong) NSString *houseUnitPrice;
@property (nonatomic, strong) NSString *pushInfoTime;
@property (nonatomic, strong) NSString *pushInfo;
@property (nonatomic, strong) NSString *pushInfoInterval;
@property (nonatomic, strong) NSString *searchKey;
@property (nonatomic, strong) NSString *appPhone;
@property (nonatomic, strong) NSString *appLogo;
@property (nonatomic, strong) NSString *couponUnitPrice;
@property (nonatomic, strong) NSArray *images;
//@property (nonatomic, strong) NSString *newHouseUnitPrice;

@end
