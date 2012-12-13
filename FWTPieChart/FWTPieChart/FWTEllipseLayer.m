//
//  FWTEllipseLayer.m
//  FWTPieChart
//
//  Created by Marco Meschini on 13/12/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "FWTEllipseLayer.h"
#define FWT_EL_EDGE_INSETS              UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f)
#define FWT_EL_START_ANGLE              3 * M_PI_2
#define FWT_EL_END_ANGLE                FWT_EL_START_ANGLE
#define FWT_EL_ARC_LENGTH               2 * M_PI
#define FWT_EL_FILL_COLOR               [UIColor lightGrayColor]
#define FWT_EL_ANIMATION_DURATION       .25f

NSString *const FWTEllipseLayerStartAngleKey = @"startAngle";
NSString *const FWTEllipseLayerEndAngleKey   = @"endAngle";

#pragma mark - FWTEllipseProgressLayer
@interface FWTEllipseLayer ()
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGPoint ellipseCenter;
@property (nonatomic, assign) CGRect availableRect;
@property (nonatomic, readwrite) CGLayerRef backgroundCGLayer;
@property (nonatomic, readwrite, retain) UIBezierPath *bezierPath;

@end

@implementation FWTEllipseLayer
@dynamic startAngle, endAngle;

- (void)dealloc
{
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
        self.startAngle         = FWT_EL_START_ANGLE;
        self.endAngle           = FWT_EL_END_ANGLE;
        [CATransaction commit];
        
        //
        self.edgeInsets         = FWT_EL_EDGE_INSETS;
        self.arcLength          = FWT_EL_ARC_LENGTH;
        self.fillColor          = FWT_EL_FILL_COLOR;
        self.animationDuration  = FWT_EL_ANIMATION_DURATION;
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
        self.radius = source.radius;
        self.ellipseCenter = source.ellipseCenter;
        
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
    self.bezierPath = [self _createEllipsePath];
    
    //
    if (self.drawPathBlock)
        self.drawPathBlock(self, ctx, self.bezierPath);
    else
    {
        CGContextAddPath(ctx, self.bezierPath.CGPath);
        CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
        CGContextFillPath(ctx);
    }
}

#pragma mark - Private
- (void)_updatePrivateVars
{
    self.availableRect = UIEdgeInsetsInsetRect(self.bounds, self.edgeInsets);
    self.radius = CGRectGetWidth(self.availableRect)*.5f;
    self.ellipseCenter = CGPointMake(CGRectGetMidX(self.availableRect), CGRectGetMidY(self.availableRect));
    
    CGLayerRelease(self.backgroundCGLayer);
    self.backgroundCGLayer = NULL;
}

- (UIBezierPath *)_createEllipsePath
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

