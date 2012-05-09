//
//  VMHomeVC.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 5/9/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMHomeVC.h"
#import "VMTopicsVC.h"
#import "VMAPI.h"

@interface VMHomeVC ()
{
    VMTopicsVC *topicsTableVC;
}

- (void)switchToLatest;
- (void)switchToHot;
- (void)switchToFriends;
- (void)highlightButton:(UIButton *)btn;
- (void)unHighlightButton:(UIButton *)btn;

@end

@implementation VMHomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *normalTitleColor = [UIColor colorWithRed:0.265625 green:0.27734375 blue:0.2890625 alpha:1];
    UIColor *hilightedTitleColor = [UIColor whiteColor];
    UIFont *titleFont = [UIFont systemFontOfSize:14];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.79 alpha:1];
    
    UIButton *latestTopicsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 104, 51)];
    [latestTopicsButton setBackgroundImage:[UIImage imageNamed:@"sub-menu-item-bg-left.png"] forState:UIControlStateNormal];
    [latestTopicsButton setBackgroundImage:[UIImage imageNamed:@"sub-menu-item-bg-left-selected.png"] forState:UIControlStateHighlighted];
    [latestTopicsButton setTitle:@"最新主题" forState:UIControlStateNormal];
    [latestTopicsButton setTitleColor:normalTitleColor forState:UIControlStateNormal];
    [latestTopicsButton setTitleColor:hilightedTitleColor forState:UIControlStateHighlighted];
    latestTopicsButton.titleLabel.font = titleFont;
    latestTopicsButton.frame = CGRectMake(8, 7, 101, 26);
    latestTopicsButton.tag = 101;
    [latestTopicsButton addTarget:self action:@selector(switchToLatest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:latestTopicsButton];
    latestTopicsButton.highlighted = YES;
    
    UIButton *hotTopicsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 104, 51)];
    [hotTopicsButton setBackgroundImage:[UIImage imageNamed:@"sub-menu-item-bg-center.png"] forState:UIControlStateNormal];
    [hotTopicsButton setBackgroundImage:[UIImage imageNamed:@"sub-menu-item-bg-center-selected.png"] forState:UIControlStateHighlighted];
    [hotTopicsButton setTitle:@"热议主题" forState:UIControlStateNormal];
    [hotTopicsButton setTitleColor:normalTitleColor forState:UIControlStateNormal];
    [hotTopicsButton setTitleColor:hilightedTitleColor forState:UIControlStateHighlighted];
    hotTopicsButton.titleLabel.font = titleFont;
    hotTopicsButton.frame = CGRectMake(109, 7, 102, 26);
    hotTopicsButton.tag = 102;
    [hotTopicsButton addTarget:self action:@selector(switchToHot) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hotTopicsButton];
    
    UIButton *friendsTopicsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 104, 51)];
    [friendsTopicsButton setBackgroundImage:[UIImage imageNamed:@"sub-menu-item-bg-right.png"] forState:UIControlStateNormal];
    [friendsTopicsButton setBackgroundImage:[UIImage imageNamed:@"sub-menu-item-bg-right-selected.png"] forState:UIControlStateHighlighted];
    [friendsTopicsButton setTitleColor:normalTitleColor forState:UIControlStateNormal];
    [friendsTopicsButton setTitleColor:hilightedTitleColor forState:UIControlStateHighlighted];
    [friendsTopicsButton setTitle:@"好友主题" forState:UIControlStateNormal];
    friendsTopicsButton.titleLabel.font = titleFont;
    friendsTopicsButton.frame = CGRectMake(211, 7, 101, 26);
    friendsTopicsButton.tag = 103;
    [friendsTopicsButton addTarget:self action:@selector(switchToFriends) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:friendsTopicsButton];
    
    [[VMAPI sharedAPI] topicsWithDelegate:self];
    
    self.title = @"V2EX";
}

- (void)didFinishedLoadingWithData:(id)data
{
    topicsTableVC = [[VMTopicsVC alloc] initWithTopics:data withAvatar:YES];
    topicsTableVC.view.frame = CGRectMake(8, 45, 304, 310);
    
    [self.view addSubview:topicsTableVC.view];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(8, topicsTableVC.view.frame.origin.y-5, 304, 5)];
    headView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    [self.view addSubview:headView];
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(8, topicsTableVC.view.frame.origin.y+topicsTableVC.view.frame.size.height, 304, 5)];
    footView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    [self.view addSubview:footView];
    
    UIImageView *cornerLeftTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-corner-left-top.png"]];
    cornerLeftTop.frame = CGRectMake(0, 0, 5, 5);
    [headView addSubview:cornerLeftTop];
    
    UIImageView *cornerRightTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-corner-right-top.png"]];
    cornerRightTop.frame = CGRectMake(299, 0, 5, 5);
    [headView addSubview:cornerRightTop];
    
    UIImageView *cornerLeftBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-corner-left-bottom.png"]];
    cornerLeftBottom.frame = CGRectMake(0, 0, 5, 5);
    [footView addSubview:cornerLeftBottom];
    
    UIImageView *cornerRightBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-corner-right-bottom.png"]];
    cornerRightBottom.frame = CGRectMake(299, 0, 5, 5);
    [footView addSubview:cornerRightBottom];
}

- (void)cancel
{
//    TODO
    NSLog(@"Load Topics Failed");
}

- (void)highlightButton:(UIButton *)btn {
    [btn setHighlighted:YES];
}

- (void)unHighlightButton:(UIButton *)btn
{
    [btn setHighlighted:NO];
}

- (void)switchToLatest
{
    [self performSelector:@selector(highlightButton:) withObject:((UIButton *)[self.view viewWithTag:101]) afterDelay:0.0];
    [self performSelector:@selector(unHighlightButton:) withObject:((UIButton *)[self.view viewWithTag:102]) afterDelay:0.0];
    [self performSelector:@selector(unHighlightButton:) withObject:((UIButton *)[self.view viewWithTag:103]) afterDelay:0.0];
}

- (void)switchToHot
{
    [self performSelector:@selector(unHighlightButton:) withObject:((UIButton *)[self.view viewWithTag:101]) afterDelay:0.0];
    [self performSelector:@selector(highlightButton:) withObject:((UIButton *)[self.view viewWithTag:102]) afterDelay:0.0];
    [self performSelector:@selector(unHighlightButton:) withObject:((UIButton *)[self.view viewWithTag:103]) afterDelay:0.0];
}

- (void)switchToFriends
{
    [self performSelector:@selector(unHighlightButton:) withObject:((UIButton *)[self.view viewWithTag:101]) afterDelay:0.0];
    [self performSelector:@selector(unHighlightButton:) withObject:((UIButton *)[self.view viewWithTag:102]) afterDelay:0.0];
    [self performSelector:@selector(highlightButton:) withObject:((UIButton *)[self.view viewWithTag:103]) afterDelay:0.0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
