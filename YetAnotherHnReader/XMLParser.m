#import "XMLParser.h"

#import "Item.h"

@implementation XMLParser

@synthesize items;

- (XMLParser *) initXMLParser 
{	
	[super init];	
	items = [[NSMutableArray alloc] init];
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName  
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName 
    attributes:(NSDictionary *)attributeDict 
{	
	if([elementName isEqualToString:@"item"]) 
	{				
		//Initialize the item.
		deprem = [[Item alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string 
{ 	
	if(!currentElementValue) 
	{
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	}
	else
	{
		[currentElementValue appendString:string];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{			
	//
	if([elementName isEqualToString:@"item"])
	{
		[items addObject:deprem];		
		[deprem release];
		deprem = nil;		
	}
	else
	{
		NSString *trimmed2 = [currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		[deprem setValue:trimmed2 	forKey: elementName];		
	}
	
	[currentElementValue release];
	currentElementValue = nil;
}

- (void) dealloc 
{	
	[deprem release];	
	[currentElementValue release];
	[super dealloc];
}

@end
