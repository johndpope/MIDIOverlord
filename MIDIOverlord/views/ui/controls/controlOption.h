//
//  controlOption.h
//  MIDIOverlord
//
//  Created by Pablo Revuelta on 14/04/14.
//  Copyright (c) 2014 Midnight City. All rights reserved.
//

#import "controlBase.h"
#import "uiLabel.h"

@class controlOption;

@protocol controlOptionDelegate
-(void)optionSelectedWithKeyValue: (NSArray*)keyValue andTag: (NSInteger)tag;
@end

@interface controlOption : controlBase;

@property (nonatomic, assign) id delegate;

@property uiLabel *label;
@property NSArray* keyValue;

-(void)setKeyValue:(NSArray*)arr;

@end
