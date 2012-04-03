//
//  VMAccount.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/10/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import <Foundation/Foundation.h>

@protocol VMAccountDalegate;
@interface VMAccount : NSObject
{
    NSHTTPCookie *cookie;
    NSURLConnection *connection;
    id <VMAccountDalegate> _delegate;
    NSMutableData *webdata;
    NSString *cookieFilePath;
    NSString *usernameFilePath;
    NSString *_username;
//    NSMutableData *webData;
}

@property (strong) NSHTTPCookie *cookie;
@property (readonly) NSString *username;
@property (strong) id <VMAccountDalegate> delegate;

- (id)init;
- (BOOL)login:(NSString *) username password:(NSString *) password;
- (void)logout;

+ (VMAccount *) getInstance;

@end

@protocol VMAccountDalegate <NSObject>

- (void)accountLoginSuccess;
- (void)accountLoginFailed;

@end
