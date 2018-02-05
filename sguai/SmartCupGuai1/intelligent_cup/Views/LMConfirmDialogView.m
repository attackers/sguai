//
//  LMConfirmDialogView.m
//  重命名_提示框
//
//  Created by liuming on 14-11-10.
//  Copyright (c) 2014年 liuming. All rights reserved.
//

#import "LMConfirmDialogView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation LMConfirmDialogView {
    UIView       *backgroundView;     // 整个屏幕的半透明，灰黑色背景
    UIView       *containerView;      // 容器view，包含提示框的全部控件。addSubView都是添加到containerView
    UIButton     *leftButton;
    UIButton     *rightButton;
    UILabel      *titleLabel; //提示语
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //初始化的时候，透明，而且隐藏  想要显示，需要调用：showSelfWithAnimation
        self.alpha = 0;
        self.hidden = YES;
        
        //占满整个屏幕
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        backgroundView = [[UIView alloc] initWithFrame:self.frame];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.5;
        [self addSubview:backgroundView];
        
        containerView = [[UIView alloc] init];
        containerView.center = self.center;
        containerView.bounds = CGRectMake(0, 0, 260, 70);
        containerView.backgroundColor = [UIColor blackColor];
        //        containerView.backgroundColor = UIColorFromRGB(0xed7119);
        [self addSubview:containerView];
        
        //提示文字
        titleLabel = [[UILabel alloc] init];
        //文字太多  自动换行
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        titleLabel.numberOfLines = 0;
        titleLabel.bounds = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height/2-3);
        titleLabel.center = CGPointMake(containerView.frame.size.width/2, (containerView.frame.size.height-3)/4);
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = NSLocalizedString(@"alert_confirm_title", nil);  //提示语应该调用者设置
//        titleLabel.backgroundColor = [UIColor grayColor];
               titleLabel.textColor = [UIColor whiteColor];
        [containerView addSubview:titleLabel];
        
        //蓝色的线
        UIView *blueLineView = [[UIView alloc] init];
        blueLineView.center = CGPointMake(containerView.frame.size.width/2, containerView.frame.size.height/2);
        blueLineView.bounds = CGRectMake(0, 0, containerView.frame.size.width, 1);
        blueLineView.backgroundColor = [UIColor grayColor];
        [containerView addSubview:blueLineView];
        
        //按钮之间灰色的线
        UIView *grayLineView = [[UIView alloc] init];
        grayLineView.center = CGPointMake(containerView.frame.size.width/2, (containerView.frame.size.height+1)*3/4);
        grayLineView.bounds = CGRectMake(0, 0, 1, (containerView.frame.size.height-3)/3);
        grayLineView.backgroundColor = [UIColor whiteColor];
        [containerView addSubview:grayLineView];
        
        leftButton = [UIButton buttonWithType:UIButtonTypeSystem] ;
        [leftButton setTitle:NSLocalizedString(@"alert_cancel", nil) forState:UIControlStateNormal];
//         [leftButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        leftButton.bounds = CGRectMake(0, 0, containerView.frame.size.width/2, containerView.frame.size.height/2-3);       leftButton.center = CGPointMake((containerView.frame.size.width-3)/4,grayLineView.center.y);
//        leftButton.backgroundColor = [UIColor redColor];
        [leftButton addTarget:self action:@selector(leftButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:leftButton];
        
        rightButton = [UIButton buttonWithType:UIButtonTypeSystem] ;
        [rightButton setTitle:NSLocalizedString(@"alert_confirm", nil) forState:UIControlStateNormal];
//        [rightButton setTitle:@"OK" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightButton.bounds = CGRectMake(0, 0, containerView.frame.size.width/2, containerView.frame.size.height/2-3);
        rightButton.center = CGPointMake((containerView.frame.size.width+1)*3/4,grayLineView.center.y);
//        rightButton.backgroundColor = [UIColor redColor];
        [rightButton addTarget:self action:@selector(rightButtonOnClick) forControlEvents:UIControlEventTouchUpInside];        [containerView addSubview:rightButton];
    }
    return self;
}

//隐藏
- (void) hiddenSelfWithAnimation {
    //     NSLog(self.hidden?@"hidden＝yes":@"hidden = NO");
    if (self.hidden) {
        return;
    }
    //    NSLog(@"渐渐隐藏");
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
//显示出来：在 addSubView 之后，需要调用此方法才行
- (void) showSelfWithAnimation {
    //    NSLog(self.hidden?@"hidden＝yes":@"hidden = NO");
    if (!self.hidden) {
        return;
    }
    //    NSLog(@"渐渐显示");
    self.hidden = NO;
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
//设置提示语
- (void)setTitle:(NSString *)titile {
    titleLabel.text = titile;
}

- (void) leftButtonOnClick {
    [self hiddenSelfWithAnimation];
    [self.confirmDelegate leftButtonOnClick];
}

- (void) rightButtonOnClick {
    [self hiddenSelfWithAnimation];
    [self.confirmDelegate rightButtonOnClick];
}


/**  例子代码
 LMConfirmDialogView *renameInputView ;
 
 - (void)showAlertView {
 if (renameInputView == nil) {
 NSLog(@"初始化 alertView");
 renameInputView = [[LMConfirmDialogView alloc] init];
 [renameInputView setTitle:@"xxx"];
 //        [renameInputView setAlertWordsText:@"ss"];
 renameInputView.confirmDelegate = self;
 [self.view addSubview:renameInputView];
 }
 [renameInputView showSelfWithAnimation];
 }
 **/
@end
