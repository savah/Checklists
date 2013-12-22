//
//  AllListsViewController.h
//  Checklists
//
//  Created by Paris Kapsouros on 17/11/13.
//  Copyright (c) 2013 Paris Kapsouros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListDetailViewController.h"

@class DataModel;

@interface AllListsViewController : UITableViewController <ListDetailViewControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) DataModel *dataModel;

@end
