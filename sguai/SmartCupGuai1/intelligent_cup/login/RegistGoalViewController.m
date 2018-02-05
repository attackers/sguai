//
//  RegistGoalViewController.m
//  intelligent_cup
//
//  Created by liuming on 15/11/13.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import "RegistGoalViewController.h"
#import "SCAccountManager.h"


@interface RegistGoalViewController () <UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation RegistGoalViewController {
    int _number_selected;  //pickerView选中的数字
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btn_goal addTarget:self action:@selector(btn_goal_click) forControlEvents:UIControlEventTouchUpInside];
    
    self.pickView_number.dataSource = self;
    self.pickView_number.delegate = self;
    
    self.view_picker_container.hidden = YES;
    self.view_shadow.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //设置饮水量
    int goal = [[SCAccountManager sharedManager].localUser calculateDrinkGoal];
    NSString *goalStr = [NSString stringWithFormat:@"%dml",goal];
    [self.btn_goal setTitle:goalStr forState:UIControlStateNormal];
    [self.btn_goal setTitle:goalStr forState:UIControlStateHighlighted];
}

- (void)btn_goal_click {
    //    NSLog(@"btn_goal_click");
    //    self.view_picker_container.hidden = NO;
    //    self.view_shadow.hidden = NO;
}

- (IBAction)btn_finish_onclicked:(id)sender {
    NSLog(@"完成");
    //根据archivedUser是否为nil，判断是注册，还是UpdateUser
    if([[SCAccountManager sharedManager] archivedUser] == nil){
        NSLog(@"注册新用户：%@",[SCAccountManager sharedManager].localUser);
        [self userRegister:[SCAccountManager sharedManager].localUser];
    }else {
        NSLog(@"更新用户信息：%@",[SCAccountManager sharedManager].localUser);
        [self userUpdate:[SCAccountManager sharedManager].localUser];
    }
}

- (IBAction)btn_confirm_onclicked:(id)sender {
    NSLog(@"btn_confirm_onclicked");
    self.view_picker_container.hidden = YES;
    self.view_shadow.hidden = YES;
    //    [IndividualInfoBean sharedIndividualInfoBean].goal= _number_selected;
    NSString *goalStr = [NSString stringWithFormat:@"%dml",_number_selected];
    [self.btn_goal setTitle:goalStr forState:UIControlStateNormal];
    [self.btn_goal setTitle:goalStr forState:UIControlStateHighlighted];
}

- (IBAction)btn_cancel_onclicked:(id)sender {
    NSLog(@"btn_cancel_onclicked");
    self.view_picker_container.hidden = YES;
    self.view_shadow.hidden = YES;
}

//data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 250;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%d",row*10+2000];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _number_selected = row*10+2000;
    NSLog(@"_number_selected=%d",_number_selected);
}

- (IBAction)btn_back_onclicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//2.http://112.74.79.95:8080/MicroMessage/UserRegister.action?name=&pwd=&email=&age=&sex=&tall=&weight=&phone=
//参数：name(用户名),pwd(密码),email(邮箱),age(年龄 int),sex(性别 1:男,2:女),tall(身高),weight(体重),phone(电话)
-(void)userRegister:(SCUser *)user {
    [self showLoading];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlStr = [NSString stringWithFormat:@"http://112.74.79.95:8080/MicroMessage/UserRegister.action?name=%@&pwd=%@&email=%@&age=%d&sex=%d&tall=%d&weight=%d&phone=%@",user.name,user.pwd,user.email,user.age,user.sex,user.tall,user.weight,user.phone];
    NSLog(@"urlStr=%@",urlStr);
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [self dismissLoading];
        if (error) {
            NSLog(@"Error: %@", error);
            [self.view makeToast:NSLocalizedString(@"注册失败", nil) duration:1.0f position:@"center"];
        } else {
            //{"code":1,"message":"用户插入成功"}
            NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
            NSNumber *code = [result objectForKey:@"code"];
            NSString *message = [result objectForKey:@"message"];
            NSLog(@"code=%@, message=%@",code, message);
            if([code intValue] == 1){
                [self.view makeToast:NSLocalizedString(@"注册成功", nil) duration:1.0f position:@"center"];
                //将用户信息归档
                [[SCAccountManager sharedManager] updateArchivedUser: [SCAccountManager sharedManager].localUser];
                [self dismissViewControllerAnimated:YES completion:nil];
                //popToRoot,还存在一个
//                [self.navigationController popToRootViewControllerAnimated:YES];
            }else {
                [self.view makeToast:NSLocalizedString(@"注册失败", nil) duration:1.0f position:@"center"];
            }
        }
    }];
    [dataTask resume];
}

-(void)userUpdate:(SCUser *)user {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlStr = [NSString stringWithFormat:@"http://112.74.79.95:8080/MicroMessage/UpdateUserInfo.action?phone=%@&sex=%ld&age=%ld&tall=%ld&weight=%ld",user.phone, user.sex, user.age, user.tall, user.weight];
    NSLog(@"urlStr=%@",urlStr);
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [self dismissLoading];
        if (error) {
            NSLog(@"Error: %@", error);
            [self.view makeToast:NSLocalizedString(@"资料修改失败", nil) duration:1.0f position:@"center"];
        } else {
            NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
            NSNumber *code = [result objectForKey:@"code"];
            NSString *message = [result objectForKey:@"message"];
            NSLog(@"code=%@, message=%@",code, message);
            if([code intValue] == 1){
                NSLog(@"userUpdate 成功");
                [self.view makeToast:NSLocalizedString(@"资料修改成功", nil) duration:1.0f position:@"center"];
                [[SCAccountManager sharedManager] updateArchivedUser: [SCAccountManager sharedManager].localUser];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else {
                [self.view makeToast:NSLocalizedString(@"资料修改失败", nil) duration:1.0f position:@"center"];
            }
        }
    }];
    [dataTask resume];
}
@end
