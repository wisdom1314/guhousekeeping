//
//  GuHouseDataManager.m
//  GuHouseKeeping
//
//  Created by David on 7/5/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "GuHouseDataManager.h"

typedef void(^DoneBlock)(int select);
@interface GuHouseDataManager()
@property (nonatomic, copy) DoneBlock doneBlock;
@property (nonatomic, strong) UIView *alterView;
@property (nonatomic, strong) UILabel *alterLabel;
@end


@implementation GuHouseDataManager
@synthesize doneBlock = _doneBlock;
@synthesize nav = _nav;
@synthesize memberId = _memberId;
@synthesize alterView = _alterView;
@synthesize alterLabel = _alterLabel;
@synthesize searchKeys = _searchKeys;
@synthesize infoModel = _infoModel;

+ (id)sharedInstance{
    static GuHouseDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GuHouseDataManager alloc] init];
        manager.nav = [[UINavigationController alloc] init];
        [manager.nav setDelegate:(id<UINavigationControllerDelegate>)manager];
        [manager.nav setNavigationBarHidden:YES];
    });
    return manager;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (animated) {
        DLog(@"willShowViewController animated:%@", [[viewController class] description]);
    }else{
        DLog(@"willShowViewController:%@", [[viewController class] description]);
    }
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (animated) {
        DLog(@"didShowViewController animated:%@", [[viewController class] description]);
    }else{
        DLog(@"didShowViewController:%@", [[viewController class] description]);
    }
}

-(BOOL)isEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(BOOL)isPhoneNum:(NSString*)honeNum{
    //    NSString *telphone = @"^(1(([35][0-9])|(47)|[8][012356789]))\\d{8}$";
    //    NSString *telphone = @"^(1(([0-9][0-9])|(47)|[8][012356789]))\\d{8}$";
    NSString *telphone = @"^(1(([357][0-9])|(47)|[8][012356789]))\\d{8}$";
    NSPredicate *telphoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telphone];
    return [telphoneTest evaluateWithObject:honeNum];
}
- (CGSize)getContentFromString:(NSString *)content WithFont:(UIFont *)font ToSize:(CGSize)size{
    size.height = MAXFLOAT;
    if ([content respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        return [content boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName: font}
                                     context:nil].size;
        
    }else{
        return [content sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
}

- (void)errorPopMsg:(NSError *)error{
    DLog(@"%@----%d",error,error.code);
    if ([error code] == -1004) {
        [self popHlintMsg:HTTPConnectSeverError];
    }else if ([error code] == -1001){
        [self popHlintMsg:HTTPConnectOutOfTime];
    }else{
        [self popHlintMsg:HTTPConnectFaildError];
    }
}

- (void)createAlphaView:(NSString *)alter{
    if (!_alterView) {
        UIView *keyWidow = [[UIApplication sharedApplication] keyWindow];
        _alterView.layer.cornerRadius=15;
        _alterView.layer.masksToBounds = YES;
        _alterView = [[UIView alloc] initWithFrame:keyWidow.bounds];
        [_alterView setBackgroundColor:[UIColor clearColor]];
        [keyWidow addSubview:_alterView];
        
        UIView * alphaView = [[UIView alloc] initWithFrame:keyWidow.bounds];
        [alphaView setBackgroundColor:[UIColor blackColor]];
        [alphaView setAlpha:0.3];
        [_alterView addSubview:alphaView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tap.numberOfTapsRequired = 1;
        [tap setDelegate:(id<UIGestureRecognizerDelegate>)self];
        tap.numberOfTouchesRequired = 1;
        [_alterView addGestureRecognizer:tap];
    }
    
    if (!_alterLabel) {
        _alterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 392 / 2.0, 270 /2.0)];
          //_alterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 392, 270)];
        [_alterLabel setBackgroundColor:[UIColor whiteColor]];
        [_alterLabel setTextColor:PURPLECOLOR];
        _alterLabel.layer.cornerRadius=15;
       _alterLabel.layer.masksToBounds = YES;
        [_alterLabel setTextAlignment:NSTextAlignmentCenter];
        [_alterLabel setNumberOfLines:0];
        [_alterLabel setCenter:CGPointMake(CGRectGetWidth(_alterView.frame) / 2.0, CGRectGetHeight(_alterView.frame) / 2.0)];
        [_alterView addSubview:_alterLabel];
    }
    [_alterLabel setText:alter];
    
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSLog(@"%@",[[touch view] class]);
    if ([[touch view] isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}

- (void)tap:(UITapGestureRecognizer *)recognizer{
    if (_alterView) {
        [_alterView removeFromSuperview];
        _alterView = nil;
    }
    if (_alterLabel) {
        [_alterLabel removeFromSuperview];
        _alterLabel = nil;
    }
}


- (void)popHlintMsg:(NSString *)message{
//    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alter show];
//    
    [self createAlphaView:message];
}

- (void)popHlintMsg:(NSString *)message doneBlock:(void (^)(int))doneBlock{
    if (doneBlock) {
        _doneBlock = doneBlock;
    }
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alter show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    DLog(@"buttonIndex:%d", buttonIndex);
    if (_doneBlock) {
        _doneBlock(buttonIndex);
    }
}


- (NSString *)jsonStringFromOjb:(id)obj{
    NSString *jsonString = @"";
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error) {
        DLog(@"%@", error);
    }else{
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        DLog(@"json:%@", jsonString);
    }
    return jsonString;
}
@end
