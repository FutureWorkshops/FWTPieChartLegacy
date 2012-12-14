//
//  PieChartViewController.m
//  FWTEllipseProgressView_Test
//
//  Created by Marco Meschini on 07/12/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "PieChartViewController.h"
//#import "FWTPieChartView.h"
#import "CustomPieChartView.h"

@interface PieChartViewController ()
@property (nonatomic, retain) FWTPieChartView *pieChart;
@end

@implementation PieChartViewController

- (void)dealloc
{
    self.pieChart = nil;
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"Pie Chart";
    
    //
    CGRect frame = CGRectMake(0, 0, 300, 300);
    self.pieChart = [[[CustomPieChartView alloc] initWithFrame:frame] autorelease]; // 
    self.pieChart.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
    self.pieChart.center = self.view.center;
    [self.view addSubview:self.pieChart];
    
    
    UISegmentedControl *sc = [[[UISegmentedControl alloc] initWithItems:@[@"D", @"C"]] autorelease];
    sc.momentary = YES;
    sc.segmentedControlStyle = UISegmentedControlStyleBar;
    sc.frame = CGRectMake(.0f, .0f, 90.0f, 32.0f);
    [sc addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:sc] autorelease];
}

- (void)doAction:(UISegmentedControl *)segmentedControl
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
