//
//  VMWebContentVC.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/25/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import <UIKit/UIKit.h>

@interface VMWebContentVC : UIViewController <UIWebViewDelegate>
{
    NSString *_author;
    NSURL *_url;
}

- (id)initWithHTML:(NSString *)html author:(NSString *)author forURL:(NSURL *)url;
- (void)reply;

@end
