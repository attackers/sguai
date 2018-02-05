//
//  FindPwdViewController.h
//  intelligent_cup
//
//  Created by liuming on 16/7/26.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindPwdViewController : BaseViewController

- (IBAction)btn_back_onclicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textField_phone;
@property (weak, nonatomic) IBOutlet UITextField *textField_pwd;
@property (weak, nonatomic) IBOutlet UITextField *textField_pwd_confirm;
- (IBAction)btn_confirm_onclicked:(id)sender;
@end
