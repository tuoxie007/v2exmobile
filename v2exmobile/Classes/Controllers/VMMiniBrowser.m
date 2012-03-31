//
//  VMMiniBrowser.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/25/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMMiniBrowser.h"
#import "Config.h"

@implementation VMMiniBrowser

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
        webView.delegate = self;
        [webView scalesPageToFit];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        [webView loadRequest:req];
        self.view = webView;
        
        self.title = @"正在加载...";
    }
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [webView scalesPageToFit];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
