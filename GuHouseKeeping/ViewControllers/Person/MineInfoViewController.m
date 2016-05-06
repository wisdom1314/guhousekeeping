//
//  MineInfoViewController.m
//  GuHouseKeeping
//
//  Created by David on 7/10/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "MineInfoViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MineInfoViewController ()
@property (nonatomic, assign) CGRect keyboardRect;
@property (nonatomic, strong) MemberInfoModel *infoModel;
@end

@implementation MineInfoViewController
@synthesize keyboardRect = _keyboardRect;
@synthesize infoModel = _infoModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _iconIV.layer.borderWidth = 1.0f;
    _iconIV.layer.borderColor = [[UIColor whiteColor] CGColor];
    _iconIV.layer.cornerRadius = CGRectGetHeight(_iconIV.frame) / 2.0;
    _iconIV.layer.masksToBounds = YES;

    
    
//    _topView.layer.borderWidth = 1.0f;
//    _topView.layer.borderColor = [DARKGRAY CGColor];
//    
//    
//    NSString *string = @"标准费用 ¥50.00/m²";
//    CGSize size = [HDM getContentFromString:string WithFont:[UIFont systemFontOfSize:11.0] ToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
//    
//    [_topLabel setText:string];
//    [_topLabel setFrame:CGRectMake(_topLabel.frame.origin.x, _topLabel.frame.origin.y, size.width, CGRectGetHeight(_topLabel.frame))];
//    
//    [_topArrow setCenter:CGPointMake(_topLabel.frame.origin.x + size.width + 2 + CGRectGetWidth(_topArrow.frame), _topArrow.center.y)];
    
    _telContainView.layer.borderWidth = 1.0f;
    _telContainView.layer.cornerRadius = 3.0f;
    _telContainView.layer.borderColor = [DARKGRAY CGColor];
    _telContainView.layer.masksToBounds = YES;
    
   
    _nickContainView.layer.borderWidth = 1.0f;
    _nickContainView.layer.cornerRadius = 3.0f;
    _nickContainView.layer.borderColor = [DARKGRAY CGColor];
    _nickContainView.layer.masksToBounds = YES;
    
    
    
    _nameContainView.layer.borderWidth = 1.0f;
    _nameContainView.layer.cornerRadius = 3.0f;
    _nameContainView.layer.borderColor = [DARKGRAY CGColor];
    _nameContainView.layer.masksToBounds = YES;
    
    
    _addressContainView.layer.borderWidth = 1.0f;
    _addressContainView.layer.cornerRadius = 3.0f;
    _addressContainView.layer.borderColor = [DARKGRAY CGColor];
    _addressContainView.layer.masksToBounds = YES;
    
    [_myScrollView setContentSize:CGSizeMake(CGRectGetWidth(_myScrollView.frame), 600)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    [tap setDelegate:(id<UIGestureRecognizerDelegate>)self];
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    _telTF.userInteractionEnabled = NO;
    _nickTF.userInteractionEnabled = NO;
    _nameTF.userInteractionEnabled = NO;
    _addressTF.userInteractionEnabled = NO;
    
    [HHM postUserServiceFindMemberByMemberId:@{@"memberId": HDM.memberId} success:^(MemberInfoModel *infoModel) {
        if (infoModel) {
            DLog(@"%@", infoModel);
            [HDM setInfoModel:infoModel];

            [_iconIV setImageWithURL:[NSURL URLWithString:infoModel.imageUrl]];
            
            if ([infoModel.mobile isEqual:[NSNull null]] || ![infoModel.mobile length]) {

            }else{
                [_telTF setText:infoModel.mobile];
            }
            if ([infoModel.nickName isEqual:[NSNull null]] || ![infoModel.nickName length]) {
                
            }else{
                [_nickTF setText:infoModel.nickName];
            }
            if ([infoModel.userName isEqual:[NSNull null]] || ![infoModel.userName length]) {
                
            }else{
                [_nameTF setText:infoModel.userName];
            }
            if ([infoModel.address isEqual:[NSNull null]] || ![infoModel.address length]) {
                
            }else{
                [_addressTF setText:infoModel.address];
            }
            
            _infoModel = infoModel;
        }
    } failure:^(NSError *error) {
        [HDM errorPopMsg:error];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];

}

//- (void)keyWillShow:(NSNotification *)noti{
//    NSDictionary *userInfo = [noti userInfo];
//    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//    
//    float dis = 0;
//    if ([_nickTF isFirstResponder]) {
//        dis = fabsf(CGRectGetHeight(_myScrollView.frame) - _nickContainView.frame.origin.y - CGRectGetHeight(_nickContainView.frame) - CGRectGetHeight(keyboardRect));
//
//    }else if ([_nameTF isFirstResponder]){
//        dis = fabsf(CGRectGetHeight(_myScrollView.frame) - _nameContainView.frame.origin.y - CGRectGetHeight(_nameContainView.frame) - CGRectGetHeight(keyboardRect));
//    }else if ([_addressTV isFirstResponder]){
//        dis = fabsf(CGRectGetHeight(_myScrollView.frame) - _addressContainView.frame.origin.y - CGRectGetHeight(_addressContainView.frame) - CGRectGetHeight(keyboardRect));
//    }
//    
//    if (_myScrollView.contentOffset.y < dis) {
//        [_myScrollView setContentOffset:CGPointMake(0, dis) animated:YES];
//    }
//
//}

- (void)keyWillChange:(NSNotification *)noti{
    NSDictionary *userInfo = [noti userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    _keyboardRect = keyboardRect;
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self resetKeyBoard];
}

- (void)resetKeyBoard{
    float dis = 0;
    if ([_nickTF isFirstResponder]) {
        dis = fabsf(CGRectGetHeight(_myScrollView.frame) - _nickContainView.frame.origin.y - CGRectGetHeight(_nickContainView.frame) - CGRectGetHeight(_keyboardRect));
        
    }else if ([_nameTF isFirstResponder]){
        dis = fabsf(CGRectGetHeight(_myScrollView.frame) - _nameContainView.frame.origin.y - CGRectGetHeight(_nameContainView.frame) - CGRectGetHeight(_keyboardRect));
    }else if ([_addressTF isFirstResponder]){
        dis = fabsf(CGRectGetHeight(_myScrollView.frame) - _addressContainView.frame.origin.y - CGRectGetHeight(_addressContainView.frame) - CGRectGetHeight(_keyboardRect));
    }
    if (_myScrollView.contentOffset.y < dis) {
        [_myScrollView setContentOffset:CGPointMake(0, dis) animated:YES];
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    if (textField == _telTF) {
////        if (IS_IPHONE5) {
////            
////        }else{
//            [_myScrollView setContentOffset:CGPointMake(0, 137) animated:YES];
////        }
//    }else if (textField == _nickTF){
//        if (IS_IPHONE5) {
//            [_myScrollView setContentOffset:CGPointMake(0, 137) animated:YES];
//        }else{
//            [_myScrollView setContentOffset:CGPointMake(0, 203) animated:YES];
//        }
//    }else if (textField == _nameTF){
//        if (IS_IPHONE5) {
//            [_myScrollView setContentOffset:CGPointMake(0, 137) animated:YES];
//        }else{
//            [_myScrollView setContentOffset:CGPointMake(0, 267.5) animated:YES];
//        }
//    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self resetKeyBoard];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _telTF) {
        [_telTF resignFirstResponder];
        [_nickTF becomeFirstResponder];
    }else if (textField == _nickTF){
        [_nickTF resignFirstResponder];
        [_nameTF becomeFirstResponder];
    }else if (textField == _nameTF){
        [_nameTF resignFirstResponder];
        [_addressTF becomeFirstResponder];
    }else if (textField == _addressTF){
        [_addressTF resignFirstResponder];
    }
    
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView == _addressTV) {
        if (IS_IPHONE5) {
            [_myScrollView setContentOffset:CGPointMake(0, 137) animated:YES];
        }else{
            [_myScrollView setContentOffset:CGPointMake(0, 331.5) animated:YES];
        }
    }
    return YES;
} //contentOffset:在哪个点的内容视图的起源是从滚动视图的原点偏移




- (void)textViewDidChange:(UITextView *)textView{
    DLog(@"%@", _addressTV.text);
    textView.contentInset = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 0.0f);
    [textView setContentInset:UIEdgeInsetsZero];
    
    DLog(@"%f", _addressTV.contentInset.top);
    
    CGSize size = [HDM getContentFromString:_addressTV.text WithFont:[UIFont systemFontOfSize:15.0] ToSize:CGSizeMake(175.0, MAXFLOAT)];
//    size.width += 20;
    size.height += 10;
    if (size.height > 45) {
        size.height = 45;
    }
    
    DLog(@"%@", NSStringFromCGSize(size));
    
    [_addressTV setFrame:CGRectMake(_addressTV.frame.origin.x, (50.0 - size.height) / 2.0 -5, CGRectGetWidth(_addressTV.frame), size.height)];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    textView.contentOffset = CGPointMake(0, 0);
    [textView resignFirstResponder];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSLog(@"%@",[[touch view] class]);
    if ([[touch view] isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}

- (void)tap:(UITapGestureRecognizer *)recognizer{
    if ([_telTF isFirstResponder]) {
        [_telTF resignFirstResponder];
    }
    if ([_nickTF isFirstResponder]) {
        [_nickTF resignFirstResponder];
    }
    if ([_nameTF isFirstResponder]) {
        [_nameTF resignFirstResponder];
    }
//    if ([_addressTV isFirstResponder]) {
//        [_addressTV resignFirstResponder];
//    }
    
    if ([_addressTF isFirstResponder]) {
        [_addressTF resignFirstResponder];
    }
    [_myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeTitle{
    [_editButton setTitle:@"完成" forState:UIControlStateNormal];
}
- (IBAction)buttonClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    switch ([btn tag]) {
        case 0:{
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 1:{
            UIActionSheet *actionSheetStore = [[UIActionSheet alloc] initWithTitle:@"" delegate:(id<UIActionSheetDelegate>)self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
            [actionSheetStore setActionSheetStyle:UIActionSheetStyleBlackOpaque];
            [actionSheetStore showInView:self.view];
        }
            break;
        case 2:{
            DLog(@"编辑");
            
            if ([_editButton.titleLabel.text isEqualToString:@"编辑"]) {
                
                [self performSelector:@selector(changeTitle) withObject:nil afterDelay:0.5];
                _nickTF.userInteractionEnabled = YES;
                _nameTF.userInteractionEnabled = YES;
                _addressTF.userInteractionEnabled = YES;
                [_nickTF becomeFirstResponder];
            }else{
                [self tap:nil];
                
                if (!_infoModel) {
                    break;
                }
                
                //            if (![_telTF.text length]) {
                //                [HDM popHlintMsg:@"请输入手机号码！"];
                //                break;
                //            }
                //            if (![HDM isPhoneNum:_telTF.text]) {
                //                [HDM popHlintMsg:@"请输入正确的手机号码！"];
                //                break;
                //            }
                
                if (![_nickTF.text length]) {
                    [HDM popHlintMsg:@"请输入昵称！"];
                    break;
                }
                //            if (![_nameTF.text length]) {
                //                [HDM popHlintMsg:@"请输入名称！"];
                //                break;
                //            }
                
                
                self.view.userInteractionEnabled = NO;
                NSError *error = nil;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{
                                                                             @"userId": _infoModel.userId,
                                                                             @"mobile": _telTF.text,
                                                                             @"userName": _nameTF.text,
                                                                             @"nickname": _nickTF.text,
                                                                             @"address": _addressTF.text
                                                                             }
                                                                   options:NSJSONWritingPrettyPrinted
                                                                     error:&error];
                
                if (error) {
                    DLog(@"%@", error);
                    self.view.userInteractionEnabled = YES;
                }else{
                    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    DLog(@"json:%@", json);
                    
                    [HHM postUserServiceModifyMemberInfo:@{@"userInfo": json} success:^(NSString *info) {
                        if (info) {
                            DLog(@"%@", info);
                            if ([info isEqualToString:@"SUCCESS"]) {
                                [HDM popHlintMsg:@"用户修改信息成功！"];
                            }else{
                                [HDM popHlintMsg:@"用户修改信息失败！"];
                            }
                        }else{
                            [HDM popHlintMsg:@"用户修改信息失败！"];
                        }
                        self.view.userInteractionEnabled = YES;
                        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
                        _telTF.userInteractionEnabled = NO;
                        _nickTF.userInteractionEnabled = NO;
                        _nameTF.userInteractionEnabled = NO;
                        _addressTF.userInteractionEnabled = NO;
                    } failure:^(NSError *error) {
                        [HDM errorPopMsg:error];
                        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
                        _telTF.userInteractionEnabled = NO;
                        _nickTF.userInteractionEnabled = NO;
                        _nameTF.userInteractionEnabled = NO;
                        _addressTF.userInteractionEnabled = NO;
                        self.view.userInteractionEnabled = YES;
                    }];
                }
            }
            
            
        }
            break;
            
        case 3:{
            DLog(@"退出");
            
            [HDM popHlintMsg:@"是否要退出？" doneBlock:^(int select) {
                DLog(@"%d", select);
                if (select == 0) {
                    
                    [HHM postSystemServiceAppLogout:@{@"userId": HDM.memberId,
                                                      @"userType": @"MEMBER"} success:^(NSString *info) {
                        
                                                          if ([info isEqualToString:@"SUCCESS"]) {
                                                              [TMC removeObjectForKey:MEMBERID];
                                                              [HDM setMemberId:nil];
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                          }else{
                                                              [HDM popHlintMsg:@"退出失败"];
                                                          }
                    } failure:^(NSError *error) {
                        [HDM errorPopMsg:error];
                    }];
                    
                    
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            DLog(@"拍照");
            __block UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            [picker setDelegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)self];
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.showsCameraControls = YES;
                picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            }
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:^{
                picker = nil;
            }];
            
        }
            break;
        case 1:
        {
            DLog(@"从手机相册选择");
            __block UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            [picker setDelegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)self];
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:^{
                picker = nil;
            }];
        }
            break;
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *gotImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [_iconIV setImage:gotImage];
    NSData *originData = UIImageJPEGRepresentation(gotImage, 1.0);
    DLog(@"%d", [originData length]);
    
    int lenght = [originData length] ;
//    70000
    
    NSData *finalData = UIImageJPEGRepresentation(gotImage, 70000.0 / lenght);
    
    [HHM postUserServiceSaveImageObj:@{@"objId": HDM.memberId,
                                       @"objType": @"PORTRAIT",
                                       @"file": finalData} success:^(NSString *info) {
                                           if (info) {
                                               DLog(@"info: %@",  info);
                                               [HDM popHlintMsg:@"头像更新成功!"];
                                           }else{
                                               [HDM popHlintMsg:@"头像更新失败!"];

                                           }
    } failure:^(NSError *error) {
        [HDM errorPopMsg:error];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    DLog(@"%f", scrollView.contentOffset.y);
    
}


@end
