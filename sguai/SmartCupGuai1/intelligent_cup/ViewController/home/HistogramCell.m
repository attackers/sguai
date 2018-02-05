//
//  HistogramCell.m
//  Nav
//
//  Created by admin-leaf on 2017/6/8.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "HistogramCell.h"
#import "Histogramlayer.h"
@interface HistogramCell()
{
    Histogramlayer *layer;
    UILabel *dateLabel;
}
@end
@implementation HistogramCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
    layer = [Histogramlayer layer];
    layer.frame = CGRectZero;
    layer.value = 1024;
    [layer setCornerRadius:6];
    [self.contentView.layer addSublayer:layer];
    
    dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(layer.frame), 40, self.height)];
    dateLabel.font = [UIFont systemFontOfSize:13];
    dateLabel.center = CGPointMake(layer.position.x, dateLabel.center.y);
    [self.contentView addSubview:dateLabel];
}

- (void)setContentInfo:(DrinkRecordBean*)sender
{

    CGRect rect  = CGRectMake(CGRectGetWidth(self.frame)/2-10, 0, 15, self.height - self.height/5+10);
    layer.frame = rect;
    layer.height = self.height;
    layer.value = [sender.drink floatValue];
    [layer setNeedsDisplay];
    rect = CGRectMake(0, CGRectGetMaxY(layer.frame), 40, self.height/10);
    dateLabel.frame = rect;
    dateLabel.text = [self stringDayForString:sender.time];

}
- (NSString *)stringDayForString:(NSString*)str
{
    NSArray *arrayStg = [str componentsSeparatedByString:@"-"];
    return [NSString stringWithFormat:@"%@/%@",arrayStg[1],arrayStg[2]];
}
@end
