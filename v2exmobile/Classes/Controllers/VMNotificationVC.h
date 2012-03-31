//
//  VMNotificationVC.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/11/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "VMNotificationsLoader.h"
#import "VMTopicVC.h"
#import "VMLoginHandler.h"

@interface VMNotificationVC : UITableViewController <EGORefreshTableHeaderDelegate, LoaderDalegate, LoginHandlerDelegate>
{
    NSArray *notifications;
    EGORefreshTableHeaderView *refreshTableHeaderView;
    VMNotificationsLoader *loader;
    BOOL loading;
    VMTopicVC *topicVC;
    VMLoginHandler *loginHandler;
    NSDictionary *imgBnt2name;
    VMwaitingView *waitingView;
}

- (void)loadNotifications;
- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (void)showMember:(UIButton *)imgBnt;
- (void)removeInfoView:(id)infoView;
@end
