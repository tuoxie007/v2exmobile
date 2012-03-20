//
//  VMNotificationVC.h
//  v2exmobile
//
//  Created by 徐 可 on 3/11/12.
//  Copyright (c) 2012 TVie. All rights reserved.
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
}

- (void)loadNotifications;
- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

@end
