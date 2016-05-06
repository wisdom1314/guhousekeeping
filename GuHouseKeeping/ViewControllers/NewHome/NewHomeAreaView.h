//
//  NewHomeAreaView.h
//  GuHouseKeeping
//
//  Created by David on 7/28/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewHomeAreaViewDelegate <NSObject>

- (void)newHomeAreaViewSelect:(NSString *)area;

@end

@interface NewHomeAreaView : UIView
@property (strong, nonatomic) id<NewHomeAreaViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UITableView *firstTableView;
@property (strong, nonatomic) IBOutlet UITableView *secondTableView;
@property (strong, nonatomic) IBOutlet UITableView *thirdTableView;
@property (strong, nonatomic) IBOutlet UITableView *forthTableView;

- (IBAction)buttonClick:(id)sender;

- (void)reloadInputData:(NSDictionary *)dataDic;

@end
