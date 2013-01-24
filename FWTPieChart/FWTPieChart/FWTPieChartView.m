//
//  FWTPieChartView.m
//  FWTPieChart
//
//  Created by Marco Meschini on 13/12/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "FWTPieChartView.h"

typedef void (^FWTPieChartViewCompletionBlock)(void);

CGFloat const FWTPieChartViewMinimumAnimationDuration   = .125f;
CGFloat const FWTPieChartViewMaximumAnimationDuration   = .5f;

@interface FWTPieChartView ()
@property (nonatomic, readwrite, retain) CALayer *containerLayer;
@property (nonatomic, assign) NSInteger animationCounter;
@property (nonatomic, assign) BOOL restoreAnimation;
@property (nonatomic, getter = isAnimating) BOOL animating;
@property (nonatomic, copy) FWTPieChartViewCompletionBlock completionBlock;

@end

@implementation FWTPieChartView

- (void)dealloc
{
    self.ellipseLayerAtIndexBlock = NULL;
    self.completionBlock = NULL;
    self.containerLayer = nil;
    self.values = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.ellipseLayerAtIndexBlock = ^(FWTPieChartView *pcv, NSInteger index, NSInteger count){
            FWTEllipseLayer *toReturn = [FWTEllipseLayer layer];
            toReturn.contentsScale = [UIScreen mainScreen].scale;
            toReturn.fillColor = [UIColor colorWithHue:(CGFloat)index/(CGFloat)count saturation:0.5 brightness:0.75 alpha:1.0].CGColor;
            return toReturn;
        };
        
        self.startAngle = FWTEllipseLayerStartAngle;
        self.arcLength = FWTEllipseLayerArcLength;
        self.minimumAnimationDuration = FWTPieChartViewMinimumAnimationDuration;
        self.maximumAnimationDuration = FWTPieChartViewMaximumAnimationDuration;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.containerLayer.superlayer) [self.layer addSublayer:self.containerLayer];
    self.containerLayer.frame = self.bounds;
}

#pragma mark - Getters
- (CALayer *)containerLayer
{
    if (!self->_containerLayer) self->_containerLayer = [[CALayer alloc] init];
    return self->_containerLayer;
}

#pragma mark - Public
- (void)setValues:(NSArray *)values animated:(BOOL)animated
{
    if ([self isAnimating]) return;
    
    if (self->_values != values)
    {
        [self->_values release];
        self->_values = nil;
        
        if (values)
        {
            self->_values = [values retain];
            [self _adjustCountOfEllipseLayers];
            
            // Set the angles on the slices
            __block CGFloat startAngle = self.startAngle;
            
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            [self->_values enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                CGFloat angle = [obj floatValue] * self.arcLength;
                
                FWTEllipseLayer *slice = [self.containerLayer.sublayers objectAtIndex:idx];
                slice.frame = self.containerLayer.bounds;
                slice.startAngle = startAngle;
                slice.endAngle = animated ? startAngle : startAngle + angle;
                
                startAngle += angle;
            }];
            [CATransaction commit];
            
            if (animated)
            {
                self.animationCounter = self->_values.count;
                self.animating = YES;
                [self _addEndAngleAnimationToLayerWithIndex:0];
                self.animationCounter--;
            }
        }
    }
}

- (void)restore
{
    [self restoreAnimated:NO];
}

- (void)restoreAnimated:(BOOL)animated
{
    if ([self isAnimating]) return;
    
    if (animated)
    {
        self.restoreAnimation = YES;
        self.animating = YES;
        self.animationCounter = self.containerLayer.sublayers.count;
        NSInteger index = self.animationCounter-1;
        [self _addEndAngleAnimationToLayerWithIndex:index restoreEnabled:YES];
        self.animationCounter--;
    }
    else
    {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [self.containerLayer.sublayers enumerateObjectsUsingBlock:^(FWTEllipseLayer *theLayer, NSUInteger idx, BOOL *stop) {
            theLayer.endAngle = theLayer.startAngle;
        }];
        [CATransaction commit];
    }
}

#pragma mark - Private
- (void)_adjustCountOfEllipseLayers
{
    NSInteger current = self.containerLayer.sublayers.count;
    NSInteger delta = self.values.count - current;
	if (delta > 0)
    {
		for (int i = 0; i < delta; i++)
			[self.containerLayer addSublayer:self.ellipseLayerAtIndexBlock(self, current + i, self.values.count)];
	}
	else if (delta < 0)
    {
		for (int i = current-1; i > self.values.count-1; i--)
			[[self.containerLayer.sublayers objectAtIndex:i] removeFromSuperlayer];
	}
}

- (void)_addEndAngleAnimationToLayerWithIndex:(NSInteger)index
{
    [self _addEndAngleAnimationToLayerWithIndex:index restoreEnabled:NO];
}

- (void)_addEndAngleAnimationToLayerWithIndex:(NSInteger)index restoreEnabled:(BOOL)restoreEnabled
{
    FWTEllipseLayer *theLayer = [self.containerLayer.sublayers objectAtIndex:index];
    NSNumber *value = [self.values objectAtIndex:index];
    CGFloat angle =  theLayer.endAngle + value.floatValue * self.arcLength;
    NSNumber *toValue = [NSNumber numberWithFloat:restoreEnabled ? theLayer.startAngle : angle];
    NSNumber *fromValue = [NSNumber numberWithFloat:theLayer.endAngle];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setCompletionBlock:self.completionBlock];
    CABasicAnimation *animation = (CABasicAnimation *)[theLayer actionForKey:FWTEllipseLayerEndAngleKey];
    animation.duration = MAX(self.minimumAnimationDuration, self.maximumAnimationDuration*value.floatValue);
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    theLayer.endAngle = toValue.floatValue;
    [theLayer addAnimation:animation forKey:FWTEllipseLayerEndAngleKey];
    [CATransaction commit];
}

- (FWTPieChartViewCompletionBlock)completionBlock
{
    if (self->_completionBlock == NULL)
    {
        __block typeof(self) myself = self;
        self->_completionBlock = [^(){
            
            if (myself.animationCounter == 0)
            {
                myself.animating = NO;
                myself.restoreAnimation = NO;
                return;
            }
            
            NSInteger index;
            BOOL restoreEnabled = NO;
            if (!myself.restoreAnimation)
                index = myself.containerLayer.sublayers.count-myself.animationCounter;
            else
            {
                index = myself.animationCounter-1;
                restoreEnabled = YES;
            }
            
            [myself _addEndAngleAnimationToLayerWithIndex:index restoreEnabled:restoreEnabled];
            myself.animationCounter--;
            
        } copy];
    }
    return self->_completionBlock;
}


@end

