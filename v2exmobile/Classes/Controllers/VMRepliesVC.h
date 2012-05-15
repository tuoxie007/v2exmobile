//
//  VMRepliesVC.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 5/11/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import <UIKit/UIKit.h>

@interface ReplyContentCell : UITableViewCell <UIWebViewDelegate>
{
    NSDictionary *reply;
}

- (id)initWithReply:(NSDictionary *)_reply indexPath:(NSIndexPath *)indexPath;
- (void)actionButtonTouched;
- (void)replyButtonTouched;
- (void)thanksButtonTouched;
- (void)cancelButtonTouched;
@end

@interface VMRepliesVC : UITableViewController

- (id)initWithTopic:(NSDictionary *)topic;

@end
