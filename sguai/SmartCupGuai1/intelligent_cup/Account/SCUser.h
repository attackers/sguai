//
//  SCUser.h
//  intelligent_cup
//
//  Created by liuming on 16/7/5.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCUser : NSObject

//name和phone一样
//name(用户名),phone pwd(密码),email(邮箱),age(年龄 int),sex(性别 1:男,2:女),tall(身高),weight(体重)
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *phone;
@property (strong,nonatomic) NSString *pwd;
@property (strong,nonatomic) NSString *pwdNew;//新密码，用户修改密码时候用
@property (strong,nonatomic) NSString *email;
@property (assign) NSInteger age;
@property (assign) NSInteger sex;
@property (assign) NSInteger tall;
@property (assign) NSInteger weight;

//@property (assign) NSInteger leftStyle;//轻度运动：1  中度运动：2  重度运动：3


-(int)calculateDrinkGoal;

//检测信息完整性
-(NSString *)checkInformationIntegrality;

@end
