//
//  MemberInfoModel.h
//  GuHouseKeeping
//
//  Created by David on 7/29/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseModel.h"

@interface MemberInfoModel : BaseModel
@property (nonatomic, strong) NSString *corpId;
@property (nonatomic, strong) NSString *optTime;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *card;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *couponCounts;
@property (nonatomic, strong) NSString *couponEndTime;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *pushAuntInfo;
@property (nonatomic, strong) NSString *auntList;
@property (nonatomic, strong) NSString *orderCount;
@property (nonatomic, strong) NSString *notPayedOrderCount;
@property (nonatomic, strong) NSString *couponUseCounts;
@property (nonatomic, strong) NSString *payedOrderCount;
@property (nonatomic, strong) NSString *imageUrl;

@end
