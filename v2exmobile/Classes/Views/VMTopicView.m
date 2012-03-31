//
//  VMTopicView.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/13/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMTopicView.h"

#define PADDING 5
#define IMAGE_SIZE 48
#define WINDOW_WIDTH 320
#define WINDOW_HEIGHT 367

#define LOADING_REPLY_VIEW_TAG 21

@implementation VMTopicView

- (id)initWithTopic:(NSDictionary *)topic
{
    self = [super initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 0)];
    if (self) {
        self.frame = CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
        
        // User Image
        UIImageView *userImgView = [[UIImageView alloc] initWithFrame:CGRectMake(PADDING, PADDING, IMAGE_SIZE, IMAGE_SIZE)];
        userImgView.image = [UIImage imageNamed:@"hp-summic.png"];
        [self addSubview:userImgView];
        
        // Title
        UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(userImgView.frame.origin.x + userImgView.frame.size.width + PADDING, PADDING, WINDOW_WIDTH-(userImgView.frame.origin.x + userImgView.frame.size.width + PADDING)-PADDING, 0)];
        titleView.font = [UIFont boldSystemFontOfSize:14];
        titleView.text = [topic objectForKey:@"title"];
        titleView.lineBreakMode = UILineBreakModeCharacterWrap;
        titleView.numberOfLines = 0;
        [titleView sizeToFit];
        [self addSubview:titleView];
        
        // Content
        UILabel *contentView = [[UILabel alloc] initWithFrame:CGRectMake(titleView.frame.origin.x, titleView.frame.origin.y+titleView.frame.size.height+PADDING, WINDOW_WIDTH-(userImgView.frame.origin.x + userImgView.frame.size.width + PADDING)-PADDING, 0)];
        contentView.font = [UIFont systemFontOfSize:12];
        contentView.text = [topic objectForKey:@"content"];
        contentView.lineBreakMode = UILineBreakModeCharacterWrap;
        contentView.numberOfLines = 0;
        [contentView sizeToFit];
        [self addSubview:contentView];
        
        // by
        UILabel *staticLabel_by = [[UILabel alloc] initWithFrame:CGRectMake(PADDING*2+userImgView.frame.size.width, PADDING+contentView.frame.origin.y+contentView.frame.size.height, 0, 0)];
        staticLabel_by.font = [UIFont systemFontOfSize:9];
        staticLabel_by.textColor = [UIColor grayColor];
        staticLabel_by.text = @"by";
        [staticLabel_by sizeToFit];
        [self addSubview:staticLabel_by];
        
        // author
        UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(staticLabel_by.frame.origin.x + staticLabel_by.frame.size.width + PADDING, staticLabel_by.frame.origin.y, 0, 0)];
        authorLabel.font = [UIFont systemFontOfSize:9];
        authorLabel.text = [topic objectForKey:@"author"];
        [authorLabel sizeToFit];
        [self addSubview:authorLabel];
        
        // at
        UILabel *staticLabel_at = [[UILabel alloc] initWithFrame:CGRectMake(authorLabel.frame.origin.x + authorLabel.frame.size.width + PADDING, authorLabel.frame.origin.y, 0, 0)];
        staticLabel_at.font = [UIFont systemFontOfSize:9];
        staticLabel_at.textColor = [UIColor grayColor];
        staticLabel_at.text = @"at";
        [staticLabel_at sizeToFit];
        [self addSubview:staticLabel_at];
        
        // time
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(staticLabel_at.frame.origin.x + staticLabel_at.frame.size.width + PADDING, staticLabel_by.frame.origin.y, 0, 0)];
        timeLabel.font = [UIFont systemFontOfSize:9];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.text = [topic objectForKey:@"time"];
        [timeLabel sizeToFit];
        [self addSubview:timeLabel];
        
        // views
        UILabel *viewsLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabel.frame.origin.x + timeLabel.frame.size.width + PADDING, staticLabel_by.frame.origin.y, 0, 0)];
        viewsLabel.font = [UIFont systemFontOfSize:9];
        viewsLabel.textColor = [UIColor grayColor];
        // TODO chagne to views not flows
        viewsLabel.text = [NSString stringWithFormat:@"%d views", [(NSNumber *)[topic objectForKey:@"flows"] intValue]];
        [viewsLabel sizeToFit];
        [self addSubview:viewsLabel];
        
        // replies
        UILabel *repliesLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, viewsLabel.frame.origin.y+viewsLabel.frame.size.height+PADDING, WINDOW_WIDTH, 0)];
        repliesLabel.font = [UIFont systemFontOfSize:12];
        repliesLabel.textColor = [UIColor grayColor];
        repliesLabel.text = [NSString stringWithFormat:@"共收到%d个回复", [((NSNumber *)[topic objectForKey:@"flows"]) intValue]];
        [repliesLabel sizeToFit];
        [self addSubview:repliesLabel];
        
        topicHeight = repliesLabel.frame.origin.y + repliesLabel.frame.size.height + PADDING;
        
        // replies loading
        UIView *loadingReplyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 50)];
        loadingReplyView.center = CGPointMake(WINDOW_WIDTH/2, viewsLabel.frame.origin.y + viewsLabel.frame.size.height+PADDING);
        UIActivityIndicatorView *loadingReplyIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        loadingReplyIndicatorView.color = [UIColor grayColor];
        loadingReplyIndicatorView.center = CGPointMake(loadingReplyView.frame.size.width/2, loadingReplyView.frame.size.height/2+25);
        [loadingReplyView addSubview:loadingReplyIndicatorView];
        loadingReplyView.tag = LOADING_REPLY_VIEW_TAG;
        [self addSubview:loadingReplyView];
        [loadingReplyIndicatorView startAnimating];
    }
    return self;
}

- (void)updateWithReplies:(NSArray *)replies delegate:(id)delegate
{
    UITableView *repliesView = [[UITableView alloc] initWithFrame:CGRectMake(0, topicHeight, WINDOW_WIDTH, WINDOW_HEIGHT-topicHeight) style:UITableViewStylePlain];
    repliesView.delegate = delegate;
    repliesView.dataSource = delegate;
    [self addSubview:repliesView];
    [[self viewWithTag:LOADING_REPLY_VIEW_TAG] removeFromSuperview];
}

@end
