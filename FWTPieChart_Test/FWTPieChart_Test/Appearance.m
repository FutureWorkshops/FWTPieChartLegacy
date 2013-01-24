//
//  Factory.m
//  TestPieChart
//
//  Created by Marco Meschini on 22/10/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "Appearance.h"

@implementation Appearance

+ (FWTEllipseLayerDrawPathBlock)StyleSTCDashboardDrawPathBlock
{     
    static dispatch_once_t onceToken;
    static CGGradientRef _gradientRef = NULL;
    dispatch_once(&onceToken, ^{
        //
        size_t locationsCount = 2;
        CGFloat locations[]   = { 1.0f, 0.0f };
        CGFloat components[]  = {
            .820, .561, .133, 1.0,
            .965, .878, .169, 1.0,
        };
        
        CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
        _gradientRef = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, locationsCount);
        CGColorSpaceRelease(rgbColorspace);
    });
    
    FWTEllipseLayerDrawPathBlock toReturn = ^(FWTEllipseLayer *elp, CGContextRef ctx, UIBezierPath *path){
    
        if (path)
        {
            //  shadow
            CGContextSaveGState(ctx);
            CGRect rect = UIEdgeInsetsInsetRect(elp.bounds, elp.edgeInsets);
            CGContextAddEllipseInRect(ctx, rect);
            CGContextClip(ctx);
            CGContextAddPath(ctx, path.CGPath);
            CGContextSetShadowWithColor(ctx, CGSizeMake(.0f, .0f), 2.5f, [[UIColor blackColor] colorWithAlphaComponent:.5f].CGColor);
            CGContextFillPath(ctx);
            CGContextRestoreGState(ctx);
            
            //  pie
            CGContextAddPath(ctx, path.CGPath);
            CGContextClip(ctx);
            CGPoint topCenterPoint = CGPointMake(.0f, CGRectGetMinY(rect));
            CGPoint bottomCenterPoint = CGPointMake(.0f, CGRectGetMaxY(rect));
            CGContextDrawLinearGradient(ctx, _gradientRef, topCenterPoint, bottomCenterPoint, 0);
        }
    };
    
    return [[toReturn copy] autorelease];
}

+ (FWTEllipseLayerDrawBackgroundBlock)StyleSTCDashboardBackgroundBlock
{
    FWTEllipseLayerDrawBackgroundBlock toReturn = ^(FWTEllipseLayer *elp, CGContextRef ctx){
        //
        UIColor *bottomShadowColor = [UIColor whiteColor];
        CGSize bottomShadowOffset = CGSizeMake(.0f, 2.0f);
        CGFloat bottomShadowBlur = 1.5f;
        
        UIColor *topShadowColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
        CGSize topShadowOffset = CGSizeMake(.0f, 3.0f);
        CGFloat topShadowBlur = 5.0f;
        
        UIEdgeInsets edgeInsets = elp.edgeInsets;
        CGRect availableRect = UIEdgeInsetsInsetRect(CGContextGetClipBoundingBox(ctx), edgeInsets);
        UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:availableRect];
        CGContextSetShadowWithColor(ctx, bottomShadowOffset, bottomShadowBlur, bottomShadowColor.CGColor);
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:.8f green:.8f blue:.76f alpha:1.0f].CGColor);
        CGContextAddPath(ctx, ovalPath.CGPath);
        CGContextDrawPath(ctx, kCGPathFill);
        
        //
        CGRect ovalBorderRect = CGRectInset(availableRect, -topShadowBlur, -topShadowBlur);
        ovalBorderRect = CGRectOffset(ovalBorderRect, -topShadowOffset.width, -topShadowOffset.height);
        ovalBorderRect = CGRectInset(CGRectUnion(ovalBorderRect, availableRect), -1.0f, -1.0f);
        UIBezierPath *negativePAth = [UIBezierPath bezierPathWithRect:ovalBorderRect];
        [negativePAth appendPath:ovalPath];
        CGContextSetShadowWithColor(ctx, topShadowOffset, topShadowBlur, topShadowColor.CGColor);
        CGContextAddPath(ctx, ovalPath.CGPath);
        CGContextClip(ctx);
        CGContextAddPath(ctx, negativePAth.CGPath);
        CGContextEOFillPath(ctx);
    };
    
    return [[toReturn copy] autorelease];
}

