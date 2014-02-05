//
//  AppDelegate.h
//  operatorMIDI
//
//  Created by Pablo Revuelta on 26/11/13.
//  Copyright (c) 2013 Midnight City. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//Data
#import "dataApp.h"
//UI
#import "viewApp.h"
#import "controlSlider.h"
#import "eventHandler.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property dataApp* state;
@property (assign) IBOutlet NSWindow *mainWin;
@property float windowPadding;
@property eventHandler* events;

- (IBAction)makeView:(id)sender;
- (void)resizeWin:(NSPoint)size;

@end