//
//  RegistGoalViewController.h
//  intelligent_cup
//
//  Created by liuming on 15/11/13.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistGoalViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIButton *btn_goal;

- (IBAction)btn_finish_onclicked:(id)sender;//完成

@property (weak, nonatomic) IBOutlet UIPickerView *pickView_number;

//确认/取消
- (IBAction)btn_confirm_onclicked:(id)sender;
- (IBAction)btn_cancel_onclicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *view_picker_container;
@property (weak, nonatomic) IBOutlet UIView *view_shadow;

- (IBAction)btn_back_onclicked:(id)sender;

@end
