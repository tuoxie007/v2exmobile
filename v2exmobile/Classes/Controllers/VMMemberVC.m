//
//  VMMemberVC.m
//  v2exmobile
//
//  Created by 徐 可 on 3/22/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import "VMMemberVC.h"
#import "VMAccount.h"
#import "VMLoginHandler.h"
#import "VMMemberLoader.h"
#import "Config.h"
#import "VMImageLoader.h"

@implementation VMMemberVC

- (id)initWithMember:(NSDictionary *)member
{
    self = [super init];
    _member = member;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [_member objectForKey:@"name"];
    UIBarButtonItem *followButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关注" style:UIBarButtonItemStylePlain target:self action:@selector(follow)];
    self.navigationItem.rightBarButtonItem = followButtonItem;
    if ([VMAccount getInstance].cookie == nil) {
        VMLoginHandler  *loginHandler = [[VMLoginHandler alloc] initWithDelegate:self];
        [loginHandler login];
    } else {
        [self loadMember];
    }
}

- (void)follow
{
    
}

- (void)loadMember
{
    VMMemberLoader *memberLoader = [[VMMemberLoader alloc] initWithDelegate:self];
    [memberLoader loadMemberWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", V2EX_URL, [_member objectForKey:@"url"]]]];
}

- (void)didFinishedLoadingWithData:(id)member
{
    _member = [NSMutableDictionary dictionaryWithDictionary:_member];
    [_member setValuesForKeysWithDictionary:member];
    [self.tableView reloadData];
}

- (void)cancel
{
    NSLog(@"Member Load Failed");
}

- (void)loginSuccess
{
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
    } else {
        static NSString *identifier = @"TopicCell";
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
#define SIGNIN_TAG 3
#define DESC_TAG 4
#define INFO_TAG 5
#define TITLE_TAG 6

- (UITableViewCell *)tableviewMemberCellWithReuseIdentifier:(NSString *)identifier
{
    CGRect rect = CGRectMake(0, 0, WINDOW_WIDTH, ROW_HEIGHT);
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.frame = rect;
    
    //Userpic view
    rect = CGRectMake(MARGIN, (ROW_HEIGHT - IMAGE_SIDE) / 2.0, IMAGE_SIDE, IMAGE_SIDE);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.tag = IMAGE_TAG;
    [cell.contentView addSubview:imageView];
    
    //Name
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLabel.tag = NAME_TAG;
    [cell addSubview:nameLabel];
    
    //Signin
    UILabel *signinLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    signinLabel.tag = SIGNIN_TAG;
    [cell addSubview:signinLabel];
    
    //Desc
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    descLabel.tag = DESC_TAG;
    [cell addSubview:descLabel];
    
    return cell;
}
- (void)configureMemberCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)identifier
{
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:IMAGE_TAG];
    VMImageLoader *imgLoader = [[VMImageLoader alloc] init];
    [imgLoader loadImageWithURL:[NSURL URLWithString:[_member objectForKey:@"img_url"]] forImageView:imageView];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:NAME_TAG];
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    CGRect nameFrame = CGRectMake(imageView.frame.origin.x+MARGIN, imageView.frame.origin.y, WINDOW_WIDTH-imageView.frame.size.width-MARGIN*3, 0);
    nameLabel.text = [_member objectForKey:@"name"];
    [nameLabel sizeToFit];
    nameFrame.size.height = nameLabel.frame.size.height;
    nameLabel.frame = nameFrame;
    
    UILabel *signinLabel = (UILabel *)[cell viewWithTag:SIGNIN_TAG];
    CGRect signinFrame = CGRectMake(imageView.frame.origin.x+MARGIN, imageView.frame.origin.y+imageView.frame.size.height/2, WINDOW_WIDTH-imageView.frame.size.width-MARGIN*3, 0);
    signinLabel.font = [UIFont systemFontOfSize:12];
    signinLabel.textColor = [UIColor lightGrayColor];
    signinLabel.text = [_member objectForKey:@"signin"];
    [signinLabel sizeToFit];
    signinFrame.size.height = signinLabel.frame.size.height;
    signinLabel.frame = signinFrame;
    
    UILabel *descLabel = (UILabel *)[cell viewWithTag:DESC_TAG];
    CGRect descFrame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y+MARGIN, WINDOW_WIDTH-MARGIN*2, 0);
    descLabel.lineBreakMode = UILineBreakModeWordWrap;
    descLabel.numberOfLines = 0;
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.text = [_member objectForKey:@"desc"];
    [descLabel sizeToFit];
    descFrame.size.height = descLabel.frame.size.height;
    descLabel.frame = descFrame;
    
    cell.frame = CGRectMake(0, 0, WINDOW_WIDTH, descLabel.frame.origin.y+descLabel.frame.size.height+MARGIN);
    NSLog(@"%f,%f,%f,%f", cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
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
    UILabel *infoLabel = (UILabel *)[cell viewWithTag:INFO_TAG];
    CGRect infoFrame = CGRectMake(MARGIN, MARGIN, WINDOW_WIDTH-MARGIN*2, 0);
    infoLabel.font = [UIFont systemFontOfSize:12];
    infoLabel.text = [NSString stringWithFormat:@"by %@ at %@ %@回复", [_member objectForKey:@"author"], [_member objectForKey:@"last_reply_time"], [_member objectForKey:@"replies"]];

    infoLabel.textColor = [UIColor lightGrayColor];
    [infoLabel sizeToFit];
    infoFrame.size.height = infoLabel.frame.size.height;
    infoLabel.frame = infoFrame;
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:INFO_TAG];
    CGRect titleFrame = CGRectMake(MARGIN, infoFrame.origin.y+infoFrame.size.height, WINDOW_WIDTH-MARGIN*2, 0);
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = [_member objectForKey:@"title"];
    [titleLabel sizeToFit];
    infoFrame.size.height = titleLabel.frame.size.height;
    titleLabel.frame = titleFrame;
    
    cell.frame = CGRectMake(0, 0, WINDOW_WIDTH, titleFrame.origin.y+titleFrame.size.height+MARGIN);
    NSLog(@"%f,%f,%f,%f", cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	return cell.frame.size.height;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
