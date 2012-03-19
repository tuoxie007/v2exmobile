#import "VMTopicsLoader.h"
#import "HTMLParser.h"
#import "Config.h"
#import "Commen.h"
#import "VMAccount.h"

@implementation VMTopicsLoader

-(void)loadTopics:(NSInteger)page
{
    _page = page;
    NSURL *url;
    if (page == 1) {
        url = [[NSURL alloc] initWithString:V2EX_URL];
    } else if (page == 2) {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/recent", V2EX_URL]];
    } else if (page == 3) {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/changes", V2EX_URL]];
    } else {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/changes/%d", V2EX_URL, page - 2]];
    }
    [self loadDataWithURL:url];
    reloading = YES;
}

-(void)loadTopics:(NSInteger)page inNode:(NSString *)node
{
    _page = page;
    _node = node;
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/go/%@?p=%d", V2EX_URL, node, page]];
    [self loadDataWithURL:url];
    reloading = YES;
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
        
        HTMLNode *topicsDiv = [bodyNode findChildWithAttribute:@"id" matchingName:@"topics_index" allowPartial:NO];
        if (topicsDiv == nil) {
            HTMLNode *contentDiv = [bodyNode findChildWithAttribute:@"id" matchingName:@"Content" allowPartial:NO];
            topicsDiv = [contentDiv findChildOfClass:@"box"];
        }
        NSArray *topicDivs = [topicsDiv findChildrenWithAttribute:@"class" matchingName:@"cell from_" allowPartial:YES];
        for (HTMLNode *topicDiv in topicDivs) {
            if ([[topicDiv getAttributeNamed:@"align"] isEqualToString:@"left"]) {
                continue;
            }
            
            HTMLNode *img = [topicDiv findChildTag:@"img"];
            if (img == nil) {
                continue;
            }
            NSString *imgSrc = [img getAttributeNamed:@"src"];
            if (![imgSrc hasPrefix:@"http://"]) {
                imgSrc = [NSString stringWithFormat:@"%@%@", V2EX_URL, imgSrc];
            }
            
            HTMLNode *repliesNode = [topicDiv findChildOfClass:@"count_livid"];
            NSString *repliesStr = [[[repliesNode children] objectAtIndex:0] rawContents];
            if (repliesStr == nil) {
                repliesStr = @"";
            }
            
            HTMLNode *titleNode = [topicDiv findChildOfClass:@"bigger"];
            HTMLNode *titleLinkNode = [titleNode findChildTag:@"a"];
            NSString *title = [[[titleLinkNode children] objectAtIndex:0] rawContents];
            NSString *topicURL = [titleLinkNode getAttributeNamed:@"href"];
            topicURL = [NSString stringWithFormat:@"%@%@", V2EX_URL, topicURL];
            HTMLNode *createdNode = [topicDiv findChildOfClass:@"created"];
            NSArray *createdLinkNodes = [createdNode findChildTags:@"a"];
            NSString *node = @"";
            NSString *author = @"";
            if (_node == nil) {
                if ([createdLinkNodes count] > 1) {
                    HTMLNode *nodeNode = [createdLinkNodes objectAtIndex:0];
                    node = [[[nodeNode children] objectAtIndex:0] rawContents];
                    HTMLNode *authorNode = [createdLinkNodes objectAtIndex:1];
                    author = [[[authorNode children] objectAtIndex:0] rawContents];
                } else {
                    HTMLNode *authorNode = [createdLinkNodes objectAtIndex:0];
                    author = [[[authorNode children] objectAtIndex:0] rawContents];
                }
            } else {
                node = _node;
                HTMLNode *authorNode = [createdLinkNodes objectAtIndex:0];
                author = [[[authorNode children] objectAtIndex:0] rawContents];
            }
            
            NSString *createdText = [createdNode allContents];
            NSArray *parts = [createdText componentsSeparatedByString:@"•"];
            NSString *timeText = [[parts lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
            
            NSDictionary *topic = [[NSDictionary alloc] initWithObjectsAndKeys:title, @"title", topicURL, @"url", node, @"node", author, @"author", imgSrc, @"img_url", repliesStr, @"replies", timeText, @"last_reply_time", nil];
            [topics addObject:topic];
        }
        [_delegate didFinishedLoadingWithData:topics forPage:_page];
        
        if (_page == 1 && _node == nil) {
            // Parse Nodes
            NSMutableDictionary *commenNodes = [[NSMutableDictionary alloc] init];
            HTMLNode *nodesDiv = [[bodyNode findChildrenOfClass:@"box"] lastObject];
            NSArray *nodeLinkNodes = [nodesDiv findChildTags:@"a"];
            for (HTMLNode *linkNode in nodeLinkNodes) {
                NSString *nodeHref = [linkNode getAttributeNamed:@"href"];
                if ([nodeHref hasPrefix:@"/go/"]) {
                    NSString *nodeName = [linkNode allContents];
                    NSString *nodeId = [nodeHref substringFromIndex:4];
                    NSString *category = [[[[linkNode parent] previousSibling] findChildTag:@"span"] allContents];
                    NSMutableArray *nodesInCategory = [commenNodes objectForKey:category];
                    if (nodesInCategory) {
                        [nodesInCategory addObject:[NSArray arrayWithObjects:nodeId, nodeName, nil]];
                    } else {
                        nodesInCategory = [[NSMutableArray alloc] init];
                        [nodesInCategory addObject:[NSArray arrayWithObjects:nodeId, nodeName, nil]];
                        [commenNodes setValue:nodesInCategory forKey:category];
                    }
                }
            }
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", V2EX_URL, @"/planes"]];
            NSData *planesPageData = [NSData dataWithContentsOfURL:url];
            HTMLParser *parser = [[HTMLParser alloc] initWithData:planesPageData error:&error];
            bodyNode = [parser body];
            nodeLinkNodes = [bodyNode findChildrenOfClass:@"item_node"];
            NSMutableDictionary *allNodes = [[NSMutableDictionary alloc] init];
            for (HTMLNode *nodeLinkNode in nodeLinkNodes) {
                NSString *nodeName = [nodeLinkNode allContents];
                NSString *nodeHref = [nodeLinkNode getAttributeNamed:@"href"];
                NSString *nodeId = [nodeHref substringFromIndex:4];
                NSString *nodeCategory = [[[[[nodeLinkNode parent] previousSibling] findChildOfClass:@"fr"] nextSibling] rawContents];
                NSMutableArray *nodesInCategory = [allNodes objectForKey:nodeCategory];
                if (nodesInCategory) {
                    [nodesInCategory addObject:[NSArray arrayWithObjects:nodeId, nodeName, nil]];
                } else {
                    nodesInCategory = [[NSMutableArray alloc] init];
                    [nodesInCategory addObject:[NSArray arrayWithObjects:nodeId, nodeName, nil]];
                    [allNodes setValue:nodesInCategory forKey:nodeCategory];
                }
            }
            [[[NSDictionary alloc] initWithObjectsAndKeys:commenNodes, @"commen", allNodes, @"all", nil] writeToFile:nodesFilePath atomically:NO];
        }
        
    }
    @catch (NSException *exception) {
        [_delegate cancel];
    }
    @finally {
        reloading = NO;
    }
}

@end
