//
//  VMMiniBrowser.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/25/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import <UIKit/UIKit.h>

@interface VMMiniBrowser : UIViewController <UIWebViewDelegate>

- (id)initWithURL:(NSURL *)url;

@end
