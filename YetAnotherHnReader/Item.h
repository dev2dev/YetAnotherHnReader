//
//  Item.h
//  HNReader
//
//  Created by dogan kaya berktas on 6/6/10.
//  Copyright 2010 Papirus Yazilim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject 
{
	NSString *title;
	NSString *link;
	NSString *comments;
	NSString *description;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *comments;
@property (nonatomic, retain) NSString *description;

@end
