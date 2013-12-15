//
//  Checklist.m
//  Checklists
//
//  Created by Paris Kapsouros on 17/11/13.
//  Copyright (c) 2013 Paris Kapsouros. All rights reserved.
//

#import "Checklist.h"

@implementation Checklist

- (id)init
{
    if ((self = [super init])) {
        self.items = [[NSMutableArray alloc] initWithCapacity:20];
    }
    return self;
}

//load the properties of the model
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.name = [aDecoder decodeObjectForKey:@"Name"];
        self.items = [aDecoder decodeObjectForKey:@"Items"];
    }
    return self;
}


//save the properties of the model
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"Name"];
    [aCoder encodeObject:self.items forKey:@"Items"];
}

@end
