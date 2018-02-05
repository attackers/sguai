//
//  CupViewController.h
//  intelligent_cup
//
//  Created by liuming on 15/10/30.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEControllerDelegate.h"
#import "BLECentralManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "LMPeripheralTableViewCell.h"
#import "CupDetailsViewController.h"
#import "LMConfirmDialogView.h"


@interface CupViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource,BLEControllerDelegate,CBPeripheralDelegate,ConfirmDialogViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView_ble;

@property (weak, nonatomic) IBOutlet UIImageView *imageView_connecting;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_cup;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_phone;

@property (weak, nonatomic) IBOutlet UIImageView *imageView_battery;
@property (weak, nonatomic) IBOutlet UILabel *label_percentage;
@property (weak, nonatomic) IBOutlet UILabel *label_use_days;

//@property (weak, nonatomic) IBOutlet UIButton *btn_findCup;

@property (weak, nonatomic) IBOutlet UIImageView *imgView_battery;//电量图标

- (IBAction)btn_search:(id)sender;

@end
