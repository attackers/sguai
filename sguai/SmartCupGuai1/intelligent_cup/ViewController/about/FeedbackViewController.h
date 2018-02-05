//
//  FeedbackViewController.h
//  intelligent_cup
//
//  Created by liuming on 16/8/8.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseChildViewController.h"

@interface FeedbackViewController : BaseChildViewController <UITextViewDelegate>

- (IBAction)btn_click_done:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *textView_feedback;
@property (weak, nonatomic) IBOutlet UILabel *label_feedback;

@end
