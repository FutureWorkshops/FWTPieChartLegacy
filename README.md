#FWTPieChart

![FWTPieChart screenshot](http://grab.by/igoS)

FWTPieChart is a small set of classes that shows how to create circular progress view and pie charts. The core is the FWTEllipseLayer, a custom CALayer subclass that adds a couple of custom animatable properties and exposes few blocks as extension points.

##Requirements
* XCode 4.4.1 or higher
* iOS 5.0

##Features
FWTEllipseLayer is a CALayer subclass with two custom animatable properties: *startAngle* and *endAngle*. FWTEllipseLayer relies on CoreAnimation default behaviour, it subclasses the *needsDisplayForKey* method, marks itself as dirty every time one of the two properties is changed and lets CoreAnimation do the magic (tweening) for us.
FWTEllipseLayer exposes very few other properties to make easy and quick to be customized.
The idea behind is that the *fillColor* is the only one shape style customizable property. If you need a deeper customization you should use instead the *drawPathBlock*. 
FWTEllipseLayer optimizes the background drawing routine by using a cached CGLayer.
See below for further details.
       
This project is not yet ARC-ready.

##How to use it: configure

####FWTEllipseProgressView
FWTEllipseProgressView depict the progress of a task on a circular shape. It has a *progress* property and, as with almost every UIKit object, you can set the progress and optionally animate the change. The backing layer of this view is an FWTEllipseLayer instance.

* **progress** the current progress shown by the receiver
* **ellipseProgressLayer** return the FWTEllipseLayer backing layer instance
* **setProgress:animated:** adjusts the current progress shown by the receiver, optionally animating the change

####FWTPieChartView
FWTPieChartView is a circular chart view divided into sectors, the arc length of each sector is proportional to the quantity it represents. It has a *values* array property and, as with FWTEllipseProgressView, you can set the values and optionally animate the change. FWTPieChartView creates an FWTEllipseLayer for each value of the array. FWTPieChartView adjusts the animation duration for each slide considering the quantity it represents inside the whole shape.

* **values** array containing normalized NSNumbers
* **containerLayer** contains all FWTEllipseLayer instances
* **colorForSliceBlock** the block to execute to get the color for the specified slice
* **minimumAnimationDuration** the minimum value of the animation
* **maximumAnimationDuration** the maximum value of the animation 
* **setValues:animated:** set the values, optionally animating the change
* **restore** reset each slice to have no arc length
* **restoreAnimated:** reset each slide to have no arc length, optionally animating

##For your interest
say about FWTEllipseLayer

##Demo
The sample project shows how to use the FWTEllipseProgressView, FWTPieChartView and how to customize the path/background drawing block.

``` objective-c

	// progress
    FWTEllipseProgressView *epv = [[[FWTEllipseProgressView alloc] initWithFrame:frame] autorelease];
    [self.view addSubview:epv];
    
    …
    [epv setProgress:aValue animated:YES];
	
	…
	…
	
	// pie chart
	FWTPieChartView *pcv = [[[FWTPieChartView alloc] initWithFrame:frame] autorelease];
	[self.view addSubview:pcv];
	
	…
	NSArray *values = @[@.14, @.26, @.2, @.15, @.25];
	[pcv setValues:values animated:YES];	
````

##Licensing
Apache License Version 2.0

##Credits
[Saudi Telecom](http://www.stc.com.sa) Mobile Apps team, who enabled and collaborated with us to extract source code from My STC App for this library

##Support, bugs and feature requests
If you want to submit a feature request, please do so via the issue tracker on github.
If you want to submit a bug report, please also do so via the issue tracker, including a diagnosis of the problem and a suggested fix (in code).
