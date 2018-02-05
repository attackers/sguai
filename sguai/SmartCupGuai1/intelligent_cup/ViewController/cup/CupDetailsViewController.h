//
//  CupDetailsViewController.h
//  intelligent_cup
//
//  Created by liuming on 15/11/4.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CupDetailsViewController : BaseViewController

@property int rename_device_index;

- (IBAction)btn_back_onclicked:(id)sender;

- (IBAction)btn_rename_onclicked:(id)sender;

- (IBAction)btn_disconnect_onclicked:(id)sender;

@end
