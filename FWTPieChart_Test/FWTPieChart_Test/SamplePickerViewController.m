//
//  SamplePickerViewController.m
//  FWTGridTableViewController_Test
//
//  Created by Marco Meschini on 7/17/12.
//  Copyright (c) 2012 Futureworkshops. All rights reserved.
//

#import "SamplePickerViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface Label : UILabel
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;
@property (nonatomic) CGGradientRef gradientRef;
@end

@implementation Label

- (void)dealloc
{
    CGGradientRelease(self.gradientRef);
    self.gradientRef = NULL;
    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef alphaMask = CGBitmapContextCreateImage(context);
    CGContextClearRect(context, rect); //
    
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (self.highlighted)
    {
        [[[UIColor redColor] colorWithAlphaComponent:.6f] setFill];
        CGContextFillRect(context, rect);
    }
    else
    {
        [[[UIColor whiteColor] colorWithAlphaComponent:.5f] setFill];
        CGContextFillRect(context, rect);
        CGContextDrawLinearGradient(context, self.gradientRef, CGPointZero, CGPointMake(.0f, rect.size.height), kCGGradientDrawsAfterEndLocation);
    }
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, rect, alphaMask);
    [[UIColor clearColor] setFill];
    UIRectFill(rect);
    CGContextRestoreGState(context);
    CGImageRelease(alphaMask);
}

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.contentEdgeInsets)];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
	return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.contentEdgeInsets) limitedToNumberOfLines:numberOfLines];
}

#pragma mark - Accessors
- (CGGradientRef)gradientRef
{
    if (!self->_gradientRef)
    {
        size_t locationsCount = 2;
        CGFloat locations[]   = { .0f, 1.0f };
        CGFloat components[]  = {
            1.0f, 1.0f, 1.0f, .3f,
            1.0f, 1.0f, 1.0f, .0f,
        };
        
        CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
        self->_gradientRef = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, locationsCount);
        CGColorSpaceRelease(rgbColorspace);
    }
    
    return self->_gradientRef;
}

@end


@interface SamplePickerTableViewCell : UITableViewCell
@property (nonatomic, retain) Label *label;
@end

@implementation SamplePickerTableViewCell

- (void)dealloc
{
    self.label = nil;
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.label.superview) [self.contentView addSubview:self.label];
    self.label.frame = self.contentView.bounds;
}

#pragma mark - Accessors
- (Label *)label
{
    if (!self->_label)
    {
        self->_label = [[Label alloc] init];
        self->_label.contentEdgeInsets = UIEdgeInsetsMake(.0f, 10.0f, .0f, 10.0f);
        self->_label.backgroundColor = [UIColor clearColor];
        self->_label.font = [UIFont boldSystemFontOfSize:20];
    }
    
    return self->_label;
}

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
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithWhite:.5f alpha:1.0f];
    self.tableView.tableFooterView = [[[UIView alloc] init] autorelease];
}

#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.samples.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SamplePickerTableViewCell *cell = (SamplePickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[[SamplePickerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectedBackgroundView = [[[UIView alloc] init] autorelease];
    }
    
    cell.label.text = [self.samples objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = [self.samples objectAtIndex:indexPath.row];
    UIViewController *vc = [[[NSClassFromString(className) alloc] init] autorelease];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
