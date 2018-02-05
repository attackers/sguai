//
//  AlarmBean.h
//  mBot_enterprise
//
//  Created by liuming on 16/6/19.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmBean : NSObject

@property (atomic, assign) int  index;
@property (atomic, assign) int  hour;
@property (atomic, assign) int  minute;
@property (atomic, assign) BOOL isOn;
@property (atomic, assign) Byte repeat;
@property (atomic, assign) int  water;

-(void)setRepeatDaysWithDay1:(BOOL)day1 day2:(BOOL)day2 day3:(BOOL)day3 day4:(BOOL)day4 day5:(BOOL)day5 day6:(BOOL)day6 day7:(BOOL)day7;

@end
