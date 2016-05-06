//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088411815979591"
//收款支付宝账号
#define SellerID  @"lvsiwei@ylbj.cn"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"o7b6n1vl14kiyvt8r0uditaxvjp5y8iw"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAOS94zJnWb//l4qFttFc9snuaeuk6Hwvpuk0qKP6kMVPcaSjZDfAt+50Q3F2YK4Lf5cQeAJArAveLfo2uubhdgSH+kAgKTUPZI4EmCxr/2uW/2zNw+LEC7tniQvz/yAdNQ+QMtlunW/esON1q5UqN/o8MovQz/4ui7T98Xwq2rPBAgMBAAECgYEAxPLqaD+sezAq3s56tpGAvCVXddmrgyHUaP86JNZdSEY65zL32zlIJTxdxZfTboff98XqTqY4fI90rvfovVprLaLbNtT/HI7/EVIcnjbUykHuw9rBy/rYkyEB/zFU55Bw/7+y7qNNzt3lskzZAK8ggASBJ1ij4rChgG/Ajeha5AECQQD0VLATcYaDhcHZb5Kt16GmPUmHy3B2Y22NcHk3UgElxmwhB2Z/jUrrzEfYphdbWw+qOQN2l2rObX/geAGZXiUxAkEA76qZk26iDTlU4gRunB26/jyoicKgz62mBWhmqTQ9VqpJa//+kKRgorws565zje1zvS1vDB6lic0DS76zvtUTkQJACgspKcNy6hknfM6vUuIYTQMb8K8WMmen6zaCZRnD3k+nxjvNpNSkDclZ8rfxIdo+bJrnX4qd41pw9UM5nZpXIQJAet7Ms3AxtnPhF6rMBk+bsYHpqg7VIQPWrMkUcMTueYL991eb7A3J2UR+BR1D8sx83MzxNJZ1qcsoWGnhfwGAcQJAZ2pIO60ND87bWswa3yKTILPxX9gOH/fNgT46zfSPFYVBa0QTi3UrZ00X6bseItDKo9qniv7e3ZRFDcYR/AzYwg=="


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif
