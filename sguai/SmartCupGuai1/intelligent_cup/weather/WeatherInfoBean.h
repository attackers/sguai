//
//  WeatherInfoBean.h
//  ApiStoreSDKDemo
//
//  Created by admin on 16/7/2.
//  Copyright © 2016年 KessonWu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherInfoBean : NSObject

@property(strong, nonatomic) NSString *txt_d;
@property(strong, nonatomic) NSString *txt_n;
//@property(strong, nonatomic) NSString *city;

@property  (nonatomic) int tempMin;
@property  (nonatomic) int tempMax;

-(int)weatherCode;

@end
