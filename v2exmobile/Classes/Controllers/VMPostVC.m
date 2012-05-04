//
//  VMPostVC.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/18/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMPostVC.h"
#import "Config.h"
#import "VMwaitingView.h"

//#define WAITING_VIEW_TAG 1

@implementation VMPostVC

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    self.title = @"发帖";
    postURL = url;
    
    UIButton *buttonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 26)];
    [buttonView setBackgroundImage:[UIImage imageNamed:@"nav-button-bg.png"] forState:UIControlStateNormal];
    [buttonView addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    UILabel *buttonTitleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 26)];
    buttonTitleView.text = @"发送";
    buttonTitleView.textColor = [UIColor whiteColor];
    buttonTitleView.textAlignment = UITextAlignmentCenter;
    buttonTitleView.font = [UIFont systemFontOfSize:12];
    buttonTitleView.backgroundColor = [UIColor clearColor];
    [buttonView addSubview:buttonTitleView];
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    self.navigationItem.rightBarButtonItem = postButton;
    
    UIButton *backButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 27)];
    [backButtonView setBackgroundImage:[UIImage imageNamed:@"nav-back-bg.png"] forState:UIControlStateNormal];
    [backButtonView addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *backButtonTitleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 27)];
    backButtonTitleView.text = @"返回";
    backButtonTitleView.textColor = [UIColor whiteColor];
    backButtonTitleView.textAlignment = UITextAlignmentCenter;
    backButtonTitleView.font = [UIFont systemFontOfSize:12];
    backButtonTitleView.backgroundColor = [UIColor clearColor];
    [backButtonView addSubview:backButtonTitleView];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
    self.navigationItem.leftBarButtonItem = backButton;
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    titleInput = [[UITextField alloc] initWithFrame:CGRectMake(0, 5, WINDOW_WIDTH-5, 30)];
    titleInput.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:titleInput];
    [titleInput becomeFirstResponder];
    
    contentInput = [[UITextView alloc] initWithFrame:CGRectMake(0, 40, WINDOW_WIDTH-5, 130)];
    contentInput.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
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
    waittingView = [[VMwaitingView alloc] initWithMessage:@"正在发送"];
    [waittingView setLoadingCenter:CGPointMake(self.view.center.x, 100)];
    [self.view addSubview:waittingView];
    
    NSString *title = titleInput.text;
    NSString *content = contentInput.text;
    if (title) {
        VMPoster *poster = [[VMPoster alloc] initWithDelegate:self];
        [poster postToURL:postURL withTitle:title content:content];
    } else {
        UIAlertView *emptyErrorAlertView = [[UIAlertView alloc] initWithTitle:@"标题不能位空" 
                                                                      message:nil 
                                                                     delegate:self 
                                                            cancelButtonTitle:nil 
                                                            otherButtonTitles:@"我知道了", nil];
        [emptyErrorAlertView show];
    }
}

#pragma mark - reply poster delegate

- (void)postSuccess
{
    [waittingView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"post_success" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)postFailed
{
    [waittingView removeFromSuperview];
    UIAlertView *errAlertView = [[UIAlertView alloc] initWithTitle:@"发送错误" 
                                                           message:@"请稍后再试" 
                                                          delegate:nil 
                                                 cancelButtonTitle:nil 
                                                 otherButtonTitles:@"知道了", nil];
    [errAlertView show];
}

@end
