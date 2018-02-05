//
//  HistogramViewController.m
//  Nav
//
//  Created by admin-leaf on 2017/6/6.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "HistogramViewController.h"
#import "HistogramCell.h"
#import "SCManager.h"
#define identifier @"cell"

@interface HistogramViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    CGFloat height;
}

@end

@implementation HistogramViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGRect rect = [UIScreen mainScreen].bounds;

    height = _heightBound/6;
    if (CGRectGetHeight(rect)==568) {
        height = _heightBound/8;
    }
    for (int i = 0; i<6; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, i*height, 60, height)];
 
        label.text = [NSString stringWithFormat:@"%d000",6-(i+1)];
        if (i==5) {
            label.text = @"";
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:13];
        [self.view addSubview:label];
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.itemSize = CGSizeMake(40, _heightBound);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _testCollectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(50, 18, CGRectGetWidth(self.view.frame)-65, _heightBound) collectionViewLayout:layout];
    
    _testCollectionview.dataSource = self;
    _testCollectionview.delegate = self;
    _testCollectionview.backgroundColor = [UIColor whiteColor];
    [_testCollectionview registerNib:[UINib nibWithNibName:@"HistogramCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    [self.view addSubview:_testCollectionview];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [SCManager sharedManager].currentDrinkRecordArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HistogramCell *cell =   [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.height = height*6;
    DrinkRecordBean *messageDic = [SCManager sharedManager].currentDrinkRecordArray[indexPath.row];
    [cell setContentInfo:messageDic];
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 20, 0, 0);
}

@end
