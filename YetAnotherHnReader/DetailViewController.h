//
//  DetailViewController.h
//  HNReader
//
//  Created by dogan kaya berktas on 6/5/10.
//  Copyright Papirus Yazilim 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "Item.h"

@interface DetailViewController : UIViewController 
<MFMailComposeViewControllerDelegate, UIActionSheetDelegate, 
UIWebViewDelegate, UIPopoverControllerDelegate, UISplitViewControllerDelegate> 
{    
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    
    Item *detailItem;
	
	IBOutlet UIWebView *mainWebView;
	IBOutlet UIWebView *commentWebView;
	
	UIView *transparentView;
	
	IBOutlet UISegmentedControl *segmented;
	IBOutlet UIBarButtonItem *home;
	IBOutlet UIBarButtonItem *back;
	IBOutlet UIBarButtonItem *forward;
	IBOutlet UIBarButtonItem *share;
	IBOutlet UIActivityIndicatorView *acivityIndicator;
	IBOutlet UIImageView *filView;
}

- (IBAction)changeView;
- (IBAction)browserAction:(id)sender;

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) Item *detailItem;
@property (nonatomic, retain) IBOutlet UIWebView *mainWebView;
@property (nonatomic, retain) IBOutlet UIWebView *commentWebView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmented;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *home;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *back;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *forward;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *share;

- (void)adjustViewsForOrientation:(UIInterfaceOrientation)orientation;
- (void)showSharePopup;

@end
