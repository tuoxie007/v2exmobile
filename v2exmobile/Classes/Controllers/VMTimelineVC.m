//
//  VMMasterViewController.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/11/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMTimelineVC.h"
#import "VMTopicVC.h"
#import "VMTopicsLoader.h"
#import "VMImageLoader.h"
#import "Config.h"
#import "VMLoader.h"
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


@implementation VMTimelineVC

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    imgBnt2name = [[NSMutableDictionary alloc] init];
    self.title = @"V2EX";
    refreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame: CGRectMake(0, 0, WINDOW_HEIGHT, 0)];
    refreshTableHeaderView.delegate = self;
    [[self view] addSubview:refreshTableHeaderView];
    currentPage = 1;
    [self loadTopics:currentPage];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - tableview protocol
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [topics count]) {
        static NSString *loadMoreCellIdentifier = @"LoadMoreCell";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadMoreCellIdentifier];
        cell.frame = CGRectMake(0, 0, WINDOW_WIDTH, 50);
        cell.textLabel.text = @"Load More";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        return cell;
    }
    
    static NSString *topicCellIdentifier = @"TopicCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topicCellIdentifier];
    if (cell == nil) {
        cell = [self tableviewCellWithReuseIdentifier:topicCellIdentifier];
    }
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.row >= [topics count]) return 50;
	
	UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [topics count]) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.text = @"正在加载...";
        return [self loadTopics:currentPage+1];
    }
    NSDictionary *topic = [topics objectAtIndex:indexPath.row];
    VMTopicVC *topicVC = [[VMTopicVC alloc] initWithTopic:topic];
    [topicVC updateView];
    [self.navigationController pushViewController:topicVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (topics) {
        return [topics count] + 1;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([topics count] && currentPage > 1) {
        return [NSString stringWithFormat:@"                         第%d页", currentPage];
    }
    return nil;
}


- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier 
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

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *topic = [topics objectAtIndex:indexPath.row];
    
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
    [imageLoader loadImageWithURL:[NSURL URLWithString:[[topic objectForKey:@"img_url"] stringByReplacingOccurrencesOfString:@"large" withString:@"normal"]] forImageButton:imageView];
    
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

#pragma mark - load topics
- (void)loadTopics:(NSInteger)page
{
    if (loader == nil) {
        loader = [[VMTopicsLoader alloc] initWithDelegate:(VMLoader *)self];
    }
    loading = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(65, 0, 0, 0);
    [loader loadTopics:page];
    [refreshTableHeaderView showAsRefreshing];
}

#pragma mark -
#pragma mark DataLoaderDelegate Protocol
- (void)didFinishedLoadingWithData:(id)data
{
    
}
- (void)didFinishedLoadingWithData:(id)data forPage:(NSInteger)page
{
    currentPage = page;
    topics = data;
    loading = NO;
    [refreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [waittingView removeFromSuperview];
}

- (void)cancel
{
    [refreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    loading = NO;
    VMInfoView *infoView = [[VMInfoView alloc] initWithMessage:@"加载失败"];
    infoView.center = CGPointMake(WINDOW_WIDTH/2, self.tableView.contentOffset.y+WINDOW_HEIGHT/2);
    [self.view addSubview:infoView];
    [self performSelector:@selector(removeInfoView:) withObject:infoView afterDelay:2];
}

- (void)removeInfoView:(id)infoView
{
    [infoView removeFromSuperview];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    if (currentPage > 1) {
        [self loadTopics:currentPage-1];
    } else {
        [self loadTopics:currentPage];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return loading;
}

- (NSInteger)egoRefreshTableHeaderDataSourceCurrentPage:(EGORefreshTableHeaderView *)view
{
    return currentPage;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
	[refreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[refreshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)showMember:(UIButton *)imgBnt
{
    VMMemberVC *memberVC = [[VMMemberVC alloc] initWithName:[imgBnt2name objectForKey:[NSString stringWithFormat:@"%d", imgBnt]]];
    [self.navigationController pushViewController:memberVC animated:YES];
}

@end
