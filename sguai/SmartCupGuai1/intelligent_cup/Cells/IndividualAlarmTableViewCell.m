//
//  IndividualAlarmTableViewCell.m
//  intelligent_cup
//
//  Created by liuming on 15/11/6.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import "IndividualAlarmTableViewCell.h"

@implementation IndividualAlarmTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSInteger)cellHeight {
    return 40;
}

+ (IndividualAlarmTableViewCell *)cellWithXib {
    NSArray *objects = [[NSBundle mainBundle]loadNibNamed:@"IndividualAlarmTableViewCell" owner:nil options:nil];
    IndividualAlarmTableViewCell *cell = objects[0];
    return cell;
}

+ (NSInteger)cellSpace {
    return 4;
}

+ (UIView *)cellSpaceView {
    UIView * sectionView = [[UIView alloc] init];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}


@end
