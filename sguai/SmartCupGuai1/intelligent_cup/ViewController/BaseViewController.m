//
//  BaseViewController.m
//  intelligent_cup
//
//  Created by liuming on 15/10/31.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import "BaseViewController.h"
#import "BLECentralManager.h"
#import "SCManager.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      UITextAttributeTextColor:[UIColor whiteColor]
                                                                      }];
    if(self.navigationItem.leftBarButtonItem){
        //1.设置NavBar的leftBarButtonItem按钮图片、
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"back_nor.png"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"back_press.png"] forState:UIControlStateHighlighted];
        //        backButton.backgroundColor = [UIColor grayColor];
        backButton.frame = CGRectMake(0, 0, 33, 33);
        //调整位置靠左一点
        [backButton addTarget:self action:@selector(btn_back_onclicked:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backItem;
    }
    
    //获取通知中心单例对象
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(alarmRing) name:ALARM_RING object:nil];
}

-(void)alarmRing{
    NSLog(@"闹钟响了");
    [self.view makeToast:NSLocalizedString(@"该喝水啦", nil) duration:2.0f position:@"center"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (IBAction)btn_back_onclicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showLoading{
    
    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    [view setTag:103];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.6];
    [self.view addSubview:view];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 132.0f, 132.0f)];
    [activityIndicator setCenter:view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:activityIndicator];
    [activityIndicator startAnimating];
}

-(void)dismissLoading{
    UIView *view = (UIView *)[self.view viewWithTag:103];
    [view removeFromSuperview];
    [self resignFirstResponder];
}

#pragma mark 蓝牙是否连接
-(BOOL)peripheralConnectedWithToast {
    if([[BLECentralManager sharedManager] activePeripheral] == nil){
        [self.view makeToast:NSLocalizedString(@"请先连接水杯", nil) duration:1.0f position:@"center"];
        return NO;
    }
    return YES;
}
-(BOOL)peripheralConnected {
    if([[BLECentralManager sharedManager] activePeripheral] == nil){
        return NO;
    }
    return YES;
}

-(BOOL)isBleOnWithToast {
    if(![BLECentralManager sharedManager].isBleOn){
         [self.view makeToast:NSLocalizedString(@"请先打开手机蓝牙", nil) duration:1.0f position:@"center"];
        return NO;
    }
    return YES;
}

-(BOOL)isBleOn {
    if(![BLECentralManager sharedManager].isBleOn){
        return NO;
    }
    return YES;
}

-(void)postNotification:(NSString *)notificationStr {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        // 设置通知的提醒时间
        NSDate *currentDate   = [NSDate date];
        notification.timeZone = [NSTimeZone defaultTimeZone]; // 使用本地时区
        notification.fireDate = [currentDate dateByAddingTimeInterval:5.0];
        
        // 设置重复间隔
        notification.repeatInterval = kCFCalendarUnitDay;
        
        // 设置提醒的文字内容
        notification.alertBody   = notificationStr;
        //        notification.alertAction = NSLocalizedString(@"起床了", nil);
        
        // 通知提示音 使用默认的
        notification.soundName= UILocalNotificationDefaultSoundName;
        
        // 设置应用程序右上角的提醒个数
        notification.applicationIconBadgeNumber++;
        
        // 设定通知的userInfo，用来标识该通知
        NSMutableDictionary *aUserInfo = [[NSMutableDictionary alloc] init];
        //        aUserInfo[kLocalNotificationID] = @"LocalNotificationID";
        notification.userInfo = aUserInfo;
        
        // 将通知添加到系统中
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}
@end
