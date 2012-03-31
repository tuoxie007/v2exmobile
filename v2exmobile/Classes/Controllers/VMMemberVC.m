//
//  VMMemberVC.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/22/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMMemberVC.h"
#import "VMAccount.h"
#import "VMLoginHandler.h"
#import "VMMemberLoader.h"
#import "Config.h"
#import "VMImageLoader.h"
#import "VMwaitingView.h"
#import "VMInfoView.h"
#import "VMTopicVC.h"

//#define WAITING_VIEW_TAG 1

@implementation VMMemberVC

- (id)init
{
    self = [super init];
    myself = YES;
    if ([VMAccount getInstance].cookie && [VMAccount getInstance].username) {
        _member = [NSDictionary dictionaryWithObjectsAndKeys:[VMAccount getInstance].username, @"name", [NSString stringWithFormat:@"/member/%@", [VMAccount getInstance].username], @"url", nil];
    }
    return self;
}

- (id)initWithMember:(NSDictionary *)member
{
    self = [super init];
    _member = member;
    return self;
}

- (id)initWithName:(NSString *)name
{
    self = [super init];
    _member = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", [NSString stringWithFormat:@"/member/%@", name], @"url", nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"账户";
    if (myself) {
        if ([VMAccount getInstance].cookie == nil || [VMAccount getInstance].username == nil) {
            [self setViewAsNotLogin];
        } else {
            [self loadMember];
        }
        if ([[_member objectForKey:@"name"] isEqual:[VMAccount getInstance].username]) {
            UIBarButtonItem *logoutButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登出" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
            self.navigationItem.rightBarButtonItem = logoutButtonItem;
        }
    } else {
        [self loadMember];
    }
}

- (void)follow
{
    following = YES;
    
    NSString *msg = @"正在关注";
    if (followed) {
        msg = @"正在取消关注";
    }
    waittingView = [[VMwaitingView alloc] initWithMessage:msg];
    [waittingView setLoadingCenter:CGPointMake(WINDOW_WIDTH/2, self.tableView.contentOffset.y+WINDOW_HEIGHT/2)];
    [self.view addSubview:waittingView];
    
    VMMemberLoader *memberLoader = [[VMMemberLoader alloc] initWithDelegate:self];
    memberLoader.referer = [[_member objectForKey:@"url"] description];
    [memberLoader loadMemberWithURL:[NSURL URLWithString:[_member objectForKey:@"follow_url"]]];
}

- (void)login
{
    loginHandler = [[VMLoginHandler alloc] initWithDelegate:self];
    [loginHandler login];
}

- (void)logout
{
    UIAlertView *logoutAlertView = [[UIAlertView alloc] initWithTitle:@"确定要登出吗" message:nil delegate:self cancelButtonTitle:@"算了" otherButtonTitles:@"是的", nil];
    [logoutAlertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[VMAccount getInstance] logout];
        [self setViewAsNotLogin];
    }
}

- (void)setViewAsNotLogin
{
    UIView *notLoginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
    notLoginView.backgroundColor = [UIColor whiteColor];
    
    UILabel *notLoginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    notLoginLabel.text = @"您还没有登录";
    [notLoginLabel sizeToFit];
    notLoginLabel.center = CGPointMake(WINDOW_WIDTH/2, 50);
    [notLoginView addSubview:notLoginLabel];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake(0, 0, 100, 50);
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"现在去登录" forState:UIControlStateNormal];
    [loginButton sizeToFit];
    loginButton.center = CGPointMake(WINDOW_WIDTH/2, 150);
    [notLoginView addSubview:loginButton];
    
    bakupView = self.view;
    self.view = notLoginView;
}

