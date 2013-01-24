//
//  AppDelegate.m
//  FWTPieChart_Test
//
//  Created by Marco Meschini on 13/12/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "AppDelegate.h"
#import "SamplePickerViewController.h"
#import "TableViewController.h"
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
    
    SamplePickerViewController *vc = [[[SamplePickerViewController alloc] init] autorelease];
    vc.samples = @[@"SingleViewController", @"TableViewController", @"PieChartViewController"];
    
    UINavigationController *nc = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    nc.toolbarHidden = NO;
    self.window.rootViewController = nc;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
