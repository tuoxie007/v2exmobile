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
#import "VMAPI.h"

@interface VMProfileVC ()
{
    VMTopicsVC *topicsTableVC;
    VMTopicsVC *repliedTopicsTableVC;
    UIScrollView *rootView;
    NSArray *topics;
    NSArray *repliedTopics;
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
    
    NSInteger bgY = 172;
    NSInteger intervalWidth = 46;
    NSInteger paddingLeft = 12;
    NSInteger paddingTop = 13;
    
    UIButton *menuItemFollow = [[UIButton alloc] init];
    [menuItemFollow setImage:[UIImage imageNamed:@"profile-menu-item-follow.png"] forState:UIControlStateNormal];
    [menuItemFollow sizeToFit];
    menuItemFollow.center = CGPointMake(106+paddingLeft, bgY+paddingTop);
    [rootView addSubview:menuItemFollow];
    
    UIButton *menuItemForbid = [[UIButton alloc] init];
    [menuItemForbid setImage:[UIImage imageNamed:@"profile-menu-item-forbid.png"] forState:UIControlStateNormal];
    [menuItemForbid sizeToFit];
    menuItemForbid.center = CGPointMake(106+paddingLeft+intervalWidth, bgY+paddingTop);
    [rootView addSubview:menuItemForbid];

    UIButton *menuItemGithub = [[UIButton alloc] init];
    [menuItemGithub setImage:[UIImage imageNamed:@"profile-menu-item-github.png"] forState:UIControlStateNormal];
    [menuItemGithub sizeToFit];
    menuItemGithub.center = CGPointMake(106+paddingLeft+intervalWidth*2, bgY+paddingTop);
    [rootView addSubview:menuItemGithub];

    UIButton *menuItemTwitter = [[UIButton alloc] init];
    [menuItemTwitter setImage:[UIImage imageNamed:@"profile-menu-item-twitter.png"] forState:UIControlStateNormal];
    [menuItemTwitter sizeToFit];
    menuItemTwitter.center = CGPointMake(106+paddingLeft+intervalWidth*3, bgY+paddingTop);
    [rootView addSubview:menuItemTwitter];

    UIButton *menuItemPB = [[UIButton alloc] init];
    [menuItemPB setImage:[UIImage imageNamed:@"profile-menu-item-pb.png"] forState:UIControlStateNormal];
    [menuItemPB sizeToFit];
    menuItemPB.center = CGPointMake(106+paddingLeft+intervalWidth*4, bgY+paddingTop);
    [rootView addSubview:menuItemPB];
    
    [[VMAPI sharedAPI] topicsWithDelegate:self];
    [[VMAPI sharedAPI] topicsWithDelegate:self];
    
    self.title = @"设置";
}

