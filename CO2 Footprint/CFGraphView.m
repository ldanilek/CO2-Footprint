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

- (CGPoint)pointAtX:(double)x y:(double)y {
    
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
    Function mapX = linearMap(self.origin.x, 0, self.origin.x+1, self.scale);
    double minX = mapX(0);
    double maxX = mapX(self.bounds.size.width);
    Function mapY = linearMap(self.origin.y, 0, self.origin.y-1, self.aspectRatio * self.scale);
    double minY = mapY(self.bounds.size.height);
    double maxY = mapY(0);
    
    UIBezierPath *grid = [UIBezierPath bezierPath];
    double xIncrements = pow(2, floor(log2(maxX-minX)))/5;
    double startX = floor((minX-1)/xIncrements)*xIncrements;
    [[UIColor blackColor] setStroke];
    for (double x=startX; x<maxX+1; x+=xIncrements) {
        if (ABS(x)>xIncrements/10) {
            [grid moveToPoint:[self pointAtX:x y:minY]];
            [grid addLineToPoint:[self pointAtX:x y:maxY]];
            
            UIFont *font = [UIFont systemFontOfSize:10];
            NSDictionary *attribs = @{NSFontAttributeName: font};
            NSString *scale = [NSString stringWithFormat:@"%gyrs", x];
            CGSize size;
            if ([scale respondsToSelector:@selector(sizeWithAttributes:)]) size = [scale sizeWithAttributes:attribs];
            else size = [scale sizeWithFont:font];
            CGPoint atX = [self pointAtX:x y:0];
            atX.x-=size.width/2;
            atX.y-=size.height;
            atX.y = MAX(MIN(self.bounds.size.height-size.height, atX.y), 0);
            if ([scale respondsToSelector:@selector(drawAtPoint:withAttributes:)]) [scale drawAtPoint:atX withAttributes:attribs];
            else [scale drawAtPoint:atX withFont:font];
        }
    }
    double yIncrements = pow(2, floor(log2(maxY-minY)))/5;
    double startY = floor((minY-1)/yIncrements)*yIncrements;
    for (double y=startY; y<maxY+1; y+=yIncrements) {
        if (ABS(y)>yIncrements/10) {
            [grid moveToPoint:[self pointAtX:minX y:y]];
            [grid addLineToPoint:[self pointAtX:maxX y:y]];
            
            UIFont *font = [UIFont systemFontOfSize:10];
            NSDictionary *attribs = @{NSFontAttributeName: font};
            NSString *scale = [NSString stringWithFormat:@"%gppm", y];
            CGSize size;
            if ([scale respondsToSelector:@selector(sizeWithAttributes:)]) size = [scale sizeWithAttributes:attribs];
            else size = [scale sizeWithFont:font];
            CGPoint atY = [self pointAtX:0 y:y];
            atY.x+=5;//move over a bit so it looks good
            atY.y-=size.height/2;
            atY.x = MAX(MIN(atY.x, self.bounds.size.width-size.width), 5);
            if ([scale respondsToSelector:@selector(drawAtPoint:withAttributes:)]) [scale drawAtPoint:atY withAttributes:attribs];
            else [scale drawAtPoint:atY withFont:font];
        }
    }
    [[UIColor lightGrayColor] setStroke];
    [grid stroke];
    
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
    
    UIBezierPath *axes = [UIBezierPath bezierPath];
    [axes moveToPoint:CGPointMake(self.origin.x, 0)];
    [axes addLineToPoint:CGPointMake(self.origin.x, self.bounds.size.height)];
    [axes moveToPoint:CGPointMake(0, self.origin.y)];
    [axes addLineToPoint:CGPointMake(self.bounds.size.height, self.origin.y)];
    [[UIColor blackColor] setStroke];
    axes.lineWidth=2;
    [axes stroke];
}

@end
