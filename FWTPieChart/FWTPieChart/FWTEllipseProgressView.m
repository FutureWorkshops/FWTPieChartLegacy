//
//  FWTEllipseProgressView.m
//  FWTPieChart
//
//  Created by Marco Meschini on 13/12/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "FWTEllipseProgressView.h"

@implementation FWTEllipseProgressView

+ (Class)layerClass
{
    return [FWTEllipseLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.contentScaleFactor = [UIScreen mainScreen].scale;
    }
    return self;
}

#pragma mark - Public
- (FWTEllipseLayer *)ellipseProgressLayer
{
    return (FWTEllipseLayer *)self.layer;
}

- (CGFloat)progress
{
    return self.ellipseProgressLayer.progress;
}

- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [self.ellipseProgressLayer setProgress:progress animated:animated];
}


@end