- (void)didFinishedLoadingWithData:(id)data forURL:(NSString *)url
{
//    if ([url rangeOfString:@"replied"].location == NSNotFound) { // topics
//    应该用上面注释掉的判断方法，由于目前API还没出，先用这个方法做测试数据之用
    if (topics == nil) {
        topics = data;
    } else { // replied topics
        repliedTopics = data;
    }
    
    if (topics && repliedTopics) {
        CGFloat topicsTableContentHeight = 0;
        for (NSDictionary *topic in topics) {
            NSString *text = [topic objectForKey:@"title"];
            CGSize maximumLabelSize = CGSizeMake(226, 200);
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
            CGFloat titleLabelHeight = size.height;
            CGFloat cellPadding = [VMTopicsVC cellPadding];
            CGFloat cellHeight = cellPadding + titleLabelHeight + 7 + 8 + cellPadding;
            topicsTableContentHeight += cellHeight;
        }
        
        UILabel *topicsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 215, 200, 20)];
        topicsLabel.text = @"发表的主题";
        topicsLabel.font = [UIFont boldSystemFontOfSize:16];
        topicsLabel.backgroundColor = [UIColor clearColor];
        [rootView addSubview:topicsLabel];
        
        topicsTableVC = [[VMTopicsVC alloc] initWithTopics:topics withAvatar:NO refreshTableHeaderView:nil parentVC:self];
        topicsTableVC.view.frame = CGRectMake(8, 240, 304, topicsTableContentHeight);
        topicsTableVC.tableView.scrollEnabled = NO;
        
        [rootView addSubview:topicsTableVC.view];
        
        //TopicsTable 表头圆角
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(8, topicsTableVC.view.frame.origin.y-5, 304, 5)];
        headView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
        [rootView addSubview:headView];
        UIImageView *cornerLeftTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-corner-left-top.png"]];
        cornerLeftTop.frame = CGRectMake(0, 0, 5, 5);
        [headView addSubview:cornerLeftTop];
        UIImageView *cornerRightTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-corner-right-top.png"]];
        cornerRightTop.frame = CGRectMake(299, 0, 5, 5);
        [headView addSubview:cornerRightTop];

        //TopicsTable 表尾圆角
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(8, topicsTableVC.view.frame.origin.y+topicsTableVC.view.frame.size.height, 304, 5)];
        footView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
        [rootView addSubview:footView];
        UIImageView *cornerLeftBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-corner-left-bottom.png"]];
        cornerLeftBottom.frame = CGRectMake(0, 0, 5, 5);
        [footView addSubview:cornerLeftBottom];
        UIImageView *cornerRightBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-corner-right-bottom.png"]];
        cornerRightBottom.frame = CGRectMake(299, 0, 5, 5);
        [footView addSubview:cornerRightBottom];
        
        //RepliedTopics 部分
        
        CGFloat repliedTopicsTableContentHeight = 0;
        for (NSDictionary *topic in repliedTopics) {
            NSString *text = [topic objectForKey:@"title"];
            CGSize maximumLabelSize = CGSizeMake(226, 200);
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
            CGFloat titleLabelHeight = size.height;
            CGFloat cellPadding = [VMTopicsVC cellPadding];
            CGFloat cellHeight = cellPadding + titleLabelHeight + 7 + 8 + cellPadding;
            repliedTopicsTableContentHeight += cellHeight;
        }
        
        UILabel *repliedTopicsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 250+topicsTableContentHeight, 200, 20)];
        repliedTopicsLabel.text = @"参与的主题";
        repliedTopicsLabel.font = [UIFont boldSystemFontOfSize:16];
        repliedTopicsLabel.backgroundColor = [UIColor clearColor];
        [rootView addSubview:repliedTopicsLabel];
        
        repliedTopicsTableVC = [[VMTopicsVC alloc] initWithTopics:topics withAvatar:NO refreshTableHeaderView:nil parentVC:self];
        repliedTopicsTableVC.view.frame = CGRectMake(8, 275+topicsTableContentHeight, CONTENT_WIDTH, topicsTableContentHeight);
        repliedTopicsTableVC.tableView.scrollEnabled = NO;
        
        [rootView addSubview:repliedTopicsTableVC.view];
        
        //TopicsTable 表头圆角
        UIView *headView2 = [[UIView alloc] initWithFrame:CGRectMake(8, repliedTopicsTableVC.view.frame.origin.y-5, 304, 5)];
        headView2.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
        [rootView addSubview:headView2];
        UIImageView *cornerLeftTop2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-corner-left-top.png"]];
        cornerLeftTop2.frame = CGRectMake(0, 0, 5, 5);
        [headView2 addSubview:cornerLeftTop2];
        UIImageView *cornerRightTop2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-corner-right-top.png"]];
        cornerRightTop2.frame = CGRectMake(299, 0, 5, 5);
        [headView2 addSubview:cornerRightTop2];
        
        //TopicsTable 表尾圆角
        UIView *footView2 = [[UIView alloc] initWithFrame:CGRectMake(8, repliedTopicsTableVC.view.frame.origin.y+repliedTopicsTableVC.view.frame.size.height, CONTENT_WIDTH, 5)];
        footView2.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
        [rootView addSubview:footView2];
        UIImageView *cornerLeftBottom2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-corner-left-bottom.png"]];
        cornerLeftBottom2.frame = CGRectMake(0, 0, 5, 5);
        [footView2 addSubview:cornerLeftBottom2];
        UIImageView *cornerRightBottom2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-corner-right-bottom.png"]];
        cornerRightBottom2.frame = CGRectMake(299, 0, 5, 5);
        [footView2 addSubview:cornerRightBottom2];
        
        rootView.contentSize = CGSizeMake(320, repliedTopicsTableVC.view.frame.origin.y+repliedTopicsTableVC.view.frame.size.height+20);
    }
}

- (void)cancel
{
    //    TODO
    NSLog(@"Load Topics Failed");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
