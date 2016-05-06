//
//  CaseInfoModel.h
//  GuHouseKeeping
//
//  Created by David on 7/31/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseModel.h"

@interface CaseInfoModel : BaseModel
@property (nonatomic, strong) NSString *corpId;
@property (nonatomic, strong) NSString *optTime;
@property (nonatomic, strong) NSString *caseId;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *auntId;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSString *caseName;
@end
