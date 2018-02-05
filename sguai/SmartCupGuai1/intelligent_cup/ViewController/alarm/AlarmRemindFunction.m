//
//  AlarmRemindFunction.m
//  intelligent_cup
//
//  Created by admin-leaf on 17/5/11.
//  Copyright © 2017年 makeblock. All rights reserved.
//

#import "AlarmRemindFunction.h"
#import "SCManager.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
@interface AlarmRemindFunction()<UIAlertViewDelegate>
{
    dispatch_source_t timer;
    dispatch_queue_t queue;
    AVAudioPlayer *player;
    AlarmBean *okayAlarm;
    AlarmBean *objAlerm;
    UIAlertView *alert;
    BOOL alerShow;
}
@end
@implementation AlarmRemindFunction
/******************** 定时闹钟提醒 *********************************/
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"water" ofType:@"wav"];
        if (player == nil) {
            player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:filePath] error:nil];
            alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"该喝水啦", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles: nil];
            alerShow = NO;
        }
    }
    return self;
}
-(void)alarmRemindNotification
{

    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance]setActive:YES error:nil];
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    NSInteger flags = NSCalendarUnitWeekday;
    comp = [calendar components:flags fromDate:[NSDate date]];
    NSInteger weekday = [comp weekday];
    
     if (timer!=nil) {
        dispatch_source_cancel(timer);
    }
   NSMutableArray *currentAlarmArray =  [SCManager sharedManager].currentAlarmArray.mutableCopy;
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        @autoreleasepool {
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"HH:mm"];
            NSString *dateStg = [formatter stringFromDate:date];
            NSInteger index = 0;
            for (AlarmBean *bean in currentAlarmArray) {
                
                Byte array[] = {0, 0, 0, 0, 0, 0, 0, 0};
                Byte b = bean.repeat;
                for (int i = 7; i>=0; i--) {
                    array[i] = (Byte)(b&1);
                    b = (Byte)(b>>1);
                }
                switch (weekday) {
                    case 1:
                        index = array[6];
                        break;
                    case 2:
                        index = array[0];
                        break;
                    case 3:
                        index = array[1];
                        break;
                    case 4:
                        index = array[2];
                        break;
                    case 5:
                        index = array[3];
                        break;
                    case 6:
                        index = array[4];
                        break;
                    case 7:
                        index = array[5];
                        break;
                        
                    default:
                        break;
                }

                NSString *alarmTime = [NSString stringWithFormat:@"%02d:%02d",bean.hour,bean.minute];
                if (index == 1 && [dateStg isEqualToString:alarmTime] && bean.isOn && ![bean isEqual:objAlerm]) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self playSound];
                    });
                    
                    if ([[UIDevice currentDevice].systemVersion floatValue]>=10.0){
                        
                            return;
                        
                    }
                    
                    if (![player isPlaying]) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [player play];
                            if (!alerShow) {
                                [alert show];
                            }
                        });
                        NSLog(@"play");
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                        okayAlarm = bean;
                        alerShow = YES;
                    }
                }
            }
        }
    });

    dispatch_resume(timer);

}
- (void)playSound
{
    if ([[UIDevice currentDevice].systemVersion floatValue]>=10.0) {
        
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
        UNNotificationSound *sound = [UNNotificationSound soundNamed:@"water_come.wav"];
        content.sound = sound;
        content.body = NSLocalizedString(@"该喝水啦", nil);
        
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"local" content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (error == nil) {
                NSLog(@"已成功加推送%@",request.identifier);
                [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
            }
        }];

    }else{
    
        UILocalNotification*   localNote = [[UILocalNotification alloc]init];
        localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
        localNote.alertBody = NSLocalizedString(@"该喝水啦", nil);
        localNote.soundName = @"water.wav";
        [[UIApplication sharedApplication]presentLocalNotificationNow:localNote];
    
    }

}
//void SoundFinishCallback(SystemSoundID soundID,void *userData){
//    
//    AudioServicesRemoveSystemSoundCompletion(soundID);
//    AudioServicesDisposeSystemSoundID(soundID);
//    
//}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    objAlerm = okayAlarm;
    alerShow = NO;
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);

}
@end