- (void)loadMember
{
    waittingView = [[VMwaitingView alloc] initWithMessage:nil];
    [waittingView setLoadingCenter:CGPointMake(WINDOW_WIDTH/2, self.tableView.contentOffset.y+WINDOW_HEIGHT/2)];
    [self.view addSubview:waittingView];
    
    VMMemberLoader *memberLoader = [[VMMemberLoader alloc] initWithDelegate:self];
    [memberLoader loadMemberWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", V2EX_URL, [_member objectForKey:@"url"]]]];
}

- (void)didFinishedLoadingWithData:(id)member
{
    _member = [NSMutableDictionary dictionaryWithDictionary:_member];
    [_member setValuesForKeysWithDictionary:member];
    
    if ([[VMAccount getInstance].username isEqualToString:[_member objectForKey:@"name"]]) {
        UIBarButtonItem *logoutButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登出" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
        self.navigationItem.rightBarButtonItem = logoutButtonItem;
    } else {
        NSString *followURL = [_member objectForKey:@"follow_url"];
        followed = [followURL hasPrefix:[NSString stringWithFormat:@"%@%@", V2EX_URL, @"/unfollow"]];
        if (followed) {
            UIBarButtonItem *followButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消关注" style:UIBarButtonItemStylePlain target:self action:@selector(follow)];
            self.navigationItem.rightBarButtonItem = followButtonItem;
        } else {
            UIBarButtonItem *followButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关注" style:UIBarButtonItemStylePlain target:self action:@selector(follow)];
            self.navigationItem.rightBarButtonItem = followButtonItem;
        }
    }
    [waittingView removeFromSuperview];
    waittingView = nil;
    if (bakupView) {
        self.view = bakupView;
    }
    [self.tableView reloadData];
}

- (void)cancel
{
    VMInfoView *infoView = [[VMInfoView alloc] initWithMessage:@"加载失败"];
    infoView.center = CGPointMake(WINDOW_WIDTH/2, self.tableView.contentOffset.y+WINDOW_HEIGHT/2);
    [self.view addSubview:infoView];
}

- (void)loginSuccess
{
    _member = [NSDictionary dictionaryWithObjectsAndKeys:[VMAccount getInstance].username, @"name", [NSString stringWithFormat:@"/member/%@", [VMAccount getInstance].username], @"url", nil];
    [self loadMember];
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
    return [[_member objectForKey:@"parted_topics"] count] + [[_member objectForKey:@"posted_topics"] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        static NSString *identifier = @"MemberCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [self tableviewMemberCellWithReuseIdentifier:identifier];
        }
        [self configureMemberCell:cell forIndexPath:indexPath];
    } else if (indexPath.row == 1) {
        static NSString *identifier = @"PostedTipCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.frame = CGRectMake(0, 0, WINDOW_WIDTH, 17);
            
            cell.textLabel.textAlignment = UITextAlignmentLeft;
            cell.textLabel.textColor = [UIColor blueColor];
            cell.textLabel.font = [UIFont systemFontOfSize:10];
            
            cell.textLabel.text = @"最近创建的主题";
        }
    } else if (indexPath.row == [[_member objectForKey:@"posted_topics"] count] + 2) {
        static NSString *identifier = @"PostedTipCell";
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.frame = CGRectMake(0, 0, WINDOW_WIDTH, 17);
        
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        cell.textLabel.textColor = [UIColor blueColor];
        cell.textLabel.font = [UIFont systemFontOfSize:10];
        
        cell.textLabel.text = @"最近参与的主题";
    } else {
        static NSString *identifier = @"PartedTipCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [self tableviewTopicCellWithReuseIdentifier:identifier];
        }
        [self configureTopicCell:cell forIndexPath:indexPath];
    }
    return cell;
}

#define MARGIN 5
#define ROW_HEIGHT 70
#define IMAGE_SIDE 48

#define IMAGE_TAG 1
#define NAME_TAG 2
#define PARTIN_TAG 3
#define DESC_TAG 4
#define INFO_TAG 5
#define TITLE_TAG 6

- (UITableViewCell *)tableviewMemberCellWithReuseIdentifier:(NSString *)identifier
{
    CGRect rect = CGRectMake(0, 0, WINDOW_WIDTH, ROW_HEIGHT);
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.frame = rect;
    
    //Userpic view
    rect = CGRectMake(MARGIN, MARGIN, IMAGE_SIDE, IMAGE_SIDE);
    UIButton *imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imgButton.frame = rect;
    imgButton.tag = IMAGE_TAG;
    [cell addSubview:imgButton];
    
    //Name
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLabel.tag = NAME_TAG;
    [cell addSubview:nameLabel];
    
    //Signin
    UILabel *signinLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    signinLabel.tag = PARTIN_TAG;
    [cell addSubview:signinLabel];
    
    //Desc
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    descLabel.tag = DESC_TAG;
    [cell addSubview:descLabel];
    
    return cell;
}

