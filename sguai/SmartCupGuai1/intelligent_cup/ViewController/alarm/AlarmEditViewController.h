//
//  AlarmEditViewController.h
//  intelligent_cup
//
//  Created by admin on 16/8/15.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseChildViewController.h"
#import "AlarmBean.h"

@interface AlarmEditViewController : BaseChildViewController

@property (weak, nonatomic) IBOutlet UIButton *btn_water;
- (IBAction)click_btn_water:(id)sender;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIButton *btn_workDay;
@property (weak, nonatomic) IBOutlet UIButton *btn_everyDay;
- (IBAction)click_btn_repeatDays:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn_day1;
@property (weak, nonatomic) IBOutlet UIButton *btn_day2;
@property (weak, nonatomic) IBOutlet UIButton *btn_day3;
@property (weak, nonatomic) IBOutlet UIButton *btn_day4;
@property (weak, nonatomic) IBOutlet UIButton *btn_day5;
@property (weak, nonatomic) IBOutlet UIButton *btn_day6;
@property (weak, nonatomic) IBOutlet UIButton *btn_day7;
- (IBAction)click_btn_days:(id)sender;

- (IBAction)click_btn_del:(id)sender;
- (IBAction)click_btn_finish:(id)sender;


//确认/取消
- (IBAction)btn_confirm_onclicked:(id)sender;
- (IBAction)btn_cancel_onclicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView_number;
@property (weak, nonatomic) IBOutlet UIView *view_picker_container;

@property (strong,nonatomic) AlarmBean *alarmBean;

@end
