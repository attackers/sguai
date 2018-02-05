//
//  CircleView.m
//  testLineProgressView
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 GLSX. All rights reserved.
//

#import "CircleView.h"

#define PI 3.14159265358979323846

@implementation CircleView


- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //划圆
    CGContextSetRGBFillColor (context,  1, 1, 1, 0.7f);//设置填充颜色
    //填充圆，无边框
    float x = rect.size.width/2;
    float y = rect.size.height/2;
    float radius = (rect.size.width<=rect.size.height) ? rect.size.width/2 : rect.size.height/2;
    CGContextAddArc(context, x, y, radius-10, 0, 2*PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFill);//绘制填充

    
    /*写文字*/
    CGContextSetRGBFillColor (context,  20.0F/255.0F, 150.0F/255.0F, 242.0F/255.0F, 0.95f);//设置填充颜色
    
     UIFont  *font2 = [UIFont boldSystemFontOfSize:20];//设置
    if(self.temperature == 0){
        [NSLocalizedString(@"还没开始喝水哦", nil) drawInRect:CGRectMake(rect.size.width/3-10, rect.size.height/2, rect.size.width, 20) withFont:font2];
    }else {
        UIFont  *font1 = [UIFont boldSystemFontOfSize:95];
        [[NSString stringWithFormat:@"%d",self.temperature] drawInRect:CGRectMake(rect.size.width/3, rect.size.height/3, rect.size.width, 20) withFont:font1];
        [NSLocalizedString(@"当前水温", nil) drawInRect:CGRectMake(rect.size.width/3+15, rect.size.height/3*2+25, rect.size.width, 20) withFont:font2];
        [@"°C" drawInRect:CGRectMake(rect.size.width/2+45, rect.size.height/3+10, rect.size.width, 20) withFont:font2];
    } 
    
}

@end
