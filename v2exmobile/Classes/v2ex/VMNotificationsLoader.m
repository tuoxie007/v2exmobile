//
//  VMNotificationLoader.m
//  v2exmobile
//
//  Created by 徐 可 on 3/19/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import "VMNotificationsLoader.h"
#import "Config.h"
#import "HTMLParser.h"

@implementation VMNotificationsLoader

- (void)loadNotifications
{
    NSURL *url = [NSString stringWithFormat:@"%@/notifications", V2EX_URL];
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
        
        NSMutableArray *notifications = [[NSMutableArray alloc] init];
        
        HTMLNode *bodyNode = [parser body];
        HTMLNode *contentDiv = [[bodyNode findChildrenWithAttribute:@"id" matchingName:@"Content" allowPartial:NO] objectAtIndex:0];
        HTMLNode *boxDiv = [contentDiv findChildOfClass:@"box"];
        NSArray *notificationDivs = [boxDiv findChildrenOfClass:@"inner"];
        for (HTMLNode *notificationDiv in notificationDivs) {
            NSString *imgURL = [[notificationDiv findChildTag:@"img"] getAttributeNamed:@"src"];
            NSString *author = [[notificationDiv findChildTag:@"strong"] contents];
            HTMLNode *titleNode = [[notificationDiv findChildTags:@"a"] objectAtIndex:1];
            NSString *title = [titleNode contents];
            NSString *url = [titleNode getAttributeNamed:@"href"];
            NSString *time = [[notificationDiv findChildOfClass:@"snow"] contents];
            NSString *content = [[notificationDiv findChildOfClass:@"payload"] contents];
            
            [notifications addObject:[[NSDictionary alloc] initWithObjectsAndKeys:author, @"author", title, @"title", url, @"url", imgURL, @"img_url", time, @"time", content, @"content", nil]];
        }
        [_delegate didFinishedLoadingWithData:notifications];
    }
    @catch (NSException *exception) {
        [_delegate cancel];
    }
    @finally {
    }
}

@end
