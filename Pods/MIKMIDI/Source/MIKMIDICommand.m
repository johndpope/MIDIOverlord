//
//  MIKMIDICommand.m
//  MIDI Testbed
//
//  Created by Andrew Madsen on 3/7/13.
//  Copyright (c) 2013 Mixed In Key. All rights reserved.
//

#import "MIKMIDICommand.h"
#include <mach/mach_time.h>
#import "MIKMIDICommand_SubclassMethods.h"
#import "MIKMIDIUtilities.h"

#if !__has_feature(objc_arc)
#error MIKMIDICommand.m must be compiled with ARC. Either turn on ARC for the project or set the -fobjc-arc flag for MIKMIDICommand.m in the Build Phases for this target
#endif

static NSMutableSet *registeredMIKMIDICommandSubclasses;

@interface MIKMIDICommand ()

@end

@implementation MIKMIDICommand

+ (void)registerSubclass:(Class)subclass;
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		registeredMIKMIDICommandSubclasses = [[NSMutableSet alloc] init];
	});
	[registeredMIKMIDICommandSubclasses addObject:subclass];
}

+ (BOOL)isMutable { return NO; }

+ (BOOL)supportsMIDICommandType:(MIKMIDICommandType)type { return [[self supportedMIDICommandTypes] containsObject:@(type)]; }
+ (NSArray *)supportedMIDICommandTypes { return @[]; }
+ (Class)immutableCounterpartClass; { return [MIKMIDICommand class]; }
+ (Class)mutableCounterpartClass; { return [MIKMutableMIDICommand class]; }

+ (instancetype)commandWithMIDIPacket:(MIDIPacket *)packet;
{
	MIKMIDICommandType commandType = packet->data[0];
	
	Class subclass = [[self class] subclassForCommandType:commandType];
	if (!subclass) subclass = self;
	if ([self isMutable]) subclass = [subclass mutableCounterpartClass];
	return [[subclass alloc] initWithMIDIPacket:packet];
}

+ (NSArray *)commandsWithMIDIPacket:(MIDIPacket *)inputPacket
{
	NSInteger firstCommandType = inputPacket->data[0];
	NSInteger standardLength = MIKMIDIStandardLengthOfMessageForCommandType(firstCommandType);
	if (standardLength <= 0 || inputPacket->length == standardLength) {
		// Can't parse multiple message because we don't know the length of each one,
		// or there's only one message there
		MIKMIDICommand *command = [MIKMIDICommand commandWithMIDIPacket:inputPacket];
		return command ? @[command] : @[];
	}
	
	NSMutableArray *result = [NSMutableArray array];
	NSInteger packetCount = 0;
	while (1) {
		
		NSInteger dataOffset = packetCount * standardLength;
		if (dataOffset > (inputPacket->length - standardLength)) break;
		const Byte *packetData = inputPacket->data + dataOffset;
		if (packetData[0] != firstCommandType && ((packetData[0] | 0x0F) != (firstCommandType | 0x0F))) {
			// Doesn't look like multiple messages because they're not all the same type
			MIKMIDICommand *command = [MIKMIDICommand commandWithMIDIPacket:inputPacket];
			return command ? @[command] : @[];
		}
		
		// This is gross, but it's the only way I can find to reliably create a
		// single-message MIDIPacket.
		MIDIPacketList packetList;
		MIDIPacket *midiPacket = MIDIPacketListInit(&packetList);
		midiPacket = MIDIPacketListAdd(&packetList,
										  sizeof(MIDIPacketList),
										  midiPacket,
										  inputPacket->timeStamp,
										  standardLength,
										  packetData);
		MIKMIDICommand *command = [MIKMIDICommand commandWithMIDIPacket:midiPacket];
		if (command) [result addObject:command];
		packetCount++;
	}
	
	return result;
}

+ (instancetype)commandForCommandType:(MIKMIDICommandType)commandType; // Most useful for mutable commands
{
	Class subclass = [[self class] subclassForCommandType:commandType];
	if (!subclass) subclass = self;
	if ([self isMutable]) subclass = [subclass mutableCounterpartClass];
	return [[subclass alloc] init];
}

- (id)init
{
    return [self initWithMIDIPacket:NULL];
}

