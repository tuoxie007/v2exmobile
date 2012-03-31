//
//  ImagLoader.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/16/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import <Foundation/Foundation.h>

@interface VMImageLoader : NSObject
{
    NSURLConnection *connection;
    NSMutableData *webdata;
    UIImageView *imageView;
    NSString *cacheFilePath;
    UIButton *imageButton;
}

- (void)loadImageWithURL:(NSURL *)url forImageView:(UIImageView *)imgView;
- (void)loadImageWithURL:(NSURL *)url forImageButton:(UIButton *)imgButton;
@end
