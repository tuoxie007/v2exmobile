//
//  VMReplyVC.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/17/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMPoster.h"

@class VMwaitingView;
@interface VMReplyVC : UIViewController <PosterDelegate>
{
    UITextView *contentInput;
    NSURL *topicURL;
    VMwaitingView *waittingView;
}

- (void)submit;
- (id)initWithURL:(NSURL *)url;
- (id)initWithURL:(NSURL *)url memtion:(NSString *)memtion;

@end
