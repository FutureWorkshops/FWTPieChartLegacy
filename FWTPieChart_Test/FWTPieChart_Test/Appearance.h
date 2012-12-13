//
//  Factory.h
//  TestPieChart
//
//  Created by Marco Meschini on 22/10/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWTEllipseLayer.h"

@interface Appearance : NSObject

//  STC
+ (FWTEllipseLayerDrawPathBlock)StyleSTCDashboardDrawPathBlock;
+ (FWTEllipseLayerDrawBackgroundBlock)StyleSTCDashboardBackgroundBlock;

//  The Open
+ (FWTEllipseLayerDrawPathBlock)StyleTheOpenDrawPathBlock;
+ (FWTEllipseLayerDrawBackgroundBlock)StyleTheOpenBackgroundBlock;

//  From ten to two
+ (FWTEllipseLayerDrawPathBlock)StyleFromTenToTwoDrawPathBlock;

@end
