//
//  ChecklistItem.m
//  Checklists
//
//  Created by Paris Kapsouros on 10/24/13.
//  Copyright (c) 2013 Paris Kapsouros. All rights reserved.
//

#import "ChecklistItem.h"

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
- (id) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.checked = [aDecoder decodeBoolForKey:@"Checked"];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
    
}

- (void)toggleChecked {
    self.checked = !self.checked;
}

@end
