//
//  VMPostVC.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/18/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMPoster.h"

@class VMwaitingView;
@interface VMPostVC : UIViewController <PosterDelegate>
{
    UITextField *titleInput;
    UITextView *contentInput;
    NSURL *postURL;
    VMwaitingView *waittingView;
}

- (id)initWithURL:(NSURL *)url;
- (void)submit;

@end
