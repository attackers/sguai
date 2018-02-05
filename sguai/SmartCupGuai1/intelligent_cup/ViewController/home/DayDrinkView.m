//
//  DayDrinkView.m
//  intelligent_cup
//
//  Created by admin-leaf on 2017/6/9.
//  Copyright © 2017年 makeblock. All rights reserved.
//

#import "DayDrinkView.h"
#import "HomeAnalyseViewController.h"
@implementation DayDrinkView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:97/255.0 green:187/255.0 blue:240/255.0 alpha:1];
        iconImageview = [[UIImageView alloc]initWithFrame:CGRectMake(8, 60*scaleLayout/2 -  (CGRectGetHeight(frame)/1.2)/2, CGRectGetHeight(frame)/1.2, CGRectGetHeight(frame)/1.2)];
        iconImageview.image = [UIImage imageNamed:@"analyze_ic_01"];
        
        drinkValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImageview.frame) + 6, CGRectGetMinY(iconImageview.frame)+4, 90, CGRectGetHeight(iconImageview.frame)/2- 6)];
        drinkValueLabel.textColor = [UIColor whiteColor];
        drinkValueLabel.font = [UIFont systemFontOfSize:15*scaleLayout];
        
        reminderLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImageview.frame) + 6, CGRectGetMaxY(drinkValueLabel.frame)  + 3, 120,  CGRectGetHeight(iconImageview.frame)/2- 6)];
        reminderLabel.textColor = [UIColor whiteColor];
        reminderLabel.font = [UIFont systemFontOfSize:15*scaleLayout];

        [self addSubview:iconImageview];
        [self addSubview:drinkValueLabel];
        [self addSubview:reminderLabel];
    }
    return self;
}
-(void)setDrinkValueLabelText:(NSString*)drink AndReminderLabel:(NSString*)reminder AndIconImageview:(NSString*)icon
{
    drinkValueLabel.text = drink;
    reminderLabel.text = reminder;
    iconImageview.image = [UIImage imageNamed:icon];
}

@end
@implementation DayDrinkView2

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        iconImageview.image = [UIImage imageNamed:@"analyze_ic_03"];
        
        drinkValueLabel.frame = CGRectMake(CGRectGetWidth(self.frame) - 90, CGRectGetMaxY(drinkValueLabel.frame)  + 3, 82,  20);
        drinkValueLabel.center = CGPointMake(drinkValueLabel.center.x, iconImageview.center.y);
        drinkValueLabel.textAlignment = NSTextAlignmentRight;

        reminderLabel.frame = CGRectMake(CGRectGetMaxX(iconImageview.frame) + 6, 8, 160, 20);
        reminderLabel.center = CGPointMake(reminderLabel.center.x, iconImageview.center.y);
    }
    return self;
}

@end
