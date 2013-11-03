//
//  AddItemViewController.h
//  Checklists
//
//  Created by Paris Kapsouros on 11/3/13.
//  Copyright (c) 2013 Paris Kapsouros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddItemViewController : UITableViewController


@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)cancel;
- (IBAction)done;

@end
