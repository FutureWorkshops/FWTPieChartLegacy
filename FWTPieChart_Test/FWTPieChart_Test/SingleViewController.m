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
@property (nonatomic, retain) UISlider *slider;
@end

@implementation SingleViewController

- (void)dealloc
{
    self.slider = nil;
    self.ellipseProgressView = nil;
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"Progress View";
    
    //
    CGFloat min = sideWidthBlock(self.view.frame, 20.0f);
    self.ellipseProgressView = [[[FWTEllipseProgressView alloc] init] autorelease];
    self.ellipseProgressView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
    self.ellipseProgressView.bounds = CGRectMake(0, 0, min, min);
    self.ellipseProgressView.center = self.view.center;
    [self.view addSubview:self.ellipseProgressView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGFloat min = sideWidthBlock(self.view.frame, 20.0f);
    if (min != CGRectGetWidth(self.ellipseProgressView.frame))
        self.ellipseProgressView.bounds = CGRectMake(0, 0, min, min);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.slider)
    {
        CGRect sliderFrame = CGRectInset(self.navigationController.toolbar.bounds, 5.0f, .0f);
        self.slider = [[[UISlider alloc] initWithFrame:sliderFrame] autorelease];
        self.slider.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.slider addTarget:self action:@selector(_sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.navigationController.toolbar addSubview:self.slider];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.slider removeFromSuperview];
}

#pragma mark - Action
- (void)_sliderValueChanged:(UISlider *)slider
{
    [self.ellipseProgressView setProgress:slider.value animated:NO];
}

@end
