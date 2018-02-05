//
//  SCChartView.m
//  ApiStoreSDKDemo
//
//  Created by admin on 16/7/11.
//  Copyright © 2016年 KessonWu. All rights reserved.
//
#import "SCChartView.h"

#define PADDING_LEFT (0.03)
#define PADDING_RIGHT (0.03)
#define PADDING_BOTTOM (0.03)
#define PADDING_TOP (0.01)

//柱状图
#define BAR_WIDTH (0.025)
#define BAR_COUNT (7)
#define BAR_MARGIN_RIGHT (0.065)

#define LABEL_LEFT_WIDTH (0.074)
#define LABEL_BOTTOM_HEIGHT (0.096)

@implementation SCChartView

-(void)setDrinkRecordBeans:(NSMutableArray *)drinkRecordBeans {
    //更新UI
    //记录取最近的七条
     _drinkRecordBeans = drinkRecordBeans;
    while(_drinkRecordBeans.count > 7){
        [_drinkRecordBeans removeLastObject];
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(self.drinkRecordBeans == nil || self.drinkRecordBeans.count == 0){
       [self drawEmptyView:context];
    }else {
        [self drawRecordView:context];
    }
}

//没有饮水记录，显示一张图片+title
-(void)drawEmptyView:(CGContextRef)context {
    UIImage *myImageObj = [UIImage imageNamed:@"home_img_default.png"];
    int WH = 100;
    [myImageObj drawInRect:CGRectMake(self.bounds.size.width/2-WH/2, self.bounds.size.height/2-WH/2-WH/4, WH, WH)];
    CGContextSetRGBFillColor(context, 135.0f/255.0f, 135.0f/255.0f, 135.0f/255.0f, 1);//灰色
    NSString *title = NSLocalizedString(@"积极向上的一天，从喝水开始", nil);
    CGRect rectStg = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15.0] forKey:NSFontAttributeName] context:nil];
    [title drawInRect:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2 - CGRectGetWidth(rectStg)/2, self.bounds.size.height/2+WH/4, self.bounds.size.width, WH) withFont:[UIFont systemFontOfSize:15.0]];
}

