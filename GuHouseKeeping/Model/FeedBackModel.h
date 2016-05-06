//
//  FeedBackModel.h
//  GuHouseKeeping
//
//  Created by David on 8/20/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseModel.h"

@interface FeedBackModel : BaseModel
@property (nonatomic, strong) NSString *corpId;
@property (nonatomic, strong) NSString *optTime;
@property (nonatomic, strong) NSString *feedbackId;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *auntId;
@property (nonatomic, strong) NSString *content;
@end
