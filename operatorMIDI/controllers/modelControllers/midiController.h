//
//  midiController.h
//  operatorMIDI
//
//  Created by Pablo Revuelta on 10/02/14.
//  Copyright (c) 2014 Midnight City. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>
#import "eventHandler.h"

@interface midiController : NSObject

// Notifications
@property NSNotificationCenter* center;

@property MIDIDeviceListRef midiDevices;
@property MIDIClientRef appClient;
@property MIDIEndpointRef appOutput;

-(void)getDestinations;
-(NSString*)getDisplayName:(MIDIObjectRef)object;
-(void)createVirtualDeviceWithClient;

-(MIDIPacketList*)getMidiNotePacket:(BOOL)on :(int)value;

-(void)handleNotifications:(NSNotification*)notification;
-(void)sendNote:(BOOL)on :(int)value;

@end