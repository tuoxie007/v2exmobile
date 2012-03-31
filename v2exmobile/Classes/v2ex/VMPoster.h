//
//  VMReplyPoster.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/17/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//


@protocol PosterDelegate;
@interface VMPoster : NSObject
{
    NSURLConnection *connection;
    id<PosterDelegate> _delegate;
}

@property(strong) id<PosterDelegate> delegate;

-(id)initWithDelegate:(id<PosterDelegate>)delegate;
-(void)postToURL:(NSURL *)url withTitle:(NSString *)title content:(NSString *)content;

@end

@protocol PosterDelegate <NSObject>

- (void)postSuccess;
- (void)postFailed;

@end
