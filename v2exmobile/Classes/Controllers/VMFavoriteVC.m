//
//  VMFavoriteVC.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/11/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "Config.h"
#import "VMFavoriteVC.h"
#import "VMAccount.h"
#import "VMLoginHandler.h"
#import "VMFavoriteMembersLoader.h"
#import "VMFavoriteNodesLoader.h"
#import "VMFavoriteTopicsLoader.h"
#import "VMImageLoader.h"
#import "VMLoader.h"
#import "VMwaitingView.h"
#import "VMTopicVC.h"
#import "VMNodeTimelineVC.h"
#import "VMMemberVC.h"
#import "VMInfoView.h"

#define NAME_TAG 11
#define TIME_TAG 12
#define IMAGE_TAG 13
#define TITLE_TAG 14
#define STATIC_TAG_IN 15
#define NODE_TAG 16
#define REPLY_TAG 17
#define LAST_REPLY_AUTHOR_TAG 18
#define FOLLWERS_LEVEL_TAG 19
//#define WAITING_VIEW_TAG 1

#define ROW_HEIGHT 70
#define IMAGE_SIDE 48
#define BORDER_WIDTH 5
#define LABEL_HEIGHT 12

#define LABEL_WIDTH 130
#define TEXT_OFFSET_X (BORDER_WIDTH * 2 + IMAGE_SIDE)
#define TEXT_OFFSET_Y (BORDER_WIDTH * 2 + LABEL_HEIGHT)
#define TEXT_WIDTH (WINDOW_WIDTH - TEXT_OFFSET_X - BORDER_WIDTH)
#define TEXT_HEIGHT (ROW_HEIGHT - TEXT_OFFSET_Y - BORDER_WIDTH * 2 - LABEL_HEIGHT)


@implementation VMFavoriteVC

#pragma mark -lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    imgBnt2name = [[NSMutableDictionary alloc] init];
    self.title = @"收藏";
    UIBarButtonItem *refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadFavorites)];
    self.navigationItem.rightBarButtonItem = refreshBarButtonItem;
    if ([VMAccount getInstance].cookie == nil) {
        loginHandler = [[VMLoginHandler alloc] initWithDelegate:self];
        [loginHandler login];
    } else {
        [self loadFavorites];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - inner methods
- (void)loadFavorites
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    waittingView = [[VMwaitingView alloc] initWithMessage:@"正在加载"];
    [waittingView setLoadingCenter:CGPointMake(WINDOW_WIDTH/2, self.tableView.contentOffset.y+WINDOW_HEIGHT/2)];
    [self.view addSubview:waittingView];
    
    VMFavoriteNodesLoader *nloader = [[VMFavoriteNodesLoader alloc] initWithDelegate:self];
    VMFavoriteMembersLoader *floader = [[VMFavoriteMembersLoader alloc] initWithDelegate:self];
    VMFavoriteTopicsLoader *tloader = [[VMFavoriteTopicsLoader alloc] initWithDelegate:self];
    
    [nloader loadFavoritesNodes];
    [floader loadFavoriteMembers];
    [tloader loadFavoriteTopics];
}

#pragma mark - data loader delegate
- (void)didFinishedLoadingWithData:(id)data
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void)didFinishedLoadingWithNodes:(id)nodes
{
    _nodes = nodes;
    if (_nodes && _members && _topics) {
        [waittingView removeFromSuperview];
        [self.tableView reloadData];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)didFinishedLoadingWithMembers:(id)members
{
    _members = members;
    if (_nodes && _members && _topics) {
        [waittingView removeFromSuperview];
        [self.tableView reloadData];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)didFinishedLoadingWithTopics:(id)topics
{
    _topics = topics;
    if (_nodes && _members && _topics) {
        [waittingView removeFromSuperview];
        [self.tableView reloadData];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)cancel
{
    VMInfoView *infoView = [[VMInfoView alloc] initWithMessage:@"收藏失败"];
    infoView.center = CGPointMake(WINDOW_WIDTH/2, self.tableView.contentOffset.y+WINDOW_HEIGHT/2);
    [self.view addSubview:infoView];
    [self performSelector:@selector(removeInfoView:) withObject:infoView afterDelay:2];
}

- (void)removeInfoView:(id)infoView
{
    [infoView removeFromSuperview];
}

#pragma mark - login handler delegate
- (void)loginSuccess
{
    [self loadFavorites];
}


#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"收藏节点";
        case 1:
            return @"收藏主题";
        case 2:
            return @"特别关注";
            
        default:
            return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [_topics count];
        case 1:
            return [_nodes count];
        case 2:
            return [_members count];
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        static NSString *identifier = @"TopicCellIdentifier";
        
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [self tableviewTopicCellWithReuseIdentifier:identifier];
        }
        [self configureTopicCell:cell forIndexPath:indexPath];
    } else if (indexPath.section == 1) {
        static NSString *identifier = @"NodeCellIdentifier";
        
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        NSDictionary *node = [_nodes objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@/%@", [node objectForKey:@"name"], [node objectForKey:@"count"]];
        return cell;
    } else if (indexPath.section == 2) {
        static NSString *identifier = @"MemberCellIdentifier";
        
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [self tableviewMemberCellWithReuseIdentifier:identifier];
        }
        [self configureMemberCell:cell forIndexPath:indexPath];
    }
    return cell;
}

