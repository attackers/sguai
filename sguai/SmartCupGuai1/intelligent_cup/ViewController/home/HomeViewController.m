//
//  HomeViewController.m
//  intelligent_cup
//
//  Created by liuming on 15/10/28.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import "HomeViewController.h"
#import "RegistViewController.h"
#import "LineProgressView.h"
#import "ApiStoreSDK.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include "JSONKit.h"
#import "WeatherManager.h"
#import "AFNetworking.h"
#import "HomeAnalyseViewController.h"
#import "SCAccountManager.h"
#import "CircleView.h"
#import "DrinkRecordBean.h"
#import "AlarmEditViewController.h"
#import "WaterSet.h"
#import "GuideViewController.h"
#import "HistogramViewController.h"
@interface HomeViewController ()<UIAlertViewDelegate>
{

    HistogramViewController *histogramVC;
    UIButton *changeButton;
    __weak IBOutlet UISegmentedControl *changeTemperature;
    __weak IBOutlet UILabel *cOrfLabel;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad  HomeViewController");
    
    //注意：将SCManager设置为BLECentralManager的delegate
    [[BLECentralManager sharedManager] addDelegate:[SCManager sharedManager]];
    
    //获取通知中心单例对象
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(cupStateChanged:) name:CUP_STATE_CHANGED object:nil];
    
    [WeatherManager sharedManager].delegate = self;
    
    SCUser *user = [[SCAccountManager sharedManager] archivedUser];
    if (user == nil) {
        NSLog(@"没有注册过，弹出注册VC");
        RegistViewController *registVC = [[RegistViewController alloc] init];
        UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:registVC];
        [navLogin setNavigationBarHidden:YES];
        [self presentModalViewController:navLogin animated:YES];
    }else {
        NSLog(@"注册过:user=%@",user);
        
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *first = [NSString stringWithFormat:@"firstLaunched %@",appVersion];
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:first]) {
//            [self presentModalViewController:[[GuideViewController alloc] init] animated:YES];
//        }
        
    }
    [self addHistogremView];
    
}
- (IBAction)cOrFSwitch:(UISegmentedControl*)sender {
    if (sender.selectedSegmentIndex == 0) {
        [SCManager sendCmd_changeTemperatureType:1];
    } else {
        [SCManager sendCmd_changeTemperatureType:0];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SCManager sendCmd_readTemperature];
    });
}
    

- (void)addHistogremView
{

    histogramVC = [HistogramViewController new];
    CGRect rect = [UIScreen mainScreen].bounds;
    histogramVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(_scChartView.frame), CGRectGetHeight(_scChartView.frame));
    histogramVC.heightBound = CGRectGetHeight(_scChartView.frame);
    [self addChildViewController:histogramVC];
    [_scChartView addSubview:histogramVC.view];
    _scChartView.hidden = YES;

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear  HomeViewController");
    
    if([self peripheralConnected]){
        NSLog(@"蓝牙已连接");
        //        self.cupNameLabel.hidden = NO;
        NSString *identifier = [BLECentralManager sharedManager].activePeripheral.activePeripheral.identifier.UUIDString;
        NSString *name = [[BLECentralManager sharedManager] getAliasWithIdentifier:identifier];
        if (name != nil) {
            self.cupNameLabel.text = name;
        }else {
            self.cupNameLabel.text = [BLECentralManager sharedManager].activePeripheral.activePeripheral.name;
        }
        
        NSLog(@"identifier=%@,name=%@",identifier,name);
    }else {
        //        self.cupNameLabel.hidden = YES;
        self.cupNameLabel.text = NSLocalizedString(@"未连接", nil);
        NSLog(@"蓝牙已断开");
    }
    
    //1.获取水温,电池电量
    [SCManager sendCmd_readTemperature];
    [SCManager sendCmd_readyBatteryEnergy];
    //3.获取天气
    if ([WeatherManager sharedManager].weatherInfoBean == nil) {
        NSLog(@"没有获取过天气信息，startGetWeatherInfo");
        [[WeatherManager sharedManager] startGetWeatherInfo];
    }else {
        NSLog(@"获取过天气信息:info=%@",[WeatherManager sharedManager].weatherInfoBean);
    }
    
    if([SCManager sharedManager].currentDrinkRecordArray == nil){
        //获取用户饮水记录
        [self requestDrinkRecord];
    }
}

