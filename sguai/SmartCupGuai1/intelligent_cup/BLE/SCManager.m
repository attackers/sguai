//
//  SCManager.m
//  mBot_enterprise
//
//  Created by liuming on 16/6/19.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import "SCManager.h"
#import <AVFoundation/AVFoundation.h> 

@implementation SCManager

static SCManager*_instance;
+(SCManager *)sharedManager{
    if(_instance==nil){
        _instance = [[SCManager alloc] init];
    }
    return _instance;
}

+ (void)sendCmd_readTemperature {
    NSLog(@"sendCmd_readTemperature");
    NSData * cmd = [SCCmdBuilder readTemperature];
    [SCManager sendData:cmd];
}

+ (void)sendCmd_changeTemperatureType:(UInt8)en {
    NSData *cmd = [SCCmdBuilder changeTemperatureType: en];
    [SCManager sendData:cmd];
}
+ (void)sendCmd_readyBatteryEnergy {
    NSLog(@"sendCmd_readyBatteryEnergy");
    NSData * cmd = [SCCmdBuilder readyBatteryEnergy];
    [SCManager sendData:cmd];
}

+ (void)sendCmd_readyAlarms {
    NSLog(@"sendCmd_readyAlarms");
    NSData * cmd = [SCCmdBuilder readyAlarms];
    [SCManager sendData:cmd];
}

+ (void)sendCmd_addAlarmWithAlarmBean:(AlarmBean *) alarmBean {
    NSLog(@"sendCmd_addAlarmWithAlarmBean alarmBean=%@", alarmBean);
    int index = alarmBean.index;
    BOOL isOn = alarmBean.isOn;
    int hour = alarmBean.hour;
    int minute = alarmBean.minute;
    int repeat = alarmBean.repeat;
    int water = alarmBean.water;
    NSData * cmd = [SCCmdBuilder writeAddAlarmWithAlarmIndex:index andIsOn:isOn andHour:hour andMinute:minute andRepeat:repeat andWater:water];
    [SCManager sendData:cmd];
}

+ (void)sendCmd_updateAlarmWithAlarmBean:(AlarmBean *) alarmBean {
    NSLog(@"sendCmd_updateAlarmWithAlarmBean alarmBean=%@", alarmBean);
    int index = alarmBean.index;
    BOOL isOn = alarmBean.isOn;
    int hour = alarmBean.hour;
    int minute = alarmBean.minute;
    int repeat = alarmBean.repeat;
    int water = alarmBean.water;
    NSData * cmd = [SCCmdBuilder writeUpdateAlarmWithAlarmIndex:index andIsOn:isOn andHour:hour andMinute:minute andRepeat:repeat andWater:water];
    [SCManager sendData:cmd];
}

+ (void)sendCmd_deleteAlarmWithAlarmBean:(AlarmBean *) alarmBean {
    int index = alarmBean.index;
    NSLog(@"sendCmd_deleteAlarmWithAlarmBean alarmBean=%@", alarmBean);
    NSData *cmd = [SCCmdBuilder writeDeleteAlarmWithAlarmIndex:index];
    [SCManager sendData:cmd];
}

+ (void)sendCmd_synchronizeTime {
    NSLog(@"sendCmd_synchronizeTime");
    
    NSString *weekStr = nil;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    comps = [calendar components:unitFlags fromDate:now];
    int year = [comps year];
    int week = [comps weekday];
    int month = [comps month];
    int day = [comps day];
    int hour = [comps hour];
    int min = [comps minute];
    int sec = [comps second];
    
    if (week==1) {
        week = 7;
    }else {
        --week;
    }
//    week = 2;
    weekStr = [NSString stringWithFormat:@"星期%d",week];
    NSLog(@"现在是:%d年%d月%d日 %d时%d分%d秒  %@",year,month,day,hour,min,sec,weekStr);
    NSData *cmd = [SCCmdBuilder writeSynchronizeTimeWithHour:hour andMinute:min andWeekDay:week];
    [SCManager sendData:cmd];
}

+ (void)sendCmd_controlLed {
    NSData *cmd = [SCCmdBuilder writeControlLed];
    [SCManager sendData:cmd];
    
}
+ (void)sendData:(NSData *)data {
    Byte *byteData = (Byte*)malloc([data length]);
    memcpy(byteData, [data bytes], [data length]);
    NSLog(@"------------sendData Start:打印数据------------");
    for (int i=0; i<[data length]; i++) {
        NSLog(@"data[%d]=%d",i,byteData[i]);
    }
    NSLog(@"------------sendData End:打印数据------------");
    [[BLECentralManager sharedManager].activePeripheral sendDataMandatory:data];
}

