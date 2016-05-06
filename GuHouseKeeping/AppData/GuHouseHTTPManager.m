//
//  GuHouseHTTPManager.m
//  GuHouseKeeping
//
//  Created by David on 7/5/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "GuHouseHTTPManager.h"
#import "CollectAuntRowModel.h"
#import "ImageModel.h"

@implementation GuHouseHTTPManager

+ (id)sharedInstance{
    static GuHouseHTTPManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        @"http://115.29.246.202:8080/hw/"
//        @"http://203.195.131.34:8081/hw/"
        manager = [[GuHouseHTTPManager alloc] initWithBaseURL:[NSURL URLWithString:HTTPBaseURL]];
    });
    return manager;
}


- (void)startNetworkActivityIndicatorVisible{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)stopNetworkActivityIndicatorVisible{
    __block BOOL check = NO;
    [self.operationQueue.operations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSOperation *operation = (NSOperation *)obj;
        
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]] && [operation isExecuting]) {
            check = YES;
        }
    }];
    if (!check) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (void)postBaseWithPath:(NSString *)path
              parameters:(NSDictionary *)param
                  isJsonEncode:(BOOL)isJson
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure{
    
    DLog(@"path:%@============param：%@", path, param);
    
    [self startNetworkActivityIndicatorVisible];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"POST"
                                                      path:path
                                                parameters:param];
    
    [request setTimeoutInterval:30.f];
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                          if (responseObject) {
                                                                              
                                                                              if (!isJson) {
                                                                                  NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                                                                  DLog(@"jsonString:%@", jsonString);
                                                                                  success(jsonString);
                                                                              }else{
                                                                                  NSError *error = nil;
                                                                                  
                                                                                  id jsonObjcet = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                                                  options:NSJSONReadingMutableLeaves
                                                                                                                                    error:&error];
                                                                                  DLog(@"jsonObjcet：%@", jsonObjcet);
                                                                                  if (error) {
                                                                                      if (success) {
                                                                                          success(nil);
                                                                                      }
                                                                                  }else{
                                                                                      if (success) {
                                                                                          success(jsonObjcet);
                                                                                      }
                                                                                  }
                                                                              }
                                                                              
                                                                              
                                                                              
                                                                              
                                                                              
                                                                          }else{
                                                                              if (success) {
                                                                                  success(nil);
                                                                              }
                                                                          }
                                                                          
                                                                          [self stopNetworkActivityIndicatorVisible];
                                                                          
                                                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                          if (failure) {
                                                                              failure(error);
                                                                          }
                                                                          
                                                                          [self stopNetworkActivityIndicatorVisible];
                                                                          
                                                                      }];
    [self enqueueHTTPRequestOperation:operation];
}


- (void)postUserServiceObtainVerifyCode:(NSDictionary *)param success:(void (^)(ObtainVerifyCodeModel *))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"UserService/obtainVerifyCode" parameters:param isJsonEncode:YES  success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            success([ObtainVerifyCodeModel instancefromJsonDic:responseObject]);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postUserServiceCheckVerifyCode:(NSDictionary *)param success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"UserService/checkVerifyCode" parameters:param isJsonEncode:NO success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postUserServiceFindMemberByMemberId:(NSDictionary *)param success:(void (^)(MemberInfoModel *))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"UserService/findMemberByMemberId" parameters:param isJsonEncode:YES success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            MemberInfoModel *info = [MemberInfoModel instancefromJsonDic:responseObject];
            if ([[responseObject allKeys] containsObject:@"imageObj"]) {
                id imageObj = responseObject[@"imageObj"];
                if ([imageObj isKindOfClass:[NSDictionary class]] && [[imageObj allKeys] containsObject:@"imageUrl"]) {
                    [info setImageUrl:ImageBaseURL(imageObj[@"imageUrl"])];
                }
            }
            success(info);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postUserServiceModifyMemberInfo:(NSDictionary *)param success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"UserService/modifyMemberInfo" parameters:param isJsonEncode:NO success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postUserServiceModifyPushAuntInfo:(NSDictionary *)param success:(void (^)(MemberInfoModel *))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"UserService/modifyPushAuntInfo" parameters:param isJsonEncode:YES success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            success([MemberInfoModel instancefromJsonDic:responseObject]);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


- (void)postAuntServiceFindAuntByIdForMember:(NSDictionary *)param success:(void (^)(AuntInfoModel *))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"AuntService/findAuntByIdForMember" parameters:param isJsonEncode:YES success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            AuntInfoModel *info = [AuntInfoModel instancefromJsonDic:responseObject];
            
            if ([[responseObject allKeys] containsObject:@"imageObj"] && [responseObject[@"imageObj"] isKindOfClass:[NSDictionary class]]) {
                id imageObj = responseObject[@"imageObj"];
                if ([[imageObj allKeys] containsObject:@"imageUrl"]) {
                    [info setImageUrl:ImageBaseURL(imageObj[@"imageUrl"])];
                }
            }

