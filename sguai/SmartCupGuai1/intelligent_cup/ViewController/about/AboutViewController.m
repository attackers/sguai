//
//  AboutViewController.m
//  intelligent_cup
//
//  Created by liuming on 15/10/30.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import "AboutViewController.h"
#import "RegistViewController.h"
#import "RecommendViewController.h"
#import "FaqViewController.h"
#import "FeedbackViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //自动获取版本信息
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    self.label_version.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"版本信息v", @""),version];
}

- (IBAction)btn_recommend_onclicked:(id)sender {
    NSLog(@"专家推荐");
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController: [[RecommendViewController alloc] init] animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}
//- (IBAction)btn_faq_onclicked:(id)sender {
//    NSLog(@"常见问题");
//    self.tabBarController.tabBar.hidden = YES;
//    self.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController: [[FaqViewController alloc] init] animated:YES];
//    self.hidesBottomBarWhenPushed=NO;
//}
- (IBAction)btn_feedback_onclicked:(id)sender {
    NSLog(@"意见反馈");
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController: [[FeedbackViewController alloc] init] animated:YES];
    self.hidesBottomBarWhenPushed=NO; 
}


- (IBAction)btn_sign_out_onclicked:(id)sender {
    NSLog(@"退出当前账号");
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"确定退出当前账号?", @"")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"取消", @"")
                                               destructiveButtonTitle:NSLocalizedString(@"退出", @"")
                                                    otherButtonTitles:nil
                                  ];
    [actionSheet showInView:self.view];
}

//点击了确定
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == [actionSheet destructiveButtonIndex]){
               //清除归档的数据
        [SCAccountManager sharedManager].localUser = nil;
        [[SCAccountManager sharedManager] updateArchivedUser:[SCAccountManager sharedManager].localUser];
        
        SCUser *user = [[SCAccountManager sharedManager] archivedUser];
        if (user == nil) {
            NSLog(@"没有注册过，弹出注册VC");
            RegistViewController *registVC = [[RegistViewController alloc] init];
            UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:registVC];
            [navLogin setNavigationBarHidden:YES];
            [self presentModalViewController:navLogin animated:YES];
        }else {
            NSLog(@"注册过:user=%@",user);
        }
        
        //退出账号后，选中tabBar的index-0的item
        [self performSelector:@selector(selectTabBarIndex0) withObject:nil afterDelay:1.0f];
    }
}

- (void)selectTabBarIndex0 {
    self.tabBarController.selectedIndex = 0;
}
@end
