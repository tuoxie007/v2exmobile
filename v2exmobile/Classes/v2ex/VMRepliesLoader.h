//
//  VMRepliesLoader.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/13/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import <Foundation/Foundation.h>
#import "VMLoader.h"

@interface VMRepliesLoader : VMLoader
{
    BOOL redirectHandled;
//    NSURL *realTopicURL;
}

//@property (strong) NSURL *realTopicURL;

- (void)loadRepliesWithURL:(NSURL *)url;

@end