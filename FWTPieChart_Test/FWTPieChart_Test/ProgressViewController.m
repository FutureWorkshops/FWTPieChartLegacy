//
//  ViewController.m
//  FWTEllipseProgressView_Test
//
//  Created by Marco Meschini on 22/10/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "ProgressViewController.h"
#import "FWTEllipseProgressView.h"

#import "Appearance.h"
#import <objc/runtime.h>

static char progressViewKey;

#pragma mark - Cell
@interface TableViewCell : UITableViewCell
@property (nonatomic, retain) FWTEllipseProgressView *progressView;
@end

@implementation TableViewCell

- (void)dealloc
{
    self.progressView = nil;
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.progressView.superview)
        [self.contentView addSubview:self.progressView];
    
    CGFloat vInset = 5.0f;
    CGFloat hInset = 10.0f;
    CGFloat maxHeight = CGRectGetHeight(self.bounds)-vInset*2;
    CGRect theFrame = CGRectMake(hInset, vInset, maxHeight, maxHeight);
    self.progressView.frame = theFrame;
    
    theFrame = self.textLabel.frame;
    theFrame.origin.x += CGRectGetMaxX(self.progressView.frame);
    self.textLabel.frame = theFrame;
}

@end

#pragma mark - ViewController
@interface ProgressViewController ()
@property (nonatomic, assign) BOOL invertedModeEnabled;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) UISlider *slider;

@end

@implementation ProgressViewController

- (void)dealloc
{
    self.slider = nil;
    self.items = nil;
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    self.invertedModeEnabled = NO;
    
    self.title = @"Sample";
    
    self.tableView.rowHeight = 100.0f;
    self.tableView.backgroundColor = [UIColor colorWithWhite:.9f alpha:1.0f];
    self.tableView.separatorColor = [UIColor blackColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.slider)
    {
        CGRect sliderFrame = CGRectInset(self.navigationController.toolbar.bounds, 5.0f, .0f);
        self.slider = [[[UISlider alloc] initWithFrame:sliderFrame] autorelease];
        self.slider.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        //    slider.continuous = NO;
        [self.slider addTarget:self action:@selector(_sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.navigationController.toolbar addSubview:self.slider];
    }
    
    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.slider removeFromSuperview];
    
    self.navigationController.toolbarHidden = YES;
}

#pragma mark - Action
- (void)_sliderValueChanged:(UISlider *)slider
{
    CGFloat value = self.invertedModeEnabled ? 1-slider.value : slider.value;
    
    for (TableViewCell *cell in self.tableView.visibleCells)
    {
        if ([cell.progressView respondsToSelector:@selector(setProgress:animated:)])
            [cell.progressView setProgress:value animated:YES];
    }
}

#pragma mark - Getters
- (NSArray *)items
{
    if (!self->_items)
    {
        //  default
        FWTEllipseProgressView *base = [[[FWTEllipseProgressView alloc] init] autorelease];
        base.ellipseProgressLayer.startAngle = 3*M_PI_2 + 5.235987755983f;
        base.ellipseProgressLayer.endAngle = base.ellipseProgressLayer.startAngle;
        objc_setAssociatedObject(base, &progressViewKey, @"default - s: 5.23r", OBJC_ASSOCIATION_RETAIN);
        
        //  STC
        FWTEllipseProgressView *stc = [[[FWTEllipseProgressView alloc] init] autorelease];
        stc.backgroundColor = [UIColor clearColor];
        stc.ellipseProgressLayer.drawPathBlock = [Appearance StyleSTCDashboardDrawPathBlock];
        stc.ellipseProgressLayer.drawBackgroundBlock = [Appearance StyleSTCDashboardBackgroundBlock];
        objc_setAssociatedObject(stc, &progressViewKey, @"stc", OBJC_ASSOCIATION_RETAIN);
        
        //  The Open
        FWTEllipseProgressView *theOpen = [[[FWTEllipseProgressView alloc] init] autorelease];
        theOpen.backgroundColor = [UIColor clearColor];
        theOpen.ellipseProgressLayer.fillColor = [UIColor whiteColor];
        theOpen.ellipseProgressLayer.drawPathBlock = [Appearance StyleTheOpenDrawPathBlock];
        theOpen.ellipseProgressLayer.drawBackgroundBlock = [Appearance StyleTheOpenBackgroundBlock];
        objc_setAssociatedObject(theOpen, &progressViewKey, @"the open", OBJC_ASSOCIATION_RETAIN);
        
        //  from ten to two
        FWTEllipseProgressView *fromTenToTwo = [[[FWTEllipseProgressView alloc] init] autorelease];
        fromTenToTwo.backgroundColor = [UIColor clearColor];
        fromTenToTwo.ellipseProgressLayer.startAngle = 3*M_PI_2 + 5.235987755983f;
        fromTenToTwo.ellipseProgressLayer.endAngle = base.ellipseProgressLayer.startAngle;
        fromTenToTwo.ellipseProgressLayer.arcLength = 2*M_PI/3;
        fromTenToTwo.ellipseProgressLayer.drawPathBlock = [Appearance StyleFromTenToTwoDrawPathBlock];
        objc_setAssociatedObject(fromTenToTwo, &progressViewKey, @"custom - s:5.23r (1/3)", OBJC_ASSOCIATION_RETAIN);
        
        self->_items = [@[base, stc, theOpen, fromTenToTwo] retain];
    }
    
    return self->_items;
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
    FWTEllipseProgressView *progressView = [self.items objectAtIndex:indexPath.row];
    cell.progressView = progressView;
    cell.textLabel.text = objc_getAssociatedObject(progressView, &progressViewKey);
    
    return cell;
}

@end
