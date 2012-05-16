//
//  VMTopicCell.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 5/9/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMTopicCell.h"
#import "VMImageLoader.h"

@implementation VMTopicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSeperator:(BOOL)_withSeperator withAvatar:(BOOL)_withAvatar
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        withAvatar = _withAvatar;
        withSeperator = _withSeperator;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 101;
        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        titleLabel.textColor = [UIColor colorWithRed:0.265625 green:0.27734375 blue:0.2890625 alpha:1];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.highlightedTextColor = [UIColor whiteColor];
        titleLabel.numberOfLines = 0;
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
        
        UILabel *authorLabel = [[UILabel alloc] init];
        authorLabel.tag = 102;
        authorLabel.font = [UIFont systemFontOfSize:9];
        authorLabel.textColor = [UIColor colorWithRed:0.464 green:0.5 blue:0.527 alpha:1];
        authorLabel.highlightedTextColor = [UIColor whiteColor];
        authorLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:authorLabel];
        
        UILabel *nodeLabel = [[UILabel alloc] init];
        nodeLabel.tag = 103;
        nodeLabel.font = [UIFont systemFontOfSize:8];
        nodeLabel.textColor = [UIColor colorWithWhite:0.30078125 alpha:1];
        nodeLabel.highlightedTextColor = [UIColor whiteColor];
        nodeLabel.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
        [self addSubview:nodeLabel];
        
        UIImageView *nodeBG = [[UIImageView alloc] init];
        nodeBG.image = [[UIImage imageNamed:@"topics-item-node-bg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        nodeBG.tag = 104;
        [self addSubview:nodeBG];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.tag = 105;
        timeLabel.font = [UIFont systemFontOfSize:9];
        timeLabel.textColor = [UIColor colorWithWhite:0.796875 alpha:1];
        timeLabel.highlightedTextColor = [UIColor whiteColor];
        timeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:timeLabel];
        
        UIImageView *replyCountBG = [[UIImageView alloc] init];
        replyCountBG.image = [UIImage imageNamed:@"topics-item-reply-count-bg.png"];
//        replyCountBG.image = [UIImage imageNamed:@"topics-item-reply-count-bg-mine.png"];
        replyCountBG.tag = 106;
        [self addSubview:replyCountBG];
        
        UILabel *replyCountLabel = [[UILabel alloc] init];
        replyCountLabel.tag = 107;
        replyCountLabel.backgroundColor = [UIColor clearColor];
        replyCountLabel.font = [UIFont systemFontOfSize:8];
        replyCountLabel.textColor = [UIColor whiteColor];
        replyCountLabel.highlightedTextColor = [UIColor whiteColor];
        [self addSubview:replyCountLabel];
        
        UIImageView *cellSeparatorBG = [[UIImageView alloc] init];
        cellSeparatorBG.image = [UIImage imageNamed:@"table-cell-separator.png"];
        cellSeparatorBG.tag = 108;
        [self addSubview:cellSeparatorBG];
    }
    return self;
}

- (void)setTopic:(NSDictionary *)_topic
{
    topic = _topic;
    [self showTopicContent];
}

- (void)showTopicContent
{
    UILabel *titleLabel = (UILabel *)[self viewWithTag:101];
    UILabel *authorLabel = (UILabel *)[self viewWithTag:102];
    UILabel *nodeLabel = (UILabel *)[self viewWithTag:103];
    UIImageView *nodeBG = (UIImageView *)[self viewWithTag:104];
    UILabel *timeLabel = (UILabel *)[self viewWithTag:105];
    UIImageView *replyCountBG = (UIImageView *)[self viewWithTag:106];
    UILabel *replyCountLabel = (UILabel *)[self viewWithTag:107];
    UIImageView *cellSeparatorBG = (UIImageView *)[self viewWithTag:108];
    //    UIButton *avatarButton = (UIButton *)[cell viewWithTag:109];
    
    CGFloat paddingLeft = PADDING_LEFT;
    CGFloat titleWidth = 226;
    
    //    [[cell viewWithTag:109+indexPath.row] removeFromSuperview];
    if (withAvatar) {
        NSInteger avatarTag = 109;
        UIButton *avatarButton = (UIButton *)[self viewWithTag:avatarTag];
        if (avatarButton == nil) {
            avatarButton = [[UIButton alloc] initWithFrame:CGRectMake(8, PADDING_TOP, AVATAR_WIDTH, AVATAR_WIDTH)];
            avatarButton.tag = avatarTag;
            VMImageLoader *imgLoader = [[VMImageLoader alloc] init];
            NSString *imgUrl = [[topic objectForKey:@"member"] objectForKey:@"avatar_large"];
            [imgLoader loadImageWithURL:[NSURL URLWithString:imgUrl] forImageButton:avatarButton];
            [self addSubview:avatarButton];
        }
        paddingLeft += AVATAR_WIDTH + PADDING_LEFT;
        titleWidth -= AVATAR_WIDTH + PADDING_LEFT;
    }
    
    titleLabel.frame = CGRectMake(paddingLeft, PADDING_TOP, titleWidth, 0);
    titleLabel.text = [topic objectForKey:@"title"];
    [titleLabel sizeToFit];
    
    CGFloat infoLabelsY = titleLabel.frame.size.height + titleLabel.frame.origin.y + 9;
    
    authorLabel.frame = CGRectMake(paddingLeft, infoLabelsY, 0, 0);
    authorLabel.text = [[topic objectForKey:@"member"] objectForKey:@"username"];
    [authorLabel sizeToFit];
    
    CGFloat nodeLabelX = authorLabel.frame.origin.x + authorLabel.frame.size.width + 9;
    
    nodeLabel.frame = CGRectMake(nodeLabelX, infoLabelsY, 0, 0);
    nodeLabel.text = [NSString stringWithFormat:@" %@ %", [[topic objectForKey:@"node"] objectForKey:@"title"]];
    [nodeLabel sizeToFit];
    
    nodeBG.frame = nodeLabel.frame;
    
    CGFloat timeLabelX = nodeLabel.frame.origin.x + nodeLabel.frame.size.width + 9;
    
    timeLabel.frame = CGRectMake(timeLabelX, infoLabelsY, 0, 0);
    timeLabel.text = @"一分钟前";//[topic objectForKey:@"created"];
    [timeLabel sizeToFit];
    
    [replyCountBG sizeToFit];
    replyCountBG.center = CGPointMake(285, titleLabel.center.y);
    
    id replies = [topic objectForKey:@"replies"];
    NSInteger replyCount = 0;
    if ([replies isKindOfClass:[NSArray class]]) {
        replyCount = [replies count];
    } else if ([replies isKindOfClass:[NSNumber class]]) {
        replyCount = [replies intValue];
    }
    replyCountLabel.text = [NSString stringWithFormat:@"%d", replyCount];
    [replyCountLabel sizeToFit];
    replyCountLabel.center = CGPointMake(285, titleLabel.center.y);
    
    cellSeparatorBG.frame = CGRectMake(0, PADDING_TOP + titleLabel.frame.size.height + 7 + 8 + PADDING_TOP - 1, self.frame.size.width, 1);
    
    if ( ! withSeperator) {
        [[self viewWithTag:108] removeFromSuperview];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
