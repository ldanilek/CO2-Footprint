//
//  CFGraphView.h
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/30/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CFGraphDelegate <NSObject>

- (double)valueForIndependent:(double)x;
- (double)secondValueForIndependent:(double)x;//for temp and CO2 separate

@end

@interface CFGraphView : UIView

//initial values to set
@property (weak) id <CFGraphDelegate> delegate;

@property double aspectRatio;//x scale * aspectRatio = y scale

@property CGPoint origin;
@property double scale;//x Scale in units per pixel

- (void)setupGestures;

@end
