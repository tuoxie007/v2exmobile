//
//  VMWebContentVC.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/25/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMWebContentVC.h"
#import "VMReplyVC.h"
#import "VMMiniBrowser.h"
#import "Config.h"

@implementation VMWebContentVC

- (id)initWithHTML:(NSString *)html author:(NSString *)author forURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        _author = author;
        _url = url;
        UIWebView *contentView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
        contentView.delegate = self;
        [contentView loadHTMLString:html baseURL:url];
        self.view = contentView;
        UIBarButtonItem *replyButton = [[UIBarButtonItem alloc] initWithTitle:@"回复" style:UIBarButtonItemStyleDone target:self action:@selector(reply)];
        self.navigationItem.rightBarButtonItem = replyButton;
    }
    return self;
}

- (void)reply
{
    VMReplyVC *replyVC = [[VMReplyVC alloc] initWithURL:_url memtion:_author];
    [self.navigationController pushViewController:replyVC animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[request URL] isEqual:_url]) {
        return YES;
    }
    VMMiniBrowser *miniBrowser = [[VMMiniBrowser alloc] initWithURL:[request URL]];
    [self.navigationController pushViewController:miniBrowser animated:YES];
    return NO;
}

@end
