//
//  VMLoader.h
//  v2exmobile
//
//  Created by 徐 可 on 3/19/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoaderDalegate;
@interface VMLoader : NSObject
{
    NSURLConnection *connection;
    NSMutableData *webdata;
    id _delegate;
}

@property (strong) id delegate;
- (id)initWithDelegate:(id)delegate;
- (void)loadDataWithURL:(NSURL *)url;
@end

@protocol LoaderDalegate <NSObject>

- (void)didFinishedLoadingWithData:(id)data;
- (void)cancel;

@end
