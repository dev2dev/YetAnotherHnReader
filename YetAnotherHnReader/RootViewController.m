//
//  RootViewController.m
//  HNReader
//
//  Created by dogan kaya berktas on 6/5/10.
//  Copyright Papirus Yazilim 2010. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"

#import "iPhoneRSS.h"
#import "XMLParser.h"

@implementation RootViewController

@synthesize detailViewController;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	//
	NSLog(@"fething HACKER NEWS data...");
	NSURL *url = [[NSURL alloc] initWithString:@"http://news.ycombinator.com/rss"];
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	
	//Initialize the delegate.
	XMLParser *parser = [[[XMLParser alloc] initXMLParser] autorelease];
	
	//Set delegate
	[xmlParser setDelegate:parser];
	[xmlParser parse];
	[xmlParser release];
	[url release];	
	
	items = [parser items];
	
}

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section 
{
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.adjustsFontSizeToFitWidth=YES;
    }

	Item *item = [items objectAtIndex:indexPath.row];
    cell.textLabel.text = [item title];
    
	if(indexPath == 0)
	{
		[cell setSelected:YES];
	}
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	[detailViewController setDetailItem:[items objectAtIndex:indexPath.row]];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc 
{
    [detailViewController release];
    [super dealloc];
}

@end

