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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.checked = [aDecoder decodeBoolForKey:@"Checked"];
        self.dueDate = [aDecoder decodeObjectForKey:@"DueDate"];
        self.shouldRemind = [aDecoder decodeBoolForKey:@"ShouldRemind"];
        self.itemId = [aDecoder decodeIntegerForKey:@"ItemID"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
    [aCoder encodeObject:self.dueDate forKey:@"DueDate"];
    [aCoder encodeBool:self.shouldRemind forKey:@"ShouldRemind"];
    [aCoder encodeInteger:self.itemId forKey:@"ItemID"];
    
}

- (void)toggleChecked
{
    self.checked = !self.checked;
}

/*
 Standard function to check if a notification is needed. 
 It checks 1) if the switch is turned to on and if the date is in the future by getting the current date and the one set.
 */

- (void)scheduleNotification
{
    UILocalNotification *existingNotification = [self notificationForThisItem];
    if (existingNotification != nil) {
        NSLog(@"Found an existing notification %@", existingNotification);
        [[UIApplication sharedApplication] cancelLocalNotification:existingNotification];
    }
         
    if (self.shouldRemind &&
        [self.dueDate compare:[NSDate date]] != NSOrderedAscending)
    {
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = self.dueDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = self.text;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.userInfo = @{@"ItemID" : @(self.itemId) };
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Scheduled notification %@ for itemId %d",localNotification, self.itemId);
    }
}


/*
 VERY common pattern on how to check if notifications exist.
 1. we get all the notifications for the application
 2. we loop though all of them
 3. we get the number that we set before in the userInfo dictionary
 4. we compare this number with the self.itemId (which is the current item edited)
 5. if this is true then we return the notification
 
 */
- (UILocalNotification *)notificationForThisItem
{
    NSArray *allNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in allNotifications) {
        NSNumber *number = [notification.userInfo objectForKey:@"ItemID"];
        if (number != nil && [number integerValue] == self.itemId) {
            return notification;
        }
    }
    return nil;
}

/*
 An object is notified when it is about to be deleted using the dealloc message.
 You can simply implement this method, look if there is a scheduled notification for this item and then cancel it.
 This happens both when an existing item gets deleted but also when a checklist gets deleted since all individual items are deleted.
 */

- (void) dealloc
{
    UILocalNotification *existingNotification = [self notificationForThisItem];
    if (existingNotification != nil) {
        NSLog(@"Removing notification %@", existingNotification);
        [[UIApplication sharedApplication] cancelLocalNotification:existingNotification];
    }
}

- (NSComparisonResult)compare:(ChecklistItem *)otherChecklistItem
{
    return [self.dueDate compare:otherChecklistItem.dueDate];
}

@end
