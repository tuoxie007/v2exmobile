//
//  VMFavoritePersonsLoader.h
//  v2exmobile
//
//  Created by 徐 可 on 3/20/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import "VMLoader.h"

@protocol FavoriteMembersLoaderDelegate;
@interface VMFavoriteMembersLoader : VMLoader

- (void)loadFavoriteMembers;

@end

@protocol FavoriteMembersLoaderDelegate <LoaderDalegate>

- (void)didFinishedLoadingWithMembers:(id)members;

@end