//
//  FWTEllipseProgressView.h
//  FWTPieChart
//
//  Created by Marco Meschini on 13/12/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWTEllipseLayer.h"

@interface FWTEllipseProgressView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, readonly) FWTEllipseLayer *ellipseProgressLayer;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
