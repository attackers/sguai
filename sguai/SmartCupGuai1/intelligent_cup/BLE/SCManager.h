//
//  SCManager.h
//  mBot_enterprise
//
//  Created by liuming on 16/6/19.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlarmBean.h"
#import "BLECentralManager.h"
#import "SCCmdBuilder.h"

#define CUP_STATE_CHANGED @"CUP_STATE_CHANGED"
#define ALARM_STATE_CHANGED @"ALARM_STATE_CHANGED"
#define ALARM_RING @"ALARM_RING"

@interface SCManager : NSObject <BLEControllerDelegate>

+(SCManager *)sharedManager;

+ (void)sendCmd_readTemperature;
+ (void)sendCmd_readyBatteryEnergy;
+ (void)sendCmd_readyAlarms;
+ (void)sendCmd_changeTemperatureType:(UInt8)en;
+ (void)sendCmd_addAlarmWithAlarmBean:(AlarmBean *) alarmBean;

+ (void)sendCmd_updateAlarmWithAlarmBean:(AlarmBean *) alarmBean;

+ (void)sendCmd_deleteAlarmWithAlarmBean:(AlarmBean *) alarmBean;

+ (void)sendCmd_synchronizeTime;

+ (void)sendCmd_controlLed;

@property (assign) NSInteger currentAlarmCount;
@property (strong, nonatomic) NSMutableArray *currentAlarmArray;
@property (assign) NSInteger currentTemp;
@property (assign) NSInteger currentTempType;
@property (assign) NSInteger currentBattery;

@property (strong, nonatomic) NSMutableArray *currentDrinkRecordArray;
//-(NSMutableArray *)unarchivedDrinkRecords;//获取归档的饮水纪录
//-(void)updateArchiveDrinkRecordsToLocal:(NSMutableArray *)records;



@end
