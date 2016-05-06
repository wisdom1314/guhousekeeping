//
//  BaseModel.m
//  BaseModel
//
//  Created by David on 7/15/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
	NSLog(@"new key found ********* %@",key);
}

+ (id)instancefromJsonDic:(NSDictionary*)dic{
    id instance = nil;
    @try {
        instance = [[self alloc] init];
        NSArray *keys = [dic allKeys];
        for (NSString *key in keys) {
            id item = [dic objectForKey:key];
            if ([item isMemberOfClass:[NSNull class]]) {
                continue;
            } else if ([item isKindOfClass:[NSDictionary class]]) {
                //add another LC instance
            } else if ([item isKindOfClass:[NSArray class]]) {
                //add a LC instances array
                //                [instance setValue:item forKey:key];
            } else if ([item isKindOfClass:[NSNumber class]]){
                [instance setValue:[item stringValue] forKey:key];
            } else {
                [instance setValue:[item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:key];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Drat! Something wrong: %@", exception.reason);
    }
	return instance;
}

+ (NSArray *)instancesFromJsonArray:(NSArray *)array{
    NSMutableArray *instances = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        id o = [self instancefromJsonDic:dic];
        if (o) {
            [instances addObject:o];
        }
    }
    return [NSArray arrayWithArray:instances];
}


//*******************************************************************************************************/
// this encode the instacnec variables defined in the self class, the ones defined in super class in not
// included
//*******************************************************************************************************/

- (void)encodeIvarOfClass:(Class)class withCoder:(NSCoder *)coder
{
    //NSLog(@"encodeIvarOfClass %@", NSStringFromClass(class));
    unsigned int numIvars = 0;
    Ivar *ivars = class_copyIvarList(class, &numIvars);
    for (int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
        id value = [self valueForKey:key];
        if ([key hasPrefix:@"parent"]) {
            [coder encodeConditionalObject:value forKey:key];
        } else {
            [coder encodeObject:value forKey:key];
        }
        //NSLog(@"var name: %@\n", key);
    }
    if (ivars != NULL) { free(ivars); }
}

//*******************************************************************************************************/
// this encode the instacnec variables defined in the self class, then go on to play with variables defined
// in superclass when the superclass do not implement encodeWithCoder: the loop is broken
//*******************************************************************************************************/

- (void)continueEncodeIvarOfClass:(Class)class withCoder:(NSCoder *)coder
{
    if (class_respondsToSelector(class, @selector(encodeWithCoder:))) {
        [self encodeIvarOfClass:class withCoder:coder];
        [self continueEncodeIvarOfClass:class_getSuperclass(class) withCoder:coder];
    }
}

//*******************************************************************************************************/
// this is the function that the NSKeyedArchiver instance will call when the class instance need to be
// archived
//*******************************************************************************************************/

- (void)encodeWithCoder:(NSCoder *)coder {
    @autoreleasepool {
        [self continueEncodeIvarOfClass:[self class] withCoder:coder];
        
    }
}

//*******************************************************************************************************/
// this decode the instacnec variables defined in the self class, the ones defined in super class in not
// included
//*******************************************************************************************************/
- (void)decodeIvarOfClass:(Class)class withCoder:(NSCoder *)coder
{
    //NSLog(@"decodeIvarOfClass %@", NSStringFromClass(class));
    unsigned int numIvars = 0;
    Ivar * ivars = class_copyIvarList(class, &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        NSString * key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
        id value = [coder decodeObjectForKey:key];
        [self setValue:value forKey:key];
        //NSLog(@"var name: %@\n", key);
    }
    if (ivars != NULL) { free(ivars); }
}

//*******************************************************************************************************/
// this decode the instacnec variables defined in the self class, then go on to play with variables defined
// in superclass when the superclass do not implement initWithCoder: the loop is broken
//*******************************************************************************************************/

- (void)continueDecodeIvarOfClass:(Class)class withCoder:(NSCoder *)coder
{
    if (class_respondsToSelector(class, @selector(initWithCoder:))) {
        [self decodeIvarOfClass:class withCoder:coder];
        [self continueDecodeIvarOfClass:class_getSuperclass(class) withCoder:coder];
    }
}

//*******************************************************************************************************/
// this is the function that the NSKeyedUnarchiver instance will call when the class instance need to be
// unarchived
//*******************************************************************************************************/
- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    @autoreleasepool {
        [self continueDecodeIvarOfClass:[self class] withCoder:coder];
    }
	return self;
}
@end
