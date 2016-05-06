//
//  CouponsViewController.h
//  GuHouseKeeping
//
//  Created by David on 7/10/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseViewController.h"


#import "ZBarReaderController.h"


//@class CouponsViewController;
//
//@protocol CouponsViewControllerDelegate <NSObject>
//
//@optional
//- (void)CouponsViewController:(CouponsViewController *)controller didScanResult:(NSString *)result;
//- (void)CouponsViewControllerDidCancel:(CouponsViewController*)controller;
//
//@end
@interface CouponsViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UIView *horizontalLine1;
@property (strong, nonatomic) IBOutlet UIView *horizontalLine2;

@property (strong, nonatomic) IBOutlet UITextField *serialNumberTF;

- (IBAction)buttonClick:(id)sender;

//@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
//@property (nonatomic, strong) AVCaptureSession *captureSession;
//@property (nonatomic, assign) id<CouponsViewControllerDelegate> delegate;
//@property (nonatomic, assign) BOOL isScanning;
//@property (nonatomic,copy)void(^ScanResult)(NSString*result,BOOL isSucceed);
////初始化函数
//-(id)initWithBlock:(void(^)(NSString*,BOOL))a;
//
////正则表达式对扫描结果筛选
//+(NSString*)zhengze:(NSString*)str;

@end
