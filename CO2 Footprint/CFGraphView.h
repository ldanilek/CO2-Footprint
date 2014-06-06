//
//  CFGraphView.h
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/30/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef double(^Function)(double);

static Function linearMap(double x0, double y0, double x1, double y1) {
    double m=(y1-y0)/(x1-x0);
    return ^(double x) {return m*(x-x0)+y0;};
}

@protocol CFGraphDelegate <NSObject>

- (double)valueForIndependent:(double)x;

@end

@interface CFGraphView : UIView

//initial values to set
@property (weak) id <CFGraphDelegate> delegate;

//constants
@property double aspectRatio;//x scale * aspectRatio = y scale
//@property double aspectRatio2;//for other graph

@property CGPoint origin;
//@property CGFloat origin2;
@property double scale;//x Scale in units per pixel

- (void)setupGestures;

@end
