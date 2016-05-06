//
//  GuHouseDataManager.h
//  GuHouseKeeping
//
//  Created by David on 7/5/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberInfoModel.h"
typedef enum {
    isAliPayDefault = 0,
    isAliPaySuccess,
    isAliPayFail
}AliPayAction;

@interface GuHouseDataManager : NSObject
@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSArray *searchKeys;
@property (nonatomic, assign) int bubbleNum;
@property (nonatomic, strong) MemberInfoModel *infoModel;
+ (id)sharedInstance;
-(BOOL)isEmail:(NSString *)email;
-(BOOL)isPhoneNum:(NSString*)honeNum;
- (CGSize)getContentFromString:(NSString *)content WithFont:(UIFont *)font ToSize:(CGSize)size;
- (void)errorPopMsg:(NSError *)error;
- (void)popHlintMsg:(NSString *)message;
- (void)popHlintMsg:(NSString *)message doneBlock:(void(^)(int select))doneBlock;
- (NSString *)jsonStringFromOjb:(id)obj;
@end
