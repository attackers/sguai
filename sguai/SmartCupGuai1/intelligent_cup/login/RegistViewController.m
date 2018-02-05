//
//  RegistViewController.m
//  intelligent_cup
//
//  Created by liuming on 15/11/13.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import "RegistViewController.h"
#import "FindPwdViewController.h"
#import "RegistModifyViewController.h"
#import "Utils.h"

@interface RegistViewController ()

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    
    
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    //    singleFingerOne.delegate = self;
    [self.view addGestureRecognizer:singleFingerOne];
}

//单指单击,收起键盘
- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender{
    [self.textField_pwd resignFirstResponder];
    [self.textField_phone resignFirstResponder];
}

- (IBAction)btn_regist_onclicked:(id)sender {
    NSString *pwdStr =  self.textField_pwd.text;
    NSString *phoneStr = self.textField_phone.text;
    if ([[phoneStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        [self.view makeToast:NSLocalizedString(@"账号不能为空", nil) duration:1.0f position:@"center"];
        return;
    }
    //正则表达式，新的运营商手机没有覆盖全，比如：170打头
//    if (![Utils isMobile:phoneStr]) {
//        [self.view makeToast:@"请输入正确的手机号码" duration:1.0f position:@"center"];
//        return;
//    }
    
    //正则表达式
    if (![Utils isNumberAndLetter:phoneStr]) {
        [self.view makeToast:NSLocalizedString(@"账号只能为数字和字母", nil) duration:1.0f position:@"center"];
        return;
    }
  

    if ([[pwdStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        [self.view makeToast:NSLocalizedString(@"密码不能为空", nil) duration:1.0f position:@"center"];
        return;
    }
    NSLog(@"发送网络请求");
    //检测账号密码是否存在
    [self showLoading];
    [self userQueryExist:[self user]];
}

- (IBAction)btn_login_onclicked:(id)sender {
    NSString *pwdStr =  self.textField_pwd.text;
    NSString *phoneStr = self.textField_phone.text;
    if ([[phoneStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        [self.view makeToast:NSLocalizedString(@"账号不能为空", nil) duration:1.0f position:@"center"];
        return;
    }
    if ([[pwdStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        [self.view makeToast:NSLocalizedString(@"密码不能为空", nil) duration:1.0f position:@"center"];
        return;
    }
    [self showLoading];
    [self userLogin:[self user]];
}

- (IBAction)btn_forgot_pwd_onclicked:(id)sender {
    NSLog(@"btn_forgot_pwd_onclicked");
    FindPwdViewController *vc = [[FindPwdViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//检测pwd和phone完整性
-(BOOL)checkUser {
    NSString *pwdStr =  self.textField_pwd.text;
    NSString *phoneStr = self.textField_phone.text;
    if ([[phoneStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        [self.view makeToast:NSLocalizedString(@"账号不能为空", nil) duration:1.0f position:@"center"];
        return NO;
    }
    if ([[pwdStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        [self.view makeToast:NSLocalizedString(@"密码不能为空", nil) duration:1.0f position:@"center"];
        return NO;
    }
    return YES;
}

-(SCUser *)user {
    NSString *pwdStr =  self.textField_pwd.text;
    NSString *phoneStr = self.textField_phone.text;
    SCUser *user = [[SCUser alloc] init];
    user.pwd = pwdStr;
    user.phone = phoneStr;
    return user;
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    //键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    NSLog(@"keyboardWasShown");
    self.view.frame = CGRectMake(0, -80, self.view.frame.size.width, self.view.frame.size.height);
}

-(void)keyboardWillBeHidden:(NSNotification*)aNotification {
    //    NSLog(@"keyboardWillBeHidden");
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(void)showLoading{
    //让键盘消失，view的frame归零
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.textField_pwd resignFirstResponder];
    [self.textField_phone resignFirstResponder];
    [super showLoading];
}

//4:http://112.74.79.95:8080/MicroMessage/UserLogin.action?phone=&pwd=
//参数：phone(手机号) pwd(密码)
-(void)userLogin:(SCUser *)user {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlStr = [NSString stringWithFormat:@"http://112.74.79.95:8080/MicroMessage/UserLogin.action?phone=%@&pwd=%@",user.phone,user.pwd];
    NSLog(@"urlStr=%@",urlStr);
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [self dismissLoading];
        if (error) {
            NSLog(@"%@Error: %@",NSLocalizedString(@"登录",nil ), error);
            [self.view makeToast:NSLocalizedString(@"网络异常", nil) duration:1.0f position:@"center"];
        } else {
            //{"code":1,"message":"登陆成功","age":"13","sex":"1","tall":"13","weight":"12"}
            NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
            NSNumber *code = [result objectForKey:@"code"];
            NSString *message = [result objectForKey:@"message"];
            NSLog(@"code=%@, message=%@",code, message);
            if([code intValue] == 1){
                NSLog(@"登录成功");
                [self.view makeToast:NSLocalizedString(@"登录成功", nil) duration:1.0f position:@"center"];
                NSString *age = [result objectForKey:@"age"];
                NSString *sex = [result objectForKey:@"sex"];
                NSString *tall = [result objectForKey:@"tall"];
                NSString *weight = [result objectForKey:@"weight"];
                SCUser *userReceived = [[SCUser alloc] init];
                userReceived.age = [age intValue];
                userReceived.sex = [sex intValue];
                userReceived.tall = [tall intValue];
                userReceived.weight = [weight intValue];
                userReceived.phone = user.phone;
                userReceived.pwd = user.pwd;
                
                [SCAccountManager sharedManager].localUser = userReceived;
                [[SCAccountManager sharedManager] updateArchivedUser:[SCAccountManager sharedManager].localUser];
                
                //dismiss当前VC
                [self dismissViewControllerAnimated:YES completion:nil];
            }else {
                NSLog(@"登录失败");
                [self.view makeToast:NSLocalizedString(@"密码错误", nil) duration:1.0f position:@"center"];
            }
        }
    }];
    [dataTask resume];
}

-(void)userQueryExist:(SCUser *)user {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlStr = [NSString stringWithFormat:@"http://112.74.79.95:8080/MicroMessage/QueryUserExist.action?phone=%@",user.phone];
    NSLog(@"urlStr=%@",urlStr);
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [self dismissLoading];
        if (error) {
            NSLog(@"Error: %@", error);
            [self.view makeToast:NSLocalizedString(@"网络异常", nil) duration:1.0f position:@"center"];
        } else {
            //{"code":"1","message":"用户名可以使用"}
            NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
            NSNumber *code = [result objectForKey:@"code"];
            NSString *message = [result objectForKey:@"message"];
            NSLog(@"code=%@, message=%@",code, message);
            if([code intValue] == 1){
                NSLog(@"用户名可以使用");
                [self.view makeToast:NSLocalizedString(@"用户名可用", nil) duration:1.0f position:@"center"];
                //修改正在注册用户的信息
                [SCAccountManager sharedManager].localUser = [[SCUser alloc] init];
                [SCAccountManager sharedManager].localUser.phone = self.textField_phone.text;
                [SCAccountManager sharedManager].localUser.pwd = self.textField_pwd.text;
                //跳到用户信息填写界面
                [self.navigationController pushViewController:[[RegistModifyViewController alloc] init] animated:YES];
            }else {
                [self.view makeToast:NSLocalizedString(@"用户名已存在", nil) duration:1.0f position:@"center"];
            }
        }
    }];
    [dataTask resume];
}


@end
