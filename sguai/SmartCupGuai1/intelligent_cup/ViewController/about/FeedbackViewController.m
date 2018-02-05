//
//  FeedbackViewController.m
//  intelligent_cup
//
//  Created by liuming on 16/8/8.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"意见反馈", nil)];
     self.textView_feedback.delegate = self;
    
    //1.设置NavBar的leftBarButtonItem按钮图片、
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:NSLocalizedString(@"发送", nil) forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
   //    [backButton setImage:[UIImage imageNamed:@"back_nor.png"] forState:UIControlStateNormal];
//    [backButton setImage:[UIImage imageNamed:@"back_press.png"] forState:UIControlStateHighlighted];
//       backButton.backgroundColor = [UIColor grayColor];
    backButton.frame = CGRectMake(0, 0, 50, 33);
    //调整位置靠左一点
    [backButton addTarget:self action:@selector(btnConfirm_click_done:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 15)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = backItem;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    [self.textView_feedback becomeFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.label_feedback.hidden = NO;
        self.label_feedback.text = NSLocalizedString(@"请输入您的问题并提交", nil);
    }else{
        self.label_feedback.hidden = YES;
        self.label_feedback.text = @"";
    }
}

//发送
- (void)btnConfirm_click_done:(id)sender {
    NSString *comment = self.textView_feedback.text;
    if ([[comment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        [self.view makeToast:NSLocalizedString(@"请填写评论", nil) duration:1.0f position:@"center"];
        return;
    }
    [self.textView_feedback resignFirstResponder];
    //增加评论，必须对comment encode，中文必须encode
    [self userAddComment:[SCAccountManager sharedManager].localUser andComment:[comment stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}


//3.http://112.74.79.95:8080/MicroMessage/MessageResgister.action?name=&content=
//参数：name(用户名),content(留言内容)
-(void)userAddComment:(SCUser *)user andComment:(NSString *)comment{
    [self showLoading];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlStr = [NSString stringWithFormat:@"http://112.74.79.95:8080/MicroMessage/MessageResgister.action?name=%@&content=%@",user.phone,comment];
    NSLog(@"urlStr=%@",urlStr);
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [self dismissLoading];
        if (error) {
            NSLog(@"Error: %@", error);
            [self.view makeToast:NSLocalizedString(@"反馈意见失败，请重试", nil) duration:1.0f position:@"center"];
        } else {
            //{"code":1,"message":"插入成功"}
            NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
            NSNumber *code = [result objectForKey:@"code"];
            NSString *message = [result objectForKey:@"message"];
            NSLog(@"code=%@, message=%@",code, message);
            if([code intValue] == 1){
                NSLog(@"添加评论成功");
                [self.view makeToast:NSLocalizedString(@"反馈意见成功", nil) duration:1.0f position:@"center"];
                //                 [self dismissViewControllerAnimated:YES completion:nil];
            }else {
                [self.view makeToast:NSLocalizedString(@"反馈意见失败，请重试", nil) duration:1.0f position:@"center"];
            }
        }
    }];
    [dataTask resume];
}




@end
