//
//  NewHomeServiceDuirationView.h
//  GuHouseKeeping
//
//  Created by David on 7/30/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewHomeServiceDurationViewDelegate <NSObject>

- (void)newHomeServiceDurationViewSelect:(NSString *)time;

@end

@interface NewHomeServiceDurationView : UIView
@property (strong, nonatomic) id<NewHomeServiceDurationViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UITableView *firstTableView;
- (IBAction)buttonClick:(id)sender;
- (void)reloadInputData:(NSDictionary *)dataDic;
@end
