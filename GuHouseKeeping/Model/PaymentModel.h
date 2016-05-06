//
//  PaymentModel.h
//  GuHouseKeeping
//
//  Created by David on 9/29/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseModel.h"

@interface PaymentModel : BaseModel
@property (nonatomic, strong) NSString *_input_charset;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *it_b_pay;
@property (nonatomic, strong) NSString *notify_url;
@property (nonatomic, strong) NSString *out_trade_no;
@property (nonatomic, strong) NSString *partner;
@property (nonatomic, strong) NSString *payment_type;
@property (nonatomic, strong) NSString *return_url;
@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *service;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *total_fee;
@end
