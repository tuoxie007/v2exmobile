//
//  VMRedmindVC.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 5/15/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMRedmindVC.h"

@interface VMRedmindVC ()

- (void)loadMore;
@end

@implementation VMRedmindVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *loadMoreButton = [[UIButton alloc] initWithFrame:CGRectMake(PADDING_LEFT, 0, CONTENT_WIDTH, 46.5f)];
    [loadMoreButton setBackgroundImage:[[UIImage imageNamed:@"button-bg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
    [loadMoreButton setTitle:@"查看更多 ..." forState:UIControlStateNormal];
    loadMoreButton.titleLabel.textColor = [Commen defaultTextColor];
    [loadMoreButton addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadMoreButton];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadMore
{
    
}

@end
