/*
 Created by: Chris Moos 
 Web: http://www.chrismoos.com
 
 This file is part of iPhoneRSS.
 
 iPhoneRSS is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.
 
 iPhoneRSS is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Foobar; if not, write to the Free Software
 Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 
 */

#import "iPhoneRSS.h"

#import <UIKit/UIKit.h>

@implementation iPhoneRSS

- (iPhoneRSS*) initWithURL:(NSURL*)url
{
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	[parser setDelegate:self];
	
	items = [[NSMutableArray alloc] init];
	
	currentProperty = nil;
	curItem = nil;
	
	[parser parse];

	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"item"]) 
	{
		curItem = [[NSMutableDictionary alloc] init];
	}
	else if(curItem != nil) 
	{
		currentProperty = [[[NSString alloc] initWithString:elementName] retain];
	}
}

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
{
	if(curItem != nil && [elementName isEqualToString:@"item"]) 
	{
		[items addObject:curItem];
		[curItem release];
		curItem = nil;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string 
{	
	if(curItem != nil && currentProperty != nil && string != nil) 
	{
		NSString *trimmed2 = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		[curItem setObject:trimmed2 forKey:currentProperty];
		[currentProperty release];
		currentProperty = nil;
	}	
}

- (NSArray*)items 
{
	return items;
}

@end
