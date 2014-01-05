//
//  ListDetailViewController.m
//  Checklists
//
//  Created by Paris Kapsouros on 18/11/13.
//  Copyright (c) 2013 Paris Kapsouros. All rights reserved.
//

#import "ListDetailViewController.h"
#import "Checklist.h"

@interface ListDetailViewController ()

@end

@implementation ListDetailViewController
{
    NSString *_iconName; //instance variable to keep track of the chosen icon name.
}

//we use the initWithCoder function since this viewcontroller is being loader from the storyboard. Since storyboard is a plist file (encrypted objects) viewcontrollers loaded for it are using the initwithcoder.
- (id) initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        _iconName = @"Folder";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.checklistToEdit != nil) {
        self.title = @"Edit Checklist";
        self.textField.text = self.checklistToEdit.name;
        self.doneBarButton.enabled = YES;
        _iconName = self.checklistToEdit.iconName; //copy the checklist's icon to the _iconName instance variable
    }
    
    self.iconImageView.image = [UIImage imageNamed:_iconName]; //load the icon into a new uiimage object and set it on the iconImageView so it shows up in the Icon row.

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel
{
    [self.delegate listDetailViewControllerDidCancel:self];
}

- (IBAction)done
{
    if (self.checklistToEdit == nil) {
        Checklist *checklist = [[Checklist alloc] init];
        checklist.name = self.textField.text;
        checklist.iconName = _iconName;
        
        [self.delegate listDetailViewController:self didFinishAddingChecklist:checklist];
    } else {
        self.checklistToEdit.name = self.textField.text;
        self.checklistToEdit.iconName = _iconName;
        
        [self.delegate listDetailViewController:self didFinishEditingChecklist:self.checklistToEdit];
    }
}

/*
    Set the delegate of the iconpickerviewcontroller to self (listdetailviewcontroller) . **** Commong practice ****
 */
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //if the segue that is going to be called is the pickIcon we make a new object of the destination controller and set the delegate of this object to self.
    if ([segue.identifier isEqualToString:@"PickIcon"]) {
        IconPickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

/* 
 This is necessary otherwise you cannot tap the cell to trigger the segue. Previously this method always returned nil, which meant tapping on rows was not possible. Now, however, you want to allow the user to tap on the “Icon” cell, so this method should return the index-path for that cell. Because the Icon cell is the only row in the second section, you only have to check indexPath.section. Users still can’t select the cell with the text field (from section 0).
 */
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     This is needed so the user can select the section 1. Since section 1 has only one row we just return this row's indexpath without any further checks.
     Still the section 0 is not possible to be selected.
    */
    if (indexPath.section == 1) {
        return indexPath;
    } else {
        return nil;
    }
}

- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneBarButton.enabled = ([newText length] > 0);
    return YES;
}

- (void)iconPicker:(IconPickerViewController *)picker didPickIcon:(NSString *)iconName
{
    _iconName = iconName; //stores the selected icon to the instance variable
    self.iconImageView.image = [UIImage imageNamed:_iconName]; //updates the image view with a new image
    
    [self.navigationController popViewControllerAnimated:YES]; //we use the popViewControllerAnimated instead of dismissViewController because the type of the segue that we used is of type push and not modal.
}

@end
