//
//  RegistViewController.h
//  intelligent_cup
//
//  Created by liuming on 15/11/13.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCAccountManager.h"

@interface RegistViewController : BaseViewController

- (IBAction)btn_regist_onclicked:(id)sender;
- (IBAction)btn_login_onclicked:(id)sender;
- (IBAction)btn_forgot_pwd_onclicked:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *textField_pwd;
@property (weak, nonatomic) IBOutlet UITextField *textField_phone;


@end
