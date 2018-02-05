//
//  GuideViewController.m
//  intelligent_cup
//
//  Created by liuming on 16/9/17.
//  Copyright © 2016年 makeblock. All rights reserved.
//

#import "GuideViewController.h"

#define SCREEN_FRAME ([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface GuideViewController () {
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    UIImageView *imageViewOne;
    UIImageView *imageViewTwo;
    UIImageView *imageViewThree;
    UIImageView *imageViewFour;
}

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化UI控件
    scrollView=[[UIScrollView alloc]initWithFrame:SCREEN_FRAME];
    scrollView.pagingEnabled=YES;
    [self.view addSubview:scrollView];
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, self.view.bounds.size.width, 30)];
//    pageControl.backgroundColor = [UIColor redColor];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.153 green:0.533 blue:0.796 alpha:1.0];
    [self.view addSubview:pageControl];
    pageControl.numberOfPages = 4;
    
    [self createViewOne];
    [self createViewTwo];
    [self createViewThree];
    [self createViewFour];
}

-(void)createViewOne{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageViewOne = [[UIImageView alloc] initWithFrame:SCREEN_FRAME];
    imageViewOne.contentMode = UIViewContentModeScaleAspectFit;
    imageViewOne.image = [UIImage imageNamed:@"img_page_01.png"];
    imageViewOne.userInteractionEnabled = YES;

    [view addSubview:imageViewOne];
    [scrollView addSubview:view];
    
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe1:)];
    swip.direction = UISwipeGestureRecognizerDirectionLeft;
    [imageViewOne addGestureRecognizer:swip];
}

-(void)createViewTwo{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageViewTwo = [[UIImageView alloc] initWithFrame:SCREEN_FRAME];
    imageViewTwo.contentMode = UIViewContentModeScaleAspectFit;
    imageViewTwo.image = [UIImage imageNamed:@"img_page_02.png"];
     imageViewTwo.userInteractionEnabled = YES;
    
    [view addSubview:imageViewTwo];
    [scrollView addSubview:view];
    
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe2:)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [imageViewTwo addGestureRecognizer:swipLeft];
    
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe2:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [imageViewTwo addGestureRecognizer:swipRight];
}

-(void)createViewThree{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageViewThree = [[UIImageView alloc] initWithFrame:SCREEN_FRAME];
    imageViewThree.contentMode = UIViewContentModeScaleAspectFit;
    imageViewThree.image = [UIImage imageNamed:@"img_page_03.png"];
    imageViewThree.userInteractionEnabled = YES;

    [view addSubview:imageViewThree];
    [scrollView addSubview:view];
    
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe3:)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [imageViewThree addGestureRecognizer:swipLeft];
    
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe3:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [imageViewThree addGestureRecognizer:swipRight];
}


-(void)createViewFour{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageViewFour = [[UIImageView alloc] initWithFrame:SCREEN_FRAME];
    imageViewFour.contentMode = UIViewContentModeScaleAspectFit;
    imageViewFour.image = [UIImage imageNamed:@"img_page_04.png"];
    imageViewFour.userInteractionEnabled = YES;
    
    [view addSubview:imageViewFour];
    [scrollView addSubview:view];
    
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe4:)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [imageViewFour addGestureRecognizer:swipLeft];
    
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe4:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [imageViewFour addGestureRecognizer:swipRight];
}


-(void)swipe1:(UISwipeGestureRecognizer *)recognizer{
     NSLog(@"swipe1");
    switch (recognizer.direction) {
        case UISwipeGestureRecognizerDirectionLeft: {
            [self selectPageWithIndex:1];
            break;
        }
    }
}

-(void)swipe2:(UISwipeGestureRecognizer *)recognizer{
     NSLog(@"swipe2");
    switch (recognizer.direction) {
        case UISwipeGestureRecognizerDirectionRight:
            [self selectPageWithIndex:0];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            [self selectPageWithIndex:2];
            break;
    }
}

-(void)swipe3:(UISwipeGestureRecognizer *)recognizer{
     NSLog(@"swipe3");
    switch (recognizer.direction) {
        case UISwipeGestureRecognizerDirectionRight:
            [self selectPageWithIndex:1];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            [self selectPageWithIndex:3];
            break;
    }
}

-(void)swipe4:(UISwipeGestureRecognizer *)recognizer{
     NSLog(@"swipe4");
    switch (recognizer.direction) {
        case UISwipeGestureRecognizerDirectionRight:
            [self selectPageWithIndex:2];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"引导页完成");
            [self dismissModalViewControllerAnimated:YES];
            break;
    }
    
}

-(void)selectPageWithIndex:(int)index {
    CGFloat pageWidth = CGRectGetWidth(self.view.bounds);
    CGPoint scrollPoint = CGPointMake(pageWidth*index, 0);
    [scrollView setContentOffset:scrollPoint animated:YES];
    pageControl.currentPage = index;
    
}

@end
