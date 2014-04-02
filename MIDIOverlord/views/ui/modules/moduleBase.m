//
//  moduleBase.m
//  MIDIOverlord
//
//  Created by Pablo Revuelta on 20/12/13.
//  Copyright (c) 2013 Midnight City. All rights reserved.
//

#import "moduleBase.h"

@implementation moduleBase

@synthesize labelText = _labelText;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    controlText *midiValueText = [[controlText alloc] initWithFrame:NSMakeRect(8, 96, 48, 32): _midiValue];
    
    [midiValueText bind:@"value" toObject:self withKeyPath:@"self.midiValue" options:nil];
    
    [self addSubview:midiValueText];

    self.height = MODULE_HEIGHT;
    
    float bgRGBA[] = UI_COLOR_PROT_1;
    
    self.bgColor = [utilities getNSColorFromRGB: bgRGBA];
    
    self.labelText = @"Untitled";
    
    return self;
}

-(void)setOrigin:(NSPoint)origin {
    NSRect f = self.frame;
    f.origin = origin;
    [self setFrame:f];
}

// Event handlers
-(void)uiEvent:(char*)type {
    [self uiEvent:type withInt:0];
}

-(void)uiEvent:(char*)type withInt:(int)value {
    NSLog(@"Ui event with int: %d", value);
    
    if(strncmp(type, "noteOn", 6) == 0) {
        NSLog(@"Note on trigger");
        [utilities midiNotification: 0x90 : self.midiValue : 127 ];
    }
    if(strncmp(type, "noteOff", 6) == 0) {
        NSLog(@"Note off trigger");
        [utilities midiNotification: 0x80 : self.midiValue : 127 ];
    }
    if(strncmp(type, "sliderVal", 9) == 0) {
        [utilities midiNotification: 0xB0 : self.midiValue :value];
    }
}

-(void)drawRect:(NSRect)rect {
    [self drawModule:rect];
    [self drawBg:rect];
}

-(void)drawModule:(NSRect)rect {
    // Overwritten
}

-(void)drawBg:(NSRect)rect {
    
    // Draw background
    
    NSBezierPath* bgPath = [NSBezierPath new];
    
    
    [self.bgColor set];
    
    [bgPath appendBezierPathWithRect:NSMakeRect(0, 0, self.width, self.height)];
    [bgPath closePath];
    [bgPath fill];
    
    
    NSLog(@"Drawing");
}

-(NSString*)labelText {
    return _labelText;
}

-(void)setLabelText:(NSString*)labelText {
    [self.label setStringValue: labelText];
    [self.label setNeedsDisplay:YES];
    _labelText = labelText;
}


@end