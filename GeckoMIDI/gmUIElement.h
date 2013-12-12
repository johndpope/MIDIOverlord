//
//  gmUIElement.h
//  GeckoMIDI
//
//  Created by Pablo Revuelta on 13/12/13.
//  Copyright (c) 2013 Midnight City. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface gmUIElement : NSObject

@property NSPointArray pointArr;
@property NSBezierPath *path;
@property NSColor *bg;

- (id)init;
- (void)drawBox;


@end
