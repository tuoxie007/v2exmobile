//
//  VMRepliesVC.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 5/11/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMRepliesVC.h"

@implementation ReplyContentCell

- (id)initWithReply:(NSDictionary *)_reply delegate:(id<ReplyContentCellDelegate>)_delegate
{
    self = [super init];
    if (self) {
        reply = _reply;
        delegate = _delegate;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.tag = 102;
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.frame = CGRectMake(0, 0, CONTENT_WIDTH, 1000);
        [self addSubview:bgView];
        
        UIButton *avatar = [[UIButton alloc] initWithFrame:CGRectMake(CONTENT_PADDING_LEFT, CONTENT_PADDING_TOP, AVATAR_WIDTH_MINI, AVATAR_WIDTH_MINI)];
        [[[VMImageLoader alloc] init] loadImageWithURL:[NSURL URLWithString:[[reply objectForKey:@"member"] objectForKey:@"avatar_normal"]] forImageButton:avatar];
        [self addSubview:avatar];
        
        UILabel *author = [[UILabel alloc] initWithFrame:CGRectMake(avatar.frame.origin.x+avatar.frame.size.width+CONTENT_PADDING_LEFT, CONTENT_PADDING_TOP, 0, 0)];
        author.text = [[reply objectForKey:@"member"] objectForKey:@"username"];
        author.textColor = [Commen defaultTextColor];
        author.font = [UIFont systemFontOfSize:12];
        [author sizeToFit];
        [self addSubview:author];
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(author.frame.origin.x+author.frame.size.width+CONTENT_PADDING_LEFT, 0, 0, 0)];
        time.text = [Commen timeAsDisplay:[NSDate dateWithTimeIntervalSince1970:[[reply objectForKey:@"created"] intValue]]];
        time.textColor = [Commen defaultLightTextColor];
        time.font = [UIFont systemFontOfSize:9];
        [time sizeToFit];
        time.frame = CGRectMake(time.frame.origin.x, author.frame.origin.y+author.frame.size.height-time.frame.size.height, time.frame.size.width, time.frame.size.height);
        [self addSubview:time];
        
        UIButton *action = [[UIButton alloc] initWithFrame:CGRectMake(CONTENT_WIDTH-CONTENT_PADDING_LEFT-23, PADDING_TOP, 23, 23)];
        [action setImage:[UIImage imageNamed:@"reply-action-button.png"] forState:UIControlStateNormal];
        [self addSubview:action];
        
        NSNumber *contentHeight = [reply objectForKey:@"content-height"];
        UIWebView *content = [[UIWebView alloc] initWithFrame:CGRectMake(author.frame.origin.x, author.frame.origin.y+author.frame.size.height+5, CONTENT_WIDTH-CONTENT_PADDING_LEFT*4-AVATAR_WIDTH_MINI-action.frame.size.width, contentHeight ? [contentHeight intValue] : 1)];
        content.scrollView.scrollEnabled = NO;
        content.delegate = contentHeight ? nil : self;
        [content loadHTMLString:[NSString stringWithFormat:@"<body style=\"font-size:12px;padding:0;margin:0;\">%@</body>", [reply objectForKey:@"content_rendered"]] baseURL:nil];
        [self addSubview:content];
        
        UIImageView *titleSep = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-cell-separator.png"]];
        titleSep.tag = 101;
        [self addSubview:titleSep];
    }
    return self;
}

#pragma mark - WebView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    
    UIImageView *titleSep = (UIImageView *)[self viewWithTag:101];
    titleSep.frame = CGRectMake(0, webView.frame.origin.y+webView.frame.size.height+CONTENT_PADDING_TOP, CONTENT_WIDTH, 1);
    
//    self.frame = CGRectMake(0, 0, CONTENT_WIDTH, titleSep.frame.origin.y+titleSep.frame.size.height+1);
    UIView *bgView = [self viewWithTag:102];
    bgView.frame = CGRectMake(0, 0, CONTENT_WIDTH, titleSep.frame.origin.y+titleSep.frame.size.height+1);
    
    [reply setValue:[NSNumber numberWithFloat:titleSep.frame.origin.y+titleSep.frame.size.height+1] forKey:@"height"];
    [reply setValue:[NSNumber numberWithFloat:webView.frame.size.height] forKey:@"content-height"];
    
    [delegate ressignHeightForCell:self];
}

@end

@interface VMRepliesVC ()
{
    NSDictionary *topic;
    NSArray *replies;
}
@end

@implementation VMRepliesVC

- (id)initWithTopic:(NSDictionary *)_topic
{
    self = [super init];
    if (self) {
        topic = _topic;
        replies = [topic objectForKey:@"replies"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.79 alpha:1];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return replies.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = [[replies objectAtIndex:indexPath.row] objectForKey:@"height"];
    if (height) {
        return [height floatValue];
    }
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *reply = [replies objectAtIndex:indexPath.row];
    static NSString *CellIdentifier;
    CellIdentifier = [NSString stringWithFormat:@"ReplyCell-%d", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ReplyContentCell alloc] initWithReply:reply delegate:self];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)ressignHeightForCell:(ReplyContentCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

@end
