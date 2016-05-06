//
//  GuHouseHTTPManager.h
//  GuHouseKeeping
//
//  Created by David on 7/5/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "AFHTTPClient.h"
#import "ObtainVerifyCodeModel.h"
#import "MemberInfoModel.h"
#import "AuntInfoModel.h"
#import "CaseInfoModel.h"
#import "CollectAuntListModel.h"
#import "AddCollectionModel.h"
#import "UserOrderModel.h"
#import "ReviewModel.h"
#import "SignModel.h"
#import "SystemManagerModel.h"
#import "FeedBackModel.h"
#import "PaymentModel.h"

@interface GuHouseHTTPManager : AFHTTPClient

+ (id)sharedInstance;

//1.获取注册验证码
- (void)postUserServiceObtainVerifyCode:(NSDictionary *)param
                                success:(void(^)(ObtainVerifyCodeModel *codeModel))success
                                failure:(void(^)(NSError *error))failure;
//2.验证注册码是否正确
- (void)postUserServiceCheckVerifyCode:(NSDictionary *)param
                               success:(void(^)(NSString *info))success
                               failure:(void(^)(NSError *error))failure;
//3.获取会员信息
- (void)postUserServiceFindMemberByMemberId:(NSDictionary *)param
                                    success:(void(^)(MemberInfoModel *infoModel))success
                                    failure:(void(^)(NSError *error))failure;
//4.修改个人信息
- (void)postUserServiceModifyMemberInfo:(NSDictionary *)param
                                success:(void(^)(NSString *info))success
                                failure:(void(^)(NSError *error))failure;

//5.设置阿姨信息推送频率
- (void)postUserServiceModifyPushAuntInfo:(NSDictionary *)param
                                  success:(void(^)(MemberInfoModel *info))success
                                  failure:(void(^)(NSError *error))failure;

//6.阿姨详情 需要加载案例（会员端）
- (void)postAuntServiceFindAuntByIdForMember:(NSDictionary *)param
                                     success:(void(^)(AuntInfoModel *info))success
                                     failure:(void(^)(NSError *error))failure;
//7.阿姨详情 需要加载统计信息（阿姨端）
- (void)postAuntServiceFindAuntByIdForAunt:(NSDictionary *)param
                                   success:(void(^)(AuntInfoModel *info))success
                                   failure:(void(^)(NSError *error))failure;
//8.工作效果详情
- (void)postAuntServiceFindCaseById:(NSDictionary *)param
                            success:(void(^)(CaseInfoModel *info))success
                            failure:(void(^)(NSError *error))failure;
//9.阿姨评论列表
- (void)postAuntServiceFindReviewByAuntId:(NSDictionary *)param
                            success:(void(^)(NSArray *info, BOOL hasNext))success
                            failure:(void(^)(NSError *error))failure;

//11.我收藏的阿姨
- (void)postCollectAuntServiceFindCollectAuntList:(NSDictionary *)param
                                          success:(void(^)(NSArray *info))success
                                          failure:(void(^)(NSError *error))failure;

//12.收藏阿姨
- (void)postCollectAuntServiceAddCollect:(NSDictionary *)param
                     success:(void(^)(AddCollectionModel *info))success
                     failure:(void(^)(NSError *error))failure;
//13.新增|修改订单
- (void)postOrderServiceSaveUserOrder:(NSDictionary *)param
                              success:(void(^)(UserOrderModel *info))success
                              failure:(void(^)(NSError *error))failure;
//14.获取用户订单列表
- (void)postOrderServiceFindOrderList:(NSDictionary *)param
                              success:(void(^)(NSArray *info, BOOL hasNext))success
                              failure:(void(^)(NSError *error))failure;
//15.获取订单详情（会员端阿姨端通用）
- (void)postOrderServiceFindOrderById:(NSDictionary *)param
                              success:(void(^)(UserOrderModel *info))success
                              failure:(void(^)(NSError *error))failure;
//16.删除订单
- (void)postOrderServiceDeleteOrder:(NSDictionary *)param
                              success:(void(^)(NSString *info))success
                              failure:(void(^)(NSError *error))failure;
//17.添加评论
- (void)postReviewServiceAddReview:(NSDictionary *)param
                           success:(void(^)(ReviewModel *info))success
                           failure:(void(^)(NSError *error))failure;

//19.更新apk
- (void)postSystemServiceUpdateAPK:(NSDictionary *)param
                           success:(void(^)(SignModel *info))success
                           failure:(void(^)(NSError *error))failure;

//22.获取系统设置信息（会员端首页）
- (void)postSystemServiceFindSystemManageSuccess:(void(^)(SystemManagerModel *info))success
                                         failure:(void(^)(NSError *error))failure;

//23.保存意见反馈
- (void)postSystemServiceSaveFeedBack:(NSDictionary *)param
                              success:(void(^)(FeedBackModel *info))success
                              failure:(void(^)(NSError *error))failure;


//24. 批量删除订单
- (void)postOrderServiceDeleteOrderBatch:(NSDictionary *)param
                                 success:(void(^)(NSString *info))success
                                 failure:(void(^)(NSError *error))failure;

//25.移动端退出登录 (阿姨端、会员端)
- (void)postSystemServiceAppLogout:(NSDictionary *)param
                           success:(void(^)(NSString *info))success
                           failure:(void(^)(NSError *error))failure;

//26.查询相应类型订单数量
- (void)postOrderServiceFindOrderCountsByMemberIdAndType:(NSDictionary *)param
                                                 success:(void(^)(NSString *info))success
                                                 failure:(void(^)(NSError *error))failure;

//27.根据条件查询阿姨列表
- (void)postSearchAuntByCondition:(NSDictionary *)param
                          success:(void(^)(NSArray *info, BOOL hasNext))success
                           failure:(void(^)(NSError *error))failure;

//30.手机支付接口
- (void)postOrderServicePayment:(NSDictionary *)param
                           success:(void(^)(PaymentModel *info))success
                           failure:(void(^)(NSError *error))failure;

//31.删除收藏的阿姨
- (void)postCollectAuntServiceDeleteCollectAunt:(NSDictionary *)param
                                        success:(void(^)(NSString *info))success
                                        failure:(void(^)(NSError *error))failure;

//32.会员卡购买接口
- (void)postOrderServiceToPayMentUserInfo:(NSDictionary *)param
                                  success:(void(^)(PaymentModel *info))success
                                  failure:(void(^)(NSError *error))failure;


- (void)postUserServiceSaveImageObj:(NSDictionary *)param
                            success:(void(^)(NSString *info))success
                            failure:(void(^)(NSError *error))failure;
@end






