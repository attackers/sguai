//
//  CupViewController.m
//  intelligent_cup
//
//  Created by liuming on 15/10/30.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import "CupViewController.h"
#import "SCManager.h"
#import "HomeAnalyseViewController.h"
#import "FeedbackViewController.h"
#import "AutoConnectManager.h"

@interface CupViewController ()

@end

@implementation CupViewController {
    NSArray *_arrayImages4Connecting;
    LMConfirmDialogView *_disconnectAlertView; //蓝牙主动断开的确认View
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
    [SCManager sendCmd_readyBatteryEnergy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"查找水杯", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(findCupBtnClicked)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    //获取通知中心单例对象
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(cupStateChanged:) name:CUP_STATE_CHANGED object:nil];
    
    //4.others
    self.tableView_ble.dataSource = self;
    self.tableView_ble.delegate = self;
    //    self.tableView_ble.tableFooterView = [[UIView alloc] init];
    
    //7.为[BLECentralManager sharedManager]增加代理
    [[BLECentralManager sharedManager] addDelegate:self];
    
    _arrayImages4Connecting = [NSArray arrayWithObjects:
                               [UIImage imageNamed:@"dot_01.png"],
                               [UIImage imageNamed:@"dot_02.png"],
                               [UIImage imageNamed:@"dot_03.png"],
                               nil];
    
   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self isBleOnWithToast]) {
        [self peripheralConnected];
    }else {
        //清空列表
//        [[BLECentralManager sharedManager].lmPeripheralBeanMutArray removeAllObjects];
//        [self.tableView_ble reloadData];
        
    }
}

-(void)findCupBtnClicked {
    NSLog(@"findCupBtnClicked");
    if([self isBleOnWithToast]){
        if ([self peripheralConnectedWithToast]) {
            [SCManager sendCmd_controlLed];
        }
    }
}

-(void)cupStateChanged:(id)sender{
    self.label_percentage.text = [NSString stringWithFormat:@"%ld%%",[SCManager sharedManager].currentBattery];
    
    self.label_use_days.text = [NSString stringWithFormat:@"%@%d%@",NSLocalizedString(@"电量还能使用", nil),(int)([SCManager sharedManager].currentBattery*3.65f),NSLocalizedString(@"天", nil)];
    
    //设置电量图标
    if ([SCManager sharedManager].currentBattery >=80 ) {
        [self.imgView_battery setImage:[UIImage imageNamed:@"ic_battery_01.png"]];
    }else if ([SCManager sharedManager].currentBattery >=60 ) {
        [self.imgView_battery setImage:[UIImage imageNamed:@"ic_battery_02.png"]];
    }else if ([SCManager sharedManager].currentBattery >=40 ) {
        [self.imgView_battery setImage:[UIImage imageNamed:@"ic_battery_03.png"]];
    }else if ([SCManager sharedManager].currentBattery >=20 ) {
        [self.imgView_battery setImage:[UIImage imageNamed:@"ic_battery_04.png"]];
    }else {
         [self.imgView_battery setImage:[UIImage imageNamed:@"ic_battery_05.png"]];
    }
}

#pragma mark ------------蓝牙库callBack------------
-(void)bleStateChanged {
    //搜索到蓝牙：会回调
//    NSLog(@"##  bleStateChanged");
    [self.tableView_ble reloadData];
}
-(void)bleConnected {
    NSLog(@"##  bleConnected");
    [self.view makeToast:NSLocalizedString(@"连接成功", nil) duration:1.0f position:@"center"];
    [self updateUI];
    [SCManager sendCmd_readyBatteryEnergy];
//    [SCManager sendCmd_readyAlarms];
}

-(void)bleDisconnected {
    NSLog(@"##   bleDisconnected");
    [self.view makeToast:NSLocalizedString(@"蓝牙断开", nil) duration:1.0f position:@"center"];
    [self updateUI];
    [[BLECentralManager sharedManager].activePeripheral.activePeripheral setDelegate:self];
}

-(void)bleReceivedData:(NSData*)data {
    Byte *byteData = (Byte*)malloc([data length]);
    memcpy(byteData, [data bytes], [data length]);
    NSLog(@"------------Start:打印数据------------");
    //
    //    for (int i=0; i<[data length]; i++) {
    //        NSLog(@"data[%d]=%d",i,byteData[i]);
    //    }
    //
    //    return;
}


- (IBAction)btn_search:(id)sender {
    NSLog(@"btn_search");
    if (![self isBleOnWithToast]) {
        return;
    }
    for (int i=0; i<[BLECentralManager sharedManager].peripherals.count; i++) {
        CBPeripheral *peripheral = (CBPeripheral *)[[BLECentralManager sharedManager].peripherals objectAtIndex:i];
        if (peripheral != [BLECentralManager sharedManager].activePeripheral.activePeripheral) {
            [[BLECentralManager sharedManager].peripherals removeObjectAtIndex:i];
        }
    }
    
    for (int i=0; i<[BLECentralManager sharedManager].lmPeripheralBeanMutArray.count; i++) {
        LMPeripheralBean *bean = [[BLECentralManager sharedManager].lmPeripheralBeanMutArray objectAtIndex:i];
        if (bean.peripheral != [BLECentralManager sharedManager].activePeripheral.activePeripheral) {
            [[BLECentralManager sharedManager].lmPeripheralBeanMutArray removeObjectAtIndex:i];
        }
    }
    
    [[BLECentralManager sharedManager] startScanning];
    [self startAnimation4Connection];
    [self.tableView_ble reloadData];
}


