//
//  VMDetailViewController.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/11/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMOldTopicVC.h"
#import "VMRepliesLoader.h"
#import "VMImageLoader.h"
#import "VMAccount.h"
#import "VMReplyVC.h"
#import "VMInfoView.h"
#import "VMWaitingView.h"
#import "VMLoginHandler.h"
#import "Config.h"
#import "VMMemberVC.h"
#import "VMWebContentVC.h"

//#define WAITING_VIEW_TAG 1

#define NAME_TAG 11
#define TIME_TAG 12
#define IMAGE_TAG 13
#define CONTENT_TAG 14
#define STATIC_TAG_IN 15
#define LOADING_REPLY_VIEW_TAG 16
#define NODE_TAG 16
#define REPLY_TAG 17
#define POPUP_WINDOW_TAG 18
#define ASK_LOGIN_TAG 19
#define LOGIN_PROMPT_TAG 20
#define INFO_VIEW_TAG 21


#define ROW_HEIGHT 70
#define IMAGE_SIDE 48
#define REPLY_IMAGE_SIDE 24
#define BORDER_WIDTH 5
#define LABEL_HEIGHT 12
#define WINDOW_WIDTH 320
#define WINDOW_HEIGHT 367

#define PADDING 5
#define IMAGE_SIZE 48

#define LABEL_WIDTH 130
#define TEXT_OFFSET_X (BORDER_WIDTH * 2 + IMAGE_SIDE)
#define TEXT_OFFSET_Y (BORDER_WIDTH * 2 + LABEL_HEIGHT)
#define TEXT_WIDTH (320 - TEXT_OFFSET_X - BORDER_WIDTH)
#define TEXT_HEIGHT (ROW_HEIGHT - TEXT_OFFSET_Y - BORDER_WIDTH)

@implementation VMOldTopicVC

@synthesize topic = _topic;

- (id)initWithTopic:(NSDictionary *)topic
{
    self = [super init];
    if (self) {
        imgBnt2name = [[NSMutableDictionary alloc] init];
        self.topic = topic;
        topicURL = [NSURL URLWithString:[[[_topic objectForKey:@"url"] componentsSeparatedByString:@"#"] objectAtIndex:0]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replySuccess) name:@"reply_success" object:nil];
    }
    return self;
}

#pragma mark - Managing the detail item
- (void)updateView
{
    if (!self.title) {
        self.title = [self.topic objectForKey:@"node"];
    }
    VMRepliesLoader *repliesLoader = [[VMRepliesLoader alloc] initWithDelegate:self];
    [repliesLoader loadRepliesWithURL:topicURL];
}

#pragma mark - Actions
- (void)favoriteTopic
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    favoriting = YES;
    if ([VMAccount getInstance].cookie == nil) {
        loginHandler = [[VMLoginHandler alloc] initWithDelegate:self];
        [loginHandler login];
        return;
    }
    
    NSString *msg = @"正在收藏";
    if (favorited) {
        msg = @"正在取消收藏";
    }
    waittingView = [[VMwaitingView alloc] initWithMessage:msg];
    [waittingView setLoadingCenter:CGPointMake(WINDOW_WIDTH/2, self.tableView.contentOffset.y+WINDOW_HEIGHT/2)];
    [self.view addSubview:waittingView];
    
    VMRepliesLoader *repliesLoader = [[VMRepliesLoader alloc] initWithDelegate:self];
    repliesLoader.referer = [topicURL description];
    [repliesLoader loadRepliesWithURL:[NSURL URLWithString:favURL]];
}

- (void)reply
{
    if ([VMAccount getInstance].cookie) {
        VMReplyVC *replyVC = [[VMReplyVC alloc] initWithURL:topicURL];
        [self.navigationController pushViewController:replyVC animated:YES];
        return;
    }
    loginHandler = [[VMLoginHandler alloc] initWithDelegate:self];
    [loginHandler login];
}

- (void)replySuccess
{
    VMInfoView *infoView = [[VMInfoView alloc] initWithMessage:@"发送成功"];
    infoView.center = CGPointMake(WINDOW_WIDTH/2, self.tableView.contentOffset.y+WINDOW_HEIGHT/2);
    infoView.tag = INFO_VIEW_TAG;
    [self.view addSubview:infoView];
    [self performSelector:@selector(removeInfoView) withObject:nil afterDelay:1];
    
    [self updateView];
    
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
    if (favoriting) {
        [self favoriteTopic];
    } else {
        [self reply];
    }
}