#pragma mark ------------BLE代理------------
-(void)bleStateChanged{
//    NSLog(@"## SCManager bleStateChanged");
}
-(void)bleConnected{
    NSLog(@"## SCManager bleConnected");
    [self.currentAlarmArray removeAllObjects];
    self.currentTemp = 0;
    self.currentBattery = 0;
    [SCManager sendCmd_synchronizeTime];
    [SCManager sendCmd_readyBatteryEnergy];
    [SCManager sendCmd_readTemperature];
}
-(void)bleDisconnected{
    NSLog(@"## SCManager bleDisconnected");
    [self.currentAlarmArray removeAllObjects];
    self.currentTemp = 0;
    self.currentBattery = 0;
}

-(void)bleReceivedData:(NSData*)data {
    NSLog(@"## SCManager bleReceivedData");
    int length = (int)[data length];
    Byte *byteData = (Byte*)malloc(length);
    memcpy(byteData, [data bytes], length);
    NSLog(@"------------Start:打印数据------------");
    for (int i=0; i<[data length]; i++) {
        NSLog(@"data[%d]=%d",i,byteData[i]);
    }
    NSLog(@"------------End:打印数据------------");
    //     NSLog(@"parse data");
    if(byteData[0]!=HEAD_1 || byteData[1]!=HEAD_2 || byteData[length-2]!=LAST_1 || byteData[length-1]!=LAST_2){
        NSLog(@"检验头尾，无效 return");
        return;
    }
    
    int type = (int)byteData[2];
    int cmdIndex = (int)byteData[3];
    int dataType = (int)byteData[4];
    
    int responseType = (int)byteData[5];
    if (responseType == 27) {
        return;
    }
    
    switch (type) {
        case TYPE_TEMPERATURE:
            NSLog(@"水温");
            if(dataType == 0x01){ //Byte
            
                int temperature = (int)byteData[5];
                int baseTemperature = (int)byteData[6];
                NSLog(@"temperature=%d",temperature);
                self.currentTemp = temperature;
                if (baseTemperature == 1){
                    self.currentTempType = 1;//华氏度
                } else {
                    self.currentTempType = 0;//摄氏度
                }
            }
            break;
        case TYPE_BATTERY:
            NSLog(@"电量");
            if(dataType == 0x01){ //Byte
                int battery = (int)byteData[5];
                NSLog(@"battery=%d",battery);
                self.currentBattery = battery;
            }
            break;
        case TYPE_ALARM_RING:
        {
            NSLog(@"闹钟响了");
            
            AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, soundCompleteCallback, NULL);
            AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
            
            //创建一个消息对象
            NSNotification *alarmRing = [NSNotification notificationWithName:ALARM_RING object:nil userInfo:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter] postNotification:alarmRing];
        }
            break;
        case TYPE_ALARM:
        {
            NSLog(@"闹钟");
            if(self.currentAlarmArray == nil){
                self.currentAlarmArray = [[NSMutableArray alloc] init];
            }
            if(dataType == 0x01){ //Byte
                self.currentAlarmCount = (int)byteData[5];
                NSLog(@"闹钟个数=%ld",self.currentAlarmCount);
                if(self.currentAlarmCount > 0){
                    int alarmIndex = (int)byteData[6];
                    int isOn = (int)byteData[7];
                    int hour = (int)byteData[8];
                    int minute = (int)byteData[9];
                    Byte repeat = byteData[10];
                    Byte water = byteData[11];
                    AlarmBean *bean = [[AlarmBean alloc] init];
                    if (isOn == 1) {
                        bean.isOn = YES;
                    }else if (isOn == 0) {
                        bean.isOn = NO;
                    }
                    bean.index = alarmIndex;
                    bean.hour = hour;
                    bean.minute = minute;
                    bean.repeat = repeat;
                    bean.water = water;
                    NSLog(@"AlarmBean=%@",bean);
                    
                    if (self.currentAlarmArray.count < self.currentAlarmCount) {
                        [self.currentAlarmArray addObject:bean];
                    }else {
                        for (int i=0; i<self.currentAlarmArray.count; i++) {
                            AlarmBean *innerBean = self.currentAlarmArray[i];
                            if (innerBean.index == bean.index) {
                                [self.currentAlarmArray removeObject:innerBean];
                                [self.currentAlarmArray addObject:bean];
                                break;
                            }
                        }
                    }
                }
                
                //按照时间排序
                NSArray *arraySorted = [[SCManager sharedManager].currentAlarmArray sortedArrayUsingComparator:
                                        ^NSComparisonResult(AlarmBean *obj1, AlarmBean *obj2) {
                                            NSComparisonResult result = NSOrderedSame;
                                            if (obj1.hour < obj2.hour) {
                                                result = NSOrderedAscending;
                                            }else if (obj1.hour > obj2.hour) {
                                                result = NSOrderedDescending;
                                            }
                                            if (result == NSOrderedSame) {
                                                if (obj1.minute < obj2.minute) {
                                                    result = NSOrderedAscending;
                                                }else if (obj1.minute > obj2.minute) {
                                                    result = NSOrderedDescending;
                                                }
                                            }
                                            return result;  
                                        }];
                [[SCManager sharedManager].currentAlarmArray setArray:arraySorted];
                NSLog(@"$$$$$$$  %@",[SCManager sharedManager].currentAlarmArray);
                //创建一个消息对象
                NSNotification *alarmStateChanged = [NSNotification notificationWithName:ALARM_STATE_CHANGED object:nil userInfo:nil];
                //发送消息
                [[NSNotificationCenter defaultCenter] postNotification:alarmStateChanged];
            }
        }
            break;
        case TYPE_SYNCHRONIZE_TIME:
            NSLog(@"同步时间");
            break;
        case TYPE_TOUCH_CUP:
            NSLog(@"触摸水杯");
            int water = ((int)byteData[6]) * 10;
            [self requestUploadDrinkRecords:water];
