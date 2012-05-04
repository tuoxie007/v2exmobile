//
//  VMMainVC.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/11/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMMainVC.h"
#import "VMTimelineVC.h"
#import "VMNotificationVC.h"
#import "VMNodeVC.h"
#import "VMFavoriteVC.h"
#import "VMMemberVC.h"
#import "HTMLParser.h"

@implementation VMMainVC

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
//    VMAccount *account = [VMAccount getInstance];
    
    VMTimelineVC *timelineVC = [[VMTimelineVC alloc] init];
    UINavigationController *timelineNavController = [[UINavigationController alloc] initWithRootViewController:timelineVC];
    UITabBarItem *timelineTabBarItem = [[UITabBarItem alloc] initWithTitle:@"时间线" image:[UIImage imageNamed:@"icon-timeline.png"] tag:0];
    [timelineNavController setTabBarItem:timelineTabBarItem];
    
    VMNotificationVC *notificationVC = [[VMNotificationVC alloc] init];
    UINavigationController *notificationNavController = [[UINavigationController alloc] initWithRootViewController:notificationVC];
    UITabBarItem *notificationTabBarItem = [[UITabBarItem alloc] initWithTitle:@"提醒" image:[UIImage imageNamed:@"icon-notification.png"] tag:1];
    [notificationNavController setTabBarItem:notificationTabBarItem];
    
    VMNodeVC *nodeVC = [[VMNodeVC alloc] init];
    UINavigationController *nodeNavController = [[UINavigationController alloc] initWithRootViewController:nodeVC];
    UITabBarItem *nodeTabBarItem = [[UITabBarItem alloc] initWithTitle:@"节点" image:[UIImage imageNamed:@"icon-node.png"] tag:2];
    [nodeNavController setTabBarItem:nodeTabBarItem];
    
    VMFavoriteVC *favoriteVC = [[VMFavoriteVC alloc] init];
    UINavigationController *favoriteNavController = [[UINavigationController alloc] initWithRootViewController:favoriteVC];
    UITabBarItem *favoriteTabBarItem = [[UITabBarItem alloc] initWithTitle:@"关注" image:[UIImage imageNamed:@"icon-favorite.png"] tag:3];
    [favoriteNavController setTabBarItem:favoriteTabBarItem];
    
    VMMemberVC *accountVC = [[VMMemberVC alloc] init];
    UINavigationController *accountNavController = [[UINavigationController alloc] initWithRootViewController:accountVC];
    UITabBarItem *accountTabBarItem = [[UITabBarItem alloc] initWithTitle:@"账户" image:[UIImage imageNamed:@"icon-account.png"] tag:4];
    [accountNavController setTabBarItem:accountTabBarItem];
    
    [self setViewControllers:[[NSArray alloc] initWithObjects:timelineNavController, notificationNavController, nodeNavController, favoriteNavController, accountNavController, nil]];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav-title-bg.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 39);
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
