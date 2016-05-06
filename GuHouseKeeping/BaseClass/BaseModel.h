//
//  BaseModel.h
//  GuHouseKeeping
//
//  Created by David on 4/30/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
+ (id)instancefromJsonDic:(NSDictionary*)dic;
+ (NSArray *)instancesFromJsonArray:(NSArray *)array;
@end
