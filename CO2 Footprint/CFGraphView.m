//
//  CFGraphView.m
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/30/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import "CFGraphView.h"

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

- (CGPoint)pointAtX:(double)x y:(double)y second:(BOOL)second {
    
    CGFloat gX;
    CGFloat gY;
    if (x==0) {
        gX=self.origin.x;
    } else {
        Function toGraphicsX = linearMap(0, self.origin.x, -self.scale*self.origin.x, 0);
        gX=toGraphicsX(x);
    }
    if (y==0) {
        gY=self.origin.y;
    } else {
        Function toGraphicsY = linearMap(0, self.origin.y, self.scale*self.aspectRatio*self.origin.y, 0);
        gY=toGraphicsY(y);
    }
    return CGPointMake(gX, gY);
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
    
    UIBezierPath *grid = [UIBezierPath bezierPath];
    double xIncrements = pow(2, floor(log2(maxX-minX)))/5;
    int startX = floor((minX-1)/xIncrements)*xIncrements;
    for (double x=startX; x<maxX+1; x+=xIncrements) {
        [grid moveToPoint:[self pointAtX:x y:minY second:NO]];
        [grid addLineToPoint:[self pointAtX:x y:maxY second:NO]];
    }
    double yIncrements = pow(2, floor(log2(maxY-minY)))/5;
    int startY = floor((minY-1)/yIncrements)*yIncrements;
    for (double y=startY; y<maxY+1; y+=yIncrements) {
        [grid moveToPoint:[self pointAtX:minX y:y second:NO]];
        [grid addLineToPoint:[self pointAtX:maxX y:y second:NO]];
    }
    [[UIColor lightGrayColor] setStroke];
    [grid stroke];
    
    UIBezierPath *graph = [UIBezierPath bezierPath];
    BOOL started = NO;
    for (double indep=minX; indep<maxX; indep+=self.scale) {
        double y = [self.delegate valueForIndependent:indep];
        if (!isnan(y)) {
            if (started) {
                [graph addLineToPoint:[self pointAtX:indep y:y second:NO]];
            } else {
                [graph moveToPoint:[self pointAtX:indep y:y second:NO]];
                started=YES;
            }
        }
    }
    [[UIColor redColor] setStroke];
    [graph stroke];
    /*
    UIBezierPath *graph2 = [UIBezierPath bezierPath];
    BOOL started2 = NO;
    
    for (double indep=minX; indep<maxX; indep+=self.scale) {
        double y = [self.delegate secondValueForIndependent:indep];
        if (!isnan(y)) {
            if (started2) {
                [graph2 addLineToPoint:[self pointAtX:indep y:y second:YES]];
            } else {
                [graph2 moveToPoint:[self pointAtX:indep y:y second:YES]];
                started2=YES;
            }
        }
    }
    [[UIColor blueColor] setStroke];
    [graph2 stroke];
    */
    UIBezierPath *axes = [UIBezierPath bezierPath];
    [axes moveToPoint:CGPointMake(self.origin.x, 0)];
    [axes addLineToPoint:CGPointMake(self.origin.x, self.bounds.size.height)];
    //[axes moveToPoint:CGPointMake(0, self.origin2)];
    //[axes addLineToPoint:CGPointMake(self.bounds.size.height, self.origin2)];
    [axes moveToPoint:CGPointMake(0, self.origin.y)];
    [axes addLineToPoint:CGPointMake(self.bounds.size.height, self.origin.y)];
    [[UIColor blackColor] setStroke];
    [axes stroke];
}

@end
