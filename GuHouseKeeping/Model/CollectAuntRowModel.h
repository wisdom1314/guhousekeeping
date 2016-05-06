//
//  CollectAuntRowModel.h
//  GuHouseKeeping
//
//  Created by David on 7/31/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseModel.h"

@interface CollectAuntRowModel : BaseModel
@property (nonatomic, strong) NSString *corpId;
@property (nonatomic, strong) NSString *optTime;
@property (nonatomic, strong) NSString *collectId;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *auntId;
@property (nonatomic, strong) NSString *collectResult;
@end
