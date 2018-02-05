//
//  RegistModifyViewController.h
//  intelligent_cup
//
//  Created by liuming on 15/11/13.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistModifyViewController : BaseViewController

//下一步
- (IBAction)btn_confirmUpdate_onclicked:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView_modify;

@property (weak, nonatomic) IBOutlet UIPickerView *pickView_number;

- (IBAction)btn_back_onclicked:(id)sender;

//确认/取消
- (IBAction)btn_confirm_onclicked:(id)sender;
- (IBAction)btn_cancel_onclicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *view_picker_container;
@property (weak, nonatomic) IBOutlet UIView *view_shadow;


@property (weak, nonatomic) IBOutlet UIButton *btn_boy;
@property (weak, nonatomic) IBOutlet UIButton *btn_girl;

@end
