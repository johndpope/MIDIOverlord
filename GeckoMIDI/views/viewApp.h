//
//  grid.h
//  GeckoMIDI
//
//  Created by Pablo Revuelta on 26/11/13.
//  Copyright (c) 2013 Midnight City. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface viewApp : NSView

@property int cols;
@property int rows;

@property int colWidth;
@property int rowHeight;
@property int uiWidth;
@property int uiHeight;

- (id)initWithFrame:(NSRect)frame;
- (NSPoint)getSize;
- (void)drawRect:(NSRect)frame;
- (void)drawGrid;
- (void)drawControls:(NSMutableDictionary*)controlData;

@end