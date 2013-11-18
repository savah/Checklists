//
//  ChecklistsViewController.h
//  Checklists
//
//  Created by Paris Kapsouros on 10/21/13.
//  Copyright (c) 2013 Paris Kapsouros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailViewController.h"

@class Checklist;

//we declared that this is a tableview controller instead of a regular view controller.

@interface ChecklistViewController : UITableViewController <ItemDetailViewControllerDelegate>

@property (weak, nonatomic) Checklist *checklist;

@end
