//
//  controlClass.h
//  GeckoMIDI
//
//  Created by Pablo Revuelta on 20/12/13.
//  Copyright (c) 2013 Midnight City. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface controlClass : NSView

@property NSDictionary* elData;
// Canvas properties

@property int padding;
@property int cWidth;
@property NSPointArray pointArray;

- (id)initWithFrame:(NSRect)frame;
- (void)drawRect:(NSRect)frame;

@end