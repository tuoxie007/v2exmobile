//
//  VMTopicsVC.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 5/6/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//


#import "VMTopicsVC.h"
#import "VMImageLoader.h"
#import "Commen.h"
#import "MD5.h"
#import "VMTopicCell.h"
#import "EGORefreshTableHeaderView.h"

@interface VMTopicsVC ()
{
    NSArray *topics;
    BOOL withAvatar;
    NSMutableDictionary *avatars;
    EGORefreshTableHeaderView *refreshTableHeaderView;
    id parentVC;
}

@end

@implementation VMTopicsVC

- (id)initWithTopics:(NSArray *)_topics withAvatar:(BOOL)_withAvatar refreshTableHeaderView:(EGORefreshTableHeaderView *)_refreshTableHeaderView parentVC:(id)_parentVC
{
    self = [super init];
    if (self) {
        parentVC = _parentVC;
        topics = _topics;
        withAvatar = _withAvatar;
        avatars = [[NSMutableDictionary alloc] initWithCapacity:topics.count];
        refreshTableHeaderView = _refreshTableHeaderView;
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
    return topics.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *topic = [topics objectAtIndex:indexPath.row];
    NSString *text = [topic objectForKey:@"title"];
    CGSize maximumLabelSize = CGSizeMake(226, 200);
    if (withAvatar) {
        maximumLabelSize = CGSizeMake(226-AVATAR_WIDTH-PADDING_LEFT, 200);
    }
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    CGFloat titleLabelHeight = size.height;
    CGFloat cellHeight = PADDDING_TOP + titleLabelHeight + 7 + 8 + PADDDING_TOP;
    
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *topic = [topics objectAtIndex:indexPath.row];
    static NSString *CellIdentifier;
    CellIdentifier = [NSString stringWithFormat:@"TopicCell-%d", indexPath.row];
    VMTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[VMTopicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withSeperator:indexPath.row < topics.count - 1 withAvatar:withAvatar];
    }
    [cell setTopic:topic];
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [parentVC didSelectRowAtIndexPath:indexPath];
}

@end
