//
//  VMWaitingVC.m
//  v2exmobile
//
//  Created by 徐 可 on 3/17/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import "VMWaitingVC.h"
#import "Config.h"

@implementation VMWaitingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    UIActivityIndicatorView *waitingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    waitingView.color = [UIColor grayColor];
    waitingView.center = self.view.center;
    [self.view addSubview:waitingView];
    [waitingView startAnimating];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
