//
//  VMAPI.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 5/4/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMAPI.h"
#import "SBJson.h"

#define URL_NODES_ALL @"http://www.v2ex.com/api/nodes/all.json"
#define URL_TOPICS_ALL @"http://www.v2ex.com/api/topics/latest.json"
#define URL_REPLIES @"http://www.v2ex.com/api/replies/show.json?topic_id=%d"

@implementation VMAPI

@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {
        requestQueue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)topicsWithDelegate:(id)delegate;
{
    if (loading) {
        [requestQueue addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"topics", @"name", delegate, @"delegate", nil]];
        return;
    }
    _delegate = delegate;
    currentURL = URL_TOPICS_ALL;
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URL_TOPICS_ALL]];
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    jsonData = [[NSMutableData alloc] init];
    loading = YES;
}

- (void)repliesWithDelegate:(id)delegate forTopicId:(NSInteger)topicId
{
    if (loading) {
        [requestQueue addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"replies", @"name", delegate, @"delegate", nil]];
        return;
    }
    NSString *url = [NSString stringWithFormat:URL_REPLIES, topicId];
    currentURL = url;
    _delegate = delegate;
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    jsonData = [[NSMutableData alloc] init];
    loading = YES;
}

- (void)allNodesWithDelegate:(id)delegate
{
    if (loading) {
        [requestQueue addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"allNodes", @"name", delegate, @"delegate", nil]];
        return;
    }
    _delegate = delegate;
    currentURL = URL_NODES_ALL;
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URL_NODES_ALL]];
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    jsonData = [[NSMutableData alloc] init];
    loading = YES;
}

- (void)processNextRequest
{
    if (requestQueue.count) {
        NSDictionary *request = [requestQueue objectAtIndex:0];
        @try {
            if ([[request objectForKey:@"name"] isEqualToString:@"allNodes"]) {
                [self allNodesWithDelegate:[request objectForKey:@"delegate"]];
            } else if ([[request objectForKey:@"name"] isEqualToString:@"topics"]) {
                [self topicsWithDelegate:[request objectForKey:@"delegate"]];
            }
        }
        @catch (NSException *exception) {}
        @finally {
            [requestQueue removeObjectAtIndex:0];
        }
    }
}

#pragma NSURLConnectoin Prototol

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [jsonData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_delegate cancel];
    loading = NO;
    [self processNextRequest];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    id data = [parser objectWithData:jsonData];
    [_delegate didFinishedLoadingWithData:data forURL:currentURL];
    loading = NO;
    [self processNextRequest];
}

+ (VMAPI *)sharedAPI
{
    static VMAPI *shared;
    if (!shared) {
        shared = [[VMAPI alloc] init];
    }
    return shared;
}


@end
