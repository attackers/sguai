//
//  AlarmBean.m
//  mBot_enterprise
//
//  Created by liuming on 16/6/19.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import "AlarmBean.h"
#import "math.h"

@implementation AlarmBean

-(void)setRepeatDaysWithDay1:(BOOL)day1 day2:(BOOL)day2 day3:(BOOL)day3 day4:(BOOL)day4 day5:(BOOL)day5 day6:(BOOL)day6 day7:(BOOL)day7 {
    Byte repeat = 1;
    if (day7) {
        repeat = repeat + pow(2,1);//计算以x为底数的y次幂
    }
    if (day6) {
        repeat = repeat + pow(2,2);//计算以x为底数的y次幂
    }
    if (day5) {
        repeat = repeat + pow(2,3);//计算以x为底数的y次幂
    }
    if (day4) {
        repeat = repeat + pow(2,4);//计算以x为底数的y次幂
    }
    if (day3) {
        repeat = repeat + pow(2,5);//计算以x为底数的y次幂
    }
    if (day2) {
        repeat = repeat + pow(2,6);//计算以x为底数的y次幂
    }
    if (day1) {
        repeat = repeat + pow(2,7);//计算以x为底数的y次幂
    }
    
    Byte array[] = {0, 0, 0, 0, 0, 0, 0, 0};
    Byte b = repeat;
    for (int i = 7; i>=0; i--) {
        array[i] = (Byte)(b&1);
        b = (Byte)(b>>1);
    }
    
    NSLog(@"设置闹钟");
    for(int i=0;i<7;i++){
        if (array[i]==1) {
            NSLog(@"星期[%d]:重复",i+1);
        }else {
            NSLog(@"星期[%d]:不重复",i+1);
        }
    }
    self.repeat = repeat;
}

-(NSString *)description {
    Byte array[] = {0, 0, 0, 0, 0, 0, 0, 0};
    Byte b = self.repeat;
    
    for (int i = 7; i>=0; i--) {
        array[i] = (Byte)(b&1);
        b = (Byte)(b>>1);
    }
    
//    for(int i=0;i<7;i++){
//        if (array[i]==1) {
//            NSLog(@"星期[%d]:重复",i+1);
//        }else {
//            NSLog(@"星期[%d]:不重复",i+1);
//        }
//    }
    
    if (self.isOn) {
        return [NSString stringWithFormat:@" index=%d,isOn=YES,hour=%d,minute=%d,water=%d",self.index,self.hour,self.minute,self.water];
    }else {
        return [NSString stringWithFormat:@" index=%d,isOn=NO,hour=%d,minute=%d,water=%d",self.index,self.hour,self.minute,self.water];
    }
}


@end