- (UITableViewCell *)tableviewTopicCellWithReuseIdentifier:(NSString *)identifier
{
    CGRect rect = CGRectMake(0, 0, WINDOW_WIDTH, ROW_HEIGHT);
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.frame = rect;
    
    //Userpic view
    rect = CGRectMake(BORDER_WIDTH, (ROW_HEIGHT - IMAGE_SIDE) / 2.0, IMAGE_SIDE, IMAGE_SIDE);
    UIButton *imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgButton addTarget:self action:@selector(showMember:) forControlEvents:UIControlEventTouchUpInside];
    imgButton.frame = rect;
    imgButton.tag = IMAGE_TAG;
    [cell addSubview:imgButton];
    
    UILabel *label;
    
    //Username
    rect = CGRectMake(TEXT_OFFSET_X, BORDER_WIDTH, 0, LABEL_HEIGHT); // not sure: W
    label = [[UILabel alloc] initWithFrame:rect];
    label.tag = NAME_TAG;
    label.font = [UIFont boldSystemFontOfSize:9];
    label.highlightedTextColor = [UIColor whiteColor];
    [cell addSubview:label];
    label.opaque = NO;
    label.backgroundColor = [UIColor clearColor];
    
    //in
    rect = CGRectMake(TEXT_OFFSET_X + BORDER_WIDTH, BORDER_WIDTH, 10, LABEL_HEIGHT); // not sure: X
    label = [[UILabel alloc] initWithFrame:rect];
    label.tag = STATIC_TAG_IN;
    label.font = [UIFont systemFontOfSize:9];
    label.highlightedTextColor = [UIColor whiteColor];
    label.textColor = [UIColor grayColor];
    [cell addSubview:label];
    label.opaque = NO;
    label.backgroundColor = [UIColor clearColor];
    
    //Node
    rect = CGRectMake(TEXT_OFFSET_X + BORDER_WIDTH*2+10, BORDER_WIDTH, 0, 0); // not sure: W,H
    label = [[UILabel alloc] initWithFrame:rect];
    label.tag = NODE_TAG;
    label.font = [UIFont boldSystemFontOfSize:9];
    label.highlightedTextColor = [UIColor whiteColor];
    [cell addSubview:label];
    label.opaque = NO;
    label.backgroundColor = [UIColor clearColor];
    
    //Replies
    rect = CGRectMake(TEXT_OFFSET_X + BORDER_WIDTH, BORDER_WIDTH, 0, LABEL_HEIGHT); // not sure: X,W
    label = [[UILabel alloc] initWithFrame:rect];
    label.tag = REPLY_TAG;
    label.font = [UIFont boldSystemFontOfSize:9];
    label.highlightedTextColor = [UIColor whiteColor];
    label.textColor = [UIColor grayColor];
    [cell addSubview:label];
    label.opaque = NO;
    label.backgroundColor = [UIColor clearColor];
    
    //Message body
    rect = CGRectMake(TEXT_OFFSET_X, TEXT_OFFSET_Y, TEXT_WIDTH, 0); // not sure: H
    label = [[UILabel alloc] initWithFrame:rect];
    label.tag = TITLE_TAG;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    label.highlightedTextColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    [cell addSubview:label];
    label.opaque = NO;
    label.backgroundColor = [UIColor clearColor];
    
    //Last reply time
    rect = CGRectMake(TEXT_OFFSET_X, TEXT_OFFSET_Y, LABEL_WIDTH, LABEL_HEIGHT); // not sure: Y
    label = [[UILabel alloc] initWithFrame:rect];
    label.tag = TIME_TAG;
    label.font = [UIFont systemFontOfSize:9];
    label.textAlignment = UITextAlignmentRight;
    label.highlightedTextColor = [UIColor whiteColor];
    label.textColor = [UIColor grayColor];
    [cell addSubview:label];
    label.opaque = NO;
    label.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)configureTopicCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *topic = [_topics objectAtIndex:indexPath.row];
    
    // Configure the cell.
    CGRect cellFrame = [cell frame];
    //Set message text
    UILabel *label = (UILabel *)[cell viewWithTag:TITLE_TAG];
    [label setFrame:CGRectMake(TEXT_OFFSET_X, TEXT_OFFSET_Y, TEXT_WIDTH, 0)];
    label.text = [topic objectForKey:@"title"];
    [label sizeToFit];
    cellFrame.size.height = ROW_HEIGHT + label.frame.size.height - TEXT_HEIGHT;
    
    [cell setFrame:cellFrame];
    
    //Set date and time
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:TIME_TAG];
    CGRect timeFrame = [timeLabel frame];
    timeFrame.origin.y = cell.frame.size.height - BORDER_WIDTH - LABEL_HEIGHT;
    [timeLabel setFrame:timeFrame];
    NSString *create = [topic objectForKey:@"create"];
    timeLabel.text = create;
    [timeLabel sizeToFit];
    
    //Set userpic
    UIButton *imageView = (UIButton *)[cell viewWithTag:IMAGE_TAG];
    [imageView setImage:[UIImage imageNamed:@"loading.png"] forState:UIControlStateNormal];
    [imgBnt2name setValue:[topic objectForKey:@"author"] forKey:[NSString stringWithFormat:@"%d", imageView]];
    VMImageLoader *imageLoader = [[VMImageLoader alloc] init];
    [imageLoader loadImageWithURL:[NSURL URLWithString:[topic objectForKey:@"img_url"]] forImageButton:imageView];
    
    //Set user name
    UILabel *userLabel = (UILabel *)[cell viewWithTag:NAME_TAG];
    userLabel.text = [topic objectForKey:@"author"];
    [userLabel sizeToFit];
    
    //Set in Label Location
    label = (UILabel *)[cell viewWithTag:STATIC_TAG_IN];
    label.text = @"in";
    [label sizeToFit];
    CGRect inFrame = [label frame];
    inFrame.origin.x = userLabel.frame.origin.x + userLabel.frame.size.width + 5;
    [label setFrame:inFrame];
    
    //Set node name
    UILabel *nodeLabel = (UILabel *)[cell viewWithTag:NODE_TAG];
    nodeLabel.text = [topic objectForKey:@"node"];
    [nodeLabel sizeToFit];
    CGRect nodeFrame = [nodeLabel frame];
    nodeFrame.origin.x = inFrame.origin.x + inFrame.size.width + 5;
    [nodeLabel setFrame:nodeFrame];
    
    //Set reply
    UILabel *replyLabel = (UILabel *)[cell viewWithTag:REPLY_TAG];
    NSString *replyNum = [topic objectForKey:@"replies"];
    if (!replyNum || [replyNum isEqualToString:@""]) {
        replyNum = @"0";
    }
    replyLabel.text = [NSString stringWithFormat:@"收到 %@ 回复", replyNum];
    [replyLabel sizeToFit];
    CGRect replyFrame = [replyLabel frame];
    replyFrame.origin.x = nodeFrame.origin.x + nodeFrame.size.width + 5;
    [replyLabel setFrame:replyFrame];
}

