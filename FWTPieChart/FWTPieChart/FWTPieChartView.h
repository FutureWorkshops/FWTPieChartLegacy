//
//  FWTPieChartView.h
//  FWTPieChart
//
//  Created by Marco Meschini on 13/12/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWTEllipseLayer.h"

@class FWTPieChartView;
typedef FWTEllipseLayer *(^FWTPieChartEllipseLayerAtIndexBlock)(FWTPieChartView *, NSInteger, NSInteger);

@interface FWTPieChartView : UIView

@property (nonatomic, retain) NSArray *values;
@property (nonatomic, readonly, retain) CALayer *containerLayer;
@property (nonatomic, copy) FWTPieChartEllipseLayerAtIndexBlock ellipseLayerAtIndexBlock;
@property (nonatomic, assign) CGFloat minimumAnimationDuration, maximumAnimationDuration;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat arcLength;

- (void)setValues:(NSArray *)values animated:(BOOL)animated;

- (void)restore;
- (void)restoreAnimated:(BOOL)animated;

@end
