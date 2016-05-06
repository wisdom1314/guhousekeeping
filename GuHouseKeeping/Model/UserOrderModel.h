//
//  UserOrderModel.h
//  GuHouseKeeping
//
//  Created by David on 7/31/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseModel.h"

@interface UserOrderModel : BaseModel
@property (nonatomic, strong) NSString *corpId;
@property (nonatomic, strong) NSString *optTime;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *orderUse;
@property (nonatomic, strong) NSString *workTime;
@property (nonatomic, strong) NSString *workLength;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *unitPrice;
@property (nonatomic, strong) NSString *totalPrice;
@property (nonatomic, strong) NSString *actualPrice;
@property (nonatomic, strong) NSString *useCouponCount;
@property (nonatomic, strong) NSString *floorSpace;
@property (nonatomic, strong) NSString *orderStatus;
@property (nonatomic, strong) NSString *specialNeed;
@property (nonatomic, strong) NSString *contactWay;
@property (nonatomic, strong) NSString *auntId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *imageUrl;
@end
