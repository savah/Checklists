//
//  itemDetailViewController.m
//  Checklists
//
//  Created by Paris Kapsouros on 11/3/13.
//  Copyright (c) 2013 Paris Kapsouros. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "ChecklistItem.h"

@interface ItemDetailViewController ()

@end

@implementation ItemDetailViewController

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
    
    if (self.itemToEdit != nil) {
        self.title = @"Edit Item";
        self.textField.text = self.itemToEdit.text;
        self.doneBarButton.enabled = YES;
    }

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


//close the modal view

- (IBAction)cancel {
    [self.delegate itemDetailViewControllerDidCancel:self];
}


//push the done button and save the item.

- (IBAction)done {
    //check if itemToEdit is object
    if (self.itemToEdit == nil) {
        ChecklistItem *item = [[ChecklistItem alloc] init];
        item.text = self.textField.text;
        item.checked = NO;
        [self.delegate itemDetailViewController:self didFinishAddingItem:item];
    } else {
        self.itemToEdit.text = self.textField.text;
        [self.delegate itemDetailViewController:self didFinishEditingItem:self.itemToEdit];
    }
    
}


//disables the selection of the table view row. Do not forget to also go to the cell on the storyboard, go to attributes inspector and set the selection to none, instead of blue
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


//The view controller receives the viewWillAppear message just before it becomes visible. So its a good place to make elements active.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //this actually selects the textfield and pops up the keyboard
    [self.textField becomeFirstResponder];
}

/*
this is one of the textfields delegate methods. It is invoked every time the user changes text, whether by tapping on the keyboard or by cut/paste.
To make this work we must make the view controller a delegate of the text field from the storyboard connection. We also need to make an outlet of the done button so we can disable it from this method.
 */
- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newText = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    
    self.doneBarButton.enabled = ([newText length] > 0);
    
    return YES;
}


@end
