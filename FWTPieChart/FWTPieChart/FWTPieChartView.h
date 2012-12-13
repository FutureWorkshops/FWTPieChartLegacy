//
//  FWTPieChartView.h
//  FWTPieChart
//
//  Created by Marco Meschini on 13/12/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FWTPieChartView;
typedef UIColor *(^FWTPieChartViewColorForSliceBlock)(FWTPieChartView *, NSInteger, NSInteger);

@interface FWTPieChartView : UIView

@property (nonatomic, retain) NSArray *values;
@property (nonatomic, copy) FWTPieChartViewColorForSliceBlock colorForSliceBlock;
@property (nonatomic, assign) CGFloat minimumAnimationDuration, maximumAnimationDuration;

- (void)setValues:(NSArray *)values animated:(BOOL)animated;

- (void)restore;
- (void)restoreAnimated:(BOOL)animated;

@end
