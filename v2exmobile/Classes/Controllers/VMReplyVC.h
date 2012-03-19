//
//  VMReplyVC.h
//  v2exmobile
//
//  Created by 徐 可 on 3/17/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import "VMPoster.h"

@interface VMReplyVC : UIViewController <PosterDelegate>
{
    UITextView *contentInput;
    NSURL *topicURL;
}

- (void)submit;
- (id)initWithURL:(NSURL *)url;

@end
