//
//  DTOAppDelegate.m
//  Dato
//
//  Created by Alexander Kolov on 13/02/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTOAppDelegate.h"

#import <TestFlightSDK/TestFlight.h>

#import "DTOCalendarViewController.h"

@implementation DTOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [TestFlight takeOff:@"c8f794e5-c69d-4c01-9176-a85662590b16"];

  DTOCalendarViewController *vc = [[DTOCalendarViewController alloc] init];
  UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:vc];

  [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
  [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont lightClavoFontOfSize:20.0f]}];

  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  self.window.rootViewController = navigation;
  [self.window makeKeyAndVisible];

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end