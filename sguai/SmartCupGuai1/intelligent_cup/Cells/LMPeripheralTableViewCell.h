//
//  LMPeripheralTableViewCell.h
//  Test_BLE_central
//
//  Created by liuming on 15/5/8.
//  Copyright (c) 2015年 liuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMPeripheralBean.h"

@interface LMPeripheralTableViewCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet UILabel *peripheralStateLabel;



@property (weak, nonatomic) IBOutlet UILabel *label_peripheralAlias;
@property (weak, nonatomic) IBOutlet UILabel *label_connectState;
@property (weak, nonatomic) IBOutlet UILabel *label_distance;
@property (weak, nonatomic) IBOutlet UIButton *btn_info;

@property (strong,nonatomic) LMPeripheralBean *bean;

+ (LMPeripheralTableViewCell *) cellWithXib;//用xib填充返回一个 Cell4Content 实例

+ (NSInteger )cellHeight; //cell的高度

+ (NSInteger )cellSpace; //cell之间的间距

+ (UIView *) cellSpaceView ;//cell之间的view，用于填充间距，否则会很难看，返回一个透明的view

+ (NSString *) cellID;

@end
