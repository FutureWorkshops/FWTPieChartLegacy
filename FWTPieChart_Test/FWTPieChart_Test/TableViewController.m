//
//  ViewController.m
//  FWTEllipseProgressView_Test
//
//  Created by Marco Meschini on 22/10/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "TableViewController.h"
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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        self.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        self.textLabel.numberOfLines = 0;
    }
    return self;
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
@interface TableViewController ()
@property (nonatomic, assign) BOOL invertedModeEnabled;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) UISlider *slider;

@end

@implementation TableViewController

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
    
    self.title = @"Table";
    
    self.items = [[self class] sampleItems];
//    self.tableView.backgroundColor = [UIColor colorWithWhite:.9f alpha:1.0f];
//    self.tableView.separatorColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView.rowHeight = ((NSInteger)CGRectGetHeight(self.tableView.frame)/self.items.count);
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
    CGFloat value = self.invertedModeEnabled ? 1-slider.value : slider.value;
    
    [self.tableView.visibleCells enumerateObjectsUsingBlock:^(TableViewCell *cell, NSUInteger idx, BOOL *stop) {
        [cell.progressView setProgress:value animated:YES];
    }];
}

#pragma mark - Getters
+ (NSArray *)sampleItems
{
//    if (!self->_items)
//    {
        //  default
        FWTEllipseProgressView *base = [[[FWTEllipseProgressView alloc] init] autorelease];
        base.ellipseProgressLayer.startAngle = 3*M_PI_2 + 5.235987755983f;
        base.ellipseProgressLayer.endAngle = base.ellipseProgressLayer.startAngle;
//        base.progress = self.invertedModeEnabled ? 1.0f : .0f;
        objc_setAssociatedObject(base, &progressViewKey, @"- default\n- startAngle: 5.23r", OBJC_ASSOCIATION_RETAIN);
        
        //  STC
        FWTEllipseProgressView *stc = [[[FWTEllipseProgressView alloc] init] autorelease];
        stc.backgroundColor = [UIColor clearColor];
        stc.ellipseProgressLayer.drawPathBlock = [Appearance StyleSTCDashboardDrawPathBlock];
        stc.ellipseProgressLayer.drawBackgroundBlock = [Appearance StyleSTCDashboardBackgroundBlock];
//        stc.progress = self.invertedModeEnabled ? 1.0f : .0f;
        objc_setAssociatedObject(stc, &progressViewKey, @"stc", OBJC_ASSOCIATION_RETAIN);
        
        //  The Open
        FWTEllipseProgressView *theOpen = [[[FWTEllipseProgressView alloc] init] autorelease];
        theOpen.backgroundColor = [UIColor clearColor];
        theOpen.ellipseProgressLayer.fillColor = [UIColor whiteColor].CGColor;
        theOpen.ellipseProgressLayer.drawPathBlock = [Appearance StyleTheOpenDrawPathBlock];
        theOpen.ellipseProgressLayer.drawBackgroundBlock = [Appearance StyleTheOpenBackgroundBlock];
//        theOpen.progress = self.invertedModeEnabled ? 1.0f : .0f;
        objc_setAssociatedObject(theOpen, &progressViewKey, @"the open", OBJC_ASSOCIATION_RETAIN);
        
        //  from ten to two
        FWTEllipseProgressView *fromTenToTwo = [[[FWTEllipseProgressView alloc] init] autorelease];
        fromTenToTwo.backgroundColor = [UIColor clearColor];
        fromTenToTwo.ellipseProgressLayer.startAngle = 3*M_PI_2 + 5.235987755983f;
        fromTenToTwo.ellipseProgressLayer.endAngle = base.ellipseProgressLayer.startAngle;
        fromTenToTwo.ellipseProgressLayer.arcLength = 2*M_PI/3;
        fromTenToTwo.ellipseProgressLayer.drawPathBlock = [Appearance StyleFromTenToTwoDrawPathBlock];
//        fromTenToTwo.progress = self.invertedModeEnabled ? 1.0f : .0f;
        objc_setAssociatedObject(fromTenToTwo, &progressViewKey, @"- custom\n- startAngle: 5.23r\n- lenght: 2π/3", OBJC_ASSOCIATION_RETAIN);

    return @[base, stc, theOpen, fromTenToTwo];
    
//        self->_items = [@[base, stc, theOpen, fromTenToTwo] retain];
//    }
//    
//    return self->_items;
}

#pragma mark - TableView
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.items.count;
//}

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
