//
//  LMConfirmDialogView.m
//  重命名_提示框
//
//  Created by liuming on 14-11-10.
//  Copyright (c) 2014年 liuming. All rights reserved.
//

#import "LMRenameInputView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation LMRenameInputView {
    UIView       *backgroundView;     // 整个屏幕的半透明，灰黑色背景
    UIView       *containerView;      // 容器view，包含提示框的全部控件。addSubView都是添加到containerView
    UIButton     *leftButton;
    UIButton     *rightButton;
    UITextField  *renameTextField; //提示语
    UILabel      *title;   //头部标题
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
        containerView.bounds = CGRectMake(0, 0, 260, 90);
        containerView.backgroundColor = [UIColor blackColor];
        //        containerView.backgroundColor = UIColorFromRGB(0xed7119);
        [self addSubview:containerView];
        
        //提示文字
        title = [[UILabel alloc] initWithFrame:CGRectMake(105, 2, 50, 20)];
        title.text = @"Rename";
        title.textColor = [UIColor whiteColor];
        [title setFont:[UIFont systemFontOfSize:13]];
        title.backgroundColor = [UIColor clearColor];
        [containerView addSubview:title];
        
        renameTextField = [[UITextField alloc] init];
        renameTextField.font = [UIFont systemFontOfSize:15];
        renameTextField.backgroundColor = [UIColor whiteColor];
        renameTextField.frame = CGRectMake(15, 25, 230, 25);
        
        renameTextField.textAlignment = NSTextAlignmentLeft;
        //renameTextField.text = @"BLUETUNE-AURA";
        renameTextField.textColor = [UIColor grayColor];
        renameTextField.placeholder = @"BLUETUNE-AURA";
        renameTextField.clearsOnBeginEditing = NO;//开始编辑，rename获取到焦点时候，text并不被清除掉
        renameTextField.keyboardType = UIKeyboardTypeDefault;
        [renameTextField setDelegate:self];
        renameTextField.clearButtonMode = UITextFieldViewModeAlways;//右边的clearButton一直显示
        [containerView addSubview:renameTextField];
    
        
        //按钮之间灰色的线
        UIView *grayLineView = [[UIView alloc] init];
        grayLineView.center = CGPointMake(containerView.frame.size.width/2, (containerView.frame.size.height+1)*3/4);
        grayLineView.bounds = CGRectMake(0, 0, 1, (containerView.frame.size.height-3)/4);
        grayLineView.backgroundColor = [UIColor whiteColor];
        [containerView addSubview:grayLineView];
        
        leftButton = [UIButton buttonWithType:UIButtonTypeSystem] ;
        
         NSString *cancelBtnStr = NSLocalizedString(@"alert_cancel",nil);
//         NSString *cancelBtnStr = @"Cancel";
         [leftButton setTitle:cancelBtnStr forState:UIControlStateNormal];
        
//        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        leftButton.bounds = CGRectMake(0, 0, containerView.frame.size.width/2, containerView.frame.size.height/2-3);       leftButton.center = CGPointMake((containerView.frame.size.width-3)/4,grayLineView.center.y);
        //        leftButton.backgroundColor = [UIColor redColor];
        [leftButton addTarget:self action:@selector(leftButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:leftButton];
        
        rightButton = [UIButton buttonWithType:UIButtonTypeSystem] ;
        
//        NSString *confirmBtnStr = NSLocalizedString(@"rename_btn_confirm",nil);
        
//        NSString *confirmBtnStr = @"OK";
        NSString *confirmBtnStr = NSLocalizedString(@"alert_confirm",nil);
        [rightButton setTitle:confirmBtnStr forState:UIControlStateNormal];
        
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
    [UIView animateWithDuration:0.5f animations:^{
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
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];//应该先调用 super 的方法
    [renameTextField resignFirstResponder];//输入法消失掉
}

- (void) leftButtonOnClick {
    [self hiddenSelfWithAnimation];
    [renameTextField resignFirstResponder];
    [_onClickDelegate renameLeftButtonOnClick];
    //    [_onClickDelegate newNameFinishInput:rename.text];
}

- (void) rightButtonOnClick {
    [self hiddenSelfWithAnimation];
    [renameTextField resignFirstResponder];
    [_onClickDelegate renameRightButtonOnClick];
    [_onClickDelegate newNameDidEndEditing:renameTextField.text andBean:self.renameBean];
}

-(void) setRenameTextFieldPlaceHolder : (NSString *)placeHolder {
    renameTextField.placeholder = placeHolder;
}

-(void) setRenameTextFieldText : (NSString *)text {
    renameTextField.text = text;
}

- (void)setTitleText:(NSString*)text{
    title.text = text;
}

#pragma mark 编辑结束，containerView返回原位置
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.5f animations:^{
        containerView.center = CGPointMake(containerView.center.x, containerView.center.y+100);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark 编辑开始，containerView上移60，避免遮住键盘
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.5f animations:^{
        containerView.center = CGPointMake(containerView.center.x, containerView.center.y-100);
    } completion:^(BOOL finished) {
        
    }];
}

/**  例子代码
 LMConfirmDialogView *renameInputView ;
 
 - (void)showAlertView {
 if (renameInputView == nil) {
 NSLog(@"初始化 alertView");
 renameInputView = [[LMConfirmDialogView alloc] init];
 [renameInputView setTitle:@"XXX"];
 //        [renameInputView setAlertWordsText:@12345678"];
 renameInputView.confirmDelegate = self;
 [self.view addSubview:renameInputView];
 }
 [renameInputView showSelfWithAnimation];
 }
 **/
@end
