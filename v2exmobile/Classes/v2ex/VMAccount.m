//
//  VMAccount.m
//  v2exmobile
//
//  Created by 徐 可 on 3/10/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import "VMAccount.h"
#import "Config.h"
#import "Commen.h"

@implementation VMAccount

@synthesize cookie;
@synthesize delegate = _delegate;

- (id) init
{
    self = [super init];
    cookieFilePath = [Commen getFilePathWithFilename:@"cookie.txt"];
    cookie = [NSHTTPCookie cookieWithProperties:[[NSDictionary alloc] initWithContentsOfFile:cookieFilePath]];
    return self;
}

- (BOOL) login:(NSString *)username password:(NSString *)password
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/signin", V2EX_URL]];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[[NSString stringWithFormat:@"u=%@&p=%@", username, password] dataUsingEncoding:NSASCIIStringEncoding]];
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    return YES;
}

- (void) logout
{
    [self setCookie:nil];
}

+ (VMAccount *) getInstance
{
    static VMAccount *singalInstance;
    if (!singalInstance) {
        singalInstance = [[VMAccount alloc] init];
    }
    return singalInstance;
}

#pragma NSURLConnectoin Protot
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
    NSArray* returnedCookies = [NSHTTPCookie 
                                cookiesWithResponseHeaderFields:[resp allHeaderFields] 
                                forURL:[NSURL URLWithString:V2EX_URL]];
    if (returnedCookies) {
        cookie = [returnedCookies objectAtIndex:0];
        [[cookie properties] writeToFile:cookieFilePath atomically:NO];
        [_delegate accountLoginSuccess];
    } else {
        [_delegate accountLoginFailed];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_delegate accountLoginFailed];
}

@end
