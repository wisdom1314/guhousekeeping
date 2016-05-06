//
//  ReviewModel.h
//  GuHouseKeeping
//
//  Created by David on 8/20/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseModel.h"

@interface ReviewModel : BaseModel
@property (nonatomic, strong) NSString *corpId;
@property (nonatomic, strong) NSString *optTime;
@property (nonatomic, strong) NSString *reviewId;
@property (nonatomic, strong) NSString *reviewTag;
@property (nonatomic, strong) NSString *reviewContent;
@property (nonatomic, strong) NSString *createUserId;
@property (nonatomic, strong) NSString *auntId;
@property (nonatomic, strong) NSString *createUserName;
@end
