//
//  ImagLoader.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/16/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
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

- (void)loadImageWithURL:(NSURL *)url forImageButton:(UIButton *)imgButton
{
//    NSString *encodedUrl = [[url description] md5];
//    cacheFilePath = [Commen getFilePathWithFilename:[NSString stringWithFormat:@"%@.png", encodedUrl]];
//    
//    NSData *imgData = [[NSData alloc] initWithContentsOfFile:cacheFilePath];
//    if (imgData) {
//        [self setImageForButton:imageButton withData:imgData];
//        return;
//    }
    
    imageButton = imgButton;
    NSURLRequest *req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];//[[NSURLRequest alloc] initWithURL:url];
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    webdata = [[NSMutableData alloc] init];
}

- (void)setImageForButton:(UIButton *)imgButton withData:(NSData *)imageData
{
    UIImage *img = [[UIImage alloc] initWithData:imageData];
    [imgButton setImage:img forState:UIControlStateNormal];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    imageView.image = [[UIImage alloc] initWithData:webdata];
    [self setImageForButton:imageButton withData:webdata];
    [webdata writeToFile:cacheFilePath atomically:NO];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webdata appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//    NSLog(@"Image Load Failed");
}

@end