- (UITableViewCell *)tableviewMemberCellWithReuseIdentifier:(NSString *)identifier
{
    CGRect rect = CGRectMake(0, 0, WINDOW_WIDTH, ROW_HEIGHT);
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.frame = rect;
    
    //Userpic view
    rect = CGRectMake(BORDER_WIDTH, BORDER_WIDTH, IMAGE_SIDE, IMAGE_SIDE);
    UIButton *imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgButton addTarget:self action:@selector(showMember:) forControlEvents:UIControlEventTouchUpInside];
    imgButton.frame = rect;
    imgButton.tag = IMAGE_TAG;
    [cell.contentView addSubview:imgButton];
    
    UILabel *label;
    
    //Username
    rect = CGRectMake(TEXT_OFFSET_X, BORDER_WIDTH*2, 0, LABEL_HEIGHT); // not sure: W
    label = [[UILabel alloc] initWithFrame:rect];
    label.tag = NAME_TAG;
    label.font = [UIFont boldSystemFontOfSize:14];
    [cell.contentView addSubview:label];
    //Followers and Level
    rect = CGRectMake(TEXT_OFFSET_X, BORDER_WIDTH, 0, LABEL_HEIGHT); // not sure: W,H
    label = [[UILabel alloc] initWithFrame:rect];
    label.tag = FOLLWERS_LEVEL_TAG;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor grayColor];
    [cell.contentView addSubview:label];
    
    return cell;
}

