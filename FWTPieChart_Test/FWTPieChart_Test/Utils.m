//
//  Utils.m
//  FWTPieChart_Test
//
//  Created by Marco Meschini on 24/01/2013.
//  Copyright (c) 2013 Marco Meschini. All rights reserved.
//

#import "Utils.h"

CGFloat (^sideWidthBlock)(CGRect, CGFloat) = ^(CGRect frame, CGFloat inset){
    return MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) - inset;
};


#pragma mark -
@interface UIViewController (Orientation)
@end

@implementation UIViewController (Orientation)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
