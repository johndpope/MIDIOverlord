//
//  gmSlider.h
//  GeckoMIDI
//
//  Created by Pablo Revuelta on 2/12/13.
//  Copyright (c) 2013 Midnight City. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface gmSlider : NSView

@property NSSlider *slider;
//@property int height;
//@property int width;

- (id)initWithFrame:(NSRect)frame;
- (void)drawRect:(NSRect)frame;

@end;