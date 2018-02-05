//
//  Histogramlayer.m
//  Nav
//
//  Created by admin-leaf on 2017/6/5.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "Histogramlayer.h"
#import <UIKit/UIKit.h>

@implementation Histogramlayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:210/255.0 green:233/255.0 blue:251/255.0 alpha:1].CGColor;
        
    }
    return self;
}
- (void)drawInContext:(CGContextRef)ctx
{
    CGFloat infoValue =  CGRectGetHeight(self.frame) - self.value/5000.0*CGRectGetHeight(self.frame);
    CGContextMoveToPoint(ctx, 0, infoValue);
    CGContextAddLineToPoint(ctx, CGRectGetWidth(self.frame),infoValue);
    CGContextAddLineToPoint(ctx, CGRectGetWidth(self.frame) , CGRectGetHeight(self.frame));
    CGContextAddLineToPoint(ctx, 0, CGRectGetHeight(self.frame));
    CGContextAddLineToPoint(ctx, 0, 2);
    CGContextSetRGBFillColor(ctx, 122.0/255, 186.0/255, 244.0/255, 1);
    
    CGContextDrawPath(ctx, kCGPathFill);
}
@end
