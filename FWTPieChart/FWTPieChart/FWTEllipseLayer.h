//
//  FWTEllipseLayer.h
//  FWTPieChart
//
//  Created by Marco Meschini on 13/12/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

FOUNDATION_EXPORT UIEdgeInsets const FWTEllipseLayerEdgeInsets;     // {2.0f, 2.0f, 2.0f, 2.0f};
FOUNDATION_EXPORT CGFloat const FWTEllipseLayerStartAngle;          //  3 * M_PI_2;
FOUNDATION_EXPORT CGFloat const FWTEllipseLayerEndAngle;            //  3 * M_PI_2;
FOUNDATION_EXPORT CGFloat const FWTEllipseLayerArcLength;           //  2 * M_PI;
FOUNDATION_EXPORT CGFloat const FWTEllipseLayerAnimationDuration;   //  .25f

FOUNDATION_EXPORT NSString *const FWTEllipseLayerStartAngleKey;
FOUNDATION_EXPORT NSString *const FWTEllipseLayerEndAngleKey;

@class FWTEllipseLayer;
typedef void (^FWTEllipseLayerDrawPathBlock)(FWTEllipseLayer *, CGContextRef, UIBezierPath *);
typedef void (^FWTEllipseLayerDrawBackgroundBlock)(FWTEllipseLayer *, CGContextRef);

@interface FWTEllipseLayer : CALayer

@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;
@property (nonatomic, assign) CGFloat arcLength;
@property (nonatomic) CGColorRef fillColor;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, readonly, retain) UIBezierPath *bezierPath;
@property (nonatomic, copy) FWTEllipseLayerDrawPathBlock drawPathBlock;
@property (nonatomic, copy) FWTEllipseLayerDrawBackgroundBlock drawBackgroundBlock;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
