//
//  VMTopicView.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/13/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import <UIKit/UIKit.h>

@interface VMTopicView : UIView
{
    CGFloat topicHeight;
}

- (id)initWithTopic:(NSDictionary *)topic;
- (void)updateWithReplies:(NSArray *)replies delegate:(id)delegate;

@end
