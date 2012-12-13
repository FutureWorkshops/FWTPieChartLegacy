//
//  FWTEllipseLayer.h
//  FWTPieChart
//
//  Created by Marco Meschini on 13/12/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

extern NSString *const FWTEllipseLayerStartAngleKey;
extern NSString *const FWTEllipseLayerEndAngleKey;

@class FWTEllipseLayer;
typedef void (^FWTEllipseLayerDrawPathBlock)(FWTEllipseLayer *, CGContextRef, UIBezierPath *);
typedef void (^FWTEllipseLayerDrawBackgroundBlock)(FWTEllipseLayer *, CGContextRef);

@interface FWTEllipseLayer : CALayer

@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) CGFloat startAngle;                                   //  default is 3*M_PI/2
@property (nonatomic, assign) CGFloat endAngle;
@property (nonatomic, assign) CGFloat arcLength;                                    //  default is 2*M_PI
@property (nonatomic, retain) UIColor *fillColor;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, readonly, retain) UIBezierPath *bezierPath;
@property (nonatomic, copy) FWTEllipseLayerDrawPathBlock drawPathBlock;
@property (nonatomic, copy) FWTEllipseLayerDrawBackgroundBlock drawBackgroundBlock;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
