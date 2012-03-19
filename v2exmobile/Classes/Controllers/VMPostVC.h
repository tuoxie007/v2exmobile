//
//  VMPostVC.h
//  v2exmobile
//
//  Created by 徐 可 on 3/18/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import "VMPoster.h"

@interface VMPostVC : UIViewController <PosterDelegate>
{
    UITextField *titleInput;
    UITextView *contentInput;
    NSURL *topicURL;
}

- (id)initWithURL:(NSURL *)url;
- (void)submit;

@end
