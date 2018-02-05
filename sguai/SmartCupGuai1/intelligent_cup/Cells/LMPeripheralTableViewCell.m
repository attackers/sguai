//
//  LMPeripheralTableViewCell.m
//  Test_BLE_central
//
//  Created by liuming on 15/5/8.
//  Copyright (c) 2015年 liuming. All rights reserved.
//

#import "LMPeripheralTableViewCell.h"

@implementation LMPeripheralTableViewCell

-(void)setBean:(LMPeripheralBean *)bean{
    _bean = bean;
    self.label_peripheralAlias.text = bean.alias;
    self.label_connectState.hidden = !(bean.peripheral.state==CBPeripheralStateConnected);
    self.btn_info.hidden = !(bean.peripheral.state==CBPeripheralStateConnected);
    float distance = [bean distanceByRSSI];
    self.label_distance.text = [NSString stringWithFormat:@"%.1fm",distance];
}

+ (NSInteger)cellHeight {
    return 44;
}

+ (LMPeripheralTableViewCell *)cellWithXib {
    NSArray *objects = [[NSBundle mainBundle]loadNibNamed:@"LMPeripheralTableViewCell" owner:nil options:nil];
    LMPeripheralTableViewCell *cell = objects[0];
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

+(NSString *)cellID {
    return @"LMPeripheralTableViewCell";
}

@end
