//
//  VMFavoriteTopicsLoader.m
//  v2exmobile
//
//  Created by 徐 可 on 3/19/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import "VMFavoriteTopicsLoader.h"
#import "Config.h"
#import "HTMLParser.h"

@implementation VMFavoriteTopicsLoader

- (void)loadFavoriteTopics
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/my/topics", V2EX_URL]];
    [self loadDataWithURL:url];
}

#pragma NSURLConnectoin Prototol
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    @try {
        NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc] initWithData:webdata error:&error];
        
        if (error) {
            return [_delegate cancel];
        }
        
        NSMutableArray *topics = [[NSMutableArray alloc] init];
        
        HTMLNode *bodyNode = [parser body];
        HTMLNode *contentDiv = [[bodyNode findChildrenWithAttribute:@"id" matchingName:@"Content" allowPartial:NO] objectAtIndex:0];
        HTMLNode *boxDiv = [contentDiv findChildOfClass:@"box"];
        NSArray *topicDivs = [boxDiv findChildrenWithAttribute:@"class" matchingName:@"cell from_" allowPartial:YES];
        for (HTMLNode *topicDiv in topicDivs) {
            NSString *imgURL = [[topicDiv findChildTag:@"img"] getAttributeNamed:@"src"];
            if (![imgURL hasPrefix:@"http://"]) {
                imgURL = [NSString stringWithFormat:@"%@%@", V2EX_URL, imgURL];
            }
            
            HTMLNode *titleNode = [[topicDiv findChildOfClass:@"bigger"] findChildTag:@"a"];
            NSString *title = [titleNode contents];
            NSString *url = [titleNode getAttributeNamed:@"href"];
            url = [NSString stringWithFormat:@"%@%@", V2EX_URL, url];
            
            NSArray *authorNodes = [topicDiv findChildTags:@"strong"];
            NSString *author = [[authorNodes objectAtIndex:0] allContents];
            NSString *nodeName = [[authorNodes objectAtIndex:1] allContents];
            
            NSString *created = [[topicDiv findChildOfClass:@"created"] allContents];
            NSString *replies = [[topicDiv findChildOfClass:@"fr"] allContents];
            
            [topics addObject:[[NSDictionary alloc] initWithObjectsAndKeys:author, @"author", title, @"title", url, @"url", imgURL, @"img_url", created, @"create", nodeName, @"node", replies, @"replies", nil]];
        }
        [_delegate didFinishedLoadingWithTopics:topics];
    }
    @catch (NSException *exception) {
        [_delegate cancel];
    }
    @finally {
    }
}

@end
