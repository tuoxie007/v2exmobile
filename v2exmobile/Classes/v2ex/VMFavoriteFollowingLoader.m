//
//  VMFavoritePersonsLoader.m
//  v2exmobile
//
//  Created by 徐 可 on 3/20/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import "VMFavoriteFollowingLoader.h"
#import "Config.h"
#import "HTMLParser.h"

@implementation VMFavoriteFollowingLoader

- (void)loadFollowing
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/following", V2EX_URL]];
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
        
        NSMutableArray *followings = [[NSMutableArray alloc] init];
        
        HTMLNode *bodyNode = [parser body];
        HTMLNode *contentDiv = [bodyNode findChildWithAttribute:@"id" matchingName:@"Content" allowPartial:NO];
        HTMLNode *followingTable = [[contentDiv findChildTags:@"table"] lastObject];
        NSArray *trNodes = [followingTable findChildrenOfClass:@"tr"];
        for (HTMLNode *trNode in trNodes) {
            HTMLNode *imgNode = [trNode findChildTag:@"img"];
            if (imgNode == nil) {
                continue;
            }
            NSString *imgURL = [imgNode getAttributeNamed:@"href"];
            
            HTMLNode *followingNode = [trNode findChildTag:@"a"];
            NSString *following = [followingNode contents];
            NSString *followingURL = [followingNode getAttributeNamed:@"href"];
            
            HTMLNode *levelNode = [trNode findChildOfClass:@"fade"];
            NSString *level = @"";
            if (levelNode) {
                level = [levelNode contents];
            }
            
            NSString *followers = [[trNode findChildTag:@"small"] contents];
            
            [followings addObject:[NSDictionary dictionaryWithObjectsAndKeys:imgURL, @"img_url", following, @"following", followingURL, @"url", followers, "followers", nil]];
        }
        [_delegate didFinishedLoadingWithData:followings];
    }
    @catch (NSException *exception) {
        [_delegate cancel];
    }
    @finally {
    }
}

@end
