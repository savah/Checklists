//
//  DataModel.h
//  Checklists
//
//  Created by Paris Kapsouros on 16/12/13.
//  Copyright (c) 2013 Paris Kapsouros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Checklist.h"

@interface DataModel : NSObject

@property (nonatomic, strong) NSMutableArray *lists;

- (void)saveChecklists;
- (NSInteger)indexOfSelectedChecklist;
- (void)setIndexOfSelectedChecklist:(NSInteger)index;
- (void)sortChecklists;
+ (NSInteger)nextChecklistItemId;

@end
