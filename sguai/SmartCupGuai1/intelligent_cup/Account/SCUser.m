//
//  SCUser.m
//  intelligent_cup
//
//  Created by liuming on 16/7/5.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import "SCUser.h"

@implementation SCUser

#define k_name @"name"
#define k_phone @"phone"
#define k_pwd @"pwd"
#define k_email @"email"
#define k_age @"age"
#define k_sex @"sex"
#define k_tall @"tall"
#define k_weight @"weight"
#define k_leftStyle @"leftStyle"

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:k_name];
    [aCoder encodeObject:self.phone forKey:k_phone];
    [aCoder encodeObject:self.pwd forKey:k_pwd];
    [aCoder encodeObject:self.email forKey:k_email];
    [aCoder encodeInteger:self.age forKey:k_age];
    [aCoder encodeInteger:self.sex forKey:k_sex];
    [aCoder encodeInteger:self.tall forKey:k_tall];
    [aCoder encodeInteger:self.weight forKey:k_weight];
    //    [aCoder encodeInteger:self.leftStyle forKey:k_leftStyle];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:k_name];
        self.phone = [aDecoder decodeObjectForKey:k_phone];
        self.pwd = [aDecoder decodeObjectForKey:k_pwd];
        self.email = [aDecoder decodeObjectForKey:k_email];
        self.age = [aDecoder decodeIntegerForKey:k_age];
        self.sex = [aDecoder decodeIntegerForKey:k_sex];
        self.tall = [aDecoder decodeIntegerForKey:k_tall];
        self.weight = [aDecoder decodeIntegerForKey:k_weight];
        //        self.leftStyle = [aDecoder decodeIntegerForKey:k_leftStyle];
        //        self.drinkGoal = [aDecoder decodeIntegerForKey:k_drinkGoal];
    }
    return self;
}

#pragma mark - NSCoping
- (id)copyWithZone:(NSZone *)zone {
    SCUser *copy = [[[self class] allocWithZone:zone] init];
    copy.name = [self.name copyWithZone:zone];
    copy.phone = [self.phone copyWithZone:zone];
    copy.pwd = [self.pwd copyWithZone:zone];
    copy.email = [self.email copyWithZone:zone];
    
    copy.age = self.age;
    copy.sex = self.sex;
    copy.tall = self.tall;
    copy.weight = self.weight;
    //    copy.leftStyle = self.leftStyle;
    //    copy.drinkGoal = self.drinkGoal;
    return copy;
}

-(NSString *)description {
    if(self.sex == 1){
        return [NSString stringWithFormat:@"%@,phone=%@,pwd=%@,age=%d,tall=%d,weight=%d",NSLocalizedString(@"男", nil),self.phone,self.pwd,self.age,self.tall,self.weight];
    }else if(self.sex == 0){
        return [NSString stringWithFormat:@"%@,phone=%@,pwd=%@,age=%d,tall=%d,weight=%d",NSLocalizedString(@"女", nil),self.phone,self.pwd,self.age,self.tall,self.weight];
    }
    return nil;
}


//检测信息完整性
-(NSString *)checkInformationIntegrality {
    NSString *result;
    if ([[self.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
    }
    if ([[self.phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
    }
    if ([[self.pwd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
    }
    if ([[self.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
    }
    if ([[self.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
    }
    return @"";
}

-(int)calculateDrinkGoal {
    //http://wenku.baidu.com/link?url=97h0RsW_5tXiBIiV_k_LOHdwwCwbnn1O6jbxQyV7SXgBOtTkZeewl2Wq8jxEw9wb0PTDsAgEASfRUebipULK4f40egpawgpqP58nXaGnvdC
    int goal = self.weight * (0.033 * 1000);//单位是ml
    if (goal < 1000) {
        goal = 1000;
    }
    return goal;
}

@end
