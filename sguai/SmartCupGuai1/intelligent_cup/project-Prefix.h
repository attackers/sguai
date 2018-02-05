//
//  project-Prefix.h
//  intelligent_cup
//
//  Created by liuming on 15/10/31.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import <Availability.h>

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseViewController.h"
#import "Toast+UIView.h"
#import "SCAccountManager.h"
#endif


////关闭打印 置0 开启置1
//#define SADEBUG 1
//#if SADEBUG
//#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//#else
//#define NSLog(FORMAT, ...) nil
//#endif
