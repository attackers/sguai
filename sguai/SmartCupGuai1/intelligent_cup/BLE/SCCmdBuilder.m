//
//  SCCmdBuilder.m
//  mBot_enterprise
//
//  Created by liuming on 16/6/19.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import "SCCmdBuilder.h"

@implementation SCCmdBuilder
//  0 	 1	      2	      3	      4	       5	  6	    last
//协议头1	 协议头2	命令长度	命令id	读/写	命令type	 data_1	data_n
+ (NSData *)changeTemperatureType:(UInt8)en {
    char lenght = 0x07;
    char index = 0x01;
    unsigned char a[7]={HEAD_1, HEAD_2, lenght, index, MODE_WRITE, 0x0B, en};
    NSData *cmd = [NSData dataWithBytes:a length:7];
    return cmd;
}

+ (NSData *)readTemperature {
    char lenght = 0x07;
    char data = 0x01;
    char index = 0x01;
    unsigned char a[7]={HEAD_1, HEAD_2, lenght, index, MODE_READ, TYPE_TEMPERATURE, data};
    NSData *cmd = [NSData dataWithBytes:a length:7];
    return cmd;
}
+ (NSData *)readyBatteryEnergy {
    char lenght = 0x07;
    char data = 0x01;
    char index = 0x01;
    unsigned char a[7]={HEAD_1, HEAD_2, lenght, index, MODE_READ, TYPE_BATTERY, data};
    NSData *cmd = [NSData dataWithBytes:a length:7];
    return cmd;
}
+ (NSData *)readyAlarms {
    char lenght = 0x07;
    char data = 0x01;
    char index = 0x01;
    unsigned char a[7]={HEAD_1, HEAD_2, lenght, index, MODE_READ, TYPE_ALARM, data};
    NSData *cmd = [NSData dataWithBytes:a length:7];
    return cmd;
}

//0	       1	  2	      3	      4	      5	      6	     7	   8	9	     10
//协议头1	 协议头2	命令长度	命令id	命令类型	type	action	id	on/off	hour	minute
//0xff	0x55	计算		write：0x02	0x03	add：0x01		on:1  off:0
//+ (NSData *)writeAddAlarmWithAlarmIndex:(int) alarmIndex andIsOn:(BOOL) isOn andHour:(int) hour andMinute:(int)minute {
//    char lenght = 11;
//    char index = 0x01;
//    char action = 0x01;//add
//    char isOnChar = 0x00;
//    if (isOn) {
//        isOnChar = 0x01;
//    }
//    unsigned char a[11]={HEAD_1, HEAD_2, lenght, index, MODE_WRITE, TYPE_ALARM, action, alarmIndex, isOnChar, hour, minute};
//    NSData *cmd = [NSData dataWithBytes:a length:11];
//    return cmd;
//}
//+ (NSData *)writeUpdateAlarmWithAlarmIndex:(int) alarmIndex andState:(BOOL) isOn and:(int) hour andMinute:(int)minute{
//    char lenght = 11;
//    char index = 0x01;
//    char action = 0x02;//update
//    char isOnChar = 0x00;
//    if (isOn) {
//        isOnChar = 0x01;
//    }
//    unsigned char a[11]={HEAD_1, HEAD_2, lenght, index, MODE_WRITE, TYPE_ALARM, action, alarmIndex, isOnChar, hour, minute};
//    NSData *cmd = [NSData dataWithBytes:a length:11];
//    return cmd;
//}

+ (NSData *)writeAddAlarmWithAlarmIndex:(int) alarmIndex andIsOn:(BOOL) isOn andHour:(int) hour andMinute:(int)minute andRepeat:(int)repeat andWater:(int)water {
    char lenght = 13;
    char index = 0x01;
    char action = 0x01;//add
    char isOnChar = 0x00;
    if (isOn) {
        isOnChar = 0x01;
    }
    unsigned char a[13]={HEAD_1, HEAD_2, lenght, index, MODE_WRITE, TYPE_ALARM, action, alarmIndex, isOnChar, hour, minute, repeat, water};
    NSData *cmd = [NSData dataWithBytes:a length:13];
    return cmd;
}
+ (NSData *)writeUpdateAlarmWithAlarmIndex:(int) alarmIndex andIsOn:(BOOL) isOn andHour:(int) hour andMinute:(int)minute andRepeat:(int)repeat andWater:(int)water {
    char lenght = 13;
    char index = 0x01;
    char action = 0x02;//update
    char isOnChar = 0x00;
    if (isOn) {
        isOnChar = 0x01;
    }
    unsigned char a[13]={HEAD_1, HEAD_2, lenght, index, MODE_WRITE, TYPE_ALARM, action, alarmIndex, isOnChar, hour, minute, repeat, (char)water};
    NSData *cmd = [NSData dataWithBytes:a length:13];
    return cmd;
}
+ (NSData *)writeDeleteAlarmWithAlarmIndex:(int) alarmIndex {
    char lenght = 0x08;
    char action = 0x03;//delete
    char index = 0x01;
    unsigned char a[8]={HEAD_1, HEAD_2, lenght, index, MODE_WRITE, TYPE_ALARM, action, alarmIndex};
    NSData *cmd = [NSData dataWithBytes:a length:8];
    return cmd;
}

+ (NSData *)writeSynchronizeTimeWithHour:(int)hour andMinute:(int)minute andWeekDay:(int)weekDay{
    char lenght = 0x09;
    char index = 0x01;
    unsigned char a[9]={HEAD_1, HEAD_2, lenght, index, MODE_WRITE, TYPE_SYNCHRONIZE_TIME, hour, minute, weekDay};
    NSData *cmd = [NSData dataWithBytes:a length:lenght];
    return cmd;
}

+ (NSData *)writeControlLed {
    char lenght = 0x07;
    char index = 0x01;
    char data = 0x01;
    unsigned char a[9]={HEAD_1, HEAD_2, lenght, index, MODE_WRITE, TYPE_LED, data};
    NSData *cmd = [NSData dataWithBytes:a length:lenght];
    return cmd;
    
}
@end
