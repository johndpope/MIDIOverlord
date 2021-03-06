//
//  appWindow.h
//  MIDIOverlord
//
//  Created by Pablo Revuelta on 9/07/14.
//  Copyright (c) 2014 Midnight City. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface appWindow : NSWindow

@property BOOL isMaxed;
@property NSRect originalFrame;

-(void)closeWindow:(NSNotification*)notification;
-(void)maxWindow:(NSNotification*)notification;

@end
