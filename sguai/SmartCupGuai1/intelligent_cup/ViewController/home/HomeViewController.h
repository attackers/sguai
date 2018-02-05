//
//  HomeViewController.h
//  intelligent_cup
//
//  Created by liuming on 15/10/28.
//  Copyright © 2015年 makeblock. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PICircularProgressView.h"
#import "SCChartView.h"
#import "SCManager.h"
#import "WeatherManager.h"

@interface HomeViewController : BaseViewController <WeatherManagerDelegate>

//上面
- (IBAction)btn_click_waterSet:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *cupNameLabel;
- (IBAction)btn_click_analyse:(id)sender;

//中间
@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;

//下面
@property (weak, nonatomic) IBOutlet UIView *citiView;
@property (weak, nonatomic) IBOutlet UILabel *batteryLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *wheaterTempLabel;
@property (weak, nonatomic) IBOutlet UIImageView *wheaterImageView;
@property (weak, nonatomic) IBOutlet UIImageView *batteryImageView;

@property (weak, nonatomic) IBOutlet SCChartView *scChartView;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;//四种不同颜色的背景图片

@property(nonatomic,strong)UIPageControl *pageControl;
@property (strong, nonatomic) UIScrollView *guidepageScrollView;



@end
