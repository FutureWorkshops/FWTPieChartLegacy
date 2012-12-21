//
//  CustomPieChartView.m
//  FWTPieChart_Test
//
//  Created by Marco Meschini on 14/12/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "CustomPieChartView.h"
#import <QuartzCore/QuartzCore.h>

@interface UIColor (Utils)
- (UIColor *)colorByDarkeningWithFactor:(CGFloat)factor;
@end

@implementation UIColor (Utils)

- (UIColor *)colorByDarkeningWithFactor:(CGFloat)factor
{
	// oldComponents is the array INSIDE the original color
	// changing these changes the original, so we copy it
	CGFloat *oldComponents = (CGFloat *)CGColorGetComponents([self CGColor]);
	CGFloat newComponents[4];
	
	int numComponents = CGColorGetNumberOfComponents([self CGColor]);
	
	switch (numComponents)
	{
		case 2:
		{
			//grayscale
			newComponents[0] = oldComponents[0]*factor;
			newComponents[1] = oldComponents[0]*factor;
			newComponents[2] = oldComponents[0]*factor;
			newComponents[3] = oldComponents[1];
			break;
		}
		case 4:
		{
			//RGBA
			newComponents[0] = oldComponents[0]*factor;
			newComponents[1] = oldComponents[1]*factor;
			newComponents[2] = oldComponents[2]*factor;
			newComponents[3] = oldComponents[3];
			break;
		}
	}
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);
	
	UIColor *retColor = [UIColor colorWithCGColor:newColor];
	CGColorRelease(newColor);
	
	return retColor;
}

@end


@interface CustomPieChartView ()
@property (nonatomic, retain) FWTEllipseLayer *selectedLayer;
@end

@implementation CustomPieChartView

- (void)dealloc
{
    self.selectedLayer = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 1.0f;
    }
    return self;
}

//- (void)drawRect:(CGRect)rect
//{
//    UIColor *bottomShadowColor = [UIColor blackColor];
//    CGSize bottomShadowOffset = CGSizeMake(.0f, .0f);
//    CGFloat bottomShadowBlur = 2.0f;
//    
//    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGRect availableRect = UIEdgeInsetsInsetRect(rect, edgeInsets);
//    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:availableRect];
//    CGContextSetShadowWithColor(ctx, bottomShadowOffset, bottomShadowBlur, bottomShadowColor.CGColor);
//    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:.5f green:.5f blue:.5f alpha:1.0f].CGColor);
//    CGContextAddPath(ctx, ovalPath.CGPath);
//    CGContextDrawPath(ctx, kCGPathFill);
//}

#pragma mark - Getters
- (FWTEllipseLayer *)selectedLayer
{
    if (!self->_selectedLayer)
    {
        self->_selectedLayer = [[FWTEllipseLayer alloc] init];
        self->_selectedLayer.contentsScale = [UIScreen mainScreen].scale;
//        self->_selectedLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:2], nil];
//        self->_selectedLayer.fillColor = [UIColor clearColor].CGColor;
        self->_selectedLayer.borderWidth = 1.0f;
    }
    
    return self->_selectedLayer;
}


#pragma mark - UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    [self _selectEllipseLayerAtPoint:point];

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    [self _selectEllipseLayerAtPoint:point];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    [self _selectEllipseLayerAtPoint:point];
}

#pragma mark - Privaye
- (void)_selectEllipseLayerAtPoint:(CGPoint)point
{
    [self.containerLayer.sublayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setHidden:NO];
        [obj setOpacity:1.0f];
    }];
    
    [self.selectedLayer removeFromSuperlayer];
    
    __block BOOL found = NO;
    [self.containerLayer.sublayers enumerateObjectsUsingBlock:^(FWTEllipseLayer *theLayer, NSUInteger idx, BOOL *stop) {
        if ([theLayer.bezierPath containsPoint:point])
        {
            theLayer.hidden = YES;
            
            found = YES;
            
            if (!self.selectedLayer.superlayer)
            {
                [self.layer addSublayer:self.selectedLayer];
                
                //
                CABasicAnimation *dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
                [dashAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
                [dashAnimation setToValue:[NSNumber numberWithFloat:5.0f]];
                [dashAnimation setDuration:1.0f];
                [dashAnimation setRepeatCount:10000];
                [self.selectedLayer addAnimation:dashAnimation forKey:@"animateLineDashPhase"];
            }
            
            [self _updateSelectedLayerWithEllipseLayer:theLayer];
            
            
//            *stop = YES;
        }
    }];
    
    
    
//    if (!found)
//    {
//        [self.containerLayer.sublayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            [obj setHidden:NO];
//        }];
//        
//        [self.selectedLayer removeFromSuperlayer];
//    }
}

- (void)_updateSelectedLayerWithEllipseLayer:(FWTEllipseLayer *)ellipseLayer
{
    //
    CGRect theFrame = CGRectInset(self.containerLayer.frame, -10, -10);
//    CGAffineTransform tranform = CGAffineTransformMakeScale(1.1f, 1.1f);
//    tranform = CGAffineTransformTranslate(tranform, -14, -14);
//    CGPathRef pathRef = CGPathCreateCopyByTransformingPath(ellipseLayer.bezierPath.CGPath, &tranform);
//    theFrame = CGRectOffset(theFrame, 10, 10);
//    CGPathRef pathRef = CGPathCreateCopyByTransformingPath(ellipseLayer.bezierPath.CGPath, NULL);
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
//    self.selectedLayer.strokeColor = [ellipseLayer.fillColor colorByDarkeningWithFactor:.5f].CGColor;
//    self.selectedLayer.fillColor = [ellipseLayer.fillColor colorWithAlphaComponent:.5f].CGColor;
//    self.selectedLayer.frame = theFrame;
//    self.selectedLayer.path = pathRef; //[UIBezierPath bezierPathWithCGPath:ellipseLayer.bezierPath.CGPath].CGPath;
    self.selectedLayer.edgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    self.selectedLayer.startAngle = ellipseLayer.startAngle;
    self.selectedLayer.endAngle = ellipseLayer.endAngle;
    self.selectedLayer.frame = theFrame;
    self.selectedLayer.fillColor = ellipseLayer.fillColor;
    
    [CATransaction commit];
    
//    CGFloat radius = self.selectedLayer.radius;
//    self.selectedLayer.radius = radius + 10.0f;
    
    
    
}


@end
