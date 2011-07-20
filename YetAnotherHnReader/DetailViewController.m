//
//  DetailViewController.m
//  HNReader
//
//  Created by dogan kaya berktas on 6/5/10.
//  Copyright Papirus Yazilim 2010. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ShareViewController.h"
#import <MessageUI/MessageUI.h>
#import "Item.h"

@interface DetailViewController ()

@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize toolbar, popoverController, detailItem;
@synthesize mainWebView, commentWebView;

@synthesize segmented;

@synthesize home, back, forward, share;

#pragma mark -
#pragma mark Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(Item *)newDetailItem 
{	
    if (detailItem != newDetailItem) 
	{
        [detailItem release];
        detailItem = [newDetailItem retain];
        
        // Update the view.
        [self configureView];
    }

    if (popoverController != nil) 
	{
        [popoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView 
{	
	//[acivityIndicator startAnimating];
	//acivityIndicator.center = self.view.center;
	//
	//[self showLoadingView];

	
	NSLog(@"configureView is running...");
	
	[mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[detailItem link]]]];
	[commentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[detailItem comments]]]];
	
	commentWebView.hidden = TRUE;
	
	NSLog(@"configureView is done..!");
	segmented.selectedSegmentIndex = 0;
	
}

#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc 
{
    NSLog(@"willHideViewController...1");
	
    barButtonItem.title = @"HN";
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem 
{
	NSLog(@"willShowViewController...");
	
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration 
{
	[self adjustViewsForOrientation:toInterfaceOrientation];
}

- (void)adjustViewsForOrientation:(UIInterfaceOrientation)orientation
{
	if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
	{
		mainWebView.frame = CGRectMake(0, 44, 704, 704);
		commentWebView.frame = CGRectMake(0, 44, 704, 704);
	}
	else if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		mainWebView.frame = CGRectMake(0, 44, 768, 960);
		commentWebView.frame = CGRectMake(0, 44, 768, 960);
	} 
}


#pragma mark -
#pragma mark View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	[self adjustViewsForOrientation:self.interfaceOrientation];
}

- (void)viewDidUnload 
{
    self.popoverController = nil;
}

-(IBAction)changeView
{		
	if(segmented.selectedSegmentIndex == 0)
	{
		mainWebView.hidden = NO;
		commentWebView.hidden = YES;
	}
	else if (segmented.selectedSegmentIndex == 1)
	{
		mainWebView.hidden = YES;
		commentWebView.hidden = NO;
	}
}

#pragma mark -
#pragma mark Memory management
- (void)webViewDidStartLoad:(UIWebView *)webView
{
	if(webView == mainWebView )
	{
		[acivityIndicator startAnimating];
	}
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	filView.hidden = TRUE;
	
	if(webView == mainWebView)
	{
		[acivityIndicator stopAnimating];
	}
}

-(void)showLoadingView
{
	CGRect transparentViewFrame = CGRectMake(0.0, 0,100,100);
	transparentView = [[UIView alloc] initWithFrame:transparentViewFrame];
	transparentView.center = self.view.center;
	transparentView.backgroundColor = [UIColor lightGrayColor];
	transparentView.alpha = 0.9;
	transparentView.layer.cornerRadius = 5;

	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	spinner.center = transparentView.center;
	[spinner startAnimating];
	
	UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 80, 30)];
	messageLabel.textAlignment = UITextAlignmentCenter;
	messageLabel.text = @"loading...";
	
	[transparentView addSubview:spinner];
	[transparentView addSubview:messageLabel];
	
	[self.view addSubview:transparentView];
	
	[messageLabel release];
	[spinner release];
	[transparentView release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0)
	{
		
		ShareViewController *switchV = [[ShareViewController alloc] init];
		
		UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:switchV];
		[pop presentPopoverFromBarButtonItem:share permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
		//[pop setPopoverContentSize:CGSizeMake(200.0, 200.0)];

		NSString *parameterString = [NSString stringWithFormat:@"%@ -- %@", [detailItem title], [detailItem comments]];
		
		NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																					   NULL,
																					   (CFStringRef)parameterString,
																					   NULL,
																					   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																					   kCFStringEncodingUTF8 );
		
		
		NSString *twiturl =  [NSString stringWithFormat:@"http://twitter.com/home?status=%@", encodedString];
		
		[(UIWebView *)[switchV view] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:twiturl]]];
		[switchV release];
	}
	else if(buttonIndex == 1)
	{
		ShareViewController *switchV = [[ShareViewController alloc] init];
		
		UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:switchV];
		[pop presentPopoverFromBarButtonItem:share permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
		[pop setPopoverContentSize:CGSizeMake(600.0, 300.0)];
		
		NSString *parameterString = [NSString stringWithFormat:@"%@",[detailItem comments]];
		
		NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																					   NULL,
																					   (CFStringRef)parameterString,
																					   NULL,
																					   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																					   kCFStringEncodingUTF8 );
		
		NSString *twiturl =  [NSString stringWithFormat:@"http://www.facebook.com/sharer.php?u=%@", encodedString];
		
		[(UIWebView *)[switchV view] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:twiturl]]];
		[switchV release];
	}
	else if(buttonIndex == 2)
	{
		MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
		controller.mailComposeDelegate = self;
		[controller setSubject:[NSString stringWithFormat: @"Check out this link -- %@", [detailItem title]]];
		[controller setMessageBody:[NSString stringWithFormat:@"%@ <br><br>--<br>This mail is send by <b>Yet Another HN iPad Reader Application</b>",[detailItem comments]] isHTML:YES];
		[self presentModalViewController:controller animated:YES];
		[controller release];
	}

}

- (void)mailComposeController:(MFMailComposeViewController*)controller 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error 
{
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)browserAction:(id)sender;
{
	//mainview
	if(segmented.selectedSegmentIndex == 0)
	{
		//home
		if([sender tag] == 0)
		{
			[mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[detailItem link]]]];
		}
		//back
		else if([sender tag] == 1)
		{
			[mainWebView goBack];
		}
		//forward
		else if([sender tag] == 2)
		{
			[mainWebView goForward];
		}
		//share
		else if([sender tag] == 3)
		{
			[self showSharePopup];
		}
	}
	//commentview
	else 
	{
		//home
		if([sender tag] == 0)
		{
			[commentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[detailItem comments]]]];
		}
		//back
		else if([sender tag] == 1)
		{
			[commentWebView goBack];
		}
		//forward
		else if([sender tag] == 2)
		{
			[commentWebView goForward];
		}
		//share
		else if([sender tag] == 3)
		{
			[self showSharePopup];
		}
	}
}

- (void)showSharePopup
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:@"Share"
								  delegate:self 
								  cancelButtonTitle:@"No way!"
								  destructiveButtonTitle:nil
								  otherButtonTitles:@"Twitter",@"Facebook", @"Email",nil];
	
	
	actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
	
	[actionSheet showFromBarButtonItem:share animated:YES];
	[actionSheet release]; 
}

- (void)dealloc 
{
    [popoverController release];
    [toolbar release];
    
    [detailItem release];
    [super dealloc];
}

@end