-(void)drawRecordView:(CGContextRef)context {
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    
    int paddingLeft = width*PADDING_LEFT;
    int paddingRight = width*PADDING_RIGHT;
    int paddingBottom = height*PADDING_BOTTOM;
    int paddingTop = height*PADDING_TOP;
    
    int labelLeftWidth = width*LABEL_LEFT_WIDTH;
    int labelBottomHeight = height*LABEL_BOTTOM_HEIGHT;
    
    int barWidth = width*BAR_WIDTH;
    int barHeight = height-paddingBottom-paddingTop-labelBottomHeight;
    int barMarginRight = width*BAR_MARGIN_RIGHT;
    
    int intervalWidht = ((width-paddingLeft-paddingRight-barMarginRight-labelLeftWidth)-barWidth*BAR_COUNT)/(BAR_COUNT-1);
    
    //绘制浅蓝色柱状图
    CGContextSetRGBFillColor(context, 3.0f/255.0f, 159.0f/255.0f, 243.0f/255.0f, 0.3);//设置填充颜色,浅蓝色
    for(int i=0;i<BAR_COUNT;i++){
        int x = paddingLeft+labelLeftWidth+i*(intervalWidht+barWidth);
        int y = paddingTop;
        CGRect rect = CGRectMake(x, y, barWidth, height-paddingTop-paddingBottom-labelBottomHeight);
        CGContextFillRect(context,rect);//填充框
    }
    
    //绘制浅蓝色细线
    CGContextSetRGBStrokeColor(context, 3.0f/255.0f, 159.0f/255.0f, 243.0f/255.0f, 0.3);
    int intervalHeight = barHeight/(BAR_COUNT-2)+1;
    for(int i=0;i<BAR_COUNT-1;i++){
        CGPoint aPoints[2];//坐标点
        int x1 = paddingLeft;
        int y1 = paddingTop+intervalHeight*i;
        int x2 = width-paddingRight;
        int y2 = y1;
        aPoints[0] = CGPointMake(x1, y1);//坐标1
        aPoints[1] = CGPointMake(x2, y2);//坐标2
        CGContextAddLines(context, aPoints, 2);//添加线
        CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
    }
    
    //绘制深蓝色柱状图
    CGContextSetRGBStrokeColor(context, 3.0f/255.0f, 159.0f/255.0f, 243.0f/255.0f, 1);
    CGContextSetRGBFillColor(context,  3.0f/255.0f, 159.0f/255.0f, 243.0f/255.0f, 1);
  
    //计算最大值
    float maxValue = 100.0f;
    for (int i=0; i<self.drinkRecordBeans.count; i++) {
        DrinkRecordBean *bean = self.drinkRecordBeans[i];
        if ([bean.drink intValue] > maxValue) {
            maxValue = [bean.drink intValue];
        }
    }
    
    float ff[] = {0,0,0,0,0,0,0};//高度
    for (int i=0; i<self.drinkRecordBeans.count; i++) {
        DrinkRecordBean *bean = self.drinkRecordBeans[i];
        ff[i] = [bean.drink intValue]/maxValue;
    }

    float radius = 5;
    
    for(int i=0;i<BAR_COUNT;i++){
        int dataBarHeight = barHeight*ff[i];
        int x1 = paddingLeft+labelLeftWidth+i*(intervalWidht+barWidth);
        int y1 = height-labelBottomHeight-paddingBottom;
        int x2 = x1+barWidth;
        int y2 = y1;
        int x3 = x2;
        int y3 = y2-dataBarHeight;
        int x4 = x1;
        int y4 = y3;
        CGContextMoveToPoint(context, x1, y1);  // 开始坐标右边开始
        CGContextAddArcToPoint(context, x1, y1, x2, y2, 0);  // 右下角角度
        CGContextAddArcToPoint(context, x2, y2, x3, y3, 0); // 左下角角度
        CGContextAddArcToPoint(context, x3, y3, x4, y4, radius); // 左上角
        CGContextAddArcToPoint(context, x4, y4, x1, y1, radius); // 右上角
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    }
    
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    [mArray addObject:[NSString stringWithFormat:@"%.0f",maxValue*1.0f]];
    [mArray addObject:[NSString stringWithFormat:@"%.0f",maxValue*0.8f]];
    [mArray addObject:[NSString stringWithFormat:@"%.0f",maxValue*0.6f]];
    [mArray addObject:[NSString stringWithFormat:@"%.0f",maxValue*0.4f]];
    [mArray addObject:[NSString stringWithFormat:@"%.0f",maxValue*0.2f]];
    //左边label
    CGContextSetRGBFillColor(context, 135.0f/255.0f, 135.0f/255.0f, 135.0f/255.0f, 1);
    UIFont *font = [UIFont boldSystemFontOfSize:10.0];//设置
    for(int i=0;i<BAR_COUNT-2;i++){
        int x = paddingLeft;
        int y = intervalHeight*i+intervalHeight*0.12f;
        NSString *data = [mArray objectAtIndex:i];
        [data drawInRect:CGRectMake(x, y, 40, 20) withFont:font];
    }
    
    NSMutableArray *mArray2 = [[NSMutableArray alloc] initWithCapacity:7];
     [mArray2 addObject:@""];
     [mArray2 addObject:@""];
     [mArray2 addObject:@""];
     [mArray2 addObject:@""];
     [mArray2 addObject:@""];
     [mArray2 addObject:@""];
     [mArray2 addObject:@""];
    for (int i=0; i<self.drinkRecordBeans.count; i++) {
        DrinkRecordBean *bean = self.drinkRecordBeans[i];
        [mArray2 insertObject:[bean formatTime] atIndex:i];
    }
    
    for(int i=0;i<BAR_COUNT;i++){
        int x = paddingLeft+labelLeftWidth/1.5+i*(intervalWidht+barWidth);
        int y = height-labelBottomHeight;
        NSString *data = [mArray2 objectAtIndex:i];
        [data drawInRect:CGRectMake(x, y, 50, 20) withFont:font];
    }

}


@end

