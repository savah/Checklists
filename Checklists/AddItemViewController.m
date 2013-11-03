//
//  AddItemViewController.m
//  Checklists
//
//  Created by Paris Kapsouros on 11/3/13.
//  Copyright (c) 2013 Paris Kapsouros. All rights reserved.
//

#import "AddItemViewController.h"

@interface AddItemViewController ()

@end

@implementation AddItemViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done {
    NSLog(@"Contents of the cell %@", self.textField.text);
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //this actually selects the textfield and pops up the keyboard
    [self.textField becomeFirstResponder];
}


@end
