//
//  AccountManager.h
//  intelligent_cup
//
//  Created by liuming on 16/7/5.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCUser.h"
#import "AFNetworking.h"


@interface SCAccountManager : NSObject



@property (strong,nonatomic) SCUser *localUser;

+(SCAccountManager*)sharedManager;

-(SCUser *)archivedUser;

-(void)updateArchivedUser:(SCUser *)user;

//
////2.
//-(void)userRegister:(SCUser *)user;
//
////3.
//-(void)userAddComment:(SCUser *)user andComment:(NSString *)comment;
//
////4.
//-(void)userLogin:(SCUser *)user;
//
//
//
////10.
//-(void)userQueryExist:(SCUser *)user;
//
////11.
//-(void)userUpdate:(SCUser *)user;

@end