#pragma mark - tableView delegate
- (UITableViewCell *)repliesTipCellWithReuseIdentifier:(NSString *)identifier
{
    UITableViewCell *tipCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    tipCell.selectionStyle = UITableViewCellSelectionStyleNone;
    tipCell.frame = CGRectMake(0, 0, WINDOW_WIDTH, 17);
    
    tipCell.textLabel.textAlignment = UITextAlignmentLeft;
    tipCell.textLabel.textColor = [UIColor grayColor];
    tipCell.textLabel.font = [UIFont systemFontOfSize:10];
    NSString *replyNum = [_topic objectForKey:@"replies"];
    if (!replyNum || [replyNum isEqualToString:@""]) {
        replyNum = [NSString stringWithFormat:@"%d", [replies count]];
        if (!replyNum || [replyNum isEqualToString:@""]) {
            replyNum = @"0";
        }
    }
    tipCell.textLabel.text = [NSString stringWithFormat:@"共收到 %@ 个回复", replyNum];
    
    return tipCell;
}

- (UITableViewCell *)topicCellWithReuseIdentifier:(NSString *)identifier
{
    UITableViewCell *topicCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    topicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    topicCell.frame = CGRectMake(0, 0, WINDOW_WIDTH, 0);
    
    // User Image
    UIButton *userImgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [userImgButton addTarget:self action:@selector(showMember:) forControlEvents:UIControlEventTouchUpInside];
    userImgButton.frame = CGRectMake(PADDING, PADDING, IMAGE_SIZE, IMAGE_SIZE);
    VMImageLoader *imgLoader = [[VMImageLoader alloc] init];
    [imgLoader loadImageWithURL:[NSURL URLWithString:[_topic objectForKey:@"img_url"]] forImageButton:userImgButton];
    [topicCell addSubview:userImgButton];
    
    // Title
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(userImgButton.frame.origin.x + userImgButton.frame.size.width + PADDING, PADDING, WINDOW_WIDTH-(userImgButton.frame.origin.x + userImgButton.frame.size.width + PADDING)-PADDING, 0)];
    titleView.font = [UIFont boldSystemFontOfSize:14];
    titleView.highlightedTextColor = [UIColor whiteColor];
    titleView.opaque = NO;
    titleView.text = [_topic objectForKey:@"title"];
    titleView.lineBreakMode = UILineBreakModeCharacterWrap;
    titleView.numberOfLines = 0;
    [titleView sizeToFit];
    [topicCell addSubview:titleView];
    
    //    NSLog(@"%f", PADDING+contentView.frame.origin.y+contentView.frame.size.height);
    // by
    UILabel *staticLabel_by = [[UILabel alloc] initWithFrame:CGRectMake(PADDING*2+userImgButton.frame.size.width, PADDING+titleView.frame.origin.y+titleView.frame.size.height, 0, 0)];
    staticLabel_by.font = [UIFont systemFontOfSize:9];
    staticLabel_by.highlightedTextColor = [UIColor whiteColor];
    staticLabel_by.opaque = NO;
    staticLabel_by.textColor = [UIColor grayColor];
    staticLabel_by.text = @"by";
    [staticLabel_by sizeToFit];
    [topicCell addSubview:staticLabel_by];
    
    //    NSLog(@"%f", staticLabel_by.frame.origin.y + staticLabel_by.frame.size.height + PADDING);
    // author
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(staticLabel_by.frame.origin.x + staticLabel_by.frame.size.width + PADDING, staticLabel_by.frame.origin.y, 0, 0)];
    authorLabel.font = [UIFont systemFontOfSize:9];
    authorLabel.highlightedTextColor = [UIColor whiteColor];
    authorLabel.opaque = NO;
    authorLabel.text = [_topic objectForKey:@"author"];
    [authorLabel sizeToFit];
    [topicCell addSubview:authorLabel];
    
    // at
    UILabel *staticLabel_at = [[UILabel alloc] initWithFrame:CGRectMake(authorLabel.frame.origin.x + authorLabel.frame.size.width + PADDING, authorLabel.frame.origin.y, 0, 0)];
    staticLabel_at.font = [UIFont systemFontOfSize:9];
    staticLabel_at.highlightedTextColor = [UIColor whiteColor];
    staticLabel_at.opaque = NO;
    staticLabel_at.textColor = [UIColor grayColor];
    staticLabel_at.text = @"at";
    [staticLabel_at sizeToFit];
    [topicCell addSubview:staticLabel_at];
    
    // time
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(staticLabel_at.frame.origin.x + staticLabel_at.frame.size.width + PADDING, staticLabel_by.frame.origin.y, 0, 0)];
    timeLabel.font = [UIFont systemFontOfSize:9];
    timeLabel.highlightedTextColor = [UIColor whiteColor];
    timeLabel.opaque = NO;
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.text = [_topic objectForKey:@"time"];
    
    [timeLabel sizeToFit];
    [topicCell addSubview:timeLabel];
    
    // Fav button
    if (favURL) {
        if (!self.navigationItem.rightBarButtonItem) {
            NSString *title;
            if (favorited) {
                title = @"取消收藏";
            } else {
                title = @"收藏";
            }
            UIBarButtonItem *favButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(favoriteTopic)];
            self.navigationItem.rightBarButtonItem = favButton;
        }
    }
    
