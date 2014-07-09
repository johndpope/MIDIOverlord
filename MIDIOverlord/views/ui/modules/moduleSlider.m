//
//  moduleSlider.m
//  MIDIOverlord
//
//  Created by Pablo Revuelta on 11/03/14.
//  Copyright (c) 2014 Midnight City. All rights reserved.
//

#import "moduleSlider.h"

@implementation moduleSlider

@synthesize ccValue = _ccValue;
@synthesize data = _data;

-(id)initWithData:(NSMutableDictionary*)data {
    
    _ccValue = 0;
    
    self.height = 32;
    
    _data = data;
    
    self = [super initWithFrame:NSMakeRect(0, 0, RACK_WIDTH - SCROLLER_WIDTH, self.height)];
    
    if(!self) return nil;
    
    NSLog(@"Data received: %@", data);
    
    // Add Slider
    _slider = [[controlSlider alloc] initWithFrame:NSMakePoint(self.width, 16): 0 :127 ];
    [_slider setOrigin:NSMakePoint(0, 0)];
    [_slider updateControlFromData: data[@"ccValue"]];
    
    [self bind:@"ccValue" toObject:_slider withKeyPath:@"value" options:nil];
    [_data bind:@"ccValue" toObject:_slider withKeyPath:@"value" options:nil];
    
    [self addSubview: _slider];

    // Add Label
    uiEditableTextField *editLabel = [[uiEditableTextField alloc] initWithString: _data[@"label"] andMaxLength: 8];
    [editLabel setOrigin:NSMakePoint(0, 16)];
    
    [_data bind:@"label" toObject: editLabel withKeyPath:@"savedString" options:nil];
    
    [self addSubview:editLabel];

    _ccControl = [[controlText alloc] initWithLabel: @"CC" andValue: data[@"ccNumber"]];
    
   [_ccControl setOrigin:NSMakePoint(editLabel.frameWidth + 2, 16)];
   [_ccControl setMax:127];
    
   [_data bind:@"ccNumber" toObject: _ccControl withKeyPath:@"value" options:nil];
    
   [self addSubview: _ccControl ];

    uiButton *removeBtn = [[uiButton alloc] initWithSize: 16];
    [removeBtn setEvent:@"removeModule" withData: @{@"rackID": self.data[@"rackID"], @"moduleID" : self.data[@"moduleID"]}];
    [removeBtn setOrigin: NSMakePoint(RACK_WIDTH - 16 - SCROLLER_WIDTH -8, 16)];
    
    [self addSubview: removeBtn];
    
    return self;
}

-(NSNumber*)ccValue {
    return _ccValue;
}

-(void)setCcValue:(NSNumber*)ccValue {
    NSLog(@"Set ccValue");
    _ccValue = ccValue;
    [self.delegate midiData: @[self.data[@"ccStatus"], self.data[@"ccNumber"], self.data[@"ccValue"]]];
}


@end