- (IBAction)btn_click_analyse:(id)sender {
    if ([SCManager sharedManager].currentDrinkRecordArray == nil || [SCManager sharedManager].currentDrinkRecordArray.count==0) {
        [self.view makeToast:NSLocalizedString(@"目前没有饮水记录", nil) duration:1.0f position:@"center"];
        return;
    }
    //跳转到健康分析界面
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController: [[HomeAnalyseViewController alloc] init] animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

-(void)cupStateChanged:(id)sender{
    NSLog(@"cupStateChanged");
    //    return;
    //根据[SCManager sharedManager]的状态，更新UI
    //1.更新温度
    NSLog(@"更新温度:%d",(int)[SCManager sharedManager].currentTemp);
    if ((int)[SCManager sharedManager].currentTempType == 0) {
        changeTemperature.selectedSegmentIndex = 0;
        cOrfLabel.text = @"ºF";
    } else {
        changeTemperature.selectedSegmentIndex = 1;
        cOrfLabel.text = @"ºC";
    }
    self.currentTempLabel.text = [NSString stringWithFormat:@"%d",(int)[SCManager sharedManager].currentTemp];
    if([SCManager sharedManager].currentTemp >= 70){
        [self.bgImageView setImage:[UIImage imageNamed:@"img_home_bg_red.png"]];
        self.currentTempLabel.textColor = [UIColor colorWithRed:251.0f/255.0f green:58.0f/255.0f blue:72.0f/255.0f alpha:1.0f];//red
    }else if([SCManager sharedManager].currentTemp >= 50){
        [self.bgImageView setImage:[UIImage imageNamed:@"img_home_bg_orange.png"]];
        self.currentTempLabel.textColor = [UIColor colorWithRed:253.0f/255.0f green:159.0f/255.0f blue:63.0f/255.0f alpha:1.0f];//orange
    }else {
        [self.bgImageView setImage:[UIImage imageNamed:@"img_home_bg_green.png"]];
        self.currentTempLabel.textColor = [UIColor colorWithRed:38.0f/255.0f green:206.0f/255.0f blue:145.0f/255.0f alpha:1.0f];//green
    }
    //2.更新电量
    NSLog(@"更新电量:%d",(int)[SCManager sharedManager].currentBattery);
    self.batteryLabel.text = [NSString stringWithFormat:@"%d%%",(int)[SCManager sharedManager].currentBattery];
    int currentBattery = (int)[SCManager sharedManager].currentBattery;
    if(currentBattery >= 90){
        [self.batteryImageView setImage:[UIImage imageNamed:@"ic_home_battery100.png"]];
    }else if(currentBattery >= 75){
        [self.batteryImageView setImage:[UIImage imageNamed:@"ic_home_battery75.png"]];
    }else if(currentBattery >= 50){
        [self.batteryImageView setImage:[UIImage imageNamed:@"ic_home_battery50.png"]];
    }else if(currentBattery >= 30){
        [self.batteryImageView setImage:[UIImage imageNamed:@"ic_home_battery30.png"]];
    }else {
        [self.batteryImageView setImage:[UIImage imageNamed:@"ic_home_battery25.png"]];
    }
}

//天气回调
-(void)onWeatherInfoReceiveSucced:(WeatherInfoBean *)info;{
    NSLog(@"获取天气信息成功 info=%@",info);
    self.wheaterTempLabel.text = [NSString stringWithFormat:@"%d~%d℃",info.tempMin,info.tempMax];
    //根据天气，切换图片
    int weatherCode = [info weatherCode];
    [self.wheaterImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"image_weather_%d.png",weatherCode]]];
    [self requestDrinkRemidWithTem:info.tempMax andWeatherCode:weatherCode];
    
}

-(void)onWeatherInfoReceiveFailed:(NSString *)info{
    NSLog(@"获取天气信息失败:%@",info);
}

-(void)onCityReceived:(NSString *)city {
    NSLog(@"home 获取城市成功:%@",city);
    if (city == nil) {
        
    }else {
        self.cityLabel.text = city;
    }
    
}

