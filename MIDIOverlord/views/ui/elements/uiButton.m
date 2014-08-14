//
//  uiButton.m
//  MIDIOverlord
//
//  Created by Pablo Revuelta on 20/05/14.
//  Copyright (c) 2014 Midnight City. All rights reserved.
//

#import "uiButton.h"
#import "utilities.h"

@implementation uiButton

@synthesize toggled = _toggled;

-(id)initWithSize:(int)size {
    return [self initWithSize:size andEvent: nil];
}

-(id)initWithSize:(int)size andEvent:(NSString*)event {
    
    _width = size;
    _height = size;
    
    self = [super initWithFrame: NSMakeRect(0, 0, _width, _height)];
    if (!self) return nil;
    
    self.event = @"";
    self.eventData = @{};
    self.isToggle = NO;
    self.flipped = YES;
    self.hasBg = YES;
    self.sendsEvent = YES;
    
    self.defaultColor = [global sharedGlobalData].colors[@"lightGrey"];
    self.activeColor =  [global sharedGlobalData].colors[@"darkGrey"];
    self.toggleColor = [global sharedGlobalData].colors[@"yellow"];
    self.disabledColor = [global sharedGlobalData].colors[@"white"];

    NSDictionary *iconTypes = @{
         @"addControlRack" : @-48,
         @"addMapRack" : @-48,
         @"closeWindow" : @-136,
         @"maxWindow" : @-212,
         @"removeRack"   : @-136,
         @"removeModule" : @-136,
         @"addSlider"   : @-96,
         @"addPads"     : @-116,
         @"addMap"      : @-192,
         @"receiveRecord"  : @-160,
         @"sendRecord"  : @-176
    };
    
    if([event isEqualTo: @"closeWindow"]) {
        self.hasBg = NO;
    }
    
    NSLog(@"Icontype: Event: %@, %@", event, iconTypes[event] );
    
    if([event length] != 0) {
        [self setEvent: event];
        
        NSImage *icons = [NSImage imageNamed:@"icons.png"];
        _iconView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, icons.size.width, icons.size.height)];
        
        [_iconView setImageScaling: NSImageScaleNone];
        
        [_iconView setImage:icons];

        [self setIconViewOrigin: NSMakePoint([iconTypes[event] intValue], 0)];
        
        [self addSubview:_iconView];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect{
    
    if(self.active) {
        [self.activeColor setFill];
    } else if (self.toggled){
        [self.toggleColor setFill];
    } else if (self.disabled) {
        [self.disabledColor setFill];
    } else {
        [self.defaultColor setFill];
    }

    if(_hasBg) {
        NSBezierPath *btnPath = [NSBezierPath new];
        
        [btnPath appendBezierPathWithRoundedRect:dirtyRect xRadius: 2 yRadius:2];
      
        [btnPath fill];
    }
}

-(void)setIconViewOrigin:(NSPoint)origin {
    NSRect f = _iconView.frame;
    f.origin = origin;
    [_iconView setFrame:f];
}

-(void)setEvent:(NSString*)event withData:(NSDictionary*)data {
    [self setEvent: event];
    [self setEventData: data];
}

-(void)mouseDown:(NSEvent*)theEvent {
    [global deselectNotify];
    
    if(_isToggle) {
        self.toggled = !self.toggled;
        self.eventData = @{@"isToggled" : [NSNumber numberWithBool:self.toggled]};
    } else {
        self.active = YES;
    }
    
    [self setNeedsDisplay:YES];

}

-(void)mouseUp:(NSEvent *)theEvent {
    self.active = NO;
    [self setNeedsDisplay:YES];
    if(self.sendsEvent) {
        [[NSNotificationCenter defaultCenter] postNotificationName: self.event object:self userInfo: self.eventData];
    }
}

-(void)deselect:(NSNotification*)notification  {
//    self.toggled = NO;
    [self setNeedsDisplay:YES];
}


@end
