//
//  VMMainVC.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/11/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMMainVC.h"
#import "VMHomeVC.h"
#import "VMNotificationVC.h"
#import "VMNodeVC.h"
#import "VMFavoriteVC.h"
#import "VMSettingVC.h"
#import "HTMLParser.h"
#import "VMProfileVC.h"

@implementation VMMainVC

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
//    VMAccount *account = [VMAccount getInstance];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav-title-bg.png"] forBarMetrics:UIBarMetricsDefault];
    
    VMHomeVC *homeVC = [[VMHomeVC alloc] init];
    UINavigationController *homeNavController = [[UINavigationController alloc] initWithRootViewController:homeVC];
    UITabBarItem *homeTabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"icon-timeline.png"] tag:0];
    [homeNavController setTabBarItem:homeTabBarItem];
    
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
    
    VMProfileVC *settingVC = [[VMProfileVC alloc] init];
    UINavigationController *accountNavController = [[UINavigationController alloc] initWithRootViewController:settingVC];
    UITabBarItem *accountTabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"icon-account.png"] tag:4];
    [accountNavController setTabBarItem:accountTabBarItem];
    
    [self setViewControllers:[[NSArray alloc] initWithObjects:homeNavController, notificationNavController, nodeNavController, favoriteNavController, accountNavController, nil]];
    
    self.selectedIndex = 0;
    
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
