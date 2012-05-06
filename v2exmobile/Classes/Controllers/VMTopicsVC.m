//
//  VMTopicsVC.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 5/6/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//


#define PADDING_LEFT 11
#define PADDDING_TOP 10

#import "VMTopicsVC.h"

@interface VMTopicsVC ()
{
    NSArray *topics;
}

@end

@implementation VMTopicsVC

- (id)initWithTopics:(NSArray *)_topics
{
    self = [super init];
    if (self) {
        topics = _topics;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

+ (CGFloat)cellPadding
{
    return PADDDING_TOP;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return topics.count;
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = @"2012 V2EX TEE 预购成功，还没有购买的，大家继续抢购啦～";
    CGSize maximumLabelSize = CGSizeMake(226, 200);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    CGFloat titleLabelHeight = size.height;
    CGFloat cellHeight = PADDDING_TOP + titleLabelHeight + 7 + 8 + PADDDING_TOP;
    
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TopicCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 101;
        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        titleLabel.textColor = [UIColor colorWithRed:0.265625 green:0.27734375 blue:0.2890625 alpha:1];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.highlightedTextColor = [UIColor whiteColor];
        titleLabel.numberOfLines = 0;
        titleLabel.backgroundColor = [UIColor clearColor];
        [cell addSubview:titleLabel];
        
        UILabel *authorLabel = [[UILabel alloc] init];
        authorLabel.tag = 102;
        authorLabel.font = [UIFont systemFontOfSize:9];
        authorLabel.textColor = [UIColor colorWithRed:0.464 green:0.5 blue:0.527 alpha:1];
        authorLabel.highlightedTextColor = [UIColor whiteColor];
        authorLabel.backgroundColor = [UIColor clearColor];
        [cell addSubview:authorLabel];
        
        UILabel *nodeLabel = [[UILabel alloc] init];
        nodeLabel.tag = 103;
        nodeLabel.font = [UIFont systemFontOfSize:8];
        nodeLabel.textColor = [UIColor colorWithWhite:0.30078125 alpha:1];
        nodeLabel.highlightedTextColor = [UIColor whiteColor];
        nodeLabel.backgroundColor = self.tableView.backgroundColor;
        [cell addSubview:nodeLabel];
        
        UIImageView *nodeBG = [[UIImageView alloc] init];
        nodeBG.image = [[UIImage imageNamed:@"topics-item-node-bg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        nodeBG.tag = 104;
        [cell addSubview:nodeBG];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.tag = 105;
        timeLabel.font = [UIFont systemFontOfSize:9];
        timeLabel.textColor = [UIColor colorWithWhite:0.796875 alpha:1];
        timeLabel.highlightedTextColor = [UIColor whiteColor];
        timeLabel.backgroundColor = [UIColor clearColor];
        [cell addSubview:timeLabel];
        
        UIImageView *replyCountBG = [[UIImageView alloc] init];
        if (indexPath.row % 2) {
            replyCountBG.image = [UIImage imageNamed:@"topics-item-reply-count-bg.png"];
        } else {
            replyCountBG.image = [UIImage imageNamed:@"topics-item-reply-count-bg-mine.png"];
        }
        replyCountBG.tag = 106;
        [cell addSubview:replyCountBG];
        
        UILabel *replyCountLabel = [[UILabel alloc] init];
        replyCountLabel.tag = 107;
        replyCountLabel.backgroundColor = [UIColor clearColor];
        replyCountLabel.font = [UIFont systemFontOfSize:8];
        replyCountLabel.textColor = [UIColor whiteColor];
        replyCountLabel.highlightedTextColor = [UIColor whiteColor];
        [cell addSubview:replyCountLabel];
        
        UIImageView *cellSeparatorBG = [[UIImageView alloc] init];
        cellSeparatorBG.image = [UIImage imageNamed:@"table-cell-separator.png"];
        cellSeparatorBG.tag = 108;
        [cell addSubview:cellSeparatorBG];
    }
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *authorLabel = (UILabel *)[cell viewWithTag:102];
    UILabel *nodeLabel = (UILabel *)[cell viewWithTag:103];
    UIImageView *nodeBG = (UIImageView *)[cell viewWithTag:104];
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:105];
    UIImageView *replyCountBG = (UIImageView *)[cell viewWithTag:106];
    UILabel *replyCountLabel = (UILabel *)[cell viewWithTag:107];
    UIImageView *cellSeparatorBG = (UIImageView *)[cell viewWithTag:108];
    
    titleLabel.frame = CGRectMake(PADDING_LEFT, PADDDING_TOP, 226, 0);
    titleLabel.text = @"2012 V2EX TEE 预购成功，还没有购买的，大家继续抢购啦～";
    [titleLabel sizeToFit];
    
    CGFloat infoLabelsY = titleLabel.frame.size.height + titleLabel.frame.origin.y + 9;
    
    authorLabel.frame = CGRectMake(PADDING_LEFT, infoLabelsY, 0, 0);
    authorLabel.text = @"nAODI";
    [authorLabel sizeToFit];
    
    CGFloat nodeLabelX = authorLabel.frame.origin.x + authorLabel.frame.size.width + 9;
    
    nodeLabel.frame = CGRectMake(nodeLabelX, infoLabelsY, 0, 0);
    nodeLabel.text = @" 问与答 ";
    [nodeLabel sizeToFit];
    
    nodeBG.frame = nodeLabel.frame;
    
    CGFloat timeLabelX = nodeLabel.frame.origin.x + nodeLabel.frame.size.width + 9;
    
    timeLabel.frame = CGRectMake(timeLabelX, infoLabelsY, 0, 0);
    timeLabel.text = @"一分钟前";
    [timeLabel sizeToFit];
    
    [replyCountBG sizeToFit];
    replyCountBG.center = CGPointMake(285, titleLabel.center.y);
    
    replyCountLabel.text = @"124";
    [replyCountLabel sizeToFit];
    replyCountLabel.center = CGPointMake(285, titleLabel.center.y);
    
    cellSeparatorBG.frame = CGRectMake(0, PADDDING_TOP + titleLabel.frame.size.height + 7 + 8 + PADDDING_TOP - 1, cell.frame.size.width, 1);
    
    if (indexPath.row == 0) {
        UIImageView *cornerLeftTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-corner-left-top.png"]];
        cornerLeftTop.frame = CGRectMake(0, 0, 5, 5);
        cornerLeftTop.tag = 10;
        [cell addSubview:cornerLeftTop];
        
        UIImageView *cornerRightTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-corner-right-top.png"]];
        cornerRightTop.frame = CGRectMake(299, 0, 5, 5);
        cornerRightTop.tag = 11;
        [cell addSubview:cornerRightTop];
    } else if (indexPath.row == 9/* topics.count - 1 */) {
        CGFloat cellHeight = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
        UIImageView *cornerLeftBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-corner-left-bottom.png"]];
        cornerLeftBottom.frame = CGRectMake(0, cellHeight-5, 5, 5);
        cornerLeftBottom.tag = 12;
        [cell addSubview:cornerLeftBottom];
        
        UIImageView *cornerRightBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-corner-right-bottom.png"]];
        cornerRightBottom.frame = CGRectMake(299, cellHeight-5, 5, 5);
        cornerRightBottom.tag = 13;
        [cell addSubview:cornerRightBottom];
        [[cell viewWithTag:108] removeFromSuperview];
    } else {
        [[cell viewWithTag:11] removeFromSuperview];
        [[cell viewWithTag:12] removeFromSuperview];
        [[cell viewWithTag:13] removeFromSuperview];
        [[cell viewWithTag:14] removeFromSuperview];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
