//
//  VMNodeTimelineVC.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/17/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMNodeTimelineVC.h"
#import "Config.h"
#import "VMPostVC.h"
#import "VMInfoView.h"
#import "VMWaitingView.h"
#import "VMLoginHandler.h"

//#define WAITING_VIEW_TAG 1
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
        VMPostVC *postVC = [[VMPostVC alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/new/%@", V2EX_URL, _node]]];
        [self.navigationController pushViewController:postVC animated:YES];
        return;
    }
    loginHandler = [[VMLoginHandler alloc] initWithDelegate:self];
    [loginHandler login];
}

- (void)postSuccess
{
    VMInfoView *infoView = [[VMInfoView alloc] initWithMessage:@"发送成功"];
    infoView.center = CGPointMake(WINDOW_WIDTH/2, self.tableView.contentOffset.y+WINDOW_HEIGHT/2);
    infoView.tag = INFO_VIEW_TAG;
    [self.view addSubview:infoView];
    [self performSelector:@selector(removeInfoView) withObject:nil afterDelay:1];
    
    loading = YES;
    [loader loadTopics:currentPage inNode:_node];
    [refreshTableHeaderView showAsRefreshing];
    
    waittingView = [[VMwaitingView alloc] initWithMessage:@"正在刷新"];
    [waittingView setLoadingCenter:CGPointMake(WINDOW_WIDTH/2, self.tableView.contentOffset.y+WINDOW_HEIGHT/2)];
    [self.view addSubview:waittingView];
}

- (void)removeInfoView
{
    [[self.view viewWithTag:INFO_VIEW_TAG] removeFromSuperview];
}

#pragma mark - account delegate
- (void)loginSuccess
{
    [self post];
}

@end
