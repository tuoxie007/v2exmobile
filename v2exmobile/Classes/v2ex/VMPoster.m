//
//  VMReplyPoster.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/17/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMPoster.h"
#import "VMAccount.h"
#import "Commen.h"

@implementation VMPoster
@synthesize delegate = _delegate;
-(id)initWithDelegate:(id<PosterDelegate>)delegate
{
    self = [super init];
    self.delegate = delegate;
    return self;
}

//-(void)replyToURL:(NSURL *)url withContent:(NSString *)content
-(void)postToURL:(NSURL *)url withTitle:(NSString *)title content:(NSString *)content
{
//    [_delegate postSuccess];
//    return;
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    NSHTTPCookie *cookie = [VMAccount getInstance].cookie;
    [req addValue:[NSString stringWithFormat:@"%@=%@", cookie.name, cookie.value] forHTTPHeaderField:@"Cookie"];
    [req addValue:[url description] forHTTPHeaderField:@"Referer"];
    if (content) {
        content = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        content = [Commen urlencode:content];
    }
    if (title == nil) {
        [req setHTTPBody:[[NSString stringWithFormat:@"content=%@", content] dataUsingEncoding:NSUTF8StringEncoding]];
    } else {
        title = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [req setHTTPBody:[[NSString stringWithFormat:@"title=%@&content=%@", title, content] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [req setHTTPMethod:@"POST"];
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_delegate postSuccess];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_delegate postFailed];
}

@end
