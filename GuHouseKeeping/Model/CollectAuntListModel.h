//
//  CollectAuntListModel.h
//  GuHouseKeeping
//
//  Created by David on 7/31/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseModel.h"

@interface CollectAuntListModel : BaseModel
@property (nonatomic, strong) NSString *pageNo;
@property (nonatomic, strong) NSString *pageSize;
@property (nonatomic, strong) NSString *autoCount;
@property (nonatomic, strong) NSString *autoPaging;
@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSString *totalPages;
@property (nonatomic, strong) NSString *hasNext;
@property (nonatomic, strong) NSString *nextPage;
@property (nonatomic, strong) NSString *hasPre;
@property (nonatomic, strong) NSString *prePage;
@property (nonatomic, strong) NSString *first;
@end
