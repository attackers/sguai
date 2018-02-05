//
//  SCCmdBuilder.h
//  mBot_enterprise
//
//  Created by liuming on 16/6/19.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MODE_READ       0x01
#define MODE_WRITE      0x02
#define MODE_FEED_BACK  0x03

#define HEAD_1     0xff
#define HEAD_2     0x55

#define LAST_1     0x0d
#define LAST_2     0x0a

#define TYPE_TEMPERATURE       0x01
#define TYPE_BATTERY           0x02
#define TYPE_ALARM             0x03
#define TYPE_SYNCHRONIZE_TIME  0x04
#define TYPE_TOUCH_CUP         0x05
#define TYPE_ALARM_RING        0x07
#define TYPE_LED               0x08

@interface SCCmdBuilder : NSObject

+ (NSData *)readTemperature;
+ (NSData *)readyBatteryEnergy;
+ (NSData *)readyAlarms;
+ (NSData *)changeTemperatureType:(UInt8)en;
+ (NSData *)writeAddAlarmWithAlarmIndex:(int) alarmIndex andIsOn:(BOOL) isOn andHour:(int) hour andMinute:(int)minute andRepeat:(int)repeat andWater:(int)water;

+ (NSData *)writeUpdateAlarmWithAlarmIndex:(int) alarmIndex andIsOn:(BOOL) isOn andHour:(int) hour andMinute:(int)minute andRepeat:(int)repeat andWater:(int)water;

+ (NSData *)writeDeleteAlarmWithAlarmIndex:(int) alarmIndex;

+ (NSData *)writeSynchronizeTimeWithHour:(int)hour andMinute:(int)minute andWeekDay:(int)weekDay;

+ (NSData *)writeControlLed;

@end