//            NSMutableArray *arr = [[NSMutableArray alloc] init];
//            if ([[responseObject allKeys] containsObject:@"caseList"]) {
//                id caseList = [responseObject objectForKey:@"caseList"];
//                if ([caseList isKindOfClass:[NSArray class]]) {
//                    [caseList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                        CaseInfoModel *tmpInfo = [CaseInfoModel instancefromJsonDic:obj];
//                        if ([[obj allKeys] containsObject:@"description"]) {
//                            [tmpInfo set_description:obj[@"description"]];
//                        }
//                        [arr addObject:tmpInfo];
//                    }];
//                }
//            }
//            
//            [info setCaseList:arr];
            if ([[responseObject allKeys] containsObject:@"caseList"]) {
                id caseList = [responseObject objectForKey:@"caseList"];
                if ([caseList isKindOfClass:[NSArray class]]) {
                    [info setCaseList:[CaseInfoModel instancesFromJsonArray:caseList]];
                }
            }
            success(info);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postAuntServiceFindAuntByIdForAunt:(NSDictionary *)param success:(void (^)(AuntInfoModel *))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"AuntService/findAuntByIdForAunt" parameters:param isJsonEncode:YES success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            AuntInfoModel *info = [AuntInfoModel instancefromJsonDic:responseObject];
            if ([[responseObject allKeys] containsObject:@"caseList"]) {
                id caseList = [responseObject objectForKey:@"caseList"];
                if ([caseList isKindOfClass:[NSArray class]]) {
                    [info setCaseList:[CaseInfoModel instancesFromJsonArray:caseList]];
                }
            }
            success(info);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postAuntServiceFindCaseById:(NSDictionary *)param
                            success:(void(^)(CaseInfoModel *info))success
                            failure:(void(^)(NSError *error))failure{
    [self postBaseWithPath:@"AuntService/findCaseById" parameters:param isJsonEncode:YES success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            CaseInfoModel *info = [CaseInfoModel instancefromJsonDic:responseObject];
            if ([[responseObject allKeys] containsObject:@"images"] && [responseObject[@"images"] isKindOfClass:[NSArray class]]) {
                
                NSMutableArray *tmpImages = [[NSMutableArray alloc] init];
                
                [responseObject[@"images"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    ImageModel *image = [ImageModel instancefromJsonDic:obj];
                    if ([image.wpixel floatValue] == 0 || [image.hpixel floatValue] == 0) {
                    
                    }else{
                        [image setImageUrl:ImageBaseURL(obj[@"imageUrl"])];
                        [tmpImages addObject:image];
                    }
                }];
                
                [info setImages:tmpImages];
            }
            success(info);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postAuntServiceFindReviewByAuntId:(NSDictionary *)param
                                  success:(void(^)(NSArray *info, BOOL hasNext))success
                                  failure:(void(^)(NSError *error))failure{
    [self postBaseWithPath:@"AuntService/findReviewByAuntId" parameters:param isJsonEncode:YES success:^(id responseObject) {
        NSArray *info = nil;
        BOOL hasNext = NO;
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            if ([[responseObject allKeys] containsObject:@"rows"]) {
                id rows = responseObject[@"rows"];
                if ([rows isKindOfClass:[NSArray class]]) {
                    info = [ReviewModel instancesFromJsonArray:rows];
                }
            }
            if ([[responseObject allKeys] containsObject:@"hasNext"]) {
                hasNext = [responseObject[@"hasNext"] boolValue];
            }
            success(info, hasNext);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postCollectAuntServiceFindCollectAuntList:(NSDictionary *)param success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"CollectAuntService/findCollectAuntList" parameters:param isJsonEncode:YES success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            if ([[responseObject allKeys] containsObject:@"rows"]) {
                id rows = [responseObject objectForKey:@"rows"];
                if ([rows isKindOfClass:[NSArray class]]) {
                    [rows enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if ([obj isKindOfClass:[NSDictionary class]] && [[obj allKeys] containsObject:@"auntInfo"]) {
                            id auntInfo = obj[@"auntInfo"];
                            AuntInfoModel *info = [AuntInfoModel instancefromJsonDic:auntInfo];
                            if ([[obj allKeys] containsObject:@"collectId"]) {
                                [info setCollectId:obj[@"collectId"]];
                            }
                            if ([[auntInfo allKeys] containsObject:@"imageObj"] && [auntInfo[@"imageObj"] isKindOfClass:[NSDictionary class]]) {
                                id imageObj = auntInfo[@"imageObj"];
                                if ([[imageObj allKeys] containsObject:@"imageUrl"]) {
                                    [info setImageUrl:ImageBaseURL(imageObj[@"imageUrl"])];
                                }
                            }
                            [arr addObject:info];
                        }
                    }];

                }
            }
            success(arr);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postCollectAuntServiceAddCollect:(NSDictionary *)param success:(void (^)(AddCollectionModel *))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"CollectAuntService/addCollect" parameters:param isJsonEncode:YES success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            AddCollectionModel *info = [AddCollectionModel instancefromJsonDic:responseObject];
            success(info);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postOrderServiceSaveUserOrder:(NSDictionary *)param success:(void (^)(UserOrderModel *))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"OrderService/saveUserOrder" parameters:param isJsonEncode:YES success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            UserOrderModel *info = [UserOrderModel instancefromJsonDic:responseObject];
            success(info);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postOrderServiceFindOrderList:(NSDictionary *)param success:(void (^)(NSArray *, BOOL))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"OrderService/findOrderList" parameters:param isJsonEncode:YES success:^(id responseObject) {
        NSMutableArray *info = [[NSMutableArray alloc] init];
        BOOL hasNext = NO;
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            if ([[responseObject allKeys] containsObject:@"rows"]) {
                id rows = responseObject[@"rows"];
                if ([rows isKindOfClass:[NSArray class]]) {
                    [rows enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if ([obj isKindOfClass:[NSDictionary class]]) {
                            UserOrderModel *order = [UserOrderModel instancefromJsonDic:obj];
                            if ([[obj allKeys] containsObject:@"auntInfo"] && [obj[@"auntInfo"] isKindOfClass:[NSDictionary class]]) {
                                id auntInfo = obj[@"auntInfo"];
                                if ([auntInfo isKindOfClass:[NSDictionary class]] && [[auntInfo allKeys] containsObject:@"imageObj"]) {
                                    id imageObj = auntInfo[@"imageObj"];
                                    if ([imageObj isKindOfClass:[NSDictionary class]] && [[imageObj allKeys]containsObject:@"imageUrl"]) {
                                        [order setImageUrl:ImageBaseURL(imageObj[@"imageUrl"])];
                                    }
                                }
                            }
                            [info addObject:order];
                        }
                    }];
                }
            }
            if ([[responseObject allKeys] containsObject:@"hasNext"]) {
                hasNext = [responseObject[@"hasNext"] boolValue];
            }
            success(info, hasNext);
        }

    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postOrderServiceFindOrderById:(NSDictionary *)param success:(void (^)(UserOrderModel *))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"OrderService/findOrderById" parameters:param isJsonEncode:YES success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            UserOrderModel *info = [UserOrderModel instancefromJsonDic:responseObject];
            success(info);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postOrderServiceDeleteOrder:(NSDictionary *)param success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"OrderService/deleteOrder" parameters:param isJsonEncode:NO success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postReviewServiceAddReview:(NSDictionary *)param success:(void (^)(ReviewModel *))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"ReviewService/addReview" parameters:param isJsonEncode:YES success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            ReviewModel *info = [ReviewModel instancefromJsonDic:responseObject];
            success(info);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


- (void)postSystemServiceUpdateAPK:(NSDictionary *)param success:(void (^)(SignModel *))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"SystemService/updateAPK" parameters:param isJsonEncode:YES success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
//            SignModel *info = [SignModel instancefromJsonDic:responseObject];
//            success(info);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


- (void)postSystemServiceFindSystemManageSuccess:(void (^)(SystemManagerModel *))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"SystemService/findSystemManage" parameters:nil isJsonEncode:YES success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"responseObject##############%@", responseObject);
            SystemManagerModel *info = [SystemManagerModel instancefromJsonDic:responseObject];
            if ([[responseObject allKeys] containsObject:@"newHouseUnitPrice"]) {
                [info setHouseUnitPrice:[NSString stringWithFormat:@"%@", responseObject[@"newHouseUnitPrice"]]];
            }
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            
            if ([[responseObject allKeys] containsObject:@"images"] && [responseObject[@"images"] isKindOfClass:[NSArray class]]) {
                [responseObject[@"images"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([obj isKindOfClass:[NSDictionary class]] && [[obj allKeys] containsObject:@"imageUrl"]) {
                        [arr addObject:ImageBaseURL(obj[@"imageUrl"])];
                    }
                }];
            }
            [info setImages:arr];
            success(info);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postSystemServiceSaveFeedBack:(NSDictionary *)param
                              success:(void(^)(FeedBackModel *info))success
                              failure:(void(^)(NSError *error))failure{
        [self postBaseWithPath:@"SystemService/saveFeedBack" parameters:param isJsonEncode:YES success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            FeedBackModel *info = [FeedBackModel instancefromJsonDic:responseObject];
            success(info);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postOrderServiceDeleteOrderBatch:(NSDictionary *)param
                                 success:(void(^)(NSString *info))success
                                 failure:(void(^)(NSError *error))failure{
    [self postBaseWithPath:@"OrderService/deleteOrderBatch" parameters:param isJsonEncode:NO success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postSystemServiceAppLogout:(NSDictionary *)param success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"SystemService/appLogout" parameters:param isJsonEncode:NO success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postOrderServiceFindOrderCountsByMemberIdAndType:(NSDictionary *)param success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"OrderService/findOrderCountsByMemberIdAndType" parameters:param isJsonEncode:NO success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postSearchAuntByCondition:(NSDictionary *)param success:(void (^)(NSArray *, BOOL))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"AuntService/searchAuntByCondition" parameters:param isJsonEncode:YES success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            
//            AuntInfoModel *info = [AuntInfoModel instancefromJsonDic:responseObject];
//            if ([[responseObject allKeys] containsObject:@"caseList"]) {
//                id caseList = [responseObject objectForKey:@"caseList"];
//                if ([caseList isKindOfClass:[NSArray class]]) {
//                    [info setCaseList:[CaseInfoModel instancesFromJsonArray:caseList]];
//                }
//            }
            
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            BOOL hasNext = NO;
            if (responseObject && success) {
                DLog(@"%@", responseObject);
                if ([[responseObject allKeys] containsObject:@"rows"]) {
                    id rows = [responseObject objectForKey:@"rows"];
                    if ([rows isKindOfClass:[NSArray class]]) {
                        [rows enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            if ([obj isKindOfClass:[NSDictionary class]]) {
                                AuntInfoModel *info = [AuntInfoModel instancefromJsonDic:obj];
                                if ([[obj allKeys] containsObject:@"imageObj"] && [obj[@"imageObj"] isKindOfClass:[NSDictionary class]]) {
                                    id imageObj = obj[@"imageObj"];
                                    if ([[imageObj allKeys] containsObject:@"imageUrl"]) {
                                        [info setImageUrl:ImageBaseURL(imageObj[@"imageUrl"])];
                                    }
                                }
                                DLog(@"info:%@", info.userName);
                                [arr addObject:info];
                            }
                        }];
                    }
                }

                if ([[responseObject allKeys] containsObject:@"hasNext"]) {
                    hasNext = [responseObject[@"hasNext"] boolValue];
                }
                success(arr, hasNext);
            }
            
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postOrderServicePayment:(NSDictionary *)param success:(void (^)(PaymentModel *))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"OrderService/toPayMentJson" parameters:param isJsonEncode:YES success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            success([PaymentModel instancefromJsonDic:responseObject]);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postCollectAuntServiceDeleteCollectAunt:(NSDictionary *)param success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"CollectAuntService/deleteCollectAunt" parameters:param isJsonEncode:NO success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postOrderServiceToPayMentUserInfo:(NSDictionary *)param success:(void (^)(PaymentModel *))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"UserService/toPayMentUserInfoJson" parameters:param isJsonEncode:YES success:^(id responseObject) {
        if (responseObject && success) {
            DLog(@"%@", responseObject);
            success([PaymentModel instancefromJsonDic:responseObject]);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postUserServiceSaveImageObj:(NSDictionary *)param success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure{
    [self startNetworkActivityIndicatorVisible];
    NSURLRequest *request = [self multipartFormRequestWithMethod:@"POST"
                                                            path:@"UserService/saveImageObj"
                                                      parameters:@{@"objId":param[@"objId"],
                                                                   @"objType": param[@"objType"]}
                                       constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                           if (param) {
                                               [formData appendPartWithFileData:param[@"file"]
                                                                           name:@"file"
                                                                       fileName:@"avatar.png"
                                                                       mimeType:@"image/png"];
                                           }
                                       }];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                          if (success) {
                                                                              DLog(@"%@", responseObject);
//                                                                              NSError *error = nil;
//                                                                              
//                                                                              id jsonObjcet = [NSJSONSerialization JSONObjectWithData:responseObject
//                                                                                                                              options:NSJSONReadingMutableContainers
//                                                                                                                                error:&error];
//                                                                              DLog(@"jsonObjcet：%@", jsonObjcet);
//                                                                              
//                                                                              if (error) {
//                                                                                  success(nil);
//                                                                              }else{
//                                                                                  
//                                                                                  
//                                                                              }
                                                                              NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                                                              DLog(@"jsonString:%@", jsonString);
                                                                              success(jsonString);
                                                                          }
                                                                          
                                                                          [self stopNetworkActivityIndicatorVisible];
                                                                          
                                                                      }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                          if (failure) {
                                                                              failure(error);
                                                                          }
                                                                          [self stopNetworkActivityIndicatorVisible];
                                                                      }];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        float progress = totalBytesWritten / (float)totalBytesExpectedToWrite;
        NSLog(@"Sent %f ..",progress);
        
    }];
    [self enqueueHTTPRequestOperation:operation];

}
@end
