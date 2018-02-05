//
//  AlarmTableViewCell.h
//  intelligent_cup
//
//  Created by liuming on 16/7/25.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmBean.h"

@interface AlarmTableViewCell : UITableViewCell

+ (AlarmTableViewCell *)cellWithXib;

+ (NSInteger )cellHeight; //cell的高度

@property (strong,nonatomic) AlarmBean *bean;
@property (weak, nonatomic) IBOutlet UIButton *btn_alarm;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UISwitch *isOn;

@end
