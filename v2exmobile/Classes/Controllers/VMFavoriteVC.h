//
//  VMFavoriteVC.h
//  v2exmobile
//
//  Created by 徐 可 on 3/11/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VMLoginHandler.h"
#import "VMFavoriteMembersLoader.h"
#import "VMFavoriteNodesLoader.h"
#import "VMFavoriteTopicsLoader.h"

@interface VMFavoriteVC : UITableViewController <LoginHandlerDelegate, FavoriteNodesLoaderDelegate, FavoriteMembersLoaderDelegate, FavoriteTopicsLoaderDelegate>
{
    NSArray *_nodes;
    NSArray *_topics;
    NSArray *_members;
}

- (void)loadFavorites;

@end
