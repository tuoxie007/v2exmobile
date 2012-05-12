//
//  VMTopicVC.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 5/10/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMTopicVC.h"
#import "VMRepliesVC.h"

@interface VMTopicVC ()
{
    NSDictionary *topic;
    UIView *topicView;
    VMRepliesVC *repliesVC;
    CGRect repliesFrame;
}
@end

@implementation VMTopicVC

- (id)initWithTopic:(NSDictionary *)_topic
{
    self = [super init];
    if (self) {
        topic = _topic;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.79 alpha:1];
    
    topicView = [[UIView alloc] init];
    topicView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *topicViewHead = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"box-border-top-bg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0]];
    topicViewHead.frame = CGRectMake(0, 0, CONTENT_WIDTH, 5);
    [topicView addSubview:topicViewHead];
    
    UIButton *avatar = [[UIButton alloc] initWithFrame:CGRectMake(CONTENT_PADDING_LEFT, CONTENT_PADDING_TOP, AVATAR_WIDTH, AVATAR_WIDTH)];
    [[[VMImageLoader alloc] init] loadImageWithURL:[NSURL URLWithString:[[topic objectForKey:@"member"] objectForKey:@"avatar_large"]] forImageButton:avatar];
    [topicView addSubview:avatar];
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_PADDING_LEFT+AVATAR_WIDTH+CONTENT_PADDING_LEFT, CONTENT_PADDING_TOP-5, CONTENT_WIDTH-CONTENT_PADDING_LEFT*3-AVATAR_WIDTH, 0)];
    titleView.font = [UIFont boldSystemFontOfSize:14];
    titleView.textColor = [Commen defaultTextColor];
    titleView.text = [topic objectForKey:@"title"];
    titleView.lineBreakMode = UILineBreakModeCharacterWrap;
    titleView.numberOfLines = 0;
    [titleView sizeToFit];
    [topicView addSubview:titleView];
    
    UILabel *timeAndClicksView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    timeAndClicksView.font = [UIFont boldSystemFontOfSize:9];
    timeAndClicksView.textColor = [Commen defaultLightTextColor];
    NSDate *time = [NSDate dateWithTimeIntervalSince1970:[[topic objectForKey:@"created"] intValue]];
    timeAndClicksView.text = [NSString stringWithFormat:@"%@, %d 次点击", [Commen timeAsDisplay:time], 168];
    [timeAndClicksView sizeToFit];
    CGFloat infoY = MAX(CONTENT_PADDING_TOP+titleView.frame.origin.y+titleView.frame.size.height, avatar.frame.origin.y+avatar.frame.size.height-timeAndClicksView.frame.size.height);
    timeAndClicksView.frame = CGRectMake(CONTENT_WIDTH-CONTENT_PADDING_LEFT-timeAndClicksView.frame.size.width, infoY, timeAndClicksView.frame.size.width, timeAndClicksView.frame.size.height);
    [topicView addSubview:timeAndClicksView];
    
    UILabel *authorView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    authorView.font = [UIFont boldSystemFontOfSize:9];
    authorView.textColor = [Commen defaultTextColor];
    authorView.text = [[topic objectForKey:@"member"] objectForKey:@"username"];
    [authorView sizeToFit];
    authorView.frame = CGRectMake(CONTENT_WIDTH-CONTENT_PADDING_LEFT-timeAndClicksView.frame.size.width-authorView.frame.size.width-5, infoY, authorView.frame.size.width, authorView.frame.size.height);
    [topicView addSubview:authorView];
    
    UILabel *byView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    byView.font = [UIFont boldSystemFontOfSize:9];
    byView.textColor = [Commen defaultLightTextColor];
    byView.text = @"By";
    [byView sizeToFit];
    byView.frame = CGRectMake(CONTENT_WIDTH-CONTENT_PADDING_LEFT-timeAndClicksView.frame.size.width-authorView.frame.size.width-5-byView.frame.size.width-5, infoY, byView.frame.size.width, byView.frame.size.height);
    [topicView addSubview:byView];
    
    UIImageView *titleSep = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-cell-separator.png"]];
    titleSep.frame = CGRectMake(0, infoY+timeAndClicksView.frame.size.height+CONTENT_PADDING_TOP, CONTENT_WIDTH, 1);
    [topicView addSubview:titleSep];
    
    UIWebView *contentView = [[UIWebView alloc] initWithFrame:CGRectMake(CONTENT_PADDING_LEFT, titleSep.frame.origin.y+titleSep.frame.size.height+5, CONTENT_WIDTH-CONTENT_PADDING_LEFT*2, 1)];
    contentView.scrollView.scrollEnabled = NO;
    contentView.delegate = self;
    [contentView loadHTMLString:[NSString stringWithFormat:@"<body style=\"font-size:12px;padding:0;margin:0;\">%@</body>", [topic objectForKey:@"content_rendered"]] baseURL:nil];
    [topicView addSubview:contentView];
    
    [self.view addSubview:topicView];
    
    [[VMAPI sharedAPI] repliesWithDelegate:self forTopicId:[[topic objectForKey:@"id"] intValue]];
}

