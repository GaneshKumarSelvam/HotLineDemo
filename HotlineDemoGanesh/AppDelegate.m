//
//  AppDelegate.m
//  HotlineDemoGanesh
//
//  Created by Tarun Sharma on 19/07/17.
//  Copyright © 2017 Chetaru Web LInk Private Limited. All rights reserved.
//

#import "AppDelegate.h"
#import <HotlineSDK/Hotline.h>
@interface AppDelegate ()
@property (nonatomic, strong)UIViewController *rootController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self hotlineIntegration];
    if( SYSTEM_VERSION_LESS_THAN( @"10.0" ) )
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |    UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        
    }
    else
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        // [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * error)
         {
             if (granted==NO) {
                 NSLog(@"Didnt allowed");
                 UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Notification Services Disabled!"  message:@"Please open this app's settings enable Notifications to get important Updates!"  preferredStyle:UIAlertControllerStyleAlert];
                 [alertController addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                             {
                                                 @try
                                                 {
                                                     NSLog(@"tapped Settings");
                                                     BOOL canOpenSettings = (UIApplicationOpenSettingsURLString != NULL);
                                                     if (canOpenSettings)
                                                     {
                                                         NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                         [[UIApplication sharedApplication] openURL:url];
                                                     }
                                                 }
                                                 @catch (NSException *exception)
                                                 {
                                                     
                                                 }
                                             }]];
                 [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
                 UINavigationController *nvc = (UINavigationController *)[[application windows] objectAtIndex:0].rootViewController;
                 UIViewController *vc = nvc.visibleViewController;
                 dispatch_async(dispatch_get_main_queue(), ^{
                     // UI UPDATE 3
                     [vc presentViewController:alertController animated:YES completion:nil];
                 });
                 
             }
             if(error)
             {
                 NSLog( @"Push registration FAILED" );
                 NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                 NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );
             }
             else
             {
                 [[UIApplication sharedApplication] registerForRemoteNotifications];  // required to get the app to do anything at all about push notifications
                 NSLog( @"Push registration success." );
                 
                 
             }
         }];
    }
    if ([[Hotline sharedInstance]isHotlineNotification:launchOptions]) {
        [[Hotline sharedInstance]handleRemoteNotification:launchOptions andAppstate:application.applicationState];
    }

    return YES;
}
-(void)hotlineIntegration{
    
    
    HotlineConfig *config = [[HotlineConfig alloc]initWithAppID:@"2667958a-7f29-4cd0-9f09-13031c3f3179" andAppKey:@"eb8bdaa1-1938-46a7-93d7-75a84d029f1c"];
    config.voiceMessagingEnabled = YES;
    config.pictureMessagingEnabled = YES;
    
    // Initialize Hotline
    [[Hotline sharedInstance]initWithConfig:config];
    
    // Setup user info
    HotlineUser *user = [HotlineUser sharedInstance];
    user.name = @"Ganesh Kumar";
    user.email = @"ganeshkumarbandari04@gmail.com";
    user.phoneCountryCode = @"+91";
    user.phoneNumber = @"9111912159";
    
    [[Hotline sharedInstance] updateUser:user];
    
    //Update user properties with custom key
    [[Hotline sharedInstance] updateUserProperties:@{
                                                     @"paid_user" : @"yes",
                                                     @"plan" : @"blossom" }];
    
    
    [[Hotline sharedInstance]unreadCountWithCompletion:^(NSInteger count) {
        NSLog(@"Unread count (Async) : %d", (int)count);
    }];
}



- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    NSLog(@"Registered Device Token  %@", devToken);
    NSLog(@"is app registered for notifications :: %d" , [[UIApplication sharedApplication] isRegisteredForRemoteNotifications]);
    [[Hotline sharedInstance] updateDeviceToken:devToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to register remote notification  %@", error);
}

- (void) application:(UIApplication *)app didReceiveRemoteNotification:(NSDictionary *)info{
    if ([[Hotline sharedInstance]isHotlineNotification:info]) {
        [[Hotline sharedInstance]handleRemoteNotification:info andAppstate:app.applicationState];
    }
}



/*
 Sample URLs to test Deep link
 hotline://?launch=chatScreen
 */
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([url.scheme isEqualToString:@"hotline"]) {
        if ([url.query isEqualToString:@"launch=chatScreen"]) {
            NSLog(@"Lauch chat screen");
        }
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   // NSInteger unreadCount;
    [[Hotline sharedInstance]unreadCountWithCompletion:^(NSInteger count) {
         [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
        NSLog(@"Unread count (Async) : %d", (int)count);
    }];

   
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
