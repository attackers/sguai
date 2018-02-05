//
//  HomeAnalyseViewController.m
//  intelligent_cup
//
//  Created by liuming on 15/11/14.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import "HomeAnalyseViewController.h"
#import "SCManager.h"
#import "DrinkRecordBean.h"
#import "SCAccountManager.h"
#import "DayDrinkView.h"

@interface HomeAnalyseViewController ()
{
    DayDrinkView *heightDrinkview;
    DayDrinkView *lowDrinkview;
    DayDrinkView2 *averageDrinkview;
    DayDrinkView2 *totalDrinkView;
    UILabel *reminderDrinkLabel;
    UILabel *minLabel;
}
@end

@implementation HomeAnalyseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *viewBackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(screenWindow), CGRectGetHeight(screenWindow))];
    viewBackgroundImageView.image = [UIImage imageNamed:@"analyze_bg"];
    [self.view addSubview:viewBackgroundImageView];
    int goal = [[SCAccountManager sharedManager].localUser calculateDrinkGoal];
    int count = [SCManager sharedManager].currentDrinkRecordArray.count;
    int countOk = 0;//达标天数
    DrinkRecordBean *bean0 = [[SCManager sharedManager].currentDrinkRecordArray objectAtIndex:0];
    int maxWater = [bean0.drink intValue];
    int minWater = [bean0.drink intValue];
    int average = 0;
    int total = 0;
    for (int i=0; i<count; i++) {
        DrinkRecordBean *bean = [[SCManager sharedManager].currentDrinkRecordArray objectAtIndex:i];
        total = total + [bean.drink intValue];
        if ([bean.drink intValue] < minWater) {
            minWater = [bean.drink intValue];
        }
        if ([bean.drink intValue] > maxWater) {
            maxWater = [bean.drink intValue];
        }
        if([bean.drink intValue]>=goal/2){
            countOk++;
        }
    }
    average = total/count;
    NSLog(@"total=%d,average=%d,maxWater=%d,minWater=%d",total,average,maxWater,minWater);
    //更新UI
    int score = (average+0.0f)/goal*100;
    
    NSString *summary = NSLocalizedString(@"5天中，2天喝水达标", nil);
    NSArray *summaryArray = [summary componentsSeparatedByString:@"，"];
    NSString *summary1 = [[summaryArray firstObject] stringByReplacingOccurrencesOfString:@"5" withString:[NSString stringWithFormat:@"%d",count]];
    NSString *summary2 = [[summaryArray lastObject] stringByReplacingOccurrencesOfString:@"2" withString:[NSString stringWithFormat:@"%d",countOk]];
    NSString *summaryStr = [NSString stringWithFormat:@"%@,%@",summary1,summary2];

    [self subViewLayout];
    
    minLabel.text = [NSString stringWithFormat:@"%d%@",score,NSLocalizedString(@"Min", nil)];;
    reminderDrinkLabel.text = summaryStr;
    
    [totalDrinkView setDrinkValueLabelText:[NSString stringWithFormat:@"%dml",total] AndReminderLabel:NSLocalizedString(@"Total water intake", nil) AndIconImageview:@"analyze_ic_04"];
    
    [averageDrinkview setDrinkValueLabelText:[NSString stringWithFormat:@"%dml",average] AndReminderLabel:NSLocalizedString(@"平均饮水量", nil) AndIconImageview:@"analyze_ic_03"];
    
    [heightDrinkview setDrinkValueLabelText:[NSString stringWithFormat:@"%d",maxWater] AndReminderLabel:NSLocalizedString(@"单日最高", nil) AndIconImageview:@"analyze_ic_01"];
    
    [lowDrinkview setDrinkValueLabelText:[NSString stringWithFormat:@"%d",minWater] AndReminderLabel:NSLocalizedString(@"lowest", nil) AndIconImageview:@"analyze_ic_02"];

}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];

}

- (void)subViewLayout
{
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.title = NSLocalizedString(@"Health", nil);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIImageView *roundImageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(screenWindow)/2-80, 64, 160*scaleLayout, 160*scaleLayout)];
    roundImageview.image = [UIImage imageNamed:@"img_home_analys_score_bg"];
    
    minLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(roundImageview.frame), 36*scaleLayout)];
    minLabel.center = roundImageview.center;
    minLabel.textColor = [UIColor colorWithRed:14/255.0 green:114/255.0 blue:218/255.0 alpha:1];
    minLabel.textAlignment = NSTextAlignmentCenter;
    minLabel.font = [UIFont boldSystemFontOfSize:19*scaleLayout];
    
    reminderDrinkLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(roundImageview.frame) - 16, CGRectGetWidth(screenWindow), 60*scaleLayout)];
    reminderDrinkLabel.textAlignment = NSTextAlignmentCenter;
    reminderDrinkLabel.textColor = [UIColor whiteColor];
    reminderDrinkLabel.numberOfLines = 222;
    
    CGFloat width = (CGRectGetWidth(screenWindow) - 24)/2;
    heightDrinkview = [[DayDrinkView alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(reminderDrinkLabel.frame) + 12, width, 60*scaleLayout)];
    
    lowDrinkview = [[DayDrinkView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(heightDrinkview.frame) + 8, CGRectGetMaxY(reminderDrinkLabel.frame) + 12, width, 60*scaleLayout)];

    averageDrinkview = [[DayDrinkView2 alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(lowDrinkview.frame) + 8, (CGRectGetWidth(screenWindow) - 16), 60*scaleLayout)];
    
    totalDrinkView = [[DayDrinkView2 alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(averageDrinkview.frame) + 8, (CGRectGetWidth(screenWindow) - 16), 60*scaleLayout)];

    [self.view addSubview:roundImageview];
    [self.view addSubview:minLabel];
    [self.view addSubview:reminderDrinkLabel];
    [self.view addSubview:heightDrinkview];
    [self.view addSubview:lowDrinkview];
    [self.view addSubview:averageDrinkview];
    [self.view addSubview:totalDrinkView];

}

- (IBAction)btn_back_onclicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
