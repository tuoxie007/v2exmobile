//
//  VMLoader.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/19/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMLoader.h"
#import "VMAccount.h"

@implementation VMLoader
@synthesize delegate = _delegate;
@synthesize referer;

-(id)initWithDelegate:(id)delegate
{
    self = [super init];
    self.delegate = delegate;
    return self;
}

- (void)loadDataWithURL:(NSURL *)url
{
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    NSHTTPCookie *cookie = [VMAccount getInstance].cookie;
    if (cookie) {
        [req addValue:[NSString stringWithFormat:@"%@=%@", cookie.name, cookie.value] forHTTPHeaderField:@"Cookie"];
    }
    if (referer) {
        [req addValue:referer forHTTPHeaderField:@"Referer"];
    }
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    webdata = [[NSMutableData alloc] init];
}

#pragma NSURLConnectoin Prototol

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webdata appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_delegate cancel];
}
@end
