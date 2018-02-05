//
//  Utils.m
//  intelligent_cup
//
//  Created by liuming on 16/9/11.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import "Utils.h"

@implementation Utils

/**
 *  手机号码验证
 *
 *  @param mobileNumbel 传入的手机号码
 *
 *  @return 格式正确返回true  错误 返回fals
 */
+ (BOOL) isMobile:(NSString *)mobileNumbel{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189,181(增加)
     */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    /**
     * 其他：
     * 170
     */
    NSString * COthers = @"^170\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
     NSPredicate *regextestcOthers = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", COthers];
    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel]
         || [regextestcOthers evaluateWithObject:mobileNumbel])) {
        return YES;
    }
    
    return NO;
}
+ (BOOL) isNumberAndLetter:(NSString *)string{
    NSString * regex = @"^[A-Za-z0-9]+$";
    NSPredicate *regextestcOthers = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([regextestcOthers evaluateWithObject:string]){
        return YES;
    }
    return NO;
}
@end
