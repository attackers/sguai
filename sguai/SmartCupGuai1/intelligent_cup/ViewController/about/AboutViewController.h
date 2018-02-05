//
//  AboutViewController.h
//  intelligent_cup
//
//  Created by liuming on 15/10/30.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : BaseViewController <UIActionSheetDelegate>

- (IBAction)btn_recommend_onclicked:(id)sender;
//- (IBAction)btn_faq_onclicked:(id)sender;
- (IBAction)btn_feedback_onclicked:(id)sender;

- (IBAction)btn_sign_out_onclicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *label_version;

@end
