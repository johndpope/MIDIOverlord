//
//  gmUIElement.m
//  MIDIOverlord
//
//  Created by Pablo Revuelta on 13/12/13.
//  Copyright (c) 2013 Midnight City. All rights reserved.
//

#import "controlTrigger.h"

@implementation controlTrigger

-(id)initWithSize:(NSSize)size andValue: (NSNumber *)value {
    
    _size = size;
    _value = value;
    
    _min = 0;
    _max = 127;
    
    self = [super initWithFrame:NSMakeRect(0, 0, size.width, size.height)];
    
    if(!self) return nil;
    
    // Colors
    _activeColor = [global sharedGlobalData].colors[@"red"];
    _defaultColor = [global sharedGlobalData].colors[@"lightGrey"];
    
    return self;
}

- (void)drawRect:(NSRect)rect {
    
    NSBezierPath* btnPath = [NSBezierPath new];
    NSBezierPath* markerPath = [NSBezierPath new];
    
    [btnPath appendBezierPathWithRoundedRect:NSMakeRect(0, 0, _size.width, _size.height) xRadius: 3 yRadius: 3];
    [markerPath appendBezierPathWithRoundedRect:NSMakeRect(0, 0, _size.width, _size.height) xRadius: 3 yRadius: 3];
    
    if(self.active) {
        [[self.activeColor colorWithAlphaComponent: [_value floatValue] / _max ] setFill];
    } else {
        [self.defaultColor setFill];
    }
    
    [btnPath fill];
    
    if(self.active) return;
    
    [markerPath fill];
}


-(void)mouseDown:(NSEvent *)theEvent {
    self.active = YES;
    [self setNeedsDisplay:YES];
}

-(void)mouseDragged:(NSEvent*)e {
    NSLog(@"Dragged");
    if(self.active){
//        [self updateControlFromEvent:e];
    }
}

-(void)mouseUp:(NSEvent *)theEvent {
    self.active = NO;
    [self setNeedsDisplay:YES];
}



-(void)updateControlFromEvent:(NSEvent*)e {
    
    NSPoint location = [self convertPoint:[e locationInWindow] fromView:nil];
//    
//    float percent = location.y / _size.y;
//    int newValue =  percent < 0 ? _min : percent > 1 ? _max : floor(_range * percent);
//    
//    [self setVelocity: [NSNumber numberWithInt: newValue]];
    
    [self setNeedsDisplay:YES];
    
}


@end