//
//  ChecklistItem.h
//  Checklists
//
//  Created by Paris Kapsouros on 10/24/13.
//  Copyright (c) 2013 Paris Kapsouros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChecklistItem : NSObject <NSCoding>

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, copy) NSDate *dueDate; // due date for the notification
@property (nonatomic, assign) BOOL shouldRemind; //flag for if the user should be reminded for the notification
@property (nonatomic, assign) NSInteger itemId; //itemid. Key to store the object id in order to fetch the checklistitem when we have just the notification

- (void)toggleChecked;

@end
