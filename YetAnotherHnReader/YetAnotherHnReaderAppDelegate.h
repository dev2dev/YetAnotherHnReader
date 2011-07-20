//
//  YetAnotherHnReaderAppDelegate.h
//  YetAnotherHnReader
//
//  Created by dogan kaya berktas on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@class DetailViewController;
@class Reachability;

@interface YetAnotherHnReaderAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
    
    UISplitViewController *splitViewController;
    
    RootViewController *rootViewController;
    DetailViewController *detailViewController;
	
	Reachability* internetReach;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

- (void)updateInterfaceWithReachability:(Reachability *)curReach;

@end
