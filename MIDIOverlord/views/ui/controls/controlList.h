//
//  controlList.h
//  MIDIOverlord
//
//  Created by Pablo Revuelta on 18/03/14.
//  Copyright (c) 2014 Midnight City. All rights reserved.
//

#import "controlBase.h"
#import "controlOption.h"

@interface controlList : controlBase <controlOptionDelegate>

@property int width;

@property NSMutableDictionary *options;
@property int optionCount;

@property BOOL hasNull;

@property NSMutableArray *content;
@property NSNumber* selectedIndex;

@property int height;

@property NSInteger tag;

@property NSString *labelText;

@property uiTextField *label;
@property uiTextField *selectLabel;

-(id)initWithContent:(NSArray*)content andHasNull:(BOOL)hasNull;

-(void)deselect:(NSNotification*)notification;

@end
