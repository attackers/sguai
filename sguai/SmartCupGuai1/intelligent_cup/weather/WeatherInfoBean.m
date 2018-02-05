//
//  WeatherInfoBean.m
//  ApiStoreSDKDemo
//
//  Created by admin on 16/7/2.
//  Copyright © 2016年 KessonWu. All rights reserved.
//

#import "WeatherInfoBean.h"

@implementation WeatherInfoBean

-(int)weatherCode {
    int result = 14; //其他
    if ([self.txt_d containsString:NSLocalizedString(@"晴", nil)]) {
        result = 1;
        return result;
    }
    if ([self.txt_d containsString:NSLocalizedString(@"多云", nil)]) {
        result = 2;
        return result;
    }
    if ([self.txt_d containsString:NSLocalizedString(@"阴", nil)]) {
        result = 3;
        return result;
    }
    if ([self.txt_d containsString:NSLocalizedString(@"雾", nil)]) {
        result = 4;
        return result;
    }
    if ([self.txt_d containsString:NSLocalizedString(@"沙尘暴", nil)]) {
        result = 5;
        return result;
    }
    if ([self.txt_d containsString:NSLocalizedString(@"阵雨", nil)]) {
        result = 6;
        return result;
    }
    if ([self.txt_d containsString:NSLocalizedString(@"小雨", nil)]) {
        result = 7;
        return result;
    }
    if ([self.txt_d containsString:NSLocalizedString(@"中雨", nil)]) {
        result = 8;
        return result;
    }
    if ([self.txt_d containsString:NSLocalizedString(@"大雨", nil)]) {
        result = 9;
        return result;
    }
    if ([self.txt_d containsString:NSLocalizedString(@"雷阵雨", nil)]) {
        result = 10;
        return result;
    }
    if ([self.txt_d containsString:NSLocalizedString(@"小雪", nil)]) {
        result = 11;
        return result;
    }
    if ([self.txt_d containsString:NSLocalizedString(@"大雪", nil)]) {
        result = 12;
        return result;
    }
    if ([self.txt_d containsString:NSLocalizedString(@"雨夹雪", nil)]) {
        result = 13;
        return result;
    }
    return result;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%@:%d~%d%@，%@:%@,%@:%@",NSLocalizedString(@"气温是", nil),self.tempMin,self.tempMax,NSLocalizedString(@"摄氏度", nil),NSLocalizedString(@"白天", nil),self.txt_d,NSLocalizedString(@"晚上", nil),self.txt_n ];
}
@end
