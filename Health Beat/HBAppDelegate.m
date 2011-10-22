//
//  HBAppDelegate.m
//  Health Beat
//
//  Created by Rich Warren on 10/7/11.
//  Copyright (c) 2011 Freelance Mad Science Labs. All rights reserved.
//

#import "HBAppDelegate.h"
#import "WeightEntry.h"

static NSString* const UbiquitousWeightUnitDefaultKey = 
@"UbiquitousWeightUnitDefaultKey";

@implementation HBAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application 
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // since the delegate lasts throughout the life of the app, 
    // we don't need to unregester these notifications
    NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore defaultStore];
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter
     addObserverForName:
     NSUbiquitousKeyValueStoreDidChangeExternallyNotification
     object:store 
     queue:nil 
     usingBlock:^(NSNotification *note) {
         
         WeightUnit value = 
         (WeightUnit)[store longLongForKey:UbiquitousWeightUnitDefaultKey];
         
         setDefaultUnits(value);
         
     }];
    
    [notificationCenter
     addObserverForName:NSUserDefaultsDidChangeNotification
     object:[NSUserDefaults standardUserDefaults]
     queue:nil
     usingBlock:^(NSNotification *note) {
         
         int value = getDefaultUnits();
         
         [store setLongLong:value forKey:UbiquitousWeightUnitDefaultKey];
         
     }];
    
    
    [store synchronize];
    
    return YES;
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

@end