//    NSLog(@"%f", titleView.frame.origin.y+titleView.frame.size.height+PADDING);
    // Content
    UILabel *contentView = [[UILabel alloc] initWithFrame:CGRectMake(userImgButton.frame.origin.x, userImgButton.frame.origin.y+userImgButton.frame.size.height+PADDING, WINDOW_WIDTH-PADDING, 0)];
    contentView.font = [UIFont systemFontOfSize:12];
    contentView.highlightedTextColor = [UIColor whiteColor];
    contentView.opaque = NO;
    contentView.text = content;
//    NSLog(@"%@", content);
    contentView.lineBreakMode = UILineBreakModeWordWrap;
    contentView.numberOfLines = 0;
    [contentView sizeToFit];
    [topicCell addSubview:contentView];
    
    // replies
    if (!replies) {
        // replies loading
        UIView *loadingReplyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 50)];
        loadingReplyView.center = CGPointMake(WINDOW_WIDTH/2, timeLabel.frame.origin.y + timeLabel.frame.size.height+PADDING);
        loadingReplyIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        loadingReplyIndicatorView.color = [UIColor grayColor];
        loadingReplyIndicatorView.center = CGPointMake(loadingReplyView.frame.size.width/2, loadingReplyView.frame.size.height/2+25);
        [loadingReplyView addSubview:loadingReplyIndicatorView];
        loadingReplyView.tag = LOADING_REPLY_VIEW_TAG;
        [topicCell addSubview:loadingReplyView];
        [loadingReplyIndicatorView startAnimating];
    }
    
    // Update cell height
    CGRect topicCellFrame = topicCell.frame;
    topicCellFrame.size.height = MAX(contentView.frame.origin.y + contentView.frame.size.height + PADDING, timeLabel.frame.origin.y + timeLabel.frame.size.height + PADDING);
