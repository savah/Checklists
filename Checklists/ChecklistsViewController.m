//
//  ChecklistsViewController.m
//  Checklists
//
//  Created by Paris Kapsouros on 10/21/13.
//  Copyright (c) 2013 Paris Kapsouros. All rights reserved.
//

#import "ChecklistsViewController.h"

@interface ChecklistsViewController ()

@end

@implementation ChecklistsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//the view controller provides the number of rows to the UITableView (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
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
    
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    
    if (indexPath.row % 5 == 0) {
        label.text = @"Walk the dog";
    } else if (indexPath.row % 5 == 1){
        label.text = @"Brush my teeth";
    } else if (indexPath.row % 5 == 2) {
        label.text = @"Learn iOS development";
    } else if (indexPath.row % 5 == 3) {
        label.text = @"Soccer practice";
    } else if (indexPath.row % 5 == 4) {
        label.text = @"Eat ice cream";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
