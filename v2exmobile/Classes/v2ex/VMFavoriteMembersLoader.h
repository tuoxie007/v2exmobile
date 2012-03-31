//
//  VMFavoritePersonsLoader.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/20/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMLoader.h"

@protocol FavoriteMembersLoaderDelegate;
@interface VMFavoriteMembersLoader : VMLoader

- (void)loadFavoriteMembers;

@end

@protocol FavoriteMembersLoaderDelegate <LoaderDalegate>

- (void)didFinishedLoadingWithMembers:(id)members;

@end