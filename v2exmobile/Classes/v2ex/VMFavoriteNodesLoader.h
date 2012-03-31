//
//  VMFavoriteLoader.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/19/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import <Foundation/Foundation.h>
#import "VMLoader.h"

@protocol FavoriteNodesLoaderDelegate;
@interface VMFavoriteNodesLoader : VMLoader

- (void)loadFavoritesNodes;

@end

@protocol FavoriteNodesLoaderDelegate <LoaderDalegate>

- (void)didFinishedLoadingWithNodes:(id)nodes;

@end
