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

- (void)allNodesWithDelegate:(id)delegate
{
    if (requestQueue.count) {
        [requestQueue addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"allNodes", @"name", delegate, @"delegate", nil]];
        return;
    }
    _delegate = delegate;
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URL_NODES_ALL]];
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    jsonData = [[NSMutableData alloc] init];
}

- (void)processNextRequest
{
    if (requestQueue.count) {
        NSDictionary *request = [requestQueue lastObject];
        @try {
            if ([[request objectForKey:@"name"] isEqualToString:@"allNodes"]) {
                [self allNodesWithDelegate:[request objectForKey:@"delegate"]];
            }
        }
        @catch (NSException *exception) {}
        @finally {
            [request delete:request];
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
    [self processNextRequest];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    id data = [parser objectWithData:jsonData];
    [_delegate didFinishedLoadingWithData:data];
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
