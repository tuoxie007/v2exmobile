//
//  VMMasterViewController.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/11/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "VMTopicsLoader.h"
#import "VMAccount.h"
//#import "VMInfoView.h"

@class VMTopicsLoader;
@class VMImageLoader;
@class VMwaitingView;
@interface VMTimelineVC : UITableViewController <EGORefreshTableHeaderDelegate, TopicsLoaderDalegate>
{
    NSArray *topics;
    EGORefreshTableHeaderView *refreshTableHeaderView;
    VMTopicsLoader *loader;
    BOOL loading;
    NSInteger currentPage;
    NSDictionary *imgBnt2name;
    VMwaitingView *waittingView;
//    VMInfoView *infoView;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier;
- (void)loadTopics:(NSInteger)page;
- (void)showMember:(UIButton *)imgBnt;
- (void)removeInfoView:(id)infoView;
@end
