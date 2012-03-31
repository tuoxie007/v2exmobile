//
//  VMFavoriteVC.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/11/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import <UIKit/UIKit.h>
#import "VMLoginHandler.h"
#import "VMFavoriteMembersLoader.h"
#import "VMFavoriteNodesLoader.h"
#import "VMFavoriteTopicsLoader.h"

@class VMwaitingView;
@interface VMFavoriteVC : UITableViewController <LoginHandlerDelegate, FavoriteNodesLoaderDelegate, FavoriteMembersLoaderDelegate, FavoriteTopicsLoaderDelegate>
{
    NSArray *_nodes;
    NSArray *_topics;
    NSArray *_members;
    NSMutableDictionary *imgBnt2name;
    VMwaitingView *waittingView;
}

- (void)loadFavorites;
- (void)showMember:(UIButton *)imgBnt;
- (void)removeInfoView:(id)infoView;

@end
