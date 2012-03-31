//
//  VMMemberLoader.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/20/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMMemberLoader.h"
#import "Config.h"
#import "HTMLParser.h"

@implementation VMMemberLoader

- (void)loadMemberWithURL:(NSURL *)url
{
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
        
        NSMutableArray *postedTopics = [[NSMutableArray alloc] init];
        NSMutableArray *partedTopics = [[NSMutableArray alloc] init];
        
        HTMLNode *bodyNode = [parser body];
        
        HTMLNode *contentDiv = [bodyNode findChildWithAttribute:@"id" matchingName:@"Content" allowPartial:NO];
        
        NSArray *cellDivs = [[contentDiv findChildOfClass:@"box"] findChildrenOfClass:@"cell"];
        HTMLNode *innerDiv = [contentDiv findChildOfClass:@"inner"];
        cellDivs = [NSMutableArray arrayWithArray:cellDivs];
        [((NSMutableArray *)cellDivs) addObject:innerDiv];
        
        NSString *followURL = [[[cellDivs objectAtIndex:0] findChildTag:@"a"] getAttributeNamed:@"href"];
        if (followURL == nil) {
            followURL = @"";
        } else if (![followURL hasPrefix:@"http://"]) {
            followURL = [NSString stringWithFormat:@"%@%@", V2EX_URL, followURL];
        }
        NSString *name = [[contentDiv findChildTag:@"h2"] contents];
        NSString *imgURL = [[contentDiv findChildTag:@"img"] getAttributeNamed:@"src"];
        NSString *level = @"";
        HTMLNode *levelNode = [contentDiv findChildOfClass:@"fade bigger"];
        if (levelNode) {
            level = [[contentDiv findChildOfClass:@"fade bigger"] contents];
        }
        NSString *partin = [[contentDiv findChildOfClass:@"snow"] contents];
        NSArray *tdNodes = [[[[cellDivs objectAtIndex:0] findChildTag:@"table"] findChildTag:@"table"] findChildTags:@"td"];
        NSMutableArray *associatedSites = [[NSMutableArray alloc] init];
        for (HTMLNode *tdNode in tdNodes) {
            HTMLNode *imgNode = [tdNode findChildTag:@"img"];
            NSString *iconURL = [imgNode getAttributeNamed:@"src"];
            HTMLNode *linkNode = [tdNode findChildTag:@"a"];
            NSString *text = [linkNode contents];
            NSString *url = [linkNode getAttributeNamed:@"href"];
            if (imgNode && linkNode) {
                [associatedSites addObject:[[NSDictionary alloc] initWithObjectsAndKeys:iconURL, @"icon_url", text, @"text", url, @"url", nil]];
            }
        }
        NSString *desc = @"";
        if ([cellDivs count] > 1) {
            desc = [[[cellDivs lastObject] allContents]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        
        NSArray *boxDivs = [contentDiv findChildrenOfClass:@"box"];
        
        HTMLNode *postedTable = [[boxDivs objectAtIndex:1] findChildTag:@"table"];
        NSArray *postedTrs = [postedTable findChildTags:@"tr"];
        postedTrs = [postedTrs subarrayWithRange:NSMakeRange(1, [postedTrs count]-1)];
        for (HTMLNode *tr in postedTrs) {
            NSArray *tds = [tr findChildTags:@"td"];
            
            NSString *replies = [[[tds objectAtIndex:0] findChildTag:@"span"] contents];
            
            HTMLNode *titleNode = [[tds objectAtIndex:1] findChildTag:@"a"];
            NSString *title = [titleNode contents];
            NSString *url = [titleNode getAttributeNamed:@"href"];
            url = [NSString stringWithFormat:@"%@%@", V2EX_URL, url];
            
            HTMLNode *replierNode = [[tds objectAtIndex:2] findChildTag:@"a"];
            NSString *author = [replierNode contents];
            NSString *authorURL = [replierNode getAttributeNamed:@"href"];
            
            NSString *lastReplyTime = [[[tds objectAtIndex:3] findChildTag:@"small"] contents];
            
            [postedTopics addObject:[NSDictionary dictionaryWithObjectsAndKeys:replies, @"replies", title, @"title", url, @"url", author, @"author", authorURL, @"author_url", lastReplyTime, @"last_reply_time", nil]];
        }
        
        HTMLNode *partedTable = [[boxDivs objectAtIndex:2] findChildTag:@"table"];
        NSArray *partedTrs = [partedTable findChildTags:@"tr"];
        partedTrs = [partedTrs subarrayWithRange:NSMakeRange(1, [partedTrs count]-1)];
        for (HTMLNode *tr in partedTrs) {
            NSArray *tds = [tr findChildTags:@"td"];
            
            NSString *replies = [[[tds objectAtIndex:0] findChildTag:@"span"] contents];
            
            HTMLNode *titleNode = [[tds objectAtIndex:1] findChildTag:@"a"];
            NSString *title = [titleNode contents];
            NSString *url = [titleNode getAttributeNamed:@"href"];
            url = [NSString stringWithFormat:@"%@%@", V2EX_URL, url];
            
            HTMLNode *replierNode = [[tds objectAtIndex:2] findChildTag:@"a"];
            NSString *author = [replierNode contents];
            NSString *authorURL = [replierNode getAttributeNamed:@"href"];
            
            NSString *lastReplyTime = [[[tds objectAtIndex:3] findChildTag:@"small"] contents];
            
            [partedTopics addObject:[NSDictionary dictionaryWithObjectsAndKeys:replies, @"replies", title, @"title", url, @"url", author, @"author", authorURL, @"author_url", lastReplyTime, @"last_reply_time", nil]];
        }
        [_delegate didFinishedLoadingWithData:[NSDictionary dictionaryWithObjectsAndKeys:postedTopics, @"posted_topics", partedTopics, @"parted_topics", followURL, @"follow_url", name, @"name", imgURL, @"img_url", level, @"level", partin, @"partin", associatedSites, @"associated_sites", desc, @"desc", nil]];
    }
    @catch (NSException *exception) {
        [_delegate cancel];
    }
    @finally {
    }
}

@end
