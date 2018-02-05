//
//  WeatherManager.m
//  ApiStoreSDKDemo
//
//  Created by admin on 16/7/2.
//  Copyright © 2016年 KessonWu. All rights reserved.
//

#import "WeatherManager.h"
#import "AFNetworking.h"
#include "JSONKit.h"
#import "ApiStoreSDK.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
//1.英文及其它的等;
//2.提醒;
//3.弹出框;
//4.
//5.

@implementation WeatherManager

static WeatherManager* _instance;
+(WeatherManager *)sharedManager{
    if(_instance==nil){
        _instance = [[WeatherManager alloc] init];
    }
    return _instance;
}

-(void)startGetWeatherInfo {
//    [self getIP];
    
     [self initLocation];
}

NSMutableData* _data;
// 分批返回数据
- (void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
    [_data appendData:data];
    //    NSLog(@"22 %@", data);
}

// 数据完全返回完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *dataString =  [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    //    NSLog(@"33 %@", dataString);
}

#pragma mark 获取设备的IP
//1.get ip
// http://pv.sohu.com/cityjson?ie=utf-8
// var returnCitySN = {"cip": "183.37.241.163", "cid": "440300", "cname": "广东省深圳市"};
-(void)getIP{
    NSString *url = @"http://pv.sohu.com/cityjson?ie=utf-8";
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //默认是json，不设置会报错
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    [session setResponseSerializer:responseSerializer];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"getIP:response成功");
        NSString *backData = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@", backData);
        NSArray *array = [backData componentsSeparatedByString:@"="];
        if(array.count == 2){
            NSString *ipJson = [((NSString *)(array[1])) stringByReplacingOccurrencesOfString:@";" withString:@""];
            NSData *data = [ipJson dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *arr=(NSArray *)[data objectFromJSONData];
            NSDictionary *dic=(NSDictionary *)[data objectFromJSONData];
            NSString *ip = [dic objectForKey:@"cip"];
            NSLog(@"ip=%@",ip);
            [self getCityNameOfSimplifiedChinese:ip];
        }else {
            NSLog(@"getIP:返回数据Exception");
            self.weatherInfoBean = nil;
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"getIP:response Error: %@", error);
        self.weatherInfoBean = nil;
    }];
}

//3.getCityPinyin 用ios自己的方法
//4.getWeather 用百度的库


//2.getCityName Chinese
// http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json&ip=218.200.48.73
// {"ret":1,"start":-1,"end":-1,"country":"\u4e2d\u56fd","province":"\u9655\u897f","city":"\u897f\u5b89","district":"","isp":"","type":"","desc":""}
-(void)getCityNameOfSimplifiedChinese:(NSString *)IP {
    //IP = @"10.20.102.55"; 一个本地局域网ip，测试用
    NSString *url = [NSString stringWithFormat:@"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json&ip=%@",IP];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    [session setResponseSerializer:responseSerializer];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"获取城市:response成功");
        NSString *backData = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //        NSLog(@"%@", backData);
        NSData *data = [backData dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic=(NSDictionary *)[data objectFromJSONData];
        NSString *city = [dic objectForKey:@"city"];
        NSLog(@"通过ip获取：city=%@",city);
        //city可能为nil
        if(city == nil){
            [self performSelector:@selector(getIP) withObject:nil afterDelay:2.0f];
            return;
        }
        //回调city
        [self.delegate onCityReceived:city];
        NSString *cityPinyin = [self transformHanziToPinyin:city];
        [self requestWithCityPinyin:cityPinyin];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"getCityName:response Error: %@", error);
        self.weatherInfoBean = nil;
    }];
}

-(NSString *)transformHanziToPinyin:(NSString *)hanziText {
    if(hanziText.length == 0){
        return NULL;
    }else {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:hanziText];
        //转成带音调的String：shēn zhèn
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            //转成带空格的String：shen zhen
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                //去掉空格：shenzhen
                NSString *pinyin = [ms stringByReplacingOccurrencesOfString:@" " withString:@""];
                //                NSLog(@"pinyin3: %@", pinyin);
                return pinyin;
            }
        }
        return NULL;
    }
}


