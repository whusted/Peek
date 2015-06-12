//
//  AppDelegate.m
//  Peek
//
//  Created by Willy Husted on 6/3/14.
//  Copyright (c) 2014 Willy Husted. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSThread sleepForTimeInterval:1];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"]];
    NSString *applicationId = [dictionary objectForKey:@"parseApplicationId"];
    NSString *clientKey = [dictionary objectForKey:@"parseClientKey"];
    NSLog(@" App id: %@", applicationId);
    NSLog(@"Client Key: %@", clientKey);
    //add your parse keys here
    [Parse setApplicationId:applicationId
                  clientKey:clientKey];
    
//    [Parse setApplicationId:@"HNH8hU7G3Ok2Wd3DDN497J1IwwYPT3Waon9v1PB9"
//                  clientKey:@"3QorkrOootDlklE3a5gejLwARYkezBwnrOxEBNdE"];
    
    [self customizeUserInterface];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Helper methods

-(void)customizeUserInterface
{
    // Nav bar customization
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBarBackground"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // Tab bar customization
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    // Set root view controller
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    
    UITabBarItem *tabInbox = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabFriends = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabCamera = [tabBar.items objectAtIndex:2];
    
    (void) [tabInbox initWithTitle:(NSString *)@"Inbox" image:[UIImage imageNamed:@"inbox"] selectedImage:[UIImage imageNamed:@"inbox"]];
    (void) [tabFriends initWithTitle:(NSString *)@"Friends" image:[UIImage imageNamed:@"friends"] selectedImage:[UIImage imageNamed:@"friends"]];
    (void) [tabCamera initWithTitle:(NSString *)@"Camera" image:[UIImage imageNamed:@"camera"] selectedImage:[UIImage imageNamed:@"camera"]];
    
    tabBar.tintColor = [UIColor whiteColor];
}


@end
