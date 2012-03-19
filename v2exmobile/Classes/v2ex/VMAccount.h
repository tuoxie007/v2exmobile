//
//  VMAccount.h
//  v2exmobile
//
//  Created by 徐 可 on 3/10/12.
//  Copyright (c) 2012 TVie. All rights reserved.
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
}

@property (strong) NSHTTPCookie *cookie;
@property (strong) id <VMAccountDalegate> delegate;

- (id) init;
- (BOOL) login:(NSString *) username password:(NSString *) password;
- (void) logout;

+ (VMAccount *) getInstance;

@end

@protocol VMAccountDalegate <NSObject>

- (void)accountLoginSuccess;
- (void)accountLoginFailed;

@end
