//
//  DrinkRecordBean.h
//  intelligent_cup
//
//  Created by liuming on 16/8/11.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrinkRecordBean : NSObject

@property (strong,nonatomic) NSString *time;
@property (strong,nonatomic) NSString *drink;

-(NSString *)formatTime;

@end
