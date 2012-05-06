//
//  VMProfile.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 5/6/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMProfileVC.h"
#import "VMTopicsVC.h"

@interface VMProfileVC ()
{
    VMTopicsVC *topicsTableVC;
    UIScrollView *rootView;
}

@end

@implementation VMProfileVC

- (id)init
{
    self = [super init];
    if (self) {
        rootView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
        rootView.contentSize = CGSizeMake(320, 583);
        [self.view addSubview:rootView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    rootView.backgroundColor = [UIColor colorWithWhite:0.78125 alpha:1];
    
    UIImageView *userBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-bg.png"]];
    userBG.frame = CGRectMake(0, 0, 320, 0);
    [userBG sizeToFit];
    [rootView addSubview:userBG];
    
    UIImageView *menuBGImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-menu-bg.png"]];
    menuBGImage.frame = CGRectMake(0, 161, 320, 43);
    [rootView addSubview:menuBGImage];
    
    UIImageView *avatarImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar.png"]];
    avatarImage.frame = CGRectMake(7, 120, 70, 70);
    [rootView addSubview:avatarImage];
    
    UIImage *srcImg = [UIImage imageNamed:@"avatar-bg.png"];
    UIImage *borderImage = [srcImg stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    UIImageView *borderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 120, 70, 70)];
    borderImageView.image = borderImage;
    [rootView addSubview:borderImageView];
    
    UIImageView *onlineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"online.png"]];
    onlineImage.frame = CGRectMake(22, 192, 0, 0);
    [onlineImage sizeToFit];
    [rootView addSubview:onlineImage];
    
    NSInteger bgY = 175;
    NSInteger intervalWidth = 46;
    NSInteger bgWidth = 24;
    NSInteger paddingLeft = 12;
    NSInteger paddingTop = 13;
    
    UIImageView *menuItemFollowBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-menu-item-bg.png"]];
    menuItemFollowBG.frame = CGRectMake(106, bgY, bgWidth, bgWidth);
    UIImageView *menuItemFollow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-menu-item-follow.png"]];
    menuItemFollow.center = CGPointMake(106+paddingLeft, bgY+paddingTop);
    [menuItemFollow sizeToFit];
    [rootView addSubview:menuItemFollowBG];
    [rootView addSubview:menuItemFollow];
    
    UIImageView *menuItemForbidBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-menu-item-bg.png"]];
    menuItemForbidBG.frame = CGRectMake(106+intervalWidth*1, bgY, bgWidth, bgWidth);
    UIImageView *menuItemForbid = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-menu-item-forbid.png"]];
    menuItemForbid.center = CGPointMake(106+paddingLeft+intervalWidth*1, bgY+paddingTop);
    [menuItemForbid sizeToFit];
    [rootView addSubview:menuItemForbidBG];
    [rootView addSubview:menuItemForbid];

    UIImageView *menuItemGithubBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-menu-item-bg.png"]];
    menuItemGithubBG.frame = CGRectMake(106+intervalWidth*2, bgY, bgWidth, bgWidth);
    UIImageView *menuItemGithub = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-menu-item-github.png"]];
    menuItemGithub.center = CGPointMake(106+paddingLeft+intervalWidth*2, bgY+paddingTop);
    [menuItemGithub sizeToFit];
    [rootView addSubview:menuItemGithubBG];
    [rootView addSubview:menuItemGithub];

    UIImageView *menuItemTwitterBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-menu-item-bg.png"]];
    menuItemTwitterBG.frame = CGRectMake(106+intervalWidth*3, bgY, bgWidth, bgWidth);
    UIImageView *menuItemTwitter = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-menu-item-twitter.png"]];
    menuItemTwitter.center = CGPointMake(106+paddingLeft+intervalWidth*3, bgY+paddingTop);
    [menuItemTwitter sizeToFit];
    [rootView addSubview:menuItemTwitterBG];
    [rootView addSubview:menuItemTwitter];

    UIImageView *menuItemPBBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-menu-item-bg.png"]];
    menuItemPBBG.frame = CGRectMake(106+intervalWidth*4, bgY, bgWidth, bgWidth);
    UIImageView *menuItemPB = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-menu-item-pb.png"]];
    menuItemPB.center = CGPointMake(106+paddingLeft+intervalWidth*4, bgY+paddingTop);
    [menuItemPB sizeToFit];
    [rootView addSubview:menuItemPBBG];
    [rootView addSubview:menuItemPB];
    
    NSString *text = @"2012 V2EX TEE 预购成功，还没有购买的，大家继续抢购啦～";
    CGSize maximumLabelSize = CGSizeMake(226, 200);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    CGFloat titleLabelHeight = size.height;
    CGFloat cellPadding = [VMTopicsVC cellPadding];
    CGFloat cellHeight = cellPadding + titleLabelHeight + 7 + 8 + cellPadding;
    CGFloat topicsTableContentHeight = cellHeight * 10;
    rootView.contentSize = CGSizeMake(320, topicsTableContentHeight + 215 + 10);
    
    topicsTableVC = [[VMTopicsVC alloc] initWithTopics:nil];
    topicsTableVC.view.frame = CGRectMake(8, 215, 304, topicsTableContentHeight);
    topicsTableVC.tableView.scrollEnabled = NO;
    
    [rootView addSubview:topicsTableVC.view];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
