//
//  BaseChildViewController.m
//  intelligent_cup
//
//  Created by liuming on 16/8/8.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import "BaseChildViewController.h"

@interface BaseChildViewController ()

@end

@implementation BaseChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      UITextAttributeTextColor:[UIColor whiteColor]
                                                                      }];
    //1.设置NavBar的leftBarButtonItem按钮图片、
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back_nor.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_press.png"] forState:UIControlStateHighlighted];
    //        backButton.backgroundColor = [UIColor grayColor];
    backButton.frame = CGRectMake(0, 0, 33, 33);
    //调整位置靠左一点
    [backButton addTarget:self action:@selector(btn_back_onclicked:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 15)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)btn_back_onclicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)showLoading{
    
    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    [view setTag:103];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.6];
    [self.view addSubview:view];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 132.0f, 132.0f)];
    [activityIndicator setCenter:view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:activityIndicator];
    [activityIndicator startAnimating];
}

-(void)dismissLoading{
    UIView *view = (UIView *)[self.view viewWithTag:103];
    [view removeFromSuperview];
    [self resignFirstResponder];
}


@end
