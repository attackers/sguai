//
//  DrinkRecordBean.m
//  intelligent_cup
//
//  Created by liuming on 16/8/11.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import "DrinkRecordBean.h"

@implementation DrinkRecordBean

-(NSString *)formatTime {
   return  [[self.time stringByReplacingOccurrencesOfString:@"-" withString:@"/"] substringFromIndex:5];
}

-(NSString *)description {
//    return [NSString stringWithFormat:@"time=%@,drink=%@",self.time,self.drink];
    return [NSString stringWithFormat:@"time=%@,drink=%@",[self formatTime],self.drink];
}

@end
