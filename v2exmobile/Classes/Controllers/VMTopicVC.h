//
//  VMDetailViewController.h
//  v2exmobile
//
//  Created by 徐 可 on 3/11/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VMAccount.h"
#import "VMRepliesLoader.h"

@class VMTopicView;
@interface VMTopicVC : UITableViewController <UIWebViewDelegate, UIAlertViewDelegate, VMAccountDalegate, LoaderDalegate>
{
    NSDictionary *_topic;
    NSArray *replies;
    UIActivityIndicatorView *loadingReplyIndicatorView;
    NSURL *topicURL;
    NSURL *popupURL;
    UIViewController *popupWindowVC;
    UIActivityIndicatorView *popupLoadingView;
    NSString *content;
    NSString *time;
}

@property (strong) NSDictionary *topic;

- (id)initWithTopic:(NSDictionary *)topic;
- (void)updateView;
- (void)configureReplyCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)topicCellWithReuseIdentifier:(NSString *)identifier;
- (UITableViewCell *)repliesTipCellWithReuseIdentifier:(NSString *)identifier;
- (UITableViewCell *)replyCellWithReuseIdentifier:(NSString *)identifier;
- (void)reply;
- (void)replySuccess;
- (void)removeInfoView;
@end
