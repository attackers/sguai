//
//  LMUtils.h
//  intelligent_cup
//
//  Created by liuming on 15/10/30.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LMUtils : NSObject


//http://blog.csdn.net/xuhuan_wh/article/details/6434055

//1.等比率缩放
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

//2.自定长宽
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

@end
