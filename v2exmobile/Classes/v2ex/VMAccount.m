//
//  VMAccount.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/10/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMAccount.h"
#import "Config.h"
#import "Commen.h"

@implementation VMAccount

@synthesize cookie;
@synthesize username = _username;
@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    cookieFilePath = [Commen getFilePathWithFilename:@"cookie.txt"];
    cookie = [NSHTTPCookie cookieWithProperties:[[NSDictionary alloc] initWithContentsOfFile:cookieFilePath]];
    usernameFilePath = [Commen getFilePathWithFilename:@"username.txt"];
    _username = [NSString stringWithContentsOfFile:usernameFilePath encoding:NSUTF8StringEncoding error:nil];
    return self;
}

- (BOOL)login:(NSString *)username password:(NSString *)password
{
    _username = [[username componentsSeparatedByString:@"@"] objectAtIndex:0];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/signin", V2EX_URL]];///
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    [req setHTTPMethod:@"POST"];
    username = [Commen urlencode:username];
    password = [Commen urlencode:password];
    [req setHTTPBody:[[NSString stringWithFormat:@"u=%@&p=%@&next=", username, password] dataUsingEncoding:NSASCIIStringEncoding]];
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    return YES;
}

- (void)logout
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:cookieFilePath error:nil];
    [fileManager removeItemAtPath:usernameFilePath error:nil];
    self.cookie = nil;
}

+ (VMAccount *)getInstance
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
    if (cookie) {
        return;
    }
    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
    NSArray* returnedCookies = [NSHTTPCookie 
                                cookiesWithResponseHeaderFields:[resp allHeaderFields] 
                                forURL:[NSURL URLWithString:V2EX_URL]];
    if ([returnedCookies count]) {
        cookie = [returnedCookies objectAtIndex:0];
        [[cookie properties] writeToFile:cookieFilePath atomically:NO];
        [[_username dataUsingEncoding:NSUTF8StringEncoding] writeToFile:usernameFilePath atomically:NO];
        [_delegate accountLoginSuccess];
    } else {
        [_delegate accountLoginFailed];
    }
}
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    if (cookie) {
        return request;
    }
    if (response) {
        NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
        NSArray* returnedCookies = [NSHTTPCookie 
                                    cookiesWithResponseHeaderFields:[resp allHeaderFields] 
                                    forURL:[NSURL URLWithString:V2EX_URL]];
        if ([returnedCookies count]) {
            cookie = [returnedCookies objectAtIndex:0];
            [[cookie properties] writeToFile:cookieFilePath atomically:NO];
            [[_username dataUsingEncoding:NSUTF8StringEncoding] writeToFile:usernameFilePath atomically:NO];
            [_delegate accountLoginSuccess];
        } else {
            [_delegate accountLoginFailed];
        }
        return nil;
    } else {
        return request;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_delegate accountLoginFailed];
}
@end