- (id)initWithMIDIPacket:(MIDIPacket *)packet
{
	self = [super init];
	if (self) {
		if (packet != NULL) {
			self.midiTimestamp = packet->timeStamp;
			self.internalData = [NSMutableData dataWithBytes:packet->data length:packet->length];
		} else {
			self.midiTimestamp = MIKMIDIGetCurrentTimeStamp();
			self.internalData = [NSMutableData dataWithLength:3];
			MIKMIDICommandType commandType = [[[[self class] supportedMIDICommandTypes] firstObject] unsignedCharValue];
			((UInt8 *)[self.internalData mutableBytes])[0] = commandType;
		}
	}
	return self;
}

- (NSString *)additionalCommandDescription
{
    return @"";
}

- (NSString *)description
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm:ss.SSS";
    NSString *timestamp =[dateFormatter stringFromDate:self.timestamp];
    NSString *additionalDescription = [self additionalCommandDescription];
    if ([additionalDescription length] > 0) {
        additionalDescription = [NSString stringWithFormat:@"%@ ", additionalDescription];
    }
	return [NSString stringWithFormat:@"%@ time: %@ command: %lu %@\n\tdata: %@", [super description], timestamp, (unsigned long)self.commandType, additionalDescription, self.data];
}

#pragma mark - Private

+ (Class)subclassForCommandType:(MIKMIDICommandType)commandType
{
	Class result = nil;
	for (Class subclass in registeredMIKMIDICommandSubclasses) {
		if ([[subclass supportedMIDICommandTypes] containsObject:@(commandType)]) {
			result = subclass;
			break;
		}
	}
	if (!result) {
		// Try again ignoring lower 4 bits
		commandType |= 0x0f;
		for (Class subclass in registeredMIKMIDICommandSubclasses) {
			if ([[subclass supportedMIDICommandTypes] containsObject:@(commandType)]) {
				result = subclass;
				break;
			}
		}
	}
	return result;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	Class copyClass = [[self class] immutableCounterpartClass];
	MIKMIDICommand *result = [[copyClass alloc] init];
	result.midiTimestamp = self.midiTimestamp;
	result.internalData = [self.data mutableCopy];
	return result;
}

- (id)mutableCopy
{
	Class copyClass = [[self class] mutableCounterpartClass];
	MIKMutableMIDICommand *result = [[copyClass alloc] init];
	result.midiTimestamp = self.midiTimestamp;
	result.data = self.data;
	return result;
}

#pragma mark - Properties

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"data"]) {
		keyPaths = [keyPaths setByAddingObject:@"internalData"];
	}
	
	if ([key isEqualToString:@"commandType"] ||
		[key isEqualToString:@"channel"] ||
		[key isEqualToString:@"dataByte1"] ||
		[key isEqualToString:@"dataByte2"]) {
		keyPaths = [keyPaths setByAddingObject:@"data"];
	}
	
	if ([key isEqualToString:@"timestamp"]) {
		keyPaths = [keyPaths setByAddingObject:@"midiTimestamp"];
	}
	
	return keyPaths;
}

- (NSDate *)timestamp
{
	int64_t elapsed = self.midiTimestamp - MIKMIDIGetCurrentTimeStamp();
	mach_timebase_info_data_t timebaseInfo;
	mach_timebase_info(&timebaseInfo);
	int64_t elapsedInNanoseconds = elapsed * timebaseInfo.numer / timebaseInfo.denom;

	NSTimeInterval elapsedInSeconds = (double)elapsedInNanoseconds / (double)NSEC_PER_SEC;
	return [NSDate dateWithTimeIntervalSinceNow:elapsedInSeconds];
}

- (void)setTimestamp:(NSDate *)date
{
	if (![[self class] isMutable]) return MIKMIDI_RAISE_MUTATION_ATTEMPT_EXCEPTION;
	
	NSTimeInterval elapsedInSeconds = [date timeIntervalSinceNow];
	int64_t elapsedInNanoseconds = (int64_t)(elapsedInSeconds * (double)NSEC_PER_SEC);
	
	mach_timebase_info_data_t timebaseInfo;
	mach_timebase_info(&timebaseInfo);
	int64_t elapsed = elapsedInNanoseconds * timebaseInfo.denom / timebaseInfo.numer;
	
	self.midiTimestamp = MIKMIDIGetCurrentTimeStamp() + elapsed;
}

- (MIKMIDICommandType)commandType
{
	if ([self.internalData length] < 1) return 0;
	UInt8 *data = (UInt8 *)[self.internalData bytes];
	MIKMIDICommandType result = data[0];
	if (![[[self class] supportedMIDICommandTypes] containsObject:@(result)]) {
		if ([[[self class] supportedMIDICommandTypes] containsObject:@(result | 0x0F)]) {
			result |= 0x0F;
		}
	}
	return result;
}

