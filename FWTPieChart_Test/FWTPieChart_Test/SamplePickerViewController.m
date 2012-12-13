//
//  SamplePickerViewController.m
//  FWTGridTableViewController_Test
//
//  Created by Marco Meschini on 7/17/12.
//  Copyright (c) 2012 Futureworkshops. All rights reserved.
//

#import "SamplePickerViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SamplePickerViewController ()

@end

@implementation SamplePickerViewController

- (void)dealloc
{
    self.samples = nil;
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"Pick a sample";
    self.tableView.backgroundColor = [UIColor colorWithWhite:.91f alpha:.25f];
    self.tableView.separatorColor = [UIColor colorWithWhite:.7f alpha:1.0f];
    self.tableView.tableFooterView = [[[UIView alloc] init] autorelease];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.samples.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
    cell.textLabel.text = [self.samples objectAtIndex:indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = [self.samples objectAtIndex:indexPath.row];
    UIViewController *vc = [[[NSClassFromString(className) alloc] init] autorelease];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
