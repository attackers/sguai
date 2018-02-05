//
//  AutoConnectManager.h
//  intelligent_cup
//
//  Created by liuming on 2016/11/2.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEPeripheral.h"

@interface AutoConnectManager : NSObject

+(AutoConnectManager *)sharedManager;

-(BOOL)isLastConnected:(CBPeripheral*)peripheral;
-(void)clearLastConnectedDevice;
-(void)updateLastConnectedDevice:(CBPeripheral*)peripheral;

@end
