//
//  VMFavoriteLoader.m
//  v2exmobile
//
//  Created by 徐 可 on 3/19/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import "VMFavoriteNodesLoader.h"
#import "Config.h"
#import "HTMLParser.h"

@implementation VMFavoriteNodesLoader

- (void)loadFavoritesNodes
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/nodes", V2EX_URL]];
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
        
        NSMutableArray *nodes = [[NSMutableArray alloc] init];
        HTMLNode *bodyNode = [parser body];
        HTMLNode *contentDiv = [bodyNode findChildWithAttribute:@"id" matchingName:@"Content" allowPartial:NO];
        NSArray *nodeDivs = [contentDiv findChildrenOfClass:@"inner"];
        for (HTMLNode *nodeDiv in nodeDivs) {
            HTMLNode *titleNode = [nodeDiv findChildTag:@"a"];
            NSString *nodeName = [titleNode contents];
            NSString *nodeId = [[titleNode getAttributeNamed:@"href"] substringFromIndex:4];
            [nodes addObject:[NSDictionary dictionaryWithObjectsAndKeys:nodeName, @"name", nodeId, @"id", nil]];
        }
        
        [_delegate didFinishedLoadingWithData:nodes];
    }
    @catch (NSException *exception) {
        [_delegate cancel];
    }
    @finally {
    }
}

@end
