//
//  LMRenameInputView2.h
//  重命名_提示框
//
//  Created by liuming on 14-12-1.
//  Copyright (c) 2014年 liuming. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol LMRenameInputViewDelegate <NSObject>

@required
-(void)renameLeftButtonOnClick ;

@required
-(void)renameRightButtonOnClick ;

@required
-(void)newNameDidEndEditing: (NSString *) newName andBean:(id)bean; //newName编辑结束（按了确认键）

@end


@interface LMRenameInputView : UIView <UITextFieldDelegate>

@property (assign, nonatomic) id<LMRenameInputViewDelegate> onClickDelegate;
@property (assign, nonatomic) id renameBean;

-(void) setRenameTextFieldPlaceHolder : (NSString *)placeHolder;

#pragma mark 设置重命名
-(void) setRenameTextFieldText : (NSString *)text;
- (void)setTitleText:(NSString*)text;   //设置头部

- (void)hiddenSelfWithAnimation;

- (void)showSelfWithAnimation ;
@end