+ (FWTEllipseLayerDrawPathBlock)StyleTheOpenDrawPathBlock
{
    FWTEllipseLayerDrawPathBlock toReturn = ^(FWTEllipseLayer *elp, CGContextRef ctx, UIBezierPath *path){
        CGContextAddPath(ctx, path.CGPath);
        CGContextSetFillColorWithColor(ctx, elp.fillColor);
        CGContextFillPath(ctx);
        
        CGRect ellipseRect = CGRectInset(elp.bounds, 12.0f, 12.0f);
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:.01f green:.13f blue:.35f alpha:1.0f].CGColor);
        CGContextFillEllipseInRect(ctx, ellipseRect);
    };
    
    return [[toReturn copy] autorelease];
}

+ (FWTEllipseLayerDrawBackgroundBlock)StyleTheOpenBackgroundBlock
{
    FWTEllipseLayerDrawBackgroundBlock toReturn = ^(FWTEllipseLayer *elp, CGContextRef ctx){
        //
        UIColor *bottomShadowColor = [UIColor blackColor];
        CGSize bottomShadowOffset = CGSizeMake(.0f, 2.0f);
        CGFloat bottomShadowBlur = 1.5f;
        
        UIEdgeInsets edgeInsets = elp.edgeInsets;
        CGRect availableRect = UIEdgeInsetsInsetRect(CGContextGetClipBoundingBox(ctx), edgeInsets);
        UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:availableRect];
        CGContextSetShadowWithColor(ctx, bottomShadowOffset, bottomShadowBlur, bottomShadowColor.CGColor);
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:.5f green:.5f blue:.5f alpha:1.0f].CGColor);
        CGContextAddPath(ctx, ovalPath.CGPath);
        CGContextDrawPath(ctx, kCGPathFill);
    };
    
    return [[toReturn copy] autorelease];
}

+ (FWTEllipseLayerDrawPathBlock)StyleFromTenToTwoDrawPathBlock
{
    //
    static dispatch_once_t onceToken;
    static CGGradientRef _gradientRef = NULL;
    dispatch_once(&onceToken, ^{
        //
        size_t locationsCount = 2;
        CGFloat components[]  = {
            .000, .965, .000, 1.0,
            .965, .000, .000, 1.0,
        };
        
        CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
        _gradientRef = CGGradientCreateWithColorComponents(rgbColorspace, components, NULL, locationsCount);
        CGColorSpaceRelease(rgbColorspace);
    });
    
    FWTEllipseLayerDrawPathBlock toReturn = ^(FWTEllipseLayer *elp, CGContextRef ctx, UIBezierPath *path){
        
        if (path)
        {
            //  shadow
            CGContextSaveGState(ctx);
            CGRect rect = UIEdgeInsetsInsetRect(elp.bounds, elp.edgeInsets);
            CGContextAddEllipseInRect(ctx, rect);
            CGContextClip(ctx);
            CGContextAddPath(ctx, path.CGPath);
            CGContextSetShadowWithColor(ctx, CGSizeMake(.0f, 1.0f), 2.5f, [[UIColor blackColor] colorWithAlphaComponent:.5f].CGColor);
            CGContextFillPath(ctx);
            CGContextRestoreGState(ctx);
            
            //  pie
            CGContextAddPath(ctx, path.CGPath);
            CGContextClip(ctx);
            CGPoint topCenterPoint = CGPointMake(.0f, .0f);
            CGPoint bottomCenterPoint = CGPointMake(CGRectGetMaxX(elp.bounds), .0f);
            CGContextDrawLinearGradient(ctx, _gradientRef, topCenterPoint, bottomCenterPoint, 0);
        }
    };
    
    return [[toReturn copy] autorelease];
}

@end
