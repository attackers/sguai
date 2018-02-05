//
//  IndividualAlarmTableViewCell.h
//  intelligent_cup
//
//  Created by liuming on 15/11/6.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndividualAlarmTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label_time;
@property (weak, nonatomic) IBOutlet UISwitch *switch_state;

+ (IndividualAlarmTableViewCell *) cellWithXib;//用xib填充返回一个 Cell4Content 实例

+ (NSInteger )cellHeight; //cell的高度

+ (NSInteger )cellSpace; //cell之间的间距

+ (UIView *) cellSpaceView ;//cell之间的view，用于填充间距，否则会很难看，返回一个透明的view

+ (NSString *) cellID;

@end
