//
//  VMLoader.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/19/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import <Foundation/Foundation.h>

@protocol LoaderDalegate;
@interface VMLoader : NSObject
{
    NSURLConnection *connection;
    NSMutableData *webdata;
    id _delegate;
    NSString *referer;
}

@property (strong) NSString *referer;
@property (strong) id delegate;
- (id)initWithDelegate:(id)delegate;
- (void)loadDataWithURL:(NSURL *)url;
@end

@protocol LoaderDalegate <NSObject>

- (void)didFinishedLoadingWithData:(id)data;
- (void)cancel;

@end
