//
//  VMTopicView.h
//  v2exmobile
//
//  Created by 徐 可 on 3/13/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VMTopicView : UIView
{
    CGFloat topicHeight;
}

- (id)initWithTopic:(NSDictionary *)topic;
- (void)updateWithReplies:(NSArray *)replies delegate:(id)delegate;

@end
