//
//  VMTopicVC.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 5/10/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import <UIKit/UIKit.h>

@interface VMTopicVC : UIViewController <UIWebViewDelegate, APIDalegate>

- (id)initWithTopic:(NSDictionary *)topic;
@end
