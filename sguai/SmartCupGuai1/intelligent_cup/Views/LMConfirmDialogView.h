//
//  LMConfirmDialogView.h
//  重命名_提示框
//
//  Created by liuming on 14-11-10.
//  Copyright (c) 2014年 liuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConfirmDialogViewDelegate <NSObject>

@required
-(void)leftButtonOnClick ;
@required
-(void)rightButtonOnClick ;
@end

@interface LMConfirmDialogView : UIView

@property (assign, nonatomic) id<ConfirmDialogViewDelegate> confirmDelegate;

-(void) setTitle : (NSString *)titile;

- (void)hiddenSelfWithAnimation;

- (void)showSelfWithAnimation;
@end
