//
//  DayDrinkView.h
//  intelligent_cup
//
//  Created by admin-leaf on 2017/6/9.
//  Copyright © 2017年 makeblock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayDrinkView : UIView
{
    UILabel *drinkValueLabel;
    UILabel *reminderLabel;
    UIImageView *iconImageview;
}
-(void)setDrinkValueLabelText:(NSString*)drink AndReminderLabel:(NSString*)reminder AndIconImageview:(NSString*)icon;
@end
@interface DayDrinkView2 : DayDrinkView

@end
