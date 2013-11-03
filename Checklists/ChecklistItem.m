//
//  ChecklistItem.m
//  Checklists
//
//  Created by Paris Kapsouros on 10/24/13.
//  Copyright (c) 2013 Paris Kapsouros. All rights reserved.
//

#import "ChecklistItem.h"

@implementation ChecklistItem

- (void)toggleChecked {
    self.checked = !self.checked;
}

@end
