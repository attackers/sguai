//
//  IndividualViewController.m
//  intelligent_cup
//
//  Created by liuming on 15/10/30.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import "IndividualViewController.h"
#import "FindPwdViewController.h"
#import "RegistModifyViewController.h"
#import "RegistGoalViewController.h"

@interface IndividualViewController ()

@end

@implementation IndividualViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    SCUser *user = [SCAccountManager sharedManager].localUser;
    NSLog(@"user=%@",user);
    if (user.sex == 1) {
        [self.imageView_head setImage:[UIImage imageNamed:@"profile_img_boy.png"]];
    }else {
         [self.imageView_head setImage:[UIImage imageNamed:@"profile_img_girl.png"]];
    }
    self.label_account.text = [NSString stringWithFormat:@"%@",user.phone];
    self.label_height.text = [NSString stringWithFormat:@"%dcm",user.tall];
    self.label_weight.text = [NSString stringWithFormat:@"%dkg",user.weight];
    self.label_goal.text = [NSString stringWithFormat:@"%dml",[user calculateDrinkGoal]];
}

- (IBAction)click_btn_modify:(id)sender {
    NSLog(@"click_btn_modify");
    //http://www.oschina.net/code/snippet_2429429_50263
    //push时候，隐藏tabbar  back时候，再显示出来
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController: [[RegistModifyViewController alloc] init] animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

- (IBAction)click_btn_resetPwd:(id)sender {
    NSLog(@"click_btn_resetPwd");
    //push时候，隐藏tabbar  back时候，再显示出来
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController: [[FindPwdViewController alloc] init] animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

@end
