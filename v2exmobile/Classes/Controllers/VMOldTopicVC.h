//
//  VMDetailViewController.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/11/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import <UIKit/UIKit.h>
#import "VMAccount.h"
#import "VMRepliesLoader.h"
#import "VMLoginHandler.h"
#import "VMwaitingView.h"

@class VMTopicView;
@interface VMOldTopicVC : UITableViewController <UIWebViewDelegate, UIAlertViewDelegate, LoginHandlerDelegate, LoaderDalegate>
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
    BOOL favorited;
    NSString *favURL;
    BOOL favoriting;
    NSDictionary *imgBnt2name;
    NSString *html;
    VMwaitingView *waittingView;
    BOOL needAppendRepilies;
    VMLoginHandler *loginHandler;
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
- (void)favoriteTopic;
- (void)showMember:(UIButton *)imgBnt;
- (void)removeInfoView:(id)infoView;
@end
