//
//  VMPostVC.m
//  v2exmobile
//
//  Created by 徐 可 on 3/18/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import "VMPostVC.h"
#import "Config.h"
#import "VMwaitingView.h"

#define WAITING_VIEW_TAG 1

@implementation VMPostVC

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    self.title = @"发帖";
    topicURL = url;
    UIBarButtonItem *sendBnt = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    sendBnt.style = UIBarButtonItemStyleDone;
    self.navigationItem.rightBarButtonItem = sendBnt;
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    titleInput = [[UITextField alloc] initWithFrame:CGRectMake(0, 5, WINDOW_WIDTH-5, 30)];
    titleInput.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:titleInput];
    [titleInput becomeFirstResponder];
    
    contentInput = [[UITextView alloc] initWithFrame:CGRectMake(0, 40, WINDOW_WIDTH-5, 130)];
    contentInput.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:contentInput];
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - actions

- (void)submit
{
    VMwaitingView *waitingView = [[VMwaitingView alloc] initWithMessage:@"正在发送"];
    [waitingView setLoadingCenter:CGPointMake(self.view.center.x, 100)];
    waitingView.tag = WAITING_VIEW_TAG;
    [self.view addSubview:waitingView];
    
    NSString *content = contentInput.text;
    NSString *title = titleInput.text;
    VMPoster *replyPoster = [[VMPoster alloc] init];
    replyPoster.delegate = self;
    [replyPoster postToURL:topicURL withTitle:title content:content];
}

#pragma mark - reply poster delegate

- (void)postSuccess
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"post_success" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)postFailed
{
    UIAlertView *errAlertView = [[UIAlertView alloc] initWithTitle:@"发送错误" message:@"请稍后再试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
    [errAlertView show];
}

@end
