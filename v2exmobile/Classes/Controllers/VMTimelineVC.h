//
//  VMMasterViewController.h
//  v2exmobile
//
//  Created by 徐 可 on 3/11/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "VMTopicsLoader.h"
#import "VMAccount.h"

@class VMTopicsLoader;
@class VMImageLoader;
@interface VMTimelineVC : UITableViewController <EGORefreshTableHeaderDelegate, TopicsLoaderDalegate>
{
    NSArray *topics;
    EGORefreshTableHeaderView *refreshTableHeaderView;
    VMTopicsLoader *loader;
    BOOL loading;
    NSInteger currentPage;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier;
- (void)loadTopics:(NSInteger)page;

@end
