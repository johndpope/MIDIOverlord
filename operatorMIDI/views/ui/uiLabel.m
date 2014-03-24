//
//  uiLabel.m
//  operatorMIDI
//
//  Created by Pablo Revuelta on 24/03/14.
//  Copyright (c) 2014 Midnight City. All rights reserved.
//

#import "uiLabel.h"

@implementation uiLabel

-(id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if(!self) return nil;
    
    [self setBezeled:NO];
    [self setDrawsBackground:NO];
    [self setEditable:NO];
    [self setSelectable:NO];
    
    return self;
}

@end
