//
//  IndividualViewController.h
//  intelligent_cup
//
//  Created by liuming on 15/10/30.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndividualViewController : BaseViewController <UITableViewDelegate>



@property (weak, nonatomic) IBOutlet UIImageView *imageView_head;

@property (weak, nonatomic) IBOutlet UILabel *label_account;//帐户：有name显示name，没有显示email

@property (weak, nonatomic) IBOutlet UILabel *label_height;
@property (weak, nonatomic) IBOutlet UILabel *label_weight;
@property (weak, nonatomic) IBOutlet UILabel *label_goal;

- (IBAction)click_btn_modify:(id)sender;     //个人资料修改
- (IBAction)click_btn_resetPwd:(id)sender;  //修改密码

@end
