//
//  XMLParser.h
//  XML
//
//  Created by iPhone SDK Articles on 11/23/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>

@class Item;

@interface XMLParser : NSObject <NSXMLParserDelegate>
{
	NSMutableString *currentElementValue;
	Item *deprem;	
	
	NSMutableArray *items;
}

- (XMLParser *) initXMLParser;

@property (nonatomic, retain) NSMutableArray *items;

@end
