//
//  ChecklistsAppDelegate.m
//  Checklists
//
//  Created by Paris Kapsouros on 10/21/13.
//  Copyright (c) 2013 Paris Kapsouros. All rights reserved.
//

#import "ChecklistsAppDelegate.h"
#import "AllListsViewController.h"
#import "DataModel.h"

/*
 You can consider the app delegate to be the top-level object in your app.
 Therefore it makes sense to make it the “owner” of the data model.
 The app delegate then gives this DataModel object to all the view controllers that need to use it.
 */

@implementation ChecklistsAppDelegate
{
    DataModel *_dataModel;
}

//this function is called as soon as the application starts up
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _dataModel = [[DataModel alloc] init]; //create the datamodel object
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController; //we find the root view controller
    AllListsViewController *controller = navigationController.viewControllers[0]; //we get the first navigation controller which is the alllistsviewcontroller
    controller.dataModel = _dataModel; //we set its datamodel property to the one we just instantiated
    
    return YES;
}

//function that shows the local notification to the console.
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"didReceiveLocalNotification %@", notification);
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)saveData
{
    [_dataModel saveChecklists];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self saveData];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveData];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
