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
{
    NSDate *_dueDate;
    BOOL _datePickerVisible;
}

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
        
        self.switchControl.on = self.itemToEdit.shouldRemind;
        _dueDate = self.itemToEdit.dueDate;
    } else {
        self.switchControl.on = NO;
        _dueDate = [NSDate date];
    }
    
    [self updateDueDateLabel];
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

- (IBAction)cancel
{
    [self.delegate itemDetailViewControllerDidCancel:self];
}


//push the done button and save the item.

- (IBAction)done
{
    //check if itemToEdit is object
    if (self.itemToEdit == nil) {
        ChecklistItem *item = [[ChecklistItem alloc] init];
        item.text = self.textField.text;
        item.checked = NO;
        item.shouldRemind = self.switchControl.on;
        item.dueDate = _dueDate;
        
        //schedule the notification
        [item scheduleNotification];
        
        [self.delegate itemDetailViewController:self didFinishAddingItem:item];
        
    } else {
        self.itemToEdit.text = self.textField.text;
        self.itemToEdit.shouldRemind = self.switchControl.on;
        self.itemToEdit.dueDate = _dueDate;
        
        //schedule the notification
        [self.itemToEdit scheduleNotification];
        
        [self.delegate itemDetailViewController:self didFinishEditingItem:self.itemToEdit];
    }
    
}


//disables the selection of the table view row. Do not forget to also go to the cell on the storyboard, go to attributes inspector and set the selection to none, instead of blue
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //make only date to respond to taps while making all others not to respond at any taps.
    if (indexPath.section == 1 && indexPath.row == 1) {
        return indexPath;
    } else {
        return nil;
    }
}


//The view controller receives the viewWillAppear message just before it becomes visible. So its a good place to make elements active.
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //this actually selects the textfield and pops up the keyboard
    [self.textField becomeFirstResponder];
}

/*
this is one of the textfields delegate methods. It is invoked every time the user changes text, whether by tapping on the keyboard or by cut/paste.
To make this work we must make the view controller a delegate of the text field from the storyboard connection. We also need to make an outlet of the done button so we can disable it from this method.
 */
- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *newText = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    
    self.doneBarButton.enabled = ([newText length] > 0);
    
    return YES;
}


/* 
 Format the date according to the formatter object. Medium date format and small time format.
 We then set the labeltext equal to the formatted object date value
 */
- (void)updateDueDateLabel
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    self.dueDateLabel.text = [formatter stringFromDate:_dueDate];
}


- (void)showDatePicker
{
    _datePickerVisible = YES;
    
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:1 inSection:1];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
    
    
    UITableViewCell *dateRowCell = [self.tableView cellForRowAtIndexPath:indexPathDateRow];
    
    //set the text color same as the tint color.
    dateRowCell.detailTextLabel.textColor = dateRowCell.detailTextLabel.tintColor;
    
    
    /*
     When we are doing insert/updates to more than 1 row at the same time we must put them inside a begin - end updates method calls so they can happen at the same time.
     */
    [self.tableView beginUpdates];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];
    
    //get the cell that the datepicker is.
    UITableViewCell *datePickerCell = [self.tableView cellForRowAtIndexPath:indexPathDatePicker];
    //get the object. We get the tablecell with tag 100 and we cast in on a datepicker object.
    UIDatePicker *datePicker = (UIDatePicker *) [datePickerCell viewWithTag:100];
    
    //we set the date to the instance variable due date.
    [datePicker setDate:_dueDate animated:NO];
}


/* 
 Override tableViewcellForRowAtIndexPath method, while providing a fallback for the case that the cell is not a date picker.
 This fallback calls the parent's tableViewcellForRowAtIndexPath method.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1 check if the indexpath is the row with the date picker.
    if (indexPath.section == 1 && indexPath.row == 2) {
        // 2 check if the cell has a datepicker object, if the cell doesnt have one create it.
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DatePickerCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DatePickerCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            // 3 create a datepicker and set its tag to 100 so it can be easily found at a later stage.
            UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 216.0f)];
            datePicker.tag = 100;
            [cell.contentView addSubview:datePicker];
            // 4 Tell the datepicker to call the method dateChanged. This is how we connect Actions from code instead of storyboards.
            [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        }
        return cell;
        // 5 for indexpaths that are not the datepicker cell refer back to the parents tableViewcellForRowAtIndexPath method to ensure that static cells are working as before.
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

/* 
 override the tableViewnumberOfRowsInSecion method.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //if section is the first and it has a datepicker then return 3 as the rows else call the normal tableViewnumberOfRowsInSection
    if (section == 1 && _datePickerVisible) {
        return 3;
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}


/* 
 Override tableViewheightForRowAtIndexPath method. 
 If the datepicker is selected then set the height to 217px, else call the parent method.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 2) {
        return 217.0f; //since the datepicker is 216 points tall + 1 for the separator line 217 points.
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

/* 
 show datepicker if the user selects the row that has a date picker.
 *****************
 STANDARD FUNCTIONALITY
 *****************
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES]; //deselects the table row.
    [self.textField resignFirstResponder]; //disables the keyboard
    if (indexPath.section == 1 && indexPath.row == 1) {
        if (!_datePickerVisible) {
            [self showDatePicker];
        } else {
            [self hideDatePicker];
        }
    }
}


/*
 If we manually add cells to a static cell, then we need to provide this method below to imitate the presence of 3 rows in the section even if in the storyboard do not exist. 
 */
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 2) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        return [super tableView:tableView indentationLevelForRowAtIndexPath:newIndexPath];
    } else {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

- (void)dateChanged:(UIDatePicker *)datePicker
{
    _dueDate = datePicker.date;
    [self updateDueDateLabel];
}

- (void)hideDatePicker
{
    if (_datePickerVisible) {
        _datePickerVisible = NO;
        NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:1 inSection:1];
        NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathDateRow];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

/*
 Hide the datepicker if the user taps on the textfield.
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self hideDatePicker];
}

@end