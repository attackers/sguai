//
//  AppDelegate.m
//  intelligent_cup
//
//  Created by liuming on 15/10/28.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import "AppDelegate.h"
#import "MobClick.h"
#import "HomeViewController.h"
#import "LMUtils.h"
#import "RegistViewController.h"
#import "SCAccountManager.h"
#import "GuideViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate {
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self RegisterLocalNotification:application];

    //友盟统计 @"App Store"
    [MobClick startWithAppkey:@"57976d3c67e58e70940016cd" reportPolicy:SEND_INTERVAL channelId:@"AppStore"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //    NSLog(@"VERSION=%@",version);
    [MobClick setAppVersion:version];
    
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBarItem *itemHomePage = [tabBarController.tabBar.items objectAtIndex:0];
    UITabBarItem *itemCup = [tabBarController.tabBar.items objectAtIndex:1];
    UITabBarItem *itemAlarm = [tabBarController.tabBar.items objectAtIndex:2];
    UITabBarItem *itemIndividual = [tabBarController.tabBar.items objectAtIndex:3];
    UITabBarItem *itemAbout = [tabBarController.tabBar.items objectAtIndex:4];
    //    //修改选中的vc
        tabBarController.selectedIndex = 1;
    
    //自定义tabBarItem
    CGSize itemImageSize = CGSizeMake(25.0f, 25.0f);
    
    UIImage *imageItemHomeSelected = [LMUtils reSizeImage:[UIImage imageNamed:@"nav_btn_home_press.png"] toSize:itemImageSize];
    UIImage *imageItemHomeUnselected = [LMUtils reSizeImage:[UIImage imageNamed:@"nav_btn_home_nor.png"] toSize:itemImageSize];
    [itemHomePage setFinishedSelectedImage:imageItemHomeSelected withFinishedUnselectedImage:imageItemHomeUnselected];
    [itemHomePage setTitle:NSLocalizedString(@"首页", nil)];
    
    UIImage *imageItemAlarmSelected = [LMUtils reSizeImage:[UIImage imageNamed:@"nav_btn_alarm_press.png"] toSize:itemImageSize];
    UIImage *imageItemAlarmUnselected = [LMUtils reSizeImage:[UIImage imageNamed:@"nav_btn_alarm_nor.png"] toSize:itemImageSize];
    [itemAlarm setFinishedSelectedImage:imageItemAlarmSelected withFinishedUnselectedImage:imageItemAlarmUnselected];
    [itemCup setTitle:NSLocalizedString(@"提醒", nil)];
    
    UIImage *imageItemCupSelected = [LMUtils reSizeImage:[UIImage imageNamed:@"nav_btn_cup_press.png"] toSize:itemImageSize];
    UIImage *imageItemCupUnselected = [LMUtils reSizeImage:[UIImage imageNamed:@"nav_btn_cup_nor.png"] toSize:itemImageSize];
    [itemCup setFinishedSelectedImage:imageItemCupSelected withFinishedUnselectedImage:imageItemCupUnselected];
    [itemCup setTitle:NSLocalizedString(@"水杯", nil)];
    
    UIImage *imageItemIndividualSelected = [LMUtils reSizeImage:[UIImage imageNamed:@"nav_btn_profile_press.png"] toSize:itemImageSize];
    UIImage *imageItemIndividualUnselected = [LMUtils reSizeImage:[UIImage imageNamed:@"nav_btn_profile_nor.png"] toSize:itemImageSize];
    [itemIndividual setFinishedSelectedImage:imageItemIndividualSelected withFinishedUnselectedImage:imageItemIndividualUnselected];
    [itemIndividual setTitle:NSLocalizedString(@"个人", nil)];
    
    UIImage *imageItemAboutSelected = [LMUtils reSizeImage:[UIImage imageNamed:@"nav_btn_about_press.png"] toSize:itemImageSize];
    UIImage *imageItemAboutUnselected = [LMUtils reSizeImage:[UIImage imageNamed:@"nav_btn_about_nor.png"] toSize:itemImageSize];
    [itemAbout setFinishedSelectedImage:imageItemAboutSelected withFinishedUnselectedImage:imageItemAboutUnselected];
    [itemAbout setTitle:NSLocalizedString(@"关于", nil)];
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *first = [NSString stringWithFormat:@"firstLaunched %@",appVersion];
    SCUser *user = [[SCAccountManager sharedManager] archivedUser];
    if (user != nil){
        NSLog(@"注册过:user=%@",user);
//         [[NSUserDefaults standardUserDefaults] setBool:YES forKey:first];
        
        NSString *ever = [NSString stringWithFormat:@"everLaunched %@",appVersion];
        if (![[NSUserDefaults standardUserDefaults] boolForKey:ever]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ever];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:first];
        }else{
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:first];
        }

    }else {
//         [[NSUserDefaults standardUserDefaults] setBool:NO forKey:first];
    }

    return YES;
}

- (void)RegisterLocalNotification:(UIApplication *)application
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 点击允许
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@", settings);
                }];
            } else {
                // 点击不允许
                NSLog(@"注册失败");
            }
        }];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >8.0){
        //iOS8 - iOS10
        [application cancelAllLocalNotifications];
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
        
    }else if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        //iOS8系统以下
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    
}
// 获得Device Token失败
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
    
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    // Warning: UNUserNotificationCenter delegate received call to -userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: but the completion handler was never called.
    completionHandler();  // 系统要求执行这个方法
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"iOS6及以下系统，收到通知");
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"iOS7及以上系统，收到通知");
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgk;
    bgk = [app beginBackgroundTaskWithExpirationHandler:^{
    
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgk!=UIBackgroundTaskInvalid) {
                bgk = UIBackgroundTaskInvalid;
            }
            
        });
        
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       dispatch_sync(dispatch_get_main_queue(), ^{
           
           if (bgk!=UIBackgroundTaskInvalid) {
               bgk = UIBackgroundTaskInvalid;
           }
       });
        
    });
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "cc.makeblock.intelligent-cup.intelligent_cup" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"intelligent_cup" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"intelligent_cup.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
