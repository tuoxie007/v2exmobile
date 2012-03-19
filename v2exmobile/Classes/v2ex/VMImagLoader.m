//
//  ImagLoader.m
//  v2exmobile
//
//  Created by 徐 可 on 3/16/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//
#import "VMImageLoader.h"
#import "MD5.h"
#import "Commen.h"

@implementation VMImageLoader

- (void)loadImageWithURL:(NSURL *)url forImageView:(UIImageView *)imgView
{
    NSString *encodedUrl = [[url description] md5];
    cacheFilePath = [Commen getFilePathWithFilename:[NSString stringWithFormat:@"%@.png", encodedUrl]];
    
    NSData *imgData = [[NSData alloc] initWithContentsOfFile:cacheFilePath];
    if ([imgData length]) {
        imgView.image = [[UIImage alloc] initWithData:imgData];
        return;
    }
    
    imageView = imgView;
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    webdata = [[NSMutableData alloc] init];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    imageView.image = [[UIImage alloc] initWithData:webdata];
    [webdata writeToFile:cacheFilePath atomically:NO];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webdata appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Image Load Failed");
}

@end