//    NSLog(@"%f", topicCellFrame.size.height);
    topicCell.frame = topicCellFrame;
    
    return topicCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *topicCellIdentifier = @"TopicCell";
        
        if (content) {
            return [self topicCellWithReuseIdentifier:topicCellIdentifier];
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topicCellIdentifier];
        if (cell == nil) {
            cell = [self topicCellWithReuseIdentifier:topicCellIdentifier];
        }
        return cell;
    }
    if (indexPath.row == 1) {
        static NSString *repliesTipCellIdentifier = @"RepliesTipCell";
        
        if (content) {
            return [self repliesTipCellWithReuseIdentifier:repliesTipCellIdentifier];
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:repliesTipCellIdentifier];
        if (cell == nil) {
            cell = [self repliesTipCellWithReuseIdentifier:repliesTipCellIdentifier];
        }
        return cell;
    }
    if (indexPath.row < [replies count]+2) {
        static NSString *topicCellIdentifier = @"ReplyCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topicCellIdentifier];
        if (cell == nil) {
            cell = [self replyCellWithReuseIdentifier:topicCellIdentifier];
        }
        [self configureReplyCell:cell forIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	return cell.frame.size.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (replies) {
        return [replies count] + 2;
    }
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([VMAccount getInstance].cookie) {
        if (indexPath.row == 0) {
            NSString *author = [_topic objectForKey:@"author"];
            VMWebContentVC *webContentVC = [[VMWebContentVC alloc] initWithHTML:html author:author forURL:topicURL];
            [self.navigationController pushViewController:webContentVC animated:YES];
        } else if (indexPath.row > 1) {
            NSString *author = [[replies objectAtIndex:indexPath.row-2] objectForKey:@"author"];
            NSString *htmlContent = [[replies objectAtIndex:indexPath.row-2] objectForKey:@"html"];
            VMWebContentVC *webContentVC = [[VMWebContentVC alloc] initWithHTML:htmlContent author:author forURL:topicURL];
            [self.navigationController pushViewController:webContentVC animated:YES];
        }
    } else {
        loginHandler = [[VMLoginHandler alloc] initWithDelegate:self];
        [loginHandler login];
    }
}


- (UITableViewCell *)replyCellWithReuseIdentifier:(NSString *)identifier
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.frame = CGRectMake(0, 0, WINDOW_WIDTH, 0);
    
    //Userpic view
    CGRect rect = CGRectMake(BORDER_WIDTH, BORDER_WIDTH, REPLY_IMAGE_SIDE, REPLY_IMAGE_SIDE);
    UIButton *userImgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [userImgButton addTarget:self action:@selector(showMember:) forControlEvents:UIControlEventTouchUpInside];
    userImgButton.frame = rect;
    userImgButton.tag = IMAGE_TAG;
    [cell addSubview:userImgButton];
    
    UILabel *label;
    
    //Username
    rect = CGRectMake(BORDER_WIDTH+REPLY_IMAGE_SIDE+BORDER_WIDTH, BORDER_WIDTH, 0, LABEL_HEIGHT); // not sure: W
    label = [[UILabel alloc] initWithFrame:rect];
    label.tag = NAME_TAG;
    label.font = [UIFont boldSystemFontOfSize:9];
    label.highlightedTextColor = [UIColor whiteColor];
    [cell addSubview:label];
    label.opaque = NO;
    label.backgroundColor = [UIColor clearColor];
    
    //Message body
    
    //Reply time
    rect = CGRectMake(0, BORDER_WIDTH, LABEL_WIDTH, LABEL_HEIGHT); // not sure: X
    label = [[UILabel alloc] initWithFrame:rect];
    label.tag = TIME_TAG;
    label.font = [UIFont systemFontOfSize:9];
    label.textColor = [UIColor grayColor];
    [cell addSubview:label];
    label.opaque = NO;
    label.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)configureReplyCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *reply = [replies objectAtIndex:indexPath.row-2];
    
    // Configure the cell.
    CGRect cellFrame = [cell frame];
    //Set reply content
    CGRect rect = CGRectMake(BORDER_WIDTH+REPLY_IMAGE_SIDE+BORDER_WIDTH, TEXT_OFFSET_Y, TEXT_WIDTH, 0); // not sure: H
    UILabel *contentView = [[UILabel alloc] initWithFrame:rect];
    contentView.font = [UIFont systemFontOfSize:12];
    contentView.highlightedTextColor = [UIColor whiteColor];
    contentView.opaque = NO;
    contentView.text = [reply objectForKey:@"content"];
    contentView.lineBreakMode = UILineBreakModeWordWrap;
    contentView.numberOfLines = 0;
    [contentView sizeToFit];
    rect = contentView.frame;
    rect.size.width = TEXT_WIDTH;
    rect.size.height += PADDING;
    contentView.frame = rect;
    [cell.contentView addSubview:contentView];
    
    cellFrame.size.height = contentView.frame.origin.y + contentView.frame.size.height;
    
    [cell setFrame:cellFrame];
    cell.clipsToBounds = YES;
    
    //Set date and time
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:TIME_TAG];
    timeLabel.highlightedTextColor = [UIColor whiteColor];
    timeLabel.opaque = NO;
    timeLabel.text = [NSString stringWithFormat:@"#%d - %@", indexPath.row - 1, [reply objectForKey:@"time"]];
    [timeLabel sizeToFit];
    CGRect timeFrame = [timeLabel frame];
    timeFrame.origin.x = 320-BORDER_WIDTH-timeFrame.size.width;
    [timeLabel setFrame:timeFrame];
    
    //Set userpic
    UIButton *imageView = (UIButton *)[cell viewWithTag:IMAGE_TAG];
    [imageView setImage:[UIImage imageNamed:@"loading.png"] forState:UIControlStateNormal];
    [imgBnt2name setValue:[reply objectForKey:@"author"] forKey:[NSString stringWithFormat:@"%d", imageView]];
    VMImageLoader *imgLoader = [[VMImageLoader alloc] init];
    NSString *imgURL = [reply objectForKey:@"img_url"];
    [imgLoader loadImageWithURL:[NSURL URLWithString:imgURL] forImageButton:imageView];
    
    //Set user name
    UILabel *userLabel = (UILabel *)[cell viewWithTag:NAME_TAG];
    userLabel.highlightedTextColor = [UIColor whiteColor];
    userLabel.opaque = NO;
    userLabel.text = [reply objectForKey:@"author"];
    [userLabel sizeToFit];
}