- (void)configureMemberCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *member = [_members objectAtIndex:indexPath.row];
    
    // Configure the cell.
    
    //Set userpic
    UIButton *imageView = (UIButton *)[cell viewWithTag:IMAGE_TAG];
    [imageView setImage:[UIImage imageNamed:@"loading.png"] forState:UIControlStateNormal];
    [imgBnt2name setValue:[member objectForKey:@"author"] forKey:[NSString stringWithFormat:@"%d", imageView]];
    VMImageLoader *imageLoader = [[VMImageLoader alloc] init];
    NSString *imgURL = [member objectForKey:@"img_url"];
    imgURL = [imgURL stringByReplacingOccurrencesOfString:@"mini" withString:@"normal"];
    [imageLoader loadImageWithURL:[NSURL URLWithString:imgURL] forImageButton:imageView];
    
    //Set user name
    UILabel *userLabel = (UILabel *)[cell viewWithTag:NAME_TAG];
    userLabel.highlightedTextColor = [UIColor whiteColor];
    userLabel.opaque = NO;
    userLabel.text = [member objectForKey:@"name"];
    [userLabel sizeToFit];
    
    //Set followers and level
    UILabel *flLabel = (UILabel *)[cell viewWithTag:FOLLWERS_LEVEL_TAG];
    flLabel.highlightedTextColor = [UIColor whiteColor];
    flLabel.opaque = NO;
    flLabel.text = [NSString stringWithFormat:@"%@ %@", [member objectForKey:@"followers"], [member objectForKey:@"level"]];
    [flLabel sizeToFit];
    
    CGRect rect = [flLabel frame];
    rect.origin.y = userLabel.frame.origin.y + userLabel.frame.size.height + BORDER_WIDTH;
    rect.size.width = WINDOW_WIDTH;
    flLabel.frame = rect;
    
    rect = cell.frame;
    rect.size.height = MAX(flLabel.frame.origin.y + flLabel.frame.size.height + BORDER_WIDTH, imageView.frame.origin.y + imageView.frame.size.height + BORDER_WIDTH);
    cell.frame = rect;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSDictionary *topic = [_topics objectAtIndex:indexPath.row];
        VMTopicVC *topicVC = [[VMTopicVC alloc] initWithTopic:topic];
        [topicVC updateView];
        [self.navigationController pushViewController:topicVC animated:YES];
    } else if (indexPath.section == 1) {
        VMNodeTimelineVC *nodeTimelineVC = [[VMNodeTimelineVC alloc] initWithNode:[[_nodes objectAtIndex:indexPath.row] objectForKey:@"id"]];
        [self.navigationController pushViewController:nodeTimelineVC animated:YES];
    } else if (indexPath.section == 2) {
        VMMemberVC *memberVC = [[VMMemberVC alloc] initWithMember:[_members objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:memberVC animated:YES];
    }
}

- (void)showMember:(UIButton *)imgBnt
{
    VMMemberVC *memberVC = [[VMMemberVC alloc] initWithName:[imgBnt2name objectForKey:[NSString stringWithFormat:@"%d", imgBnt]]];
    [self.navigationController pushViewController:memberVC animated:YES];
}

@end
