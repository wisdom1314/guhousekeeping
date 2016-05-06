//
//  ObtainVerifyCodeModel.h
//  GuHouseKeeping
//
//  Created by David on 7/29/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseModel.h"

@interface ObtainVerifyCodeModel : BaseModel
@property (nonatomic, strong) NSString *corpId;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *optTime;
@property (nonatomic, strong) NSString *token;
@end
