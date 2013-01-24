//
//  PieChartViewController.m
//  FWTEllipseProgressView_Test
//
//  Created by Marco Meschini on 07/12/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "PieChartViewController.h"
#import "FWTPieChartView.h"
#import "CustomPieChartView.h"

@interface PieChartViewController ()
@property (nonatomic, retain) FWTPieChartView *pieChart;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@end

@implementation PieChartViewController

- (void)dealloc
{
    self.segmentedControl = nil;
    self.pieChart = nil;
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"Pie Chart";
    
    //
    CGFloat min = sideWidthBlock(self.view.frame, 20.0f);
    self.pieChart = [[[FWTPieChartView alloc] init] autorelease]; // 
    self.pieChart.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
    self.pieChart.bounds = CGRectMake(0, 0, min, min);
    self.pieChart.center = self.view.center;
    [self.view addSubview:self.pieChart];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.segmentedControl)
    {
        CGRect sliderFrame = CGRectInset(self.navigationController.toolbar.bounds, 5.0f, 5.0f);
        self.segmentedControl = [[[UISegmentedControl alloc] initWithItems:@[@"generate", @"clear"]] autorelease];
        self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.segmentedControl.momentary = YES;
        self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        self.segmentedControl.frame = sliderFrame;
        [self.segmentedControl addTarget:self action:@selector(_doAction:) forControlEvents:UIControlEventValueChanged];
        [self.navigationController.toolbar addSubview:self.segmentedControl];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.segmentedControl removeFromSuperview];
}

#pragma mark - Private
- (void)_doAction:(UISegmentedControl *)segmentedControl
{
    if (segmentedControl.selectedSegmentIndex == 0)
    {
        NSLog(@"*******");
        int count = 2 + rand() % 5;
        int total = 0;
        NSInteger tmp[count];
        for (int i = 0; i < count; i++) {
            NSInteger random = arc4random()%100 + 1;
            tmp[i] = random;
            total += random;
        }
        
        NSMutableArray *randomNumbers = [NSMutableArray array];
        for (int i = 0; i < count; i++) {
            CGFloat value = (CGFloat)tmp[i]/(CGFloat)total;
            NSLog(@"total:%i, tmp[%i]:%i, value:%f", total, i, tmp[i], value);
            [randomNumbers addObject:[NSNumber numberWithFloat:value]];
        }
        
        [self.pieChart setValues:[NSArray arrayWithArray:randomNumbers] animated:YES];
        NSLog(@"*******");
    }
    else
    {
        [self.pieChart restoreAnimated:YES];
    }
}


@end
