//
//  moduleSlider.m
//  operatorMIDI
//
//  Created by Pablo Revuelta on 11/03/14.
//  Copyright (c) 2014 Midnight City. All rights reserved.
//

#import "moduleSlider.h"

@implementation moduleSlider

-(id)initWithFrame{
    
    int width = 80;
    
    NSRect frame = NSMakeRect(0, 0, width, RACK_HEIGHT );
    
    self = [super initWithFrame:frame];
    
    if(!self) return nil;
    
    self.value = 0;
    
    self.width = width;
    
    // Add UI buttons
    
    // Add UI buttons
    float sliderRGBA[] = UI_COLOR_PROT_3;
    NSColor* sliderColor = [utilities getNSColorFromRGB:sliderRGBA];
    
    controlSlider *slider = [[controlSlider alloc] initWithFrame:NSMakePoint(self.width - 16, self.width - 16): NSMakePoint(8, 8): sliderColor :0 :127 ];
    
   slider.delegate = self;
    
    [self addSubview: slider];
    
//    controlText *midiNoteValue = [[controlText alloc] initWithFrame:NSMakeRect(8, 96, 48, 32):_midiNote];
    
    //    [midiNoteValue bind:@"midNote" toObject:self withKeyPath:@"selection.midiNote" options:nil];
    
//    [self addSubview:midiNoteValue];
    
    return self;
}

-(void)drawRect:(NSRect)rect {
    
    NSBezierPath* bgPath = [NSBezierPath new];
    
    float bgRGBA[] = UI_COLOR_PROT_1;
    
    NSColor* bgColor = [utilities getNSColorFromRGB:bgRGBA];
    
    [bgColor set];
    
    [bgPath appendBezierPathWithRect:NSMakeRect(0, 0, self.width, RACK_HEIGHT)];
    [bgPath closePath];
    [bgPath fill];
    
}

@end
