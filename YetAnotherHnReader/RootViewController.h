//
//  RootViewController.h
//  HNReader
//
//  Created by dogan kaya berktas on 6/5/10.
//  Copyright Papirus Yazilim 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface RootViewController : UITableViewController
{
    DetailViewController *detailViewController;
	
	NSArray *items;
	
	IBOutlet UIBarButtonItem *collapse;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;


@end
