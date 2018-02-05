//
//  FindPwdViewController.m
//  intelligent_cup
//
//  Created by liuming on 16/7/26.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import "FindPwdViewController.h"

@interface FindPwdViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation FindPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel.text = NSLocalizedString(@"找回密码", nil);
}

- (IBAction)btn_back_onclicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btn_confirm_onclicked:(id)sender {
    NSLog(@"btn_confirm_onclicked");
    if([self check]){
        NSLog(@"ok");
        //隐藏键盘
        [self.textField_pwd resignFirstResponder];
        [self.textField_pwd_confirm resignFirstResponder];
        [self.textField_phone resignFirstResponder];
        NSString *pwdStr =  self.textField_pwd.text;
        NSString *phoneStr = self.textField_phone.text;
        [self userModifyPwdWithPhone:phoneStr andPwd:pwdStr];
    }else {
        NSLog(@"no");
    }
}

-(BOOL)check {
    NSString *pwdStr =  self.textField_pwd.text;
    NSString *pwdConfirmStr =  self.textField_pwd_confirm.text;
    NSString *phoneStr = self.textField_phone.text;
    if ([[phoneStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        [self.view makeToast:NSLocalizedString(@"账号不能为空", nil) duration:1.0f position:@"center"];
        return NO;
    }
    if ([[pwdStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        [self.view makeToast:NSLocalizedString(@"密码不能为空", nil) duration:1.0f position:@"center"];
        return NO;
    }
    if ([[pwdConfirmStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        [self.view makeToast:NSLocalizedString(@"确认密码不能为空", nil) duration:1.0f position:@"center"];
        return NO;
    }
    if(![pwdConfirmStr isEqualToString:pwdStr]){
        [self.view makeToast:NSLocalizedString(@"两次输入的密码必须相同", nil) duration:1.0f position:@"center"];
        return NO;
    }
    return YES;
}

//5:http://112.74.79.95:8080/MicroMessage/UpdateUser.action?phone=&pwd=
//修改密码接口
//参数：phone(手机号),pwd(密码)
-(void)userModifyPwdWithPhone:(NSString *)phone andPwd:(NSString *)pwdNew{
    [self showLoading];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlStr = [NSString stringWithFormat:@"http://112.74.79.95:8080/MicroMessage/UpdateUserPwd.action?phone=%@&pwd=%@",phone, pwdNew];
    NSLog(@"urlStr=%@",urlStr);
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [self dismissLoading];
        if (error) {
            NSLog(@"Error: %@", error);
             NSLog(@"重置密码失败");
            [self.view makeToast:NSLocalizedString(@"重置密码失败", nil) duration:1.0f position:@"center"];
        } else {
            NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
            NSNumber *code = [result objectForKey:@"count"];
            NSString *message = [result objectForKey:@"message"];
            NSLog(@"code=%@, message=%@",code, message);
            if([code intValue] == 1){
                NSLog(@"重置密码成功");
               [self.view makeToast:NSLocalizedString(@"重置密码成功", nil) duration:1.0f position:@"center"];
            }else {
                [self.view makeToast:NSLocalizedString(@"重置密码失败", nil) duration:1.0f position:@"center"];
            }
        }
    }];
    [dataTask resume];
}


@end
