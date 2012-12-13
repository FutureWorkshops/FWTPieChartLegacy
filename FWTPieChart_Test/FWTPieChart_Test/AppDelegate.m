//
//  AppDelegate.m
//  FWTPieChart_Test
//
//  Created by Marco Meschini on 13/12/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "AppDelegate.h"
#import "SamplePickerViewController.h"
#import "ProgressViewController.h"
#import "PieChartViewController.h"
#import "SingleViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    //    ViewController *vc = [[[ViewController alloc] init] autorelease];
    //    PieChartViewController *vc = [[[PieChartViewController alloc] init] autorelease];
    //    SingleViewController *vc = [[[SingleViewController alloc] init] autorelease];
    
    SamplePickerViewController *vc = [[[SamplePickerViewController alloc] init] autorelease];
    vc.samples = @[@"SingleViewController", @"ProgressViewController", @"PieChartViewController"];
    
    UINavigationController *nc = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    self.window.rootViewController = nc;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
