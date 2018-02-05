//
//  AutoConnectManager.m
//  intelligent_cup
//
//  Created by liuming on 2016/11/2.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import "AutoConnectManager.h"
#define AUTO_CONNECT_PLIST  @"AUTO_CONNECT_PLIST.plist"
@implementation AutoConnectManager

static AutoConnectManager*_instance;
+(AutoConnectManager *)sharedManager{
    if(_instance==nil){
        _instance = [[AutoConnectManager alloc] init];
    }
    return _instance;
}

-(BOOL)isLastConnected:(CBPeripheral*)peripheral {
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documents[0];
    NSString *archivePath = [docDir stringByAppendingPathComponent:AUTO_CONNECT_PLIST];
    NSString *identifier = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
    if ([[peripheral.identifier UUIDString] isEqualToString:identifier]) {
        return YES;
    }
    return NO;
}
-(void)clearLastConnectedDevice {
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documents[0];
    NSString *archivePath = [docDir stringByAppendingPathComponent:AUTO_CONNECT_PLIST];
    NSString *identifier = @"";
    [NSKeyedArchiver archiveRootObject:identifier toFile:archivePath];
}
-(void)updateLastConnectedDevice:(CBPeripheral*)peripheral {
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documents[0];
    NSString *archivePath = [docDir stringByAppendingPathComponent:AUTO_CONNECT_PLIST];
    NSString *identifier = [peripheral.identifier UUIDString];
    [NSKeyedArchiver archiveRootObject:identifier toFile:archivePath];
}

//-(SCUser *)archivedUser {
//    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = documents[0];
//    NSString *archivePath = [docDir stringByAppendingPathComponent:@"defaultUser.plist"];
//    SCUser *defaultUser = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
//    NSLog(@"获取归档的user: %@",defaultUser);
//    return defaultUser;
//}
//
//-(void)updateArchivedUser:(SCUser *)user {
//    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = documents[0];
//    NSString *archivePath = [docDir stringByAppendingPathComponent:@"defaultUser.plist"];
//    NSLog(@"重新归档user: %@",user);
//    [NSKeyedArchiver archiveRootObject:user toFile:archivePath];
//}

@end