//            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//            NSDate *now = [NSDate date];;
//            NSDateComponents *comps = [[NSDateComponents alloc] init];
//            NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
//            NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//            comps = [calendar components:unitFlags fromDate:now];
//            int hour = [comps hour];
//            int min = [comps minute];
//            NSLog(@"当前时间:hour=%d,minute=%d",hour,min);

            //如果当前时间和闹钟时间一样，则上传
//            NSArray *values = [_currentAlarmDic allValues];
//            for (int i=0; i<values.count; i++) {
//                AlarmBean *bean = [values objectAtIndex:i];
//                if (bean.hour == hour && bean.minute == min) {
//                    [self requestUploadDrinkRecords:bean.water*10];
//                    break;
//                }
//            }
            break;
    }
    
    //创建一个消息对象
    NSNotification *cupStateChanged = [NSNotification notificationWithName:CUP_STATE_CHANGED object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:cupStateChanged];
}

//-(NSMutableArray *)unarchivedDrinkRecords {
//    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = documents[0];
//    NSString *archivePath = [docDir stringByAppendingPathComponent:@"defaultDrinkRecord.plist"];
//    NSMutableArray *records = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
//    NSLog(@"获取归档的饮水记录: %@",records);
//    return records;
//}
//
//-(void)updateArchiveDrinkRecordsToLocal:(NSMutableArray *)records {
//    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = documents[0];
//    NSString *archivePath = [docDir stringByAppendingPathComponent:@"defaultDrinkRecord.plist"];
//    NSLog(@"重新归档饮水记录: %@",records);
//    [NSKeyedArchiver archiveRootObject:records toFile:archivePath];
//}


-(void)requestUploadDrinkRecords:(int)water{
    if([SCAccountManager sharedManager].localUser.phone == nil){
         NSLog(@"[SCAccountManager sharedManager].localUser.phone == nil  return");
        return;
    }
    //获取时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];//转为字符型
    NSLog(@"timeString=%@",timeString);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlStr = [NSString stringWithFormat:@"http://112.74.79.95:8080/MicroMessage/DayDrink.action?phone=%@&drink=%d&time=%@",[SCAccountManager sharedManager].localUser.phone, water, timeString];
    NSLog(@"urlStr=%@",urlStr);
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            NSLog(@"上传饮水记录 失败");
        } else {
            NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
            NSNumber *code = [result objectForKey:@"code"];
            NSString *message = [result objectForKey:@"message"];
            NSLog(@"code=%@, message=%@",code, message);
            if([code intValue] == 1){
                 NSLog(@"上传饮水记录 成功");
            }else {
                NSLog(@"上传饮水记录 失败");
            }
        }
    }];
    [dataTask resume];
}

static int vibreatTimes = 0;
void soundCompleteCallback(SystemSoundID sound,void * clientData) {
    NSLog(@"震动结束");
    vibreatTimes++;
    if (vibreatTimes%5 != 0) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  //震动
    }
    
   
}


@end
