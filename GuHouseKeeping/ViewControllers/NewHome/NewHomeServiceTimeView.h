//
//  NewHomeServiceTimeView.h
//  GuHouseKeeping
//
//  Created by David on 7/28/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewHomeServiceTimeViewDelegate <NSObject>

- (void)newHomeServiceTimeViewSelect:(NSString *)area;

@end

@interface NewHomeServiceTimeView : UIView
@property (strong, nonatomic) id<NewHomeServiceTimeViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *firstTableView;
@property (strong, nonatomic) IBOutlet UITableView *secondTableView;
@property (strong, nonatomic) IBOutlet UITableView *thirdTableView;
@property (strong, nonatomic) IBOutlet UITableView *forthTableView;
@property (strong, nonatomic) IBOutlet UITableView *fifthTableView;

- (IBAction)buttonClick:(id)sender;
- (void)reloadInputData:(NSDictionary *)dataDic;
@end
