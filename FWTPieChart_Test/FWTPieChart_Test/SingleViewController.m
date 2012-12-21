//
//  SingleViewController.m
//  FWTEllipseProgressView_Test
//
//  Created by Marco Meschini on 07/12/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "SingleViewController.h"
#import "FWTEllipseProgressView.h"

@interface SingleViewController ()
@property (nonatomic, retain) FWTEllipseProgressView *ellipseProgressView;
@property (nonatomic, retain) UISlider *sliderA, *sliderB, *sliderC;
@end

@implementation SingleViewController

- (void)dealloc
{
    self.sliderB = nil;
    self.sliderA = nil;
    self.ellipseProgressView = nil;
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"Pie Chart";
    
    //
    CGRect frame = CGRectMake(0, 0, 300, 300);
    self.ellipseProgressView = [[[FWTEllipseProgressView alloc] initWithFrame:frame] autorelease];
    self.ellipseProgressView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
    self.ellipseProgressView.center = self.view.center;
    [self.view addSubview:self.ellipseProgressView];
    
    CGRect sliderFrame = CGRectMake(.0f, 10.0f, 320.0f, 30.0f);
    self.sliderA = [[[UISlider alloc] initWithFrame:sliderFrame] autorelease];
    self.sliderA.continuous = NO;
    [self.sliderA addTarget:self action:@selector(_sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.sliderA];
    
    sliderFrame = CGRectMake(.0f, 40.0f, 320.0f, 30.0f);
    self.sliderB = [[[UISlider alloc] initWithFrame:sliderFrame] autorelease];
    self.sliderB.continuous = NO;
    [self.sliderB addTarget:self action:@selector(_sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.sliderB];
    
    sliderFrame = CGRectMake(.0f, 70.0f, 320.0f, 30.0f);
    self.sliderC = [[[UISlider alloc] initWithFrame:sliderFrame] autorelease];
    self.sliderC.continuous = NO;
    [self.sliderC addTarget:self action:@selector(_sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.sliderC];
}

#pragma mark - Action
- (void)_sliderValueChanged:(UISlider *)slider
{
    if (slider == self.sliderA)
    {
        self.ellipseProgressView.ellipseProgressLayer.startAngle = 2*M_PI*slider.value + 3*M_PI_2;
    }
    else if (slider == self.sliderB)
    {
        self.ellipseProgressView.ellipseProgressLayer.endAngle = 2*M_PI*(1-slider.value) + self.ellipseProgressView.ellipseProgressLayer.startAngle;
    }
    else
    {
        [self.ellipseProgressView setProgress:slider.value animated:YES];
    }
}

@end