-(void)requestDrinkRecord {
    if ([SCAccountManager sharedManager].localUser == nil) {
        return;
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlStr = [NSString stringWithFormat:@"http://112.74.79.95:8080/MicroMessage/GetDrink.action?phone=%@&day=20",[SCAccountManager sharedManager].localUser.phone];
    NSLog(@"urlStr=%@",urlStr);
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [self dismissLoading];
        if (error) {
            NSLog(@"Error: %@", error);
            NSLog(@"获取用户饮水记录 失败");
            //todo 使用本地record
        } else {
            NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
            NSNumber *code = [result objectForKey:@"code"];
            NSString *message = [result objectForKey:@"message"];
            NSLog(@"code=%@, message=%@",code, message);
            if([code intValue] == 1){
                NSLog(@"获取用户饮水记录 成功");
                
                NSArray *array = (NSArray *)message;
                
                [SCManager sharedManager].currentDrinkRecordArray = [[NSMutableArray alloc] init];
                
                for(int i=0; i<array.count; i++){
                    NSDictionary *dic =(NSDictionary *)[array objectAtIndex:i];
                    DrinkRecordBean *bean = [[DrinkRecordBean alloc] init];
                    bean.time = [dic objectForKey:@"time"];
                    bean.drink = [dic objectForKey:@"drink"];
                    if (![bean.time containsString:@"1970"]) {
                        [[SCManager sharedManager].currentDrinkRecordArray addObject:bean];
                    }
                }
                //本地记录，如果有，则上传到服务器。上传成功，则删除本地记录
                //                NSMutableArray *records = [[SCManager sharedManager] unarchivedDrinkRecords];
                //                if (records == nil || records.count == 0) {
                //
                //
                //                    //1.发送数据到服务器
                //
                //
                //                    //2.添加到currentDrinkRecordArray中
                //
                //                }
                
                NSLog(@"饮水记录:%@",[SCManager sharedManager].currentDrinkRecordArray);
                
                //更新chartView的内容
                [self.scChartView setDrinkRecordBeans:[SCManager sharedManager].currentDrinkRecordArray];
                [histogramVC.testCollectionview reloadData];
                _scChartView.hidden = NO;
            }else {
                NSLog(@"获取用户饮水记录 失败");
            }
        }
    }];
    [dataTask resume];
}

-(void)requestDrinkRemidWithTem:(int)tem andWeatherCode:(int)weatherCode {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlStr = [NSString stringWithFormat:@"http://112.74.79.95:8080/MicroMessage/GetDrinkRemind.action?tem=%d&weather=%d",tem, weatherCode];
    NSLog(@"urlStr=%@",urlStr);
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [self dismissLoading];
        if (error) {
            NSLog(@"Error: %@", error);
            NSLog(@"获取饮水提醒 失败");
        } else {
            NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
            NSNumber *code = [result objectForKey:@"code"];
            NSString *message = [result objectForKey:@"message"];
            NSLog(@"code=%@, message=%@",code, message);
            if([code intValue] == 1){
                //弹出提示框
                [self postNotification:message];
            }else {
                NSLog(@"获取饮水提醒 失败");
            }
        }
    }];
    [dataTask resume];
}



//手动设置饮水量
- (IBAction)btn_click_waterSet:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"输入饮水量", nil) message:nil delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil),nil];
    alert.alertViewStyle  = UIAlertViewStylePlainTextInput;
    UITextField *contentField = [alert textFieldAtIndex:0];
    contentField.keyboardType = UIKeyboardTypeNumberPad;
    [alert show];
  
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    SCUser *user= [[SCAccountManager sharedManager] archivedUser];
    UITextField *contentField = [alertView textFieldAtIndex:0];
    NSInteger drinkValue = [contentField.text integerValue];
    NSString *drinkStg = [NSString stringWithFormat:@"%lu",drinkValue/2];
    if (contentField.text.length == 0) {
        drinkStg = @"0";
    }
    if (drinkValue == 5000) {
        drinkStg = @"5000";
    }
    if (buttonIndex == 1) {
        NSTimeInterval inter = [[NSDate date] timeIntervalSince1970];

        NSString *phone = user.phone;
        NSString *time =  [NSString stringWithFormat:@"%lu",(NSInteger)inter];
        NSString *urlStr = [NSString stringWithFormat:@"http://112.74.79.95:8080/MicroMessage/UpdateDrink.action?phone=%@&time=%@000&water=%@",phone,time,drinkStg];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        __weak typeof(self) weakSelf = self;
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                [weakSelf requestDrinkRecord];
            }
        }];
        [dataTask resume];
    }

}

@end
