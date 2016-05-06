//
//  OrderDetailFootView.h
//  GuHouseKeeping
//
//  Created by David on 7/28/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailFootView : UIView
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIButton *useButton;
@property (strong, nonatomic) IBOutlet UILabel *useLabel;

@property (strong, nonatomic) IBOutlet UIButton *pausePurchaseButton;
@property (strong, nonatomic) IBOutlet UIButton *networkPurchaseButton;
@end
