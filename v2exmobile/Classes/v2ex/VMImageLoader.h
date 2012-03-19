//
//  ImagLoader.h
//  v2exmobile
//
//  Created by 徐 可 on 3/16/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VMImageLoader : NSObject
{
    NSURLConnection *connection;
    NSMutableData *webdata;
    UIImageView *imageView;
    NSString *cacheFilePath;
}

- (void)loadImageWithURL:(NSURL *)url forImageView:(UIImageView *)imgView;
@end
