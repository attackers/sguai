//
//  AlarmTableViewCell.m
//  intelligent_cup
//
//  Created by liuming on 16/7/25.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import "AlarmTableViewCell.h"

@implementation AlarmTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (NSInteger)cellHeight {
    return 50;
}
+ (AlarmTableViewCell *)cellWithXib {
    NSArray *objects = [[NSBundle mainBundle]loadNibNamed:@"AlarmTableViewCell" owner:nil options:nil];
    AlarmTableViewCell *cell = objects[0];
    cell.isOn.transform = CGAffineTransformMakeScale(0.85, 0.8);//改变switch的大小
    return cell;
}


-(void)setBean:(AlarmBean *)bean{
    _bean = bean;
    NSString *hour = [NSString stringWithFormat:@"%d",bean.hour];
    NSString *minute = [NSString stringWithFormat:@"%d",bean.minute];
    if (bean.hour < 10) {
        hour = [NSString stringWithFormat:@"0%d",bean.hour];
    }
    if (bean.minute < 10) {
        minute = [NSString stringWithFormat:@"0%d",bean.minute];
    }
    self.time.text = [NSString stringWithFormat:@"%@:%@",hour,minute];
    [self.isOn setOn:bean.isOn];
    [self.btn_alarm setSelected:bean.isOn];
    
//    Byte byte = bean.repeat;
//    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
//    NSString *string = [NSString stringWithFormat:@"%d",byte];
//    Byte valueBY = 255;
//    Byte oneBY = 1;
//    for (int i = 1; i < 8; i++) {
//        NSString *byteString = [NSString stringWithFormat:@"%d",(valueBY&0xff)>>i];
//        NSString *oneString = [NSString stringWithFormat:@"%d",(oneBY&0xff)<<(8-i)];
//        NSLog(@"byteString: %@ oneString: %@",byteString,oneString);
//
//    }
//    NSLog(@"%@",string);
}

@end
