//
//  CFGraphView.m
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/30/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import "CFGraphView.h"

typedef double(^Function)(double);

static Function linearMap(double x0, double y0, double x1, double y1) {
    double m=(y1-y0)/(x1-x0);
    return ^(double x) {return m*(x-x0)+y0;};
}

@implementation CFGraphView

- (void)pan:(UIPanGestureRecognizer *)pan {
    self.origin=CGPointMake(self.origin.x+[pan translationInView:self].x, self.origin.y+[pan translationInView:self].y);
    [pan setTranslation:CGPointZero inView:self];
    [self setNeedsDisplay];
}

- (void)zoomAroundPoint:(CGPoint)point scale:(double)scale {
    double xDiff = self.origin.x-point.x;
    double yDiff = self.origin.y-point.y;
    xDiff*=scale;
    yDiff*=scale;
    self.origin = CGPointMake(point.x+xDiff, point.y+yDiff);
    self.scale/=scale;
}

- (void)zoom:(UIPinchGestureRecognizer *)pinch {
    CGPoint location = [pinch locationInView:self];
    double scale = [pinch scale];
    [self zoomAroundPoint:location scale:scale];
    pinch.scale=1;
    [self setNeedsDisplay];
}

- (void)setupGestures {
    UIPanGestureRecognizer *scroll = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:scroll];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoom:)];
    [self addGestureRecognizer:pinch];
}

- (CGPoint)pointAtX:(double)x y:(double)y {
    Function toGraphicsX = linearMap(0, self.origin.x, -self.scale*self.origin.x, 0);
    Function toGraphicsY = linearMap(0, self.origin.y, self.scale*self.aspectRatio*self.origin.y, 0);
    return CGPointMake(toGraphicsX(x), toGraphicsY(y));
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //min x
    //map x: origin.x->0; 0->-scale*origin.x
    Function mapX = linearMap(self.origin.x, 0, 0, -self.scale*self.origin.x);
    double minX = mapX(0);
    double maxX = mapX(self.bounds.size.width);
    Function mapY = linearMap(self.origin.y, 0, 0, self.scale*self.aspectRatio*self.origin.y);
    double minY = mapY(self.bounds.size.height);
    double maxY = mapY(0);
    UIBezierPath *graph = [UIBezierPath bezierPath];
    BOOL started = NO;
    
    for (double indep=minX; indep<maxX; indep+=self.scale) {
        double y = [self.delegate valueForIndependent:indep];
        if (!isnan(y)) {
            if (started) {
                [graph addLineToPoint:[self pointAtX:indep y:y]];
            } else {
                [graph moveToPoint:[self pointAtX:indep y:y]];
                started=YES;
            }
        }
    }
    [[UIColor redColor] setStroke];
    [graph stroke];
    
    UIBezierPath *graph2 = [UIBezierPath bezierPath];
    BOOL started2 = NO;
    
    for (double indep=minX; indep<maxX; indep+=self.scale) {
        double y = [self.delegate secondValueForIndependent:indep];
        if (!isnan(y)) {
            if (started2) {
                [graph2 addLineToPoint:[self pointAtX:indep y:y]];
            } else {
                [graph2 moveToPoint:[self pointAtX:indep y:y]];
                started2=YES;
            }
        }
    }
    [[UIColor blueColor] setStroke];
    [graph2 stroke];
    
    UIBezierPath *grid = [UIBezierPath bezierPath];
    for (int x=minX-1; x<maxX+1; x++) {
        [grid moveToPoint:[self pointAtX:x y:minY]];
        [grid addLineToPoint:[self pointAtX:x y:maxY]];
    }
    for (int y=minY-1; y<maxY+1; y++) {
        [grid moveToPoint:[self pointAtX:minX y:y]];
        [grid addLineToPoint:[self pointAtX:maxX y:y]];
    }
    [[UIColor lightGrayColor] setStroke];
    [grid stroke];
    
    UIBezierPath *axes = [UIBezierPath bezierPath];
    [axes moveToPoint:CGPointMake(self.origin.x, 0)];
    [axes addLineToPoint:CGPointMake(self.origin.x, self.bounds.size.height)];
    [axes moveToPoint:CGPointMake(0, self.origin.y)];
    [axes addLineToPoint:CGPointMake(self.bounds.size.height, self.origin.y)];
    [[UIColor blackColor] setStroke];
    [axes stroke];
}

@end
