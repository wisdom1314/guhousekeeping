//
//  SignModel.h
//  GuHouseKeeping
//
//  Created by David on 7/31/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseModel.h"

@interface SignModel : BaseModel
@property (nonatomic, strong) NSString *corpId;
@property (nonatomic, strong) NSString *optTime;
@property (nonatomic, strong) NSString *signId;
@property (nonatomic, strong) NSString *auntId;
@property (nonatomic, strong) NSString *signYear;
@property (nonatomic, strong) NSString *signDay;
@property (nonatomic, strong) NSString *signMonth;
@property (nonatomic, strong) NSString *signPlaceDesc;
@property (nonatomic, strong) NSString *signGeographic;
@end
