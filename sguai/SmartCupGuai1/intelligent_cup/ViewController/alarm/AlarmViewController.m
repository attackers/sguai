//
//  AlarmViewController.m
//  intelligent_cup
//
//  Created by liuming on 16/7/26.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import "AlarmViewController.h"
#import "AlarmTableViewCell.h"
#import "AlarmEditViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AlarmRemindFunction.h"
@interface AlarmViewController ()
{
    AlarmRemindFunction *remindFunction;
}
@end

@implementation AlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[BLECentralManager sharedManager] addDelegate:[SCManager sharedManager]];

    remindFunction = [[AlarmRemindFunction alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView_alarms.dataSource = self;
    self.tableView_alarms.delegate = self;
    //获取通知中心单例对象
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(alarmStateChanged) name:ALARM_STATE_CHANGED object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewWillAppear  AlarmViewController");
    self.label_water.text = [NSString stringWithFormat:@"%dml",[[SCAccountManager sharedManager].localUser calculateDrinkGoal]];
    //1.获取闹钟
    [SCManager sendCmd_readyAlarms];
    if (![self isBleOn] || ![self peripheralConnected]) {
        [[SCManager sharedManager].currentAlarmArray removeAllObjects];
        [self.tableView_alarms reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlarmTableViewCell *cell = [AlarmTableViewCell cellWithXib];
   
    AlarmBean *bean = (AlarmBean *)([SCManager sharedManager].currentAlarmArray[indexPath.row]);
    [cell setBean:bean];
    [cell.isOn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

-(void)switchAction:(UISwitch *)sender {
    
    if (![self isBleOnWithToast] || ![self peripheralConnected]) {
        [[SCManager sharedManager].currentAlarmArray removeAllObjects];
        [self.tableView_alarms reloadData];
        return;
    }
    AlarmBean *bean = ((AlarmTableViewCell *)(sender.superview.superview)).bean;
    bean.isOn = sender.isOn;
    [SCManager sendCmd_addAlarmWithAlarmBean:bean];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return [SCManager sharedManager].currentAlarmCount;
    return [SCManager sharedManager].currentAlarmArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [AlarmTableViewCell cellHeight];
}

-(void)alarmStateChanged{
    NSLog(@"刷新闹钟列表");
    [self.tableView_alarms reloadData];
    [remindFunction alarmRemindNotification];
}

//点击后，设置data，并跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self isBleOnWithToast] || ![self peripheralConnected]) {
        [[SCManager sharedManager].currentAlarmArray removeAllObjects];
        [self.tableView_alarms reloadData];
        return;
    }
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed=YES;
    AlarmEditViewController *vc = [[AlarmEditViewController alloc] init];
    vc.alarmBean = (AlarmBean *)[[SCManager sharedManager].currentAlarmArray objectAtIndex:indexPath.row];
    NSLog(@"vc.alarmBean:%@",vc.alarmBean);
    [self.navigationController pushViewController: vc animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}
@end
