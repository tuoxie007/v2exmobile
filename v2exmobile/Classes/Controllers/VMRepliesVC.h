//
//  VMRepliesVC.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 5/11/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import <UIKit/UIKit.h>

@protocol ReplyContentCellDelegate;

@interface ReplyContentCell : UITableViewCell <UIWebViewDelegate>
{
    NSDictionary *reply;
    id <ReplyContentCellDelegate> delegate;
}

- (id)initWithReply:(NSDictionary *)_topic delegate:(id<ReplyContentCellDelegate>)_delegate;
@end

@protocol ReplyContentCellDelegate <NSObject>
@required
- (void)ressignHeightForCell:(ReplyContentCell *)cell;
@end

@interface VMRepliesVC : UITableViewController <ReplyContentCellDelegate>

- (id)initWithTopic:(NSDictionary *)topic;

@end
