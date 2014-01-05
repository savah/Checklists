//
//  ChecklistsViewController.m
//  Checklists
//
//  Created by Paris Kapsouros on 10/21/13.
//  Copyright (c) 2013 Paris Kapsouros. All rights reserved.
//

#import "ChecklistViewController.h"
#import "ChecklistItem.h"
#import "Checklist.h"

@interface ChecklistViewController ()

@end

@implementation ChecklistViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.checklist.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 
 UITableView’s data source protocol
 
 */

//the view controller provides the number of rows to the UITableView (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.checklist.items count];
}

- (void)configureCheckmarkForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item
{
    UILabel *label = (UILabel *)[cell viewWithTag:1001];
    if (item.checked) {
        label.text = @"√";
    } else {
        label.text = @"";
    }
    label.textColor = self.view.tintColor;
}

- (void)configureTextForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item
{
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    label.text = item.text;
}



/*
 Carefull that the identifier is the same as the one declared at storyboard.
 the view controller provides the actual data to the UITableView (tableView), when the tableview asks for it.
 indexPath --> NSIndexPath is simply an object that points to a specific row in the table.
 indexPath.row property to find out for which row this cell is intended
 indexPath.section property to find out to which section a row belongs
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChecklistItem"];
    ChecklistItem *item = self.checklist.items[indexPath.row];
    [self configureTextForCell:cell withChecklistItem:item];
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    return cell;
}

/*
 
 end of UITableView’s data source protocol

*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ChecklistItem *item = self.checklist.items[indexPath.row];
    [item toggleChecked];
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



/*
 swipe to delete implementations
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.checklist.items removeObjectAtIndex:indexPath.row];
    
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

/*
 
 start of interface functions implementation
 
 */

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ChecklistItem *)item
{

    //always when we add a new item to an array we add to the the element that is equal to the count of the items of the array.
    NSInteger newRowIndex = [self.checklist.items count];
    [self.checklist.items addObject:item];

    //NSIndexPath object that points to the new row, using the row number from the newRowIndex variable.
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];

    //new temporary array
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItem *)item
{
    NSInteger index = [self.checklist.items indexOfObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self configureTextForCell:cell withChecklistItem:item];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
 
 end of interface functions implementation
 
 */


/* this is how we set this current controller a delegate of another (in this instance, the AddItemView one).
 
 We are using the prepareForSegue method, which is the one before the segue gets called.
 
 if the segue that is going to be active is the additem one
 1) get the navigation controller that is going to be called
 2) gets its top view controller that is the controller that the navigation controller embeds in
 3) set the target controller delegate to self
 
 
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddItem"]) {
        //1
        UINavigationController *navigationController = segue.destinationViewController;
        //destinationviewcontroller will be the navigation controller that embeds the add item view
        
        
        //2 gets the currently active viewcontroller inside the navigation controller.
        ItemDetailViewController *controller = (ItemDetailViewController *) navigationController.topViewController;
        
        //3 sets the addviewitems delegate to self (checklistsview controller)
        controller.delegate = self;
    } else if ([segue.identifier isEqualToString:@"EditItem"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        
        ItemDetailViewController *controller = (ItemDetailViewController *) navigationController.topViewController;
        
        controller.delegate = self;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        controller.itemToEdit = self.checklist.items[indexPath.row];
    }
}

@end