- (void)setCommandType:(MIKMIDICommandType)commandType
{
	if (![[self class] isMutable]) return MIKMIDI_RAISE_MUTATION_ATTEMPT_EXCEPTION;
	
	if ([self.internalData length] < 2) [self.internalData increaseLengthBy:1-[self.internalData length]];
	
	UInt8 *data = (UInt8 *)[self.internalData mutableBytes];
	data[0] = commandType;
}

- (UInt8)statusByte
{
	if ([self.internalData length] < 1) return 0;
	return ((UInt8 *)[self.internalData bytes])[0];
}

- (UInt8)dataByte1
{
	if ([self.internalData length] < 2) return 0;
	UInt8 *data = (UInt8 *)[self.internalData bytes];
	return data[1] & 0x7F;
}

- (void)setDataByte1:(UInt8)byte
{
	if (![[self class] isMutable]) return MIKMIDI_RAISE_MUTATION_ATTEMPT_EXCEPTION;
	
	byte &= 0x7F;
	if ([self.internalData length] < 2) [self.internalData increaseLengthBy:2-[self.internalData length]];
	[self.internalData replaceBytesInRange:NSMakeRange(1, 1) withBytes:&byte length:1];
}

- (UInt8)dataByte2
{
	if ([self.internalData length] < 3) [self.internalData increaseLengthBy:3-[self.internalData length]];
	UInt8 *data = (UInt8 *)[self.internalData bytes];
	return data[2] & 0x7F;
}

- (void)setDataByte2:(UInt8)byte
{
	if (![[self class] isMutable]) return MIKMIDI_RAISE_MUTATION_ATTEMPT_EXCEPTION;
	
	byte &= 0x7F;
	if ([self.internalData length] < 3) [self.internalData increaseLengthBy:3-[self.internalData length]];
	[self.internalData replaceBytesInRange:NSMakeRange(2, 1) withBytes:&byte length:1];
}

- (NSData *)data { return [self.internalData copy]; }

- (void)setData:(NSData *)data
{
	if (![[self class] isMutable]) return MIKMIDI_RAISE_MUTATION_ATTEMPT_EXCEPTION;
	
	self.internalData = [data mutableCopy];
}

@end

@implementation MIKMutableMIDICommand

+ (BOOL)isMutable { return YES; }

+ (BOOL)supportsMIDICommandType:(MIKMIDICommandType)type; { return [[self immutableCounterpartClass] supportsMIDICommandType:type]; }

#pragma mark - Properties

// MIKMIDICommand already implements a getter *and* setter for these. @dynamic keeps the compiler happy.
@dynamic timestamp;
@dynamic commandType;
@dynamic dataByte1;
@dynamic dataByte2;
@dynamic midiTimestamp;
@dynamic data;

@end

ByteCount MIKMIDIPacketListSizeForCommands(NSArray *commands)
{
	if (commands == nil || [commands count] == 0) {
		return 0;
	}

	// Compute the size of static members of MIDIPacketList and (MIDIPacket * [commands count])
	ByteCount packetListSize = offsetof(MIDIPacketList, packet) + offsetof(MIDIPacket, data) * [commands count];

	// Compute the total number of MIDI bytes in all commands
	for (MIKMIDICommand *command in commands) {
		packetListSize += [[command data] length];
	}

	return packetListSize;
}

BOOL MIKCreateMIDIPacketListFromCommands(MIDIPacketList **outPacketList, NSArray *commands)
{
	if (outPacketList == NULL || commands == nil || [commands count] == 0) {
		return NO;
	}

	ByteCount listSize = MIKMIDIPacketListSizeForCommands(commands);

	if (listSize == 0) {
		return NO;
	}

	MIDIPacketList *packetList = calloc(1, listSize);
	if (packetList == NULL) {
		return NO;
	}

	MIDIPacket *currentPacket = MIDIPacketListInit(packetList);
	for (NSUInteger i=0; i<[commands count]; i++) {
		MIKMIDICommand *command = [commands objectAtIndex:i];
		currentPacket = MIDIPacketListAdd(packetList,
										  listSize,
										  currentPacket,
										  command.midiTimestamp,
										  [command.data length],
										  [command.data bytes]);
		if (!currentPacket && (i < [commands count] - 1)) {
			free(packetList);
			return NO;
		}
	}

	*outPacketList = packetList;
	return YES;
}
