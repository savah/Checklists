//
//  ChecklistItem.m
//  Checklists
//
//  Created by Paris Kapsouros on 10/24/13.
//  Copyright (c) 2013 Paris Kapsouros. All rights reserved.
//

#import "ChecklistItem.h"
#import "DataModel.h"

@implementation ChecklistItem

/*
 Standard way to write init functions.
 We first call the parents init with self = [super init] and then if this returns something except nil we make the initialization.
 We then return self. Example:
 
 - (id)init {
 self = [super init];
 if (self) {
 // Initialization code here.
 }
 return self;
 }
 */

- (id) init
{
    if ( self = [super init] ) {
        self.itemId = [DataModel nextChecklistItemId];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.checked = [aDecoder decodeBoolForKey:@"Checked"];
        self.dueDate = [aDecoder decodeObjectForKey:@"DueDate"];
        self.shouldRemind = [aDecoder decodeBoolForKey:@"ShouldRemind"];
        self.itemId = [aDecoder decodeIntegerForKey:@"ItemID"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
    [aCoder encodeObject:self.dueDate forKey:@"DueDate"];
    [aCoder encodeBool:self.shouldRemind forKey:@"ShouldRemind"];
    [aCoder encodeInteger:self.itemId forKey:@"ItemID"];
    
}

- (void)toggleChecked {
    self.checked = !self.checked;
}

@end
