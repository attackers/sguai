//
//  AlarmEditViewController.m
//  intelligent_cup
//
//  Created by admin on 16/8/15.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import "AlarmEditViewController.h"
#import "SCManager.h"

@interface AlarmEditViewController () <UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation AlarmEditViewController {
     int _number_selected;  //pickerView选中的数字
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"闹钟编辑",nil);
    [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    
    self.view_picker_container.hidden = YES;
    self.pickView_number.dataSource = self;
    self.pickView_number.delegate = self;
    [self.view_picker_container setBackgroundColor:[UIColor colorWithWhite:0.f alpha:0.5]];
    
    [self.btn_water setTitle:[NSString stringWithFormat:@"%dml",self.alarmBean.water*10] forState:UIControlStateNormal];
}
- (void)viewWillAppear:(BOOL)animated {
    //根据alarmBean设置UI
       NSLog(@"self.alarmBean:%@",self.alarmBean);
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    [comps setHour:self.alarmBean.hour];
    [comps setMinute:self.alarmBean.minute];
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [calendar dateFromComponents:comps];
    [self.datePicker setDate:date];
    
    //设置重复
    Byte array[] = {0, 0, 0, 0, 0, 0, 0, 0};
    Byte b = self.alarmBean.repeat;
    for (int i = 7; i>=0; i--) {
        array[i] = (Byte)(b&1);
        b = (Byte)(b>>1);
    }
    [self.btn_day1 setSelected:(array[0]==1)];
    [self.btn_day2 setSelected:(array[1]==1)];
    [self.btn_day3 setSelected:(array[2]==1)];
    [self.btn_day4 setSelected:(array[3]==1)];
    [self.btn_day5 setSelected:(array[4]==1)];
    [self.btn_day6 setSelected:(array[5]==1)];
    [self.btn_day7 setSelected:(array[6]==1)];
    
    
    [super viewWillAppear:animated];
}

-(void)dateChange:(UIDatePicker *)datePicker {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:datePicker.date];
    int hour = [comps hour];
    int min = [comps minute];
    NSLog(@"%d:%d",hour,min);
    self.alarmBean.minute = min;
    self.alarmBean.hour = hour;
    NSLog(@"self.alarmBean:%@",self.alarmBean);
}

- (IBAction)click_btn_days:(id)sender {
    [((UIButton *)sender) setSelected:!((UIButton *)sender).isSelected];
}



- (IBAction)click_btn_repeatDays:(id)sender {
    [self.btn_workDay setSelected:NO];
    [self.btn_everyDay setSelected:NO];
    [(UIButton *)sender setSelected:YES];
    if (sender == self.btn_workDay) {
        [self.btn_day1 setSelected:YES];
        [self.btn_day2 setSelected:YES];
        [self.btn_day3 setSelected:YES];
        [self.btn_day4 setSelected:YES];
        [self.btn_day5 setSelected:YES];
        [self.btn_day6 setSelected:NO];
        [self.btn_day7 setSelected:NO];
    }else if (sender == self.btn_everyDay) {
        [self.btn_day1 setSelected:YES];
        [self.btn_day2 setSelected:YES];
        [self.btn_day3 setSelected:YES];
        [self.btn_day4 setSelected:YES];
        [self.btn_day5 setSelected:YES];
        [self.btn_day6 setSelected:YES];
        [self.btn_day7 setSelected:YES];
    }
}

- (IBAction)click_btn_water:(id)sender {
    NSLog(@"click_btn_water");
    //弹出数字输入框
    self.view_picker_container.hidden = NO;
}


- (IBAction)click_btn_del:(id)sender {
    NSLog(@"click_btn_del");
    [SCManager sendCmd_deleteAlarmWithAlarmBean: self.alarmBean];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)click_btn_finish:(id)sender {
    NSLog(@"click_btn_finish");
    [self.alarmBean setRepeatDaysWithDay1:self.btn_day1.isSelected
                                     day2:self.btn_day2.isSelected
                                     day3:self.btn_day3.isSelected
                                     day4:self.btn_day4.isSelected
                                     day5:self.btn_day5.isSelected
                                     day6:self.btn_day6.isSelected
                                     day7:self.btn_day7.isSelected];
    [SCManager sendCmd_updateAlarmWithAlarmBean: self.alarmBean];
    //    [SCManager sendCmd_addAlarmWithAlarmBean: self.alarmBean];
    [self.navigationController popViewControllerAnimated:YES];
}



//data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 10;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    _number_selected = (row)*50+100;
    return [NSString stringWithFormat:@"%d",_number_selected];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"didSelectRow=%ld",row);
    
}

- (IBAction)btn_confirm_onclicked:(id)sender {
    NSLog(@"btn_confirm_onclicked");
    self.view_picker_container.hidden = YES;
    //修改Bean
    self.alarmBean.water = _number_selected/10;
    [self.btn_water setTitle:[NSString stringWithFormat:@"%dml",self.alarmBean.water*10] forState:UIControlStateNormal];
}

- (IBAction)btn_cancel_onclicked:(id)sender {
    NSLog(@"btn_cancel_onclicked");
    self.view_picker_container.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    self.view_picker_container.hidden = YES;
    [super viewDidDisappear:animated];
}

@end
