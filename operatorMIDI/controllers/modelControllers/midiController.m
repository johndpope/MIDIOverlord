//
//  midiController.m
//  operatorMIDI
//
//  Created by Pablo Revuelta on 10/02/14.
//  Copyright (c) 2014 Midnight City. All rights reserved.
//

#import "midiController.h"


Byte packetBuffer[128];

@implementation midiController

-(id)init {
    self = [super init];
    if(!self) return nil;

    [self createVirtualDeviceWithClient];
    [self getDestinations];
    
    // Setup notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotifications:) name:@"noteOn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotifications:) name:@"noteOff" object:nil];
    
     return self;
}

-(void)getDestinations {
    ItemCount destCount = MIDIGetNumberOfDestinations();
    ItemCount sourceCount = MIDIGetNumberOfSources();
    NSLog(@"sources: %i", (int)sourceCount);
    NSLog(@"Destinationcount: %i", (int)destCount);
    for (ItemCount i = 0 ; i < destCount ; ++i) {
        
        // Grab a reference to a destination endpoint
        MIDIEndpointRef dest = MIDIGetDestination(i);
        if (dest) {
            NSLog(@"  Destination: %@", [self getDisplayName:dest]);
        }
    }
}

-(NSString*)getDisplayName:(MIDIObjectRef)object{
    // Returns the display name of a given MIDIObjectRef as an NSString
    CFStringRef name = nil;
    if (noErr != MIDIObjectGetStringProperty(object, kMIDIPropertyDisplayName, &name)) {
        return nil;
    }
    return (NSString*)CFBridgingRelease(name);
}

-(void)createVirtualDeviceWithClient {
    
    OSStatus result;
    
    // Create midi client
    
    MIDIClientCreate(CFSTR("Operator Midi Client"), NULL, NULL, &_appClient);
    
    
    // Create virtual source
    result = MIDISourceCreate(_appClient, CFSTR("Op source"), &_appOutput);
    
    if(result != noErr) {
        NSLog(@"Error creating MIDI client: %s - %s",
              GetMacOSStatusErrorString(result),
              GetMacOSStatusCommentString(result));
        return;
    }

}


-(MIDIPacketList*)getMidiNotePacket:(BOOL)on :(int)value {
    
    MIDIPacketList* packetList = (MIDIPacketList*)packetBuffer;
    MIDIPacket *packet;
    
    char status = on ? 0x80 : 0x90;
    
    Byte msg[3] = {status, (Byte)value, 0x40};
    
    packet = MIDIPacketListInit(packetList);
    packet = MIDIPacketListAdd(packetList, 1024, packet, 0, 3, msg);
    
   
    
    return packetList;
    
}

- (void)handleNotifications:(NSNotification*)notification {
    NSLog(@"Got notified: %@", notification);
    int note = [[notification.userInfo objectForKey:@"note"] intValue];
    if(notification.name == @"noteOn") {

    }
    
    if(notification.name == @"noteOff") {

    }
    
}

-(void)sendNote:(BOOL)on :(int)noteValue {
    NSLog(@"Send note: %d", noteValue);
   
    if(on){
        // Note on
        MIDIPacketList *packetList = [self getMidiNotePacket:true :noteValue];
        MIDIReceived(_appOutput, packetList);
    } else {
        MIDIPacketList *packetList = [self getMidiNotePacket:false :noteValue];
        MIDIReceived(_appOutput, packetList);
    }

 
}


@end