- (void)configureMemberCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)identifier
{
    UIButton *imageView = (UIButton *)[cell viewWithTag:IMAGE_TAG];
    [imageView setImage:[UIImage imageNamed:@"loading.png"] forState:UIControlStateNormal];
    if ([_member objectForKey:@"img_url"]) {
        VMImageLoader *imgLoader = [[VMImageLoader alloc] init];
        [imgLoader loadImageWithURL:[NSURL URLWithString:[[[_member objectForKey:@"img_url"] stringByReplacingOccurrencesOfString:@"mini" withString:@"large"] stringByReplacingOccurrencesOfString:@"normal" withString:@"large"]] forImageButton:imageView];
    }
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:NAME_TAG];
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    CGRect nameFrame = CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+MARGIN, 
                                  imageView.frame.origin.y, 
                                  WINDOW_WIDTH-imageView.frame.size.width-MARGIN*3, 
                                  0);
    nameLabel.frame = nameFrame;
    nameLabel.highlightedTextColor = [UIColor whiteColor];
    nameLabel.opaque = NO;
    nameLabel.text = [_member objectForKey:@"name"];
    [nameLabel sizeToFit];
    nameFrame.size.height = nameLabel.frame.size.height;
    nameLabel.frame = nameFrame;
    
    UILabel *partinLabel = (UILabel *)[cell viewWithTag:PARTIN_TAG];
    CGRect partinFrame = CGRectMake(nameLabel.frame.origin.x, 
                                    nameLabel.frame.origin.y+nameLabel.frame.size.height+MARGIN, 
                                    WINDOW_WIDTH-imageView.frame.size.width-MARGIN*3, 
                                    0);
    partinLabel.frame = partinFrame;
    partinLabel.font = [UIFont systemFontOfSize:12];
    partinLabel.highlightedTextColor = [UIColor whiteColor];
    partinLabel.opaque = NO;
    partinLabel.textColor = [UIColor lightGrayColor];
    partinLabel.text = [[_member objectForKey:@"partin"] substringFromIndex:5];
    [partinLabel sizeToFit];
    partinFrame.size.height = partinLabel.frame.size.height;
    partinLabel.frame = partinFrame;
    
    UILabel *descLabel = (UILabel *)[cell viewWithTag:DESC_TAG];
    CGRect descFrame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y+IMAGE_SIDE+MARGIN, WINDOW_WIDTH-MARGIN*2, 0);
    descLabel.frame = descFrame;
    descLabel.lineBreakMode = UILineBreakModeWordWrap;
    descLabel.numberOfLines = 0;
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.highlightedTextColor = [UIColor whiteColor];
    descLabel.opaque = NO;
    descLabel.text = [_member objectForKey:@"desc"];
    [descLabel sizeToFit];
    descFrame.size.height = descLabel.frame.size.height;
    descLabel.frame = descFrame;
    
    cell.frame = CGRectMake(0, 0, WINDOW_WIDTH, descLabel.frame.origin.y+descLabel.frame.size.height+MARGIN);
}

- (UITableViewCell *)tableviewTopicCellWithReuseIdentifier:(NSString *)identifier
{
    CGRect rect = CGRectMake(0, 0, WINDOW_WIDTH, ROW_HEIGHT);
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.frame = rect;
    
    //Info
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    infoLabel.tag = INFO_TAG;
    [cell addSubview:infoLabel];
    
    //Title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.tag = TITLE_TAG;
    [cell addSubview:titleLabel];
    
    return cell;
}

- (void)configureTopicCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *topic;
    if (indexPath.row < [[_member objectForKey:@"posted_topics"] count]+2) {
        topic = [[_member objectForKey:@"posted_topics"] objectAtIndex:(indexPath.row-2)];
    } else {
        topic = [[_member objectForKey:@"parted_topics"] objectAtIndex:(indexPath.row-3-[[_member objectForKey:@"posted_topics"] count])];
    }
    
    UILabel *infoLabel = (UILabel *)[cell viewWithTag:INFO_TAG];
    CGRect infoFrame = CGRectMake(MARGIN, MARGIN, WINDOW_WIDTH-MARGIN*2, 0);
    infoLabel.font = [UIFont systemFontOfSize:9];
    infoLabel.highlightedTextColor = [UIColor whiteColor];
    infoLabel.opaque = NO;
    infoLabel.text = [NSString stringWithFormat:@"%@ 回复 | 最近由 %@ 在 %@ 回复", [topic objectForKey:@"replies"], [topic objectForKey:@"author"], [topic objectForKey:@"last_reply_time"]];
    
    infoLabel.textColor = [UIColor lightGrayColor];
    [infoLabel sizeToFit];
    infoFrame.size.height = infoLabel.frame.size.height;
    infoLabel.frame = infoFrame;
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:TITLE_TAG];
    CGRect titleFrame = CGRectMake(MARGIN, infoFrame.origin.y+infoFrame.size.height, WINDOW_WIDTH-MARGIN*2, 0);
    titleLabel.frame = titleFrame;
    titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    titleLabel.highlightedTextColor = [UIColor whiteColor];
    titleLabel.opaque = NO;
    titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    titleLabel.numberOfLines = 0;
    titleLabel.text = [topic objectForKey:@"title"];
    [titleLabel sizeToFit];
    titleFrame.size.height = titleLabel.frame.size.height;
    titleLabel.frame = titleFrame;
    
    cell.frame = CGRectMake(0, 0, WINDOW_WIDTH, titleFrame.origin.y+titleFrame.size.height+MARGIN);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	return cell.frame.size.height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 2) {
        return;
    }
    NSDictionary *topic;
    if (indexPath.row < [[_member objectForKey:@"posted_topics"] count]+2) {
        topic = [[_member objectForKey:@"posted_topics"] objectAtIndex:(indexPath.row-2)];
    } else {
        topic = [[_member objectForKey:@"parted_topics"] objectAtIndex:(indexPath.row-3-[[_member objectForKey:@"posted_topics"] count])];
    }
    VMTopicVC *topicVC = [[VMTopicVC alloc] initWithTopic:topic];
    [topicVC updateView];
    [self.navigationController pushViewController:topicVC animated:YES];
}

@end
