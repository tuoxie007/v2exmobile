//
//  VMFavoriteTopicsLoader.h
//  v2exmobile
//
//  Created by 徐 可 on 3/19/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import "VMLoader.h"

@protocol FavoriteTopicsLoaderDelegate;
@interface VMFavoriteTopicsLoader : VMLoader

- (void)loadFavoriteTopics;

@end

@protocol FavoriteTopicsLoaderDelegate <LoaderDalegate>

- (void)didFinishedLoadingWithTopics:(id)topics;

@end