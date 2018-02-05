//
//  WaterSet.m
//  intelligent_cup
//
//  Created by liuming on 16/9/12.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import "WaterSet.h"

@implementation WaterSet
+(WaterSet *)instance {
    NSArray *nibView =  [[NSBundle mainBundle] loadNibNamed:@"WaterSet" owner:nil options:nil];
    WaterSet *view = [nibView objectAtIndex:0];
    return view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
