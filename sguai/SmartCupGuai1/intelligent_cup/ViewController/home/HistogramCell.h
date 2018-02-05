//
//  HistogramCell.h
//  Nav
//
//  Created by admin-leaf on 2017/6/8.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrinkRecordBean.h"
@interface HistogramCell : UICollectionViewCell
@property (nonatomic,assign) CGFloat height;
- (void)setContentInfo:(DrinkRecordBean*)sender;
@end
