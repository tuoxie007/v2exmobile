//
//  VMNotificationVC.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/11/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMNotificationVC.h"
#import "EGORefreshTableHeaderView.h"
#import "VMImageLoader.h"
#import "VMLoginHandler.h"
#import "Config.h"
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
//#define INFO_VIEW_TAG 19
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

@implementation VMNotificationVC

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    imgBnt2name = [[NSMutableDictionary alloc] init];
    self.title = @"提醒";
    
    refreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame: CGRectMake(0, 0, WINDOW_HEIGHT, 0)];
    refreshTableHeaderView.delegate = self;
    [[self view] addSubview:refreshTableHeaderView];
    
    NSHTTPCookie *cookie = [VMAccount getInstance].cookie;
    if (cookie == nil) {
        loginHandler = [[VMLoginHandler alloc] initWithDelegate:self];
        [loginHandler login];
    } else {
        [self loadNotifications];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - login handler delegate
- (void)loginSuccess
{
    [self loadNotifications];
}


#pragma mark - tableview protocol
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *notificationCellIdentifier = @"NotificationCell";
    
    UITableViewCell *cell = nil;//[tableView dequeueReusableCellWithIdentifier:notificationCellIdentifier];
    if (cell == nil) {
        cell = [self tableviewCellWithReuseIdentifier:notificationCellIdentifier forIndexPath:indexPath];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.row >= [notifications count]) return 50;
	
	UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *notification = [notifications objectAtIndex:indexPath.row];
    topicVC = [[VMOldTopicVC alloc] initWithTopic:notification];
    [topicVC updateView];
    [self.navigationController pushViewController:topicVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [notifications count];
}


- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *topic = [notifications objectAtIndex:indexPath.row];
    
    CGRect rect = CGRectMake(0, 0, WINDOW_WIDTH, ROW_HEIGHT);
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.frame = rect;
    
    //Userpic view
    rect = CGRectMake(BORDER_WIDTH, (ROW_HEIGHT - IMAGE_SIDE) / 2.0, IMAGE_SIDE, IMAGE_SIDE);
    UIButton *imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgBnt2name setValue:[topic objectForKey:@"author"] forKey:[NSString stringWithFormat:@"%d", imgButton]];
    [imgButton addTarget:self action:@selector(showMember:) forControlEvents:UIControlEventTouchUpInside];
    imgButton.frame = rect;
    VMImageLoader *imageLoader = [[VMImageLoader alloc] init];
    [imageLoader loadImageWithURL:[NSURL URLWithString:[topic objectForKey:@"img_url"]] forImageButton:imgButton];
    [cell addSubview:imgButton];
    
    UILabel *label;
    
    //Title
    rect = CGRectMake(TEXT_OFFSET_X, BORDER_WIDTH, TEXT_WIDTH, 0);
    label = [[UILabel alloc] initWithFrame:rect];
    label.text = [topic objectForKey:@"title"];
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithRed:0 green:0 blue:0.8f alpha:1];
    label.highlightedTextColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.opaque = NO;
    [label sizeToFit];
    CGRect labelFrame = label.frame;
    labelFrame.size.width = TEXT_WIDTH;
    labelFrame.size.height += BORDER_WIDTH;
    label.frame = labelFrame;
    [cell addSubview:label];
    
    //Content
    rect = CGRectMake(TEXT_OFFSET_X, label.frame.origin.y+label.frame.size.height, TEXT_WIDTH, 0); // not sure: W, H
    label = [[UILabel alloc] initWithFrame:rect];
    label.text = [topic objectForKey:@"content"];
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.font = [UIFont systemFontOfSize:12];
    label.highlightedTextColor = [UIColor whiteColor];
    label.opaque = NO;
    label.numberOfLines = 0;
    [label sizeToFit];
    labelFrame = label.frame;
    labelFrame.size.width = TEXT_WIDTH;
    labelFrame.size.height += BORDER_WIDTH;
    label.frame = labelFrame;
    [cell addSubview:label];
    
    cell.frame = CGRectMake(0, 0, WINDOW_WIDTH, label.frame.origin.y + label.frame.size.height + BORDER_WIDTH);
    
    return cell;
}

#pragma mark - load topics
- (void)loadNotifications
{
    if (loader == nil) {
        loader = [[VMNotificationsLoader alloc] initWithDelegate:(VMLoader *)self];
    }
    loading = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(65, 0, 0, 0);
    [loader loadNotifications];
    [refreshTableHeaderView showAsRefreshing];
}

#pragma mark -
#pragma mark DataLoaderDelegate Protocol
- (void)didFinishedLoadingWithData:(id)data
{
    notifications = data;
    loading = NO;
    [refreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [self.tableView reloadData];
    [waitingView removeFromSuperview];
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
    [(UIView *)infoView removeFromSuperview];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self loadNotifications];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return loading;
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
