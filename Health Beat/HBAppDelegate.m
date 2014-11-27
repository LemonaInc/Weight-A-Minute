//
//  HBAppDelegate.m
//  Super Health
//
//  Created by Jaxon Stevens on 2013-01-20.
//  Copyright (c) 2013 Jaxon Stevens. All rights reserved.
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
    
    [Pushbots getInstance];
    
    NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo) {
        // Notification Message
        NSString* notificationMsg = [userInfo valueForKey:@"message"];
        // Custom Field
        NSString* title = [userInfo valueForKey:@"title"];
        NSLog(@"Notification Msg is %@ and Custom field title = %@", notificationMsg , title);
    }
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

-(void)onReceivePushNotification:(NSDictionary *) pushDict andPayload:(NSDictionary *)payload {
    [payload valueForKey:@"title"];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"New Alert !" message:[pushDict valueForKey:@"alert"] delegate:self cancelButtonTitle:@"Thanks !" otherButtonTitles: @"Open",nil];
    [message show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Open"]) {
        [[Pushbots getInstance] OpenedNotification];
        // set Badge to 0
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        // reset badge on the server
        [[Pushbots getInstance] resetBadgeCount];
    }
}

@end
