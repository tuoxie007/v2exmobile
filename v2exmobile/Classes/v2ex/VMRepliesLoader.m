//
//  VMRepliesLoader.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/13/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMRepliesLoader.h"
#import "Config.h"
#import "HTMLParser.h"
#import "VMAccount.h"

@implementation VMRepliesLoader
//@synthesize realTopicURL;

- (void)loadRepliesWithURL:(NSURL *)url
{
    [self loadDataWithURL:url];
}

//-(NSURLRequest *)connection:(NSURLConnection *)connection
//            willSendRequest:(NSURLRequest *)request
//           redirectResponse:(NSURLResponse *)redirectResponse
//{
//    if ([[[request URL] description] length] < [V2EX_URL length] + 2 && !redirectHandled) {
//        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:realTopicURL];
//        NSHTTPCookie *cookie = [VMAccount getInstance].cookie;
//        if (cookie) {
//            [req addValue:[NSString stringWithFormat:@"%@=%@", cookie.name, cookie.value] forHTTPHeaderField:@"Cookie"];
//        }
//        redirectHandled = YES;
//        return req;
//    }
//    return request;
//}
//
#pragma NSURLConnectoin Prototol
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    @try {
        NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc] initWithData:webdata error:&error];
        
        if (error) {
            return [_delegate cancel];
        }
        
        NSMutableArray *replies = [[NSMutableArray alloc] init];
        
        HTMLNode *bodyNode = [parser body];
        
        NSString *favURL = [[bodyNode findChildOfClass:@"op"] getAttributeNamed:@"href"];
        if (![favURL hasPrefix:@"http://"]) {
            favURL = [NSString stringWithFormat:@"%@%@", V2EX_URL, favURL];
        }
        
        HTMLNode *topicNode = [bodyNode findChildWithAttribute:@"id" matchingName:@"Content" allowPartial:NO];
        NSString *title = [[topicNode findChildTag:@"h1"] contents];
        NSString *imgSrc = [[topicNode findChildTag:@"img"] getAttributeNamed:@"src"];
        imgSrc = [imgSrc stringByReplacingOccurrencesOfString:@"large" withString:@"normal"];
        if (![imgSrc hasPrefix:@"http://"]) {
            imgSrc = [NSString stringWithFormat:@"%@%@", V2EX_URL, imgSrc];
        }
        HTMLNode *authorNode = [topicNode findChildOfClass:@"dark"];
        NSString *author = [authorNode contents];
        HTMLNode *infoNode = [authorNode nextSibling];
        NSArray *parts = [[[infoNode rawContents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsSeparatedByString:@"ago"];
        NSString *timeText = [NSString stringWithFormat:@"%@ ago", [parts objectAtIndex:0]];
        NSString *time = [timeText substringFromIndex:3];
        NSString *viewsText = [parts objectAtIndex:1];
        NSString *views;
        if ([viewsText length] > 5) {
            views = [viewsText substringToIndex:[viewsText length]-5];
        } else {
            views = nil;
        }
        
        HTMLNode *contentDiv = [bodyNode findChildOfClass:@"content topic_content"];
        NSString *content = @"";
        NSString *html = @"";
        if (contentDiv) {
            content = [[contentDiv allContents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            html = [contentDiv rawContents];
        }
        
        HTMLNode *pageCurrent = [bodyNode findChildOfClass:@"page_current"];
        NSString *nextPage = 0;
        if (pageCurrent) {
            NSString *currentPage = [pageCurrent contents];
            NSInteger currentPageId = [currentPage intValue];
            if (currentPageId > 1) {
                nextPage = [NSString stringWithFormat:@"%d", currentPageId-1];
            }
        }
        
        HTMLNode *repliesDiv = [bodyNode findChildWithAttribute:@"id" matchingName:@"replies" allowPartial:NO];
        NSArray *replyDivs = [repliesDiv findChildrenWithAttribute:@"class" matchingName:@"reply from_" allowPartial:YES];
        if (repliesDiv) {
            @try {
                for (HTMLNode *replyDiv in replyDivs) {
//                    NSLog(@"%@", [replyDiv rawContents]);
                    HTMLNode *imgNode = [replyDiv findChildTag:@"img"];
                    NSString *imgSrc = [imgNode getAttributeNamed:@"src"];
                    if (![imgSrc hasPrefix:@"http://"]) {
                        imgSrc = [NSString stringWithFormat:@"%@%@", V2EX_URL, imgSrc];
                    }
                    
                    HTMLNode *timeNode = [replyDiv findChildOfClass:@"snow"];
                    NSString *timeText = [NSString stringWithFormat:@"%@ ago", [[[[[timeNode contents] componentsSeparatedByString:@" - "] objectAtIndex:1] componentsSeparatedByString:@" ago"] objectAtIndex:0]];
                    
                    HTMLNode *authorNode = [replyDiv findChildOfClass:@"dark"];
                    NSString *author = [[[authorNode children] objectAtIndex:0] rawContents];
                    
                    HTMLNode *replyContentDiv = [replyDiv findChildOfClass:@"content reply_content"];
                    NSString *replyContent = [[replyContentDiv allContents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSString *replyHTML = [replyContentDiv rawContents];
                    
                    NSDictionary *reply = [[NSDictionary alloc] initWithObjectsAndKeys:imgSrc, @"img_url", timeText, @"time", author, @"author", replyContent, @"content", replyHTML, @"html", nil];
                    
                    [replies addObject:reply];
                }
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
        NSDictionary *topic = [NSDictionary dictionaryWithObjectsAndKeys:title, @"title", imgSrc, @"img_url", replies, @"replies", author, @"author", content, @"content", time, @"time", favURL, @"fav_url", html, @"html", nextPage, @"next_page", nil];
//        views, @"views", 
        [_delegate didFinishedLoadingWithData:topic];
    }
    @catch (NSException *exception) {
        [_delegate cancel];
    }
    @finally {
    }
}

@end