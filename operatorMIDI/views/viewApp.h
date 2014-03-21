//
//  grid.h
//  operatorMIDI
//
//  Created by Pablo Revuelta on 26/11/13.
//  Copyright (c) 2013 Midnight City. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "moduleRack.h"
#import "moduleBase.h"
#import "moduleSlider.h"
#import "modulePad.h"
#import "uiApp.h"


@interface viewApp : NSView

@property int rackCount;

@property NSMutableArray* layout;
@property NSMutableDictionary* modules;
@property NSDictionary* moduleData;
@property NSMutableArray* rackData;

-(id)initWithFrame:(NSRect)frame andRackData:(NSMutableArray*)rackData andModuleData:(NSDictionary*)moduleData andLayout:(NSMutableArray*)layout;
-(NSPoint)getSize;

-(void)drawRect:(NSRect)rect;

-(void)drawGrid;

-(moduleBase*)getModuleWithId:(NSString*)mID;
@end