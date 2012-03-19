//
//  VMMemberLoader.m
//  v2exmobile
//
//  Created by 徐 可 on 3/20/12.
//  Copyright (c) 2012 TVie. All rights reserved.
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
        NSArray *boxDivs = [contentDiv findChildrenOfClass:@"box"];
        
        HTMLNode *postedTable = [[boxDivs objectAtIndex:1] findChildTag:@"table"];
        NSArray *postedTrs = [postedTable findChildTags:@"tr"];
        postedTrs = [postedTrs subarrayWithRange:NSMakeRange(1, [postedTrs count]-1)];
        for (HTMLNode *tr in postedTrs) {
            NSArray *tds = [tr findChildTags:@"td"];
            HTMLNode *titleNode = [[tds objectAtIndex:1] findChildTag:@"a"];
            NSString *title = [titleNode contents];
            NSString *url = [titleNode getAttributeNamed:@"href"];
            
            HTMLNode *replierNode = [[tds objectAtIndex:2] findChildTag:@"a"];
            NSString *member = [replierNode contents];
            NSString *memberURL = [replierNode getAttributeNamed:@"href"];
            
            HTMLNode *lastReplyTimeNode = [[tds objectAtIndex:3] findChildTag:@"small"];
            NSString *lastReplyTime = [lastReplyTimeNode contents];
            
            [postedTopics addObject:[NSDictionary dictionaryWithObjectsAndKeys:title, @"title", url, @"url", member, @"member", memberURL, @"member_url", lastReplyTime, @"last_reply_time", nil]];
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
            
            HTMLNode *replierNode = [[tds objectAtIndex:2] findChildTag:@"a"];
            NSString *member = [replierNode contents];
            NSString *memberURL = [replierNode getAttributeNamed:@"href"];
            
            NSString *lastReplyTime = [[[tds objectAtIndex:3] findChildTag:@"small"] contents];
            
            [partedTopics addObject:[NSDictionary dictionaryWithObjectsAndKeys:replies, @"replies", title, @"title", url, @"url", member, @"member", memberURL, @"member_url", lastReplyTime, @"last_reply_time", nil]];
        }
        [_delegate didFinishedLoadingWithData:[NSDictionary dictionaryWithObjectsAndKeys:postedTopics, @"posted_topics", partedTopics, @"parted_topics", nil]];
    }
    @catch (NSException *exception) {
        [_delegate cancel];
    }
    @finally {
    }
}

@end
