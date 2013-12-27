//
//  AllListsViewController.m
//  Checklists
//
//  Created by Paris Kapsouros on 17/11/13.
//  Copyright (c) 2013 Paris Kapsouros. All rights reserved.
//

#import "AllListsViewController.h"
#import "Checklist.h"
#import "ChecklistViewController.h"
#import "ChecklistItem.h"
#import "DataModel.h"

@interface AllListsViewController ()

@end

@implementation AllListsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

//this is called after the controller becomes visible
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self; //makes itself delegate for the navigation controller. This serves a dual purpose. Since the delegate is set after the controller becomes visible the delegate method (willShowViewController) will not run. The second time this will be called after willShowViewController. Since then the index will be -1 the segue will not be performed again.
    
    NSInteger index = [self.dataModel indexOfSelectedChecklist]; //set the current integer that is stored in the nsdefaults to a nsinteger variable. this allows us to see if the user was in the default screen or another screen.
    
    if (index >= 0 && index < [self.dataModel.lists count]) {
        Checklist *checklist = self.dataModel.lists[index];
        [self performSegueWithIdentifier:@"ShowChecklist" sender:checklist];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataModel.lists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    /*
     the method below asks the table view controller if a table view cell can be dequed and reused. If it can reuse a cell this method returns the cell whereas if it cannot dequeue a cell it returns nil where we need to alloc and init a new cell as shown below.
    */
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //UITableViewCellStyleSubtitle means a cell with a subtitle.
    }
    
    // Configure the cell...
    
    Checklist *checklist = self.dataModel.lists[indexPath.row];
    
    cell.textLabel.text =checklist.name;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    /*
        Make the detaillabel text of the table view
     */
    
    int count = [checklist countUncheckedItems];
    if ([checklist.items count] == 0) {
        cell.detailTextLabel.text = @"(No items)";
    } else if (count == 0 ) {
        cell.detailTextLabel.text = @"All Done!";
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d Remaining", count];
    }
    
    
    
    return cell;
}

/*
 ******************** VERY IMPORTANT **********************
 
 Common mistake to use didDeselectRowAtIndexPath instead of didSelectRowAtIndexPath. The first selects the row when another one is deselected whereas the second applies the common behavior of selecting the row when the user taps in it.
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataModel setIndexOfSelectedChecklist:indexPath.row]; //store the index of the selected row into NSUserDefaults under the key  "ChecklistsIndex"
    
    Checklist *checklist = self.dataModel.lists[indexPath.row];
    
    [self performSegueWithIdentifier:@"ShowChecklist" sender:checklist]; //manually perform segue. We manually perform it since we want to pass an object with it.
}

/*
 This happens before the segue is visualized in the screen. In the didSelectRowAtIndexPath we send through the performSegueWithIdentifier the Checklist object.
 In the prepareForSegue this object is sent through the sender method variable.
 We use this variable to set the checklist to appear in the destination view controller.
 
 
 In the second if We look for the view controller inside the navigation controller (which is the ListDetailViewController) and set its delegate property to self.
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowChecklist"]) {
        ChecklistViewController *controller = segue.destinationViewController; //the application segues into checklistview controller.
        controller.checklist = sender; //the checklist object that belongs to that row is passed along.
    } else if ([segue.identifier isEqualToString:@"AddChecklist"]){
        UINavigationController *navigationController = segue.destinationViewController; //get the navigation controller that the addchecklist segue is pointing
        ListDetailViewController *controller = (ListDetailViewController *) navigationController.topViewController; //get the top view controller that the navigation controller is showing. On this occasion this is the listdetail view controller.
        controller.delegate = self; //set the listdetailsviewcontroller delegate to self ( this controller ).
        controller.checklistToEdit = nil;
    }
}

- (void)listDetailViewControllerDidCancel: (ListDetailViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingChecklist:(Checklist *)checklist
{
    [self.dataModel.lists addObject:checklist];
    [self.dataModel sortChecklists];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(Checklist *)checklist
{
    [self.dataModel sortChecklists];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataModel.lists removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListNavigationController"]; //instantiate the navigation controller.
    ListDetailViewController *controller = (ListDetailViewController *) navigationController.topViewController; //Get the toopviewcontroller of this navigation controller. This is being casted as listdetailview controller.
    
    controller.delegate = self; //Set the delegate of the listdetailviewcontroller to self (alllistsviewcontroller)
    Checklist *checklist = self.dataModel.lists[indexPath.row]; //sets the checklist object to the lists item at the speficic indexpath row.
    controller.checklistToEdit = checklist; //sets the checklist to edit at the target controller (listdetailviewcontroller)
    
    [self presentViewController:navigationController animated:YES completion:nil]; //presents the view controller with the standard way.
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

/*
 This method is called whenever the navigation controller will slide to a new screen. If the back button was pressed, then the new view controller is AllListsViewController itself and you set the “ChecklistIndex” value in NSUserDefaults to -1, meaning that no checklist is currently selected.
*/
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self) {
        [self.dataModel setIndexOfSelectedChecklist:-1];
    }
}

@end
