//
//  AlarmViewController.h
//  intelligent_cup
//
//  Created by liuming on 16/7/26.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCManager.h"

@interface AlarmViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView_alarms;

@property (weak, nonatomic) IBOutlet UILabel *label_water;
- (IBAction)test:(id)sender;


@end
