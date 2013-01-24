//
//  FWTEllipseLayer.m
//  FWTPieChart
//
//  Created by Marco Meschini on 13/12/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "FWTEllipseLayer.h"

#define FWT_EL_FILL_COLOR                        [UIColor lightGrayColor].CGColor

NSString *const FWTEllipseLayerStartAngleKey    = @"startAngle";
NSString *const FWTEllipseLayerEndAngleKey      = @"endAngle";

UIEdgeInsets const FWTEllipseLayerEdgeInsets    = (UIEdgeInsets){2.0f, 2.0f, 2.0f, 2.0f};
CGFloat const FWTEllipseLayerStartAngle         = 3 * M_PI_2;
CGFloat const FWTEllipseLayerEndAngle           = 3 * M_PI_2;
CGFloat const FWTEllipseLayerArcLength          = 2 * M_PI;
CGFloat const FWTEllipseLayerAnimationDuration  = .25f;

#pragma mark - FWTEllipseProgressLayer
@interface FWTEllipseLayer ()
@property (nonatomic, assign) CGPoint ellipseCenter;
@property (nonatomic, assign) CGRect availableRect;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, readwrite) CGLayerRef backgroundCGLayer;
@property (nonatomic, readwrite, retain) UIBezierPath *bezierPath;

@end

@implementation FWTEllipseLayer
@dynamic startAngle, endAngle;
@synthesize fillColor = _fillColor;

- (void)dealloc
{
    if (self->_fillColor)
        self.fillColor = NULL;

    self.bezierPath = nil;
    CGLayerRelease(self.backgroundCGLayer);
    self.backgroundCGLayer = NULL;
    self.drawPathBlock = nil;
    self.drawBackgroundBlock = nil;
    [super dealloc];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.needsDisplayOnBoundsChange = YES;
        
        //
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.startAngle         = FWTEllipseLayerStartAngle;
        self.endAngle           = FWTEllipseLayerEndAngle;
        [CATransaction commit];
        
        //
        self.edgeInsets         = FWTEllipseLayerEdgeInsets;
        self.arcLength          = FWTEllipseLayerArcLength;
        self.animationDuration  = FWTEllipseLayerAnimationDuration;
    }
    return self;
}

- (id)initWithLayer:(id)layer
{
    if ((self = [super initWithLayer:layer]))
    {
        FWTEllipseLayer *source = (FWTEllipseLayer *)layer;
        self.edgeInsets = source.edgeInsets;
        self.startAngle = source.startAngle;
        self.endAngle = source.endAngle;
        
        self.arcLength = source.arcLength;
        self.availableRect = source.availableRect;
        self.ellipseCenter = source.ellipseCenter;
        self.radius = source.radius;
        
        self.backgroundCGLayer = CGLayerRetain(source.backgroundCGLayer);
        self.drawPathBlock = source.drawPathBlock;
        self.drawBackgroundBlock = source.drawBackgroundBlock;
        self.fillColor = source.fillColor;
        self.animationDuration = source.animationDuration;
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self _updatePrivateVars];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self _updatePrivateVars];
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGRect ctxRect = CGContextGetClipBoundingBox(ctx);
    CGContextClearRect(ctx, ctxRect);
    
    //
    if (self.drawBackgroundBlock)
    {
        if (!self.backgroundCGLayer)
        {
            CGFloat scale = self.contentsScale;
            CGSize layerSize = CGSizeMake(CGRectGetWidth(self.bounds)*scale, CGRectGetHeight(self.bounds)*scale);
            self.backgroundCGLayer = CGLayerCreateWithContext(ctx, layerSize, NULL);
            CGContextRef cgLayerCtx = CGLayerGetContext(self.backgroundCGLayer);
            CGContextScaleCTM(cgLayerCtx, scale, scale);
            self.drawBackgroundBlock(self, cgLayerCtx);
        }
        
        CGContextDrawLayerInRect(ctx, self.bounds, self.backgroundCGLayer);
    }
    
    //
    self.bezierPath = [self _getEllipsePath];
    
    //
    if (self.drawPathBlock)
        self.drawPathBlock(self, ctx, self.bezierPath);
    else
    {
        CGContextAddPath(ctx, self.bezierPath.CGPath);
        CGContextSetFillColorWithColor(ctx, self.fillColor);
        CGContextFillPath(ctx);
    }
}

#pragma mark - Private
- (void)_updatePrivateVars
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.availableRect = UIEdgeInsetsInsetRect(self.bounds, self.edgeInsets);
    self.radius = CGRectGetWidth(self.availableRect)*.5f;
    self.ellipseCenter = CGPointMake(CGRectGetMidX(self.availableRect), CGRectGetMidY(self.availableRect));
    
    CGLayerRelease(self.backgroundCGLayer);
    self.backgroundCGLayer = NULL;
    [CATransaction commit];
}

- (UIBezierPath *)_getEllipsePath
{
    if (self.startAngle == self.endAngle) return nil;
    
    int clockwise = self.startAngle < self.endAngle;
    CGPoint p1 = self.ellipseCenter;
    p1.x += self.radius * cosf(self.startAngle);
    p1.y += self.radius * sinf(self.startAngle);
    UIBezierPath *toReturn = [UIBezierPath bezierPath];
    [toReturn moveToPoint:self.ellipseCenter];
    [toReturn addLineToPoint:p1];
    [toReturn addArcWithCenter:self.ellipseCenter
                        radius:self.radius
                    startAngle:self.startAngle
                      endAngle:self.endAngle
                     clockwise:clockwise];
    [toReturn closePath];
    return toReturn;
}

#pragma mark - Public
- (void)setFillColor:(CGColorRef)fillColor
{
    if (self->_fillColor != fillColor)
    {
        CGColorRelease(self->_fillColor);
        self->_fillColor = NULL;
        
        if (fillColor)
        {
            self->_fillColor = CGColorRetain(fillColor);
            [self setNeedsDisplay];
        }
    }
}

- (CGColorRef)fillColor
{
    if (!self->_fillColor) self->_fillColor = CGColorRetain(FWT_EL_FILL_COLOR);
    return self->_fillColor;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    if (self->_progress != progress)
    {
        self->_progress = progress;
        
        if (!animated)
        {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
        }
        
        self.endAngle = self.arcLength * self->_progress + self.startAngle;
        
        if (!animated)
            [CATransaction commit];
    }
}

#pragma mark - Custom animatable property
+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:FWTEllipseLayerEndAngleKey] || [key isEqualToString:FWTEllipseLayerStartAngleKey]) return YES;
    return [super needsDisplayForKey:key];
}

- (id<CAAction>)actionForKey:(NSString *)event {
	if ([event isEqualToString:FWTEllipseLayerEndAngleKey] || [event isEqualToString:FWTEllipseLayerStartAngleKey])
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
        animation.duration = self.animationDuration;
        animation.fromValue = [self.presentationLayer valueForKey:event];
        return animation;
	}
	
	return [super actionForKey:event];
}

@end