#pragma mark ------------蓝牙设备TableView的方法------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMPeripheralTableViewCell *cell = [LMPeripheralTableViewCell cellWithXib];
    LMPeripheralBean *bean = [BLECentralManager sharedManager].lmPeripheralBeanMutArray[indexPath.row];
    [cell setBean:bean];
    cell.btn_info.tag = indexPath.row;
    [cell.btn_info addTarget:self action:@selector(infoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


-(void)infoBtnClicked:(UIButton *)sender {
   self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController: [[CupDetailsViewController alloc] init] animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [BLECentralManager sharedManager].peripherals.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"## didSelectRowAtIndexPath");
    LMPeripheralBean *bean = (LMPeripheralBean *)[[BLECentralManager sharedManager].lmPeripheralBeanMutArray objectAtIndex:indexPath.row];
    CBPeripheral *p = bean.peripheral;
    if (p.state == CBPeripheralStateConnected) {
        NSLog(@"此设备已经连接 return");
        [self showDisconnectAlertView];
        return;
    }
    if([[BLECentralManager sharedManager] activePeripheral] != nil){
        [self.view makeToast:NSLocalizedString(@"disconnect_current_connection", nil) duration:1.0f position:@"center"];
        return;
    }
    [self.view makeToast:NSLocalizedString(@"connect_begin", nil) duration:2.0f position:@"center"];
    [[BLECentralManager sharedManager] stopScanning];
    [[BLECentralManager sharedManager] connectPeripheral:p];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LMPeripheralTableViewCell cellHeight];
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{

//
//
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"device" forIndexPath:indexPath];
//
//    NSLog(@"cellForRowAtIndexPath cell=%lu",(unsigned long)cell.hash);
//
////    [tableView dequeueReusableCellWithIdentifier:@"device"];
//
//    UIView *contentView = cell.subviews[0];
//    UILabel *label = [contentView viewWithTag:11];
//    UIButton *button = [contentView viewWithTag:12];
//
//    LMPeripheralBean *bean = (LMPeripheralBean *)[[BLECentralManager sharedManager].lmPeripheralBeanMutArray objectAtIndex:indexPath.row];
//       CBPeripheral *p = bean.peripheral;
//    label.text = bean.alias;
//    button.tag = indexPath.row;
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//        NSLog(@"## didSelectRowAtIndexPath row=%d",indexPath.row);
//}
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"CupInfoSegue"]) {
//        //sender为info按钮
//        UINavigationController *navigationController = segue.destinationViewController;
//       CupInfoViewController *cupInfoViewController = [navigationController viewControllers][0];
//        cupInfoViewController.select_index = ((UIButton *)sender).tag;
//    }
//}

- (void)startAnimation4Connection {
    [self.imageView_connecting setAnimationImages:_arrayImages4Connecting];
    [self.imageView_connecting setAnimationRepeatCount:10000];
    [self.imageView_connecting setAnimationDuration:1.5f];
    [self.imageView_connecting startAnimating];
}

- (void)stopAnimation4Connection {
    [self.imageView_connecting.layer removeAllAnimations];
}

- (void)updateUI {
    if([[BLECentralManager sharedManager] activePeripheral] == nil){
        self.imageView_phone.hidden = NO;
        self.imageView_cup.hidden = NO;
        self.imageView_connecting.hidden = NO;
        self.imageView_battery.hidden = YES;
        self.label_use_days.hidden = YES;
        self.label_percentage.hidden = YES;
        [self.tableView_ble reloadData];
        [self startAnimation4Connection];
        
        self.imgView_battery.hidden = YES;
        self.label_use_days.hidden = YES;
        self.label_percentage.hidden = YES;
    }else {
        self.imageView_phone.hidden = YES;
        self.imageView_cup.hidden = YES;
        self.imageView_connecting.hidden = YES;
        self.imageView_battery.hidden = NO;
        self.label_use_days.hidden = NO;
        self.label_percentage.hidden = NO;
        [self.tableView_ble reloadData];
        [self stopAnimation4Connection];
        
        self.imgView_battery.hidden = NO;
        self.label_use_days.hidden = YES;
        self.label_percentage.hidden = YES;
    }
}

#pragma mark ------------提示框:蓝牙断开------------
- (void)showDisconnectAlertView {
    if (_disconnectAlertView == nil) {
        NSLog(@"初始化 alertView");
        _disconnectAlertView = [[LMConfirmDialogView alloc] init];
        [_disconnectAlertView setTitle:NSLocalizedString(@"alert_confirm_title", nil)];
        //        [renameInputView setAlertWordsText:@"ss"];
        _disconnectAlertView.confirmDelegate = self;
        [self.view addSubview:_disconnectAlertView];
    }
    [_disconnectAlertView showSelfWithAnimation];
}

//断开提示框的delegate方法
-(void)leftButtonOnClick {
    //取消
}
-(void)rightButtonOnClick {
    //确认
    NSLog(@"执行操作：断开蓝牙");
    [[BLECentralManager sharedManager] disconnectPeripheral:[[BLECentralManager sharedManager] activePeripheral].activePeripheral];
    
    [[AutoConnectManager sharedManager] clearLastConnectedDevice];
    //[[BLECentralManager sharedManager] startScanning];
}

@end
