//
//  VMFavoritePersonsLoader.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/20/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMFavoriteMembersLoader.h"
#import "Config.h"
#import "HTMLParser.h"

@implementation VMFavoriteMembersLoader

- (void)loadFavoriteMembers
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/my/following", V2EX_URL]];
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
        
        NSMutableArray *members = [[NSMutableArray alloc] init];
        
        HTMLNode *bodyNode = [parser body];
        HTMLNode *contentDiv = [bodyNode findChildWithAttribute:@"id" matchingName:@"Content" allowPartial:NO];
        HTMLNode *followingTable = [[contentDiv findChildTags:@"table"] lastObject];
        NSArray *trNodes = [followingTable findChildTags:@"tr"];
        for (HTMLNode *trNode in trNodes) {
            HTMLNode *imgNode = [trNode findChildTag:@"img"];
            if (imgNode == nil) {
                continue;
            }
            NSString *imgURL = [imgNode getAttributeNamed:@"src"];
            if (![imgURL hasPrefix:@"http://"]) {
                imgURL = [NSString stringWithFormat:@"%@%@", V2EX_URL, imgURL];
            }
            
            HTMLNode *followingNode = [trNode findChildTag:@"a"];
            NSString *name = [followingNode contents];
            NSString *url = [followingNode getAttributeNamed:@"href"];
            
            NSArray *fadeNodes = [trNode findChildrenOfClass:@"fade"];
            
            NSString *followers = @"";
            NSString *level = @"";
            if ([fadeNodes count] == 1) {
                HTMLNode *followersNode = [fadeNodes objectAtIndex:0];
                followers = [followersNode contents];
            } else if ([fadeNodes count] == 2) {
                HTMLNode *levelNode = [fadeNodes objectAtIndex:0];
                level = [levelNode contents];
                HTMLNode *followersNode = [fadeNodes objectAtIndex:1];
                followers = [followersNode contents];
            }
            
            [members addObject:[NSDictionary dictionaryWithObjectsAndKeys:imgURL, @"img_url", name, @"name", url, @"url", followers, @"followers", level, @"level", nil]];
        }
        [_delegate didFinishedLoadingWithMembers:members];
    }
    @catch (NSException *exception) {
        [_delegate cancel];
    }
    @finally {
    }
}

@end