#pragma mark - RepliesLoader delegate
- (void)didFinishedLoadingWithData:(NSDictionary *)topic
{
    NSMutableDictionary *newTopic = [NSMutableDictionary dictionaryWithDictionary:_topic];
    [newTopic setValue:[topic objectForKey:@"title"] forKey:@"title"];
    [newTopic setValue:[topic objectForKey:@"img_url"] forKey:@"img_url"];
    [newTopic setValue:[topic objectForKey:@"author"] forKey:@"author"];
    [newTopic setValue:[topic objectForKey:@"time"] forKey:@"time"];
    _topic = newTopic;
    content = [topic objectForKey:@"content"];
    html = [topic objectForKey:@"html"];
    if (replies && needAppendRepilies) {
        [[topic objectForKey:@"replies"] addObjectsFromArray:replies];
        needAppendRepilies = NO;
    }
    replies = [topic objectForKey:@"replies"];
    favURL = [topic objectForKey:@"fav_url"];
    favorited = [favURL hasPrefix:[NSString stringWithFormat:@"%@%@", V2EX_URL, @"/unfavorite"]];
    if (favoriting) {
        if (favorited) {
            self.navigationItem.rightBarButtonItem.title = @"取消收藏";
        } else {
            self.navigationItem.rightBarButtonItem.title = @"收藏";
        }
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    favoriting = NO;
    
    if ([topic objectForKey:@"next_page"] > @"0") {
        needAppendRepilies = YES;
        VMRepliesLoader *repliesLoader = [[VMRepliesLoader alloc] initWithDelegate:self];
        [repliesLoader loadRepliesWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?p=%@", [topicURL description], [topic objectForKey:@"next_page"]]]];
    } else {
        [self.tableView reloadData];
        [loadingReplyIndicatorView stopAnimating];
        [loadingReplyIndicatorView removeFromSuperview];
        [waittingView removeFromSuperview];
    }
}

- (void)cancel
{
    VMInfoView *infoView = [[VMInfoView alloc] initWithMessage:@"加载失败"];
    infoView.center = CGPointMake(WINDOW_WIDTH/2, self.tableView.contentOffset.y+WINDOW_HEIGHT/2);
    [self.view addSubview:infoView];
    [self performSelector:@selector(removeInfoView:) withObject:infoView afterDelay:2];
}

- (void)removeInfoView:(id)infoView
{
    [(UIView *)infoView removeFromSuperview];
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - webview delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (webView.tag == POPUP_WINDOW_TAG) {
        return YES;
    }
    if ([[request.URL description] isEqual:[topicURL description]]) {
        return YES;
    }
    popupURL = [request URL];
    UIWebView *newWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
    newWebView.tag = POPUP_WINDOW_TAG;
    newWebView.delegate = self;
    UIView *newWindow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
    [newWindow addSubview:newWebView];
    popupLoadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    popupLoadingView.color = [UIColor grayColor];
    popupLoadingView.center = newWebView.center;
    [newWebView addSubview:popupLoadingView];
    [popupLoadingView startAnimating];
    popupWindowVC = [[UIViewController alloc] init];
    popupWindowVC.view = newWindow;
    [self.navigationController pushViewController:popupWindowVC animated:YES];
    [newWebView loadRequest:request];
    return NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    popupWindowVC.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title;"];
    [popupLoadingView stopAnimating];
    [popupLoadingView removeFromSuperview];
}

- (void)showMember:(UIButton *)imgBnt
{
    VMMemberVC *memberVC = [[VMMemberVC alloc] initWithName:[imgBnt2name objectForKey:[NSString stringWithFormat:@"%d", imgBnt]]];
    [self.navigationController pushViewController:memberVC animated:YES];
}

@end
