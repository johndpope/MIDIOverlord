//
//  controlClass.m
//  GeckoMIDI
//
//  Created by Pablo Revuelta on 20/12/13.
//  Copyright (c) 2013 Midnight City. All rights reserved.
//

#import "controlClass.h"

@implementation controlClass

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // setup the initial properties of the

    }
    return self;
}

- (void)drawRect:(NSRect)frame {
    
    NSBezierPath* path = [NSBezierPath new];
    [path setLineWidth: 0.5];
    
    int count = (sizeof _pointArray);// count];
    
    NSLog(@"Rendering %i", count);
    NSPoint test1 = {0, 0};
    NSPoint test = {50, 50};
    [path moveToPoint:test1];
    [path lineToPoint:test];
//    [path appendBezierPathWithPoints:_pointArray count:count];
    
    [path closePath];

    [[NSColor blackColor] set];
    
    [path stroke];
}

@end
