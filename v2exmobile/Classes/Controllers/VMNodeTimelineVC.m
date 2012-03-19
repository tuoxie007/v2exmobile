//
//  VMNodeTimelineVC.m
//  v2exmobile
//
//  Created by 徐 可 on 3/17/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import "VMNodeTimelineVC.h"
#import "Config.h"
#import "VMPostVC.h"
#import "VMInfoView.h"
#import "VMWaitingView.h"

#define WAITING_VIEW_TAG 1
#define ASK_LOGIN_TAG 19
#define LOGIN_PROMPT_TAG 20
#define INFO_VIEW_TAG 21

@implementation VMNodeTimelineVC

#pragma mark - lift cycle
- (id)initWithNode:(NSString *)node
{
    self = [super init];
    if (self) {
        _node = node;
        [[NSNotificationCenter defaultCenter] addObserver:self	selector:@selector(postSuccess) name:@"post_success" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"发帖" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem = postButton;
}

#pragma mark - load topics
- (void)loadTopics:(NSInteger)page
{
    if (loader == nil) {
        loader = [[VMTopicsLoader alloc] initWithDelegate:self];
        loader.delegate = self;
    }
    loading = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(65, 0, 0, 0);
    [loader loadTopics:page inNode:_node];
    [refreshTableHeaderView showAsRefreshing];
}

#pragma mark - actions
- (void)post
{
    if ([VMAccount getInstance].cookie) {
        VMPostVC *postVC = [[VMPostVC alloc] initWithURL:[NSString stringWithFormat:@"%@/new/%@", V2EX_URL, _node]];
        [self.navigationController pushViewController:postVC animated:YES];
        return;
    }
    UIAlertView *askWillLoginAlertView = [[UIAlertView alloc] initWithTitle:@"发帖需要登录" message:@"您尚未登录，现在就去登录吗？" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"是的", nil];
    askWillLoginAlertView.tag = ASK_LOGIN_TAG;
    [askWillLoginAlertView show];
}

- (void)postSuccess
{
    VMInfoView *infoView = [[VMInfoView alloc] initWithMessage:@"发送成功"];
    infoView.tag = INFO_VIEW_TAG;
    [self.view addSubview:infoView];
    [self performSelector:@selector(removeInfoView) withObject:nil afterDelay:1];
    
    loading = YES;
    [loader loadTopics:currentPage inNode:_node];
    [refreshTableHeaderView showAsRefreshing];
    
    VMwaitingView *waitingView = [[VMwaitingView alloc] initWithMessage:@"正在刷新"];
    [waitingView setLoadingCenter:CGPointMake(self.view.center.x, 100)];
    waitingView.tag = WAITING_VIEW_TAG;
    [self.view addSubview:waitingView];
}

- (void)removeInfoView
{
    [[self.view viewWithTag:INFO_VIEW_TAG] removeFromSuperview];
}

#pragma mark - alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ASK_LOGIN_TAG) {
        if (buttonIndex) {
            UIAlertView *loginPromptAlertView = [[UIAlertView alloc] initWithTitle:@"请输入用户名和密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"提交", nil];
            loginPromptAlertView.tag = LOGIN_PROMPT_TAG;
            loginPromptAlertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            [loginPromptAlertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeEmailAddress;
            [loginPromptAlertView show];
        }
    } else if (alertView.tag == LOGIN_PROMPT_TAG) {
        if (buttonIndex) {
            // do login
            NSString *username = [alertView textFieldAtIndex:0].text;
            NSString *password = [alertView textFieldAtIndex:1].text;
            VMAccount *account = [VMAccount getInstance];
            account.delegate = self;
            [account login:username password:password];
        }
    }
}

#pragma mark - account delegate
- (void)accountLoginSuccess
{
    [self post];
}

- (void)accountLoginFailed
{
    UIAlertView *errAlertView = [[UIAlertView alloc] initWithTitle:@"登录错误" message:@"请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
    [errAlertView show];
}

@end
