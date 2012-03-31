//
//  VMReplyVC.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/17/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMReplyVC.h"
#import "Config.h"
#import "VMPoster.h"
#import "VMWaitingView.h"
#import "VMInfoView.h"

//#define WAITING_VIEW_TAG 1

@implementation VMReplyVC
#pragma mark - View lifecycle

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    topicURL = url;
    self.title = @"回帖";
    UIBarButtonItem *sendBnt = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    sendBnt.style = UIBarButtonItemStyleDone;
    self.navigationItem.rightBarButtonItem = sendBnt;
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
    self.view.backgroundColor = [UIColor whiteColor];
    contentInput = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 170)];
    [self.view addSubview:contentInput];
    [contentInput becomeFirstResponder];
    return self;
}

- (id)initWithURL:(NSURL *)url memtion:(NSString *)memtion
{
    self = [self initWithURL:url];
    contentInput.text = [NSString stringWithFormat:@"@%@ ", memtion];
    contentInput.selectedRange = NSMakeRange(0, [memtion length]+2);
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - actions

- (void)submit
{
    waittingView = [[VMwaitingView alloc] initWithMessage:@"正在发送"];
    [waittingView setLoadingCenter:CGPointMake(self.view.center.x, 100)];
    [self.view addSubview:waittingView];
    
    NSString *content = contentInput.text;
    VMPoster *replyPoster = [[VMPoster alloc] init];
    replyPoster.delegate = self;
    [replyPoster postToURL:topicURL withTitle:nil content:content];
}

#pragma mark - reply poster delegate

- (void)postSuccess
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reply_success" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)postFailed
{
    UIAlertView *errAlertView = [[UIAlertView alloc] initWithTitle:@"发送错误" message:@"请稍后再试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
    [errAlertView show];
}

@end
