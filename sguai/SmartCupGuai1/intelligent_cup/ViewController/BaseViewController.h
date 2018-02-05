//
//  BaseViewController.h
//  intelligent_cup
//
//  Created by liuming on 15/10/31.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCAccountManager.h"
#import "SCUser.h"
#import "AFNetworking.h"

@interface BaseViewController : UIViewController 

-(void)showLoading;
-(void)dismissLoading;
-(BOOL)peripheralConnectedWithToast;
-(BOOL)peripheralConnected;
-(BOOL)isBleOn;
-(BOOL)isBleOnWithToast;
-(void)postNotification:(NSString *)notificationStr;
@end
