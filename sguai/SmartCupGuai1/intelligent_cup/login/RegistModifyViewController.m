//
//  RegistModifyViewController.m
//  intelligent_cup
//
//  Created by liuming on 15/11/13.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import "RegistModifyViewController.h"
#import "RegistGoalViewController.h"
#import "SCAccountManager.h"

@interface RegistModifyViewController ()<UITableViewDelegate, UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *boyButton;
@property (weak, nonatomic) IBOutlet UIButton *girlButton;

@end

@implementation RegistModifyViewController {
    NSArray *_array4Title;
    int _section_selected; //选中修改的section
    int _number_selected;  //pickerView选中的数字
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _array4Title = [NSArray arrayWithObjects:NSLocalizedString(@"年龄", nil),NSLocalizedString(@"身高", nil),NSLocalizedString(@"体重", nil),nil];
    [_btn_boy setTitle:NSLocalizedString(@"男", nil) forState:UIControlStateNormal];
    [_btn_girl setTitle:NSLocalizedString(@"女", nil) forState:UIControlStateNormal];
    
    [_btn_boy setImage:[UIImage imageNamed:NSLocalizedString(@"signup_btn_boy_nor", nil)] forState:UIControlStateNormal];
    [_btn_boy setImage:[UIImage imageNamed:NSLocalizedString(@"signup_btn_boy_press", nil)] forState:UIControlStateSelected];
    [_btn_girl setImage:[UIImage imageNamed:NSLocalizedString(@"signup_btn_girl_nor", nil)] forState:UIControlStateNormal];
    [_btn_girl setImage:[UIImage imageNamed:NSLocalizedString(@"signup_btn_girl_press", nil)] forState:UIControlStateSelected];
    [self setupViews];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IndividualInfoBeanCell"];
    NSLog(@"localUser=%@", [SCAccountManager sharedManager].localUser);
    switch (indexPath.section) {
        case 0:
        {
            int age = [SCAccountManager sharedManager].localUser.age;
            if(age==0){
                NSString *ageStr = [NSString stringWithFormat:@"%@",NSLocalizedString(@"岁", nil)];
                cell.textLabel.text = ageStr;
            }else{
                NSString *ageStr = [NSString stringWithFormat:@"%d%@",age,NSLocalizedString(@"岁", nil)];
                cell.textLabel.text = ageStr;
            }
        }
            break;
        case 1:
        {
            int height = [SCAccountManager sharedManager].localUser.tall;
            if(height==0){
                NSString *heightStr = [NSString stringWithFormat:@"cm"];
                cell.textLabel.text = heightStr;
            }else{
                NSString *heightStr = [NSString stringWithFormat:@"%dcm",height];
                cell.textLabel.text = heightStr;
            }
        }
            break;
        case 2:
        {
            int weight = [SCAccountManager sharedManager].localUser.weight;
            if(weight==0){
                NSString *weightStr = [NSString stringWithFormat:@"kg"];
                cell.textLabel.text = weightStr;
            }else{
                NSString *weightStr = [NSString stringWithFormat:@"%dkg",weight];
                cell.textLabel.text = weightStr;
            }
        }
            break;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _array4Title[section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _section_selected = (int)indexPath.section;
    NSLog(@"sectionIndex=%d",(int)indexPath.section);
    self.view_picker_container.hidden = NO;
    self.view_shadow.hidden = NO;
    self.pickView_number.dataSource = self;
//    [self.pickView_number reloadAllComponents];
    [self.pickView_number selectRow:0 inComponent:0 animated:NO];
}

//data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (_section_selected) {
        case 0:
            //age: 1,120
            return 120;
        case 1:
            //height 60,230
            return 171;
        case 2:
            //weight 5,250
            return 246;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (_section_selected) {
        case 0:
             //age: 1,120
            return [NSString stringWithFormat:@"%d",row+1];
        case 1:
             //height 60,230
            return [NSString stringWithFormat:@"%d",row+60];
        case 2:
            //weight 5,250
           return [NSString stringWithFormat:@"%d",row+5];
    }
    return [NSString stringWithFormat:@"%d",row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (_section_selected) {
        case 0:
            //age: 1,120
            _number_selected = row+1;
            break;
        case 1:
              //height 60,230
            _number_selected = row+60;
            break;
        case 2:
             //weight 5,250
            _number_selected = row+5;
            break;
    }
    NSLog(@"_number_selected=%d",_number_selected);
    
}

- (IBAction)btn_confirm_onclicked:(id)sender {
    NSLog(@"btn_confirm_onclicked");
    self.view_picker_container.hidden = YES;
    self.view_shadow.hidden = YES;
    
    switch (_section_selected) {
        case 0:
            [SCAccountManager sharedManager].localUser.age = _number_selected;
            break;
        case 1:
            [SCAccountManager sharedManager].localUser.tall = _number_selected;
            break;
        case 2:
            [SCAccountManager sharedManager].localUser.weight = _number_selected;
            break;
    }
    NSLog(@"localUser=%@", [SCAccountManager sharedManager].localUser);
    [self.tableView_modify reloadData];
}

- (IBAction)btn_cancel_onclicked:(id)sender {
    NSLog(@"btn_cancel_onclicked");
    self.view_picker_container.hidden = YES;
    self.view_shadow.hidden = YES;
}

-(void)setupViews {
    [self.btn_boy addTarget:self action:@selector(btns_onclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_girl addTarget:self action:@selector(btns_onclick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView_modify.dataSource = self;
    self.tableView_modify.delegate = self;
    
    self.pickView_number.dataSource = self;
    self.pickView_number.delegate = self;
    
    self.view_picker_container.hidden = YES;
    self.view_shadow.hidden = YES;
}

-(void)btns_onclick:(UIButton *)sender {
    [self.btn_girl setSelected:NO];
    [self.btn_boy setSelected:NO];
    [sender setSelected:YES];
}

- (IBAction)btn_confirmUpdate_onclicked:(id)sender {
    NSLog(@"下一步");
    //1.检查信息完整性
    if (!self.btn_boy.isSelected && !self.btn_girl.isSelected) {
        [self.view makeToast:NSLocalizedString(@"请选择性别", nil) duration:1.0f position:@"center"];
        return;
    }
    if([SCAccountManager sharedManager].localUser.age == 0){
        [self.view makeToast:NSLocalizedString(@"请选择年龄", nil) duration:1.0f position:@"center"];
        return;
    }
    if([SCAccountManager sharedManager].localUser.tall == 0){
        [self.view makeToast:NSLocalizedString(@"请选择身高", nil) duration:1.0f position:@"center"];
        return;
    }
    if([SCAccountManager sharedManager].localUser.weight == 0){
        [self.view makeToast:NSLocalizedString(@"请选择体重", nil) duration:1.0f position:@"center"];
        return;
    }
    //2.信息完成，下一步
    if (self.btn_boy.isSelected) {
        [SCAccountManager sharedManager].localUser.sex = 1;
    }else if (self.btn_girl.isSelected) {
        [SCAccountManager sharedManager].localUser.sex = 0;
    }
        
    //push时候，隐藏tabbar  back时候，再显示出来
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:[[RegistGoalViewController alloc] init] animated:YES];
//    self.hidesBottomBarWhenPushed=NO;
}

- (IBAction)btn_back_onclicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
