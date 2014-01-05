//
//  ListDetailViewController.h
//  Checklists
//
//  Created by Paris Kapsouros on 18/11/13.
//  Copyright (c) 2013 Paris Kapsouros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconPickerViewController.h"

@class ListDetailViewController;
@class Checklist;

/*
 Interface that the delegate has to implement together with the functions
 */

@protocol ListDetailViewControllerDelegate <NSObject>

- (void)listDetailViewControllerDidCancel: (ListDetailViewController *)controller;

- (void)listDetailViewController: (ListDetailViewController *)controller didFinishAddingChecklist:(Checklist *)checklist;

- (void)listDetailViewController: (ListDetailViewController *)controller didFinishEditingChecklist:(Checklist *)checklist;

@end

@interface ListDetailViewController : UITableViewController <UITextFieldDelegate, IconPickerViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneBarButton;
@property (nonatomic, weak) id <ListDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) Checklist *checklistToEdit;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

- (IBAction)cancel;
- (IBAction)done;

@end