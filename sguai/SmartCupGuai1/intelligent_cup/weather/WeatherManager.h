//
//  WeatherManager.h
//  ApiStoreSDKDemo
//
//  Created by admin on 16/7/2.
//  Copyright © 2016年 KessonWu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherInfoBean.h"
#import <CoreLocation/CoreLocation.h>

@protocol WeatherManagerDelegate <NSObject>
@optional
-(void)onWeatherInfoReceiveSucced:(WeatherInfoBean *)info;
-(void)onWeatherInfoReceiveFailed:(NSString *)info;
-(void)onCityReceived:(NSString *)city;
@end

@interface WeatherManager : NSObject <CLLocationManagerDelegate>


@property (assign, nonatomic) id<WeatherManagerDelegate> delegate;
@property(strong,nonatomic) WeatherInfoBean *weatherInfoBean;
@property (nonatomic, strong) CLLocationManager* locationManager;
+(WeatherManager *)sharedManager;

-(void)startGetWeatherInfo;


@end