- (void)didFinishedLoadingWithData:(id)data
{
    [topic setValue:data forKey:@"replies"];
    repliesVC = [[VMRepliesVC alloc] initWithTopic:topic];
    repliesVC.view.frame = CGRectMake(PADDING_LEFT, 0, CONTENT_WIDTH, 367);
    UIView *repliesViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CONTENT_WIDTH, topicView.frame.size.height)];
    repliesViewHeader.backgroundColor = self.view.backgroundColor;
    [repliesViewHeader addSubview:topicView];
    topicView.frame = CGRectMake(0, topicView.frame.origin.y, topicView.frame.size.width, topicView.frame.size.height);
    repliesVC.tableView.tableHeaderView = repliesViewHeader;
    [self.view addSubview:repliesVC.view];
}

- (void)cancel
{
//    TODO
    NSLog(@"Load replies failed");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    
    
    UIImageView *contentSep = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"box-shadow-bg1.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0]];
    contentSep.frame = CGRectMake(0, webView.frame.origin.y+webView.frame.size.height+CONTENT_PADDING_TOP, CONTENT_WIDTH, 4);
    [topicView addSubview:contentSep];
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, contentSep.frame.origin.y+contentSep.frame.size.height, CONTENT_WIDTH, 26)];
    infoView.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    [topicView addSubview:infoView];
    
    UILabel *favView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    favView.font = [UIFont boldSystemFontOfSize:9];
    favView.textColor = [Commen defaultLightTextColor];
    favView.backgroundColor = [UIColor clearColor];
    favView.text = [NSString stringWithFormat:@"已有 %d 人收藏此主题", 12];
    [favView sizeToFit];
    favView.frame = CGRectMake(CONTENT_PADDING_LEFT, 5, favView.frame.size.width, favView.frame.size.height);
    [infoView addSubview:favView];
    
    UIImageView *topicViewFoot = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"box-shadow-bg2.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:0]];
    topicViewFoot.frame = CGRectMake(0, infoView.frame.origin.y+infoView.frame.size.height, CONTENT_WIDTH, 4);
    [topicView addSubview:topicViewFoot];
    
    if ([[topic objectForKey:@"replies"] intValue]) {
        UIView *topicViewFootTraBg = [[UIView alloc] init];
        topicViewFootTraBg.frame = CGRectMake(0, topicViewFoot.frame.origin.y+topicViewFoot.frame.size.height, CONTENT_WIDTH, 12);;
        topicViewFootTraBg.backgroundColor = [Commen backgroundColor];
        [topicView addSubview:topicViewFootTraBg];
        
        UIImageView *topicViewFootTra = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"replies-table-top-tra.png"]];
        topicViewFootTra.frame = CGRectMake(CONTENT_PADDING_LEFT, topicViewFoot.frame.origin.y+topicViewFoot.frame.size.height+6, 10, 6);
        topicViewFootTra.backgroundColor = [Commen backgroundColor];
        [topicView addSubview:topicViewFootTra];
        
        UIImageView *repliesViewHead = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"box-border-top-bg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0]];
        repliesViewHead.frame = CGRectMake(0, topicViewFootTra.frame.origin.y+topicViewFootTra.frame.size.height, CONTENT_WIDTH, 5);
        [topicView addSubview:repliesViewHead];
        
        topicView.frame = CGRectMake(8, PADDING_TOP, CONTENT_WIDTH, repliesViewHead.frame.origin.y+repliesViewHead.frame.size.height+CONTENT_PADDING_TOP);
    } else {
        topicView.frame = CGRectMake(8, PADDING_TOP, CONTENT_WIDTH, infoView.frame.origin.y+infoView.frame.size.height+CONTENT_PADDING_TOP);
    }
}

@end
