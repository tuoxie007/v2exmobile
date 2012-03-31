//
//  VMFavoriteTopicsLoader.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/19/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
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
            
            NSString *created = [[[topicDiv findChildOfClass:@"created"] allContents]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *replies = [[[topicDiv findChildOfClass:@"fr"] allContents]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
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
