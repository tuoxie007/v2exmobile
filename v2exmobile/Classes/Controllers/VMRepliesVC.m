//
//  VMRepliesVC.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 5/11/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMRepliesVC.h"
#import <QuartzCore/QuartzCore.h>

@implementation ReplyContentCell

- (id)initWithReply:(NSDictionary *)_reply indexPath:(NSIndexPath *)indexPath
{
    self = [super init];
    if (self) {
        reply = _reply;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
        
        UIButton *action = [[UIButton alloc] initWithFrame:CGRectMake(CONTENT_WIDTH-CONTENT_PADDING_LEFT-23, CONTENT_PADDING_TOP, 23, 23)];
        [action setImage:[UIImage imageNamed:@"reply-action-button.png"] forState:UIControlStateNormal];
        [action addTarget:self action:@selector(actionButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:action];
        
        CGRect frame = CGRectMake(author.frame.origin.x, author.frame.origin.y+author.frame.size.height+5, CONTENT_WIDTH-CONTENT_PADDING_LEFT*4-AVATAR_WIDTH_MINI-action.frame.size.width, 18);
        [DTAttributedTextContentView setLayerClass:[CATiledLayer class]];
        DTAttributedTextView *contentView = [[DTAttributedTextView alloc] initWithFrame:frame];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        contentView.attributedString = [reply objectForKey:@"attributed-string"];
        [self addSubview:contentView];
        
        if (indexPath.row) {
            UIImageView *titleSep = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-cell-separator.png"]];
            [self addSubview:titleSep];
        }
        
        self.frame = CGRectMake(0, 0, CONTENT_WIDTH, contentView.frame.origin.y+contentView.contentSize.height+CONTENT_PADDING_TOP);
    }
    return self;
}

- (void)actionButtonTouched
{
    UIButton *actionCancelButton = (UIButton *)[self viewWithTag:300];
    if (actionCancelButton == nil) {
        actionCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CONTENT_WIDTH, self.frame.size.height)];
        actionCancelButton.tag = 300;
        [actionCancelButton addTarget:self action:@selector(cancelButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:actionCancelButton];
    }
    actionCancelButton.hidden = NO;
    
    UIImageView *actionBG = (UIImageView *)[self viewWithTag:301];
    if (actionBG == nil) {
        actionBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reply-action-bg.png"]];
        actionBG.tag = 301;
        [actionBG sizeToFit];
        actionBG.center = CGPointMake(232, 20);
        [self addSubview:actionBG];
    }
    actionBG.hidden = NO;
    
    UIButton *actionReply = (UIButton *)[self viewWithTag:302];
    if (actionReply == nil) {
        actionReply = [[UIButton alloc] init];
        actionReply.tag = 302;
        [actionReply setImage:[UIImage imageNamed:@"reply-action-reply.png"] forState:UIControlStateNormal];
        [actionReply sizeToFit];
        actionReply.center = CGPointMake(213, 17);
        [actionReply addTarget:self action:@selector(replyButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:actionReply];
    }
    actionReply.hidden = NO;
    
    UIButton *actionThanks = (UIButton *)[self viewWithTag:303];
    if (actionThanks == nil) {
        actionThanks = [[UIButton alloc] init];
        actionThanks.tag = 303;
        [actionThanks setImage:[UIImage imageNamed:@"reply-action-thanks.png"] forState:UIControlStateNormal];
        [actionThanks sizeToFit];
        actionThanks.center = CGPointMake(247, 17);
        [actionThanks addTarget:self action:@selector(thanksButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:actionThanks];
    }
    actionThanks.hidden = NO;
}

- (void)cancelButtonTouched
{
    [self viewWithTag:300].hidden = YES;
    [self viewWithTag:301].hidden = YES;
    [self viewWithTag:302].hidden = YES;
    [self viewWithTag:303].hidden = YES;
}

- (void)replyButtonTouched
{
    [self viewWithTag:300].hidden = YES;
    [self viewWithTag:301].hidden = YES;
    [self viewWithTag:302].hidden = YES;
    [self viewWithTag:303].hidden = YES;
}

- (void)thanksButtonTouched
{
    [self viewWithTag:300].hidden = YES;
    [self viewWithTag:301].hidden = YES;
    [self viewWithTag:302].hidden = YES;
    [self viewWithTag:303].hidden = YES;
}

@end

@interface VMRepliesVC ()
{
    NSDictionary *topic;
    NSArray *replies;
    DTAttributedTextView *testHeightContentView;
}
@end

@implementation VMRepliesVC

- (id)initWithTopic:(NSDictionary *)_topic
{
    self = [super init];
    if (self) {
        topic = _topic;
        replies = [topic objectForKey:@"reply_objects"];
        [DTAttributedTextContentView setLayerClass:[CATiledLayer class]];
        testHeightContentView = [[DTAttributedTextView alloc] initWithFrame:CGRectMake(0, 0, 241, 1)];
        testHeightContentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
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
    NSAttributedString *string = [[replies objectAtIndex:indexPath.row] objectForKey:@"attributed-string"];
    if (string == nil) {
        NSString *html = [[replies objectAtIndex:indexPath.row] objectForKey:@"content_rendered"];
        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
        string = [[NSAttributedString alloc] initWithHTML:data options:nil documentAttributes:nil];
    }
    testHeightContentView.attributedString = string;
    [[replies objectAtIndex:indexPath.row] setValue:string forKey:@"attributed-string"];
    return testHeightContentView.contentSize.height + 28;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *reply = [replies objectAtIndex:indexPath.row];
    static NSString *CellIdentifier;
    CellIdentifier = [NSString stringWithFormat:@"ReplyCell-%d", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ReplyContentCell alloc] initWithReply:reply indexPath:indexPath];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
