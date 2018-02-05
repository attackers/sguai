//
//  RecommendViewController.m
//  intelligent_cup
//
//  Created by liuming on 16/8/8.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import "RecommendViewController.h"

@interface RecommendViewController ()
@property (weak, nonatomic) IBOutlet UITextView *oneRowTextView;
@property (weak, nonatomic) IBOutlet UITextView *twoRowTextView;
@property (weak, nonatomic) IBOutlet UITextView *threeRowTextView;
@property (weak, nonatomic) IBOutlet UITextView *fourRowTextView;
@property (weak, nonatomic) IBOutlet UITextView *fiveRowTextView;
@property (weak, nonatomic) IBOutlet UITextView *sixRowTextView;
@property (weak, nonatomic) IBOutlet UITextView *sevenRowTextView;
@property (weak, nonatomic) IBOutlet UITextView *eightRowTextView;

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"专家推荐", nil);
    _oneRowTextView.text = NSLocalizedString(@"ccx-ux-5aO.text", nil);
    _twoRowTextView.text = NSLocalizedString(@"ena-FB-FfY.text", nil);
    _threeRowTextView.text = NSLocalizedString(@"rvr-td-IO5.text", nil);
    _fourRowTextView.text = NSLocalizedString(@"igt-KH-RY9.text", nil);
    _fiveRowTextView.text = NSLocalizedString(@"DSY-yg-JQe.text", nil);
    _sixRowTextView.text = NSLocalizedString(@"MHN-un-KQ5.text", nil);
    _sevenRowTextView.text = NSLocalizedString(@"KPb-ZC-R2L.text", nil);
    _eightRowTextView.text = NSLocalizedString(@"4xp-2r-6g6.text", nil);
}




@end
