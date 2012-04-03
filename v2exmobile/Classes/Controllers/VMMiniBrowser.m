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
        webView.scalesPageToFit = YES;
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        [webView loadRequest:req];
        self.view = webView;
        
        self.title = @"正在加载...";
        
        UIBarButtonItem *openInSafariBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openInSafari)];
        self.navigationItem.rightBarButtonItem = openInSafariBarItem;
        currentURL = url;
    }
    return self;
}

- (void)openInSafari
{
    [[UIApplication sharedApplication] openURL:currentURL];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    currentURL = request.URL;
    return YES;
}

@end
