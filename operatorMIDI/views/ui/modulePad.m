//
//  modulePad.m
//  operatorMIDI
//
//  Created by Pablo Revuelta on 20/12/13.
//  Copyright (c) 2013 Midnight City. All rights reserved.
//

#import "modulePad.h"

@implementation modulePad

- (id)initWithFrame{
    
    NSRect frame = NSMakeRect(0, 0, 80, RACK_HEIGHT );
    
    self = [super initWithFrame:frame];
    
    if(!self) return nil;
    
    self.gridX = 2;
    self.gridY = 1;
    
    self.width = 80;
    
    _midiNote = 122;
    
    // Add UI buttons
    float padRGBA[] = DARK_GREY;
    NSColor* padColor = [utilities getNSColorFromRGB:padRGBA];
    
    controlTrigger *pad = [[controlTrigger alloc] initWithFrame:NSMakePoint(self.width - 16, self.width - 16): NSMakePoint(8, 8): padColor ];
    
    pad.delegate = self;
    
    [self addSubview: pad];
    
    return self;
}

- (void)drawRect:(NSRect)rect {
    
    NSBezierPath* bgPath = [NSBezierPath new];
    
    float bgRGBA[] = LIGHT_OLIVE;

    NSColor* bgColor = [utilities getNSColorFromRGB:bgRGBA];
    
    [bgColor set];
    
    [bgPath appendBezierPathWithRect:NSMakeRect(0, 0, self.width, RACK_HEIGHT)];
    [bgPath closePath];
    [bgPath fill];
    
}

@end
 