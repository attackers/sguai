//
//  CupDetailsViewController.m
//  intelligent_cup
//
//  Created by liuming on 15/11/4.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import "CupDetailsViewController.h"
#import "LMPeripheralBean.h"
#import "BLECentralManager.h"
#import "LMRenameInputView.h"
#import "LMConfirmDialogView.h"

@interface CupDetailsViewController () <ConfirmDialogViewDelegate,LMRenameInputViewDelegate>

@end

@implementation CupDetailsViewController {
     LMRenameInputView *_renameInputView ;
     LMConfirmDialogView *_disconnectAlertView; //蓝牙主动断开的确认View
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"rename_device_index=%d",self.rename_device_index);
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
}

- (IBAction)btn_back_onclicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btn_rename_onclicked:(id)sender {
    NSLog(@"btn_rename_onclicked");
    [self showRenameAlertView:self.rename_device_index];
}

- (IBAction)btn_disconnect_onclicked:(id)sender {
    NSLog(@"btn_disconnect_onclicked");
    [self showDisconnectAlertView];
}

- (void)showRenameAlertView:(int)tag {
    LMPeripheralBean *bean = [BLECentralManager sharedManager].lmPeripheralBeanMutArray[tag];
    if (_renameInputView == nil) {
        _renameInputView = [[LMRenameInputView alloc] init];
        [_renameInputView setRenameTextFieldPlaceHolder:@""];
        [_renameInputView setRenameTextFieldText:bean.alias];
        [_renameInputView setRenameBean:bean];
        _renameInputView.onClickDelegate = self;
        [_renameInputView setTitleText:NSLocalizedString(@"alert_rename_title", nil)];
        [self.view addSubview:_renameInputView];
    }else{
        [_renameInputView setRenameTextFieldText:bean.alias];
    }
    [_renameInputView showSelfWithAnimation];
}

-(void)renameLeftButtonOnClick { }
-(void)renameRightButtonOnClick { }
-(void)newNameDidEndEditing: (NSString *) newName andBean:(id)bean {
    NSLog(@"newName=%@",newName);
    if (newName != nil && newName.length > 0) {
        LMPeripheralBean *peripheralBean = (LMPeripheralBean *)bean;
        
        //1.与原来名字一样
        if ([peripheralBean.alias isEqualToString:newName]) {
            NSLog(@"与原来alias一样");
            [self.view makeToast:NSLocalizedString(@"rename_success", nil) duration:1.0f position:@"center"];
            return;
        }
        
        //2.执行重命名
        NSLog(@"alias:%@-->%@",peripheralBean.alias,newName);
        peripheralBean.alias = newName;
        [[BLECentralManager sharedManager] renameWithIdentifier:[peripheralBean.peripheral.identifier UUIDString] andAlias:newName];
        [self.view makeToast:NSLocalizedString(@"rename_success", nil) duration:1.0f position:@"center"];
       
    }else{
        NSLog(@"重命名失败 newName为空");
        [self.view makeToast:NSLocalizedString(@"rename_can_not_null", nil) duration:1.0f position:@"center"];
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
    
  
    [self dismissViewControllerAnimated:YES completion:nil];

}


@end
