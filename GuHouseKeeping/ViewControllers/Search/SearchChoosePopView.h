//
//  SearchChoosePopView.h
//  GuHouseKeeping
//
//  Created by luyun on 14-7-26.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol searchChooseDelegate <NSObject>

- (void) setChooseWithkey:(NSString *)selectKey viewComeForm:(NSString *)comeForm;

@end

@interface SearchChoosePopView : UIView

- (id)initWithFrame:(CGRect)frame withTableViewFram:(CGRect)tableViewFrame tableViewArr:(NSArray *)tableViewArr viewComeForm:(NSString *)comeForm withIndex:(int)selectInt;
@property (nonatomic, strong) NSArray *tableViewArr;
@property (nonatomic, assign) NSInteger selectInt;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) id<searchChooseDelegate>searchDelegate;
@property (nonatomic, strong) NSString *comeFormStr;

@end