-(void)requestWithCityPinyin:(NSString *) cityPinyin {
    //实例化一个回调，处理请求的返回值
    APISCallBack* callBack = [APISCallBack alloc];
    
    callBack.onSuccess = ^(long status, NSString* responseString) {
        NSLog(@"onSuccess");
        if(responseString != nil) {
            NSDictionary *dic=(NSDictionary *)[responseString objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
            NSString *ip = [dic objectForKey:@"HeWeather data service 3.0"];
            NSArray *dic2=(NSArray *)ip;
            NSDictionary *obj =(NSDictionary *)[dic2 objectAtIndex:0];
            NSArray *oo = (NSArray *)[obj objectForKey:@"daily_forecast"];
            
            NSString *currentDateString = [self currentDateString];
            
            //            //日出
            //               String sunriseTime = astro.getString("sr");
            //               //日落
            //               String sunsetTime = astro.getString("ss");
            //               //白天天气
            //               String dayWeather = cond.getString("txt_d");
            //               //夜晚天气
            //               String nightWeather = cond.getString("txt_n");
            //               //风力
            //               String windText = wind.getString("dir") + " " + wind.getString("sc") + "级";
            //               //降水概率
            //               String pop = daily_forecast_first.getString("pop");
            //               //温度
            //               String tempText = temp.getString("min") + "℃~" + temp.getString("max") + "℃";
            //               //更新时间
            //               String updateTime = update.getString("loc");
            //               //城市名
            //               String cityName = basic.getString("city");
            for (int i=0; i<oo.count; i++) {
                NSDictionary *obj2 =(NSDictionary *)[oo objectAtIndex:i];
                NSString *date = (NSString *)[obj2 objectForKey:@"date"];
                NSLog(@"date=%@",date);
                if([date isEqualToString:currentDateString]){
                    NSDictionary *tmp = (NSDictionary *)[obj2 objectForKey:@"tmp"];
                    int max = [((NSString *)[tmp objectForKey:@"max"]) intValue];
                    int min = [((NSString *)[tmp objectForKey:@"min"]) intValue];
                    
                    NSDictionary *cond = (NSDictionary *)[obj2 objectForKey:@"cond"];
                    NSString *txt_d = (NSString *)[cond objectForKey:@"txt_d"];
                    NSString *txt_n = (NSString *)[cond objectForKey:@"txt_n"];
                    
                    //                    NSDictionary *astro = (NSDictionary *)[obj2 objectForKey:@"astro"];
                    //                    NSString *sr = (NSString *)[astro objectForKey:@"sr"];
                    //                    NSString *ss = (NSString *)[astro objectForKey:@"ss"];
                    
                    //                    NSLog(@"今天是:%@,气温是:%d~%d摄氏度，白天:%@,晚上:%@,日出:%@,日落:%@",currentDateString,min,max,txt_d,txt_n,sr,ss);
                    
                    //回调给delegate
                    self.weatherInfoBean = [[WeatherInfoBean alloc] init];
                    self.weatherInfoBean .tempMax = max;
                    self.weatherInfoBean .tempMin = min;
                    self.weatherInfoBean .txt_d = txt_d;
                    self.weatherInfoBean .txt_n = txt_n;
                    //                    NSLog(@"天气信息:%@",info);
                    [self.delegate onWeatherInfoReceiveSucced:self.weatherInfoBean];
                    break;
                }
            }
        }
    };
    
    callBack.onError = ^(long status, NSString* responseString) {
        NSLog(@"onError");
        self.weatherInfoBean = nil;
    };
    
    callBack.onComplete = ^() {
        NSLog(@"onComplete");
    };
    
    //部分参数
    NSString *uri = @"http://apis.baidu.com/heweather/weather/free";
    NSString *method = @"post";
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    cityPinyin = cityPinyin==nil?@"":cityPinyin;
    [parameter setObject:cityPinyin forKey:@"city"];
    
    //请求API
    [ApiStoreSDK executeWithURL:uri method:method apikey:@"" parameter:parameter callBack:callBack];
}

-(NSString *)currentDateString {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

- (void)initLocation {
    //检测定位功能是否开启
    NSLog(@"initLocation");
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"locationServicesEnabled");
        if(!_locationManager){
            self.locationManager = [[CLLocationManager alloc] init];
            if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
                
                [self.locationManager requestWhenInUseAuthorization];
                [self.locationManager requestAlwaysAuthorization];
            }
            //设置代理
            [self.locationManager setDelegate:self];
            //设置定位精度
            [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            //设置距离筛选
            [self.locationManager setDistanceFilter:100];
            //开始定位
            [self.locationManager startUpdatingLocation];
            //设置开始识别方向
            [self.locationManager startUpdatingHeading];
            
            if( [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
                //定位被拒绝，
                NSLog(@"locationServices  kCLAuthorizationStatusDenied");
                [self getIP];
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:NSLocalizedString(@"为了获取更精确的天气信息，请到设置中为“小水怪”打开定位功能", nil)
                                                                    delegate:nil
                                                           cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                           otherButtonTitles:nil, nil];
                [alertView show];

            }
        }
    }else{
          NSLog(@"locationServices  disable");
    }
    
}

#pragma mark - CLLocationManangerDelegate
//定位成功以后调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [self.locationManager stopUpdatingLocation];
    CLLocation* location = locations.lastObject;
    [self reverseGeocoder:location];
}

#pragma mark Geocoder
//反地理编码
- (void)reverseGeocoder:(CLLocation *)currentLocation {
    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error || placemarks.count == 0){
            NSLog(@"error = %@",error);
        }else{
            
            CLPlacemark* placemark = placemarks.firstObject;
            NSDictionary *addressDic = [placemark addressDictionary];
//            NSLog(@"addressDic=%@",addressDic);
            NSString *city = [[placemark addressDictionary] objectForKey:@"City"];
            NSLog(@"placemark:%@",[[placemark addressDictionary] objectForKey:@"City"]);
             NSLog(@"通过location获取：city:%@",city);
            //临时解决一下：如果获取的city含有市，如深圳市，参数对不上号。fuck！
            NSString *last = [city substringFromIndex:city.length-1];
            if ([last isEqualToString:@"市"]) {
                city = [city substringToIndex:city.length-1];
            }
            //回调city
            [self.delegate onCityReceived:city];
            NSString *cityPinyin = [self transformHanziToPinyin:city];
            [self requestWithCityPinyin:cityPinyin];
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你的位置" message:[[placemark addressDictionary] objectForKey:@"City"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
        }
    }];
}



@end
