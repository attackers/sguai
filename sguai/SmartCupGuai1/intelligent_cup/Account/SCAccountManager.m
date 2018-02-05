//
//  AccountManager.m
//  intelligent_cup
//
//  Created by liuming on 16/7/5.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import "SCAccountManager.h"

@implementation SCAccountManager

static SCAccountManager *_instance;
+(SCAccountManager*)sharedManager{
    if(_instance == nil){
        _instance = [[SCAccountManager alloc]init];
        SCUser *archivedUser = [_instance archivedUser];
        if (archivedUser == nil) {
            NSLog(@"archivedUser == nil");
            _instance.localUser = [[SCUser alloc] init];
        }else {
            NSLog(@"archivedUser=%@",archivedUser);
            _instance.localUser = archivedUser;
        }
    }
    return _instance;
}

-(SCUser *)archivedUser {
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documents[0];
    NSString *archivePath = [docDir stringByAppendingPathComponent:@"defaultUser.plist"];
    SCUser *defaultUser = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
    NSLog(@"获取归档的user: %@",defaultUser);
    return defaultUser;
}

-(void)updateArchivedUser:(SCUser *)user {
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documents[0];
    NSString *archivePath = [docDir stringByAppendingPathComponent:@"defaultUser.plist"];
     NSLog(@"重新归档user: %@",user);
    [NSKeyedArchiver archiveRootObject:user toFile:archivePath];
}


//1.http://112.74.79.95:8080/MicroMessage/List.action
//进入后台管理页面







//6:http://112.74.79.95:8080/MicroMessage//DeleteOneDrinkWarnServlet.action?tem=3
//进入后台: 获取温度提示信息  参数:tem(温度值)

//7:http://112.74.79.95:8080/MicroMessage/DrinkList.action
//进入后台: 提醒信息列表

//8:http://112.74.79.95:8080/MicroMessage/GetDrink.action?phone=&day=
//返回用户平均喝水量
//参数:phone用户手机 day多少天的平均喝水量(10就是近10的平均)


//9:http://112.74.79.95:8080/MicroMessage/DayDrink.action?phone=&drink=&time=
//记录用户喝水量
//参数:phone用户手机 drink用户喝水量 time13位时间戳


//10.

@end
