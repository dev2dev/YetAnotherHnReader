//
//  YetAnotherHnReaderAppDelegate.m
//  YetAnotherHnReader
//
//  Created by dogan kaya berktas on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YetAnotherHnReaderAppDelegate.h"
#import "RootViewController.h"
#import "DetailViewController.h"
#import "Reachability.h"
#import "LocalyticsSession.h"

@implementation YetAnotherHnReaderAppDelegate

@synthesize window=_window;
@synthesize splitViewController, rootViewController, detailViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"localitics_key" ofType:@""];
    NSString *localitics_key = [NSString stringWithContentsOfFile:fullPath encoding:NSASCIIStringEncoding error:nil];
    
    // Override point for customization after application launch.
    [[LocalyticsSession sharedLocalyticsSession] startSession:localitics_key];
    
	internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifer];
	[self updateInterfaceWithReachability:internetReach];
    
    
    self.window.rootViewController = splitViewController;
    [window makeKeyAndVisible];
    
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
	[[LocalyticsSession sharedLocalyticsSession] close];
	[[LocalyticsSession sharedLocalyticsSession] upload];
}

- (void)applicationWillEnterForeground:(UIApplication *)application 
{
 	[[LocalyticsSession sharedLocalyticsSession] resume];
	[[LocalyticsSession sharedLocalyticsSession] upload];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)updateInterfaceWithReachability:(Reachability *)curReach
{   		
	NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    switch (netStatus)
    {
        case NotReachable:
        {
			UIAlertView *charAlert = [[UIAlertView alloc]   initWithTitle:@"Connection Problem"  
                                                                  message:@"There is no internet connection so I can not show you the feed."  
                                                                 delegate:nil  
                                                        cancelButtonTitle:@"Ok"  
                                                        otherButtonTitles:nil];
			
			[charAlert show];
			[charAlert autorelease];
			
            break;
        }
            
        case ReachableViaWWAN:
        case ReachableViaWiFi:
        {
            
            break;
		}
	}			
}


- (void)dealloc
{
    [splitViewController release];
    [_window release];
    [super dealloc];
}

@end
