//
//  VMNodeVC.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/11/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMNodeVC.h"
#import "Commen.h"
#import "VMNodeVC2.h"
#import "VMAPI.h"
#import "VMNodeTimelineVC.h"

NSString *int2string(NSInteger section, char startChar);
NSArray *filterNodes(NSArray *nodes, NSString *query);

NSString *int2string(NSInteger section, char startChar)
{
    char head[2];
    head[0] = startChar + section;
    head[1] = '\0';
    NSString *header = [NSString stringWithCString:head encoding:NSASCIIStringEncoding];
    return header;
}
NSArray *filterNodes(NSArray *nodes, NSString *query)
{
    if (query && query.length) {
        NSMutableArray *filteredNodes = [[NSMutableArray alloc] init];
        for (NSDictionary *node in nodes) {
            if ([((NSString *)[node objectForKey:@"name"]) hasPrefix:query]) {
                [filteredNodes addObject:node];
            }
        }
        return filteredNodes;
    }
    return nodes;
}

@implementation VMNodeVC

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"节点";
//    NSString *nodesFilePath = [Commen getFilePathWithFilename:@"nodes.txt"];
//    nodes = [[NSDictionary alloc] initWithContentsOfFile:nodesFilePath];
    [[VMAPI sharedAPI] allNodesWithDelegate:self];
    
    UIView *searchBarBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 53)];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.keyboardType = UIKeyboardTypeAlphabet;
    _searchBar.placeholder = @"搜索";
    _searchBar.tintColor = [UIColor colorWithWhite:0.86 alpha:1];
    _searchBar.delegate = self;
    [searchBarBG addSubview:_searchBar];
    
    UIImageView *searchBottomBorder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search-bar-bottom-border.png"]];
    searchBottomBorder.frame = CGRectMake(0, 43, 320, 10);
    [searchBarBG addSubview:searchBottomBorder];
    
//    self.tableView.tableHeaderView = _searchBar;
//    [self.view addSubview:searchBarBG];
    self.tableView.tableHeaderView = searchBarBG;
//	[self.tableView setContentInset:UIEdgeInsetsMake(53, 0, 0, 0)];
    
    self.tableView.backgroundColor =  [UIColor colorWithWhite:0.78 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isSearching = YES;
    if (searchCancelButton == nil) {
        searchCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 53, 320, 44*(nodesCount ? nodesCount : 546)+26*22)];
        [searchCancelButton addTarget:self action:@selector(cancelSearch:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:searchCancelButton];
    query = searchBar.text;
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    query = searchBar.text;
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    isSearching = NO;
    query = searchBar.text;
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}

- (void)cancelSearch:(UIButton *)sender
{
    isSearching = NO;
    [sender removeFromSuperview];
    [_searchBar resignFirstResponder];
    [self.tableView reloadData];
}

- (void)cancel
{
//    TODO
    NSLog(@"load nodes failed");
}

- (void)didFinishedLoadingWithData:(NSArray *)data
{
    nodesCount = data.count;
    nodes = [[NSMutableDictionary alloc] initWithCapacity:26];
    for (char i=0; i<26; i++) {
        NSString *header = int2string('a', i);
        NSMutableArray *subNodes = [[NSMutableArray alloc] init];
        for (NSDictionary *node in data) {
            NSString *name = [node objectForKey:@"name"];
            if ([name hasPrefix:header]) {
                [subNodes addObject:node];
            }
        }
        [nodes setValue:subNodes forKey:header];
    }
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0, 44) animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 26;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *header = int2string(section, 'a');
    NSArray *filteredNodes = filterNodes([nodes objectForKey:header], query);
    return filteredNodes.count;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (isSearching) {
        return nil;
    }
    static NSArray *indexTitles;
    if (indexTitles == nil) {
        indexTitles = [NSArray arrayWithObjects:UITableViewIndexSearch, @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"S", @"R", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    }
    return indexTitles;
}

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (index == 0)
    {
        [tableView setContentOffset:CGPointZero animated:NO];
        return NSNotFound;
    }
    return index - 1; // due magnifying glass icon
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NodeIdentifier";
    UITableViewCell *nodeCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nodeCell == nil) {
        nodeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, 304, 44)];
        bgView.backgroundColor = [UIColor whiteColor];
        [nodeCell addSubview:bgView];
        UIImageView *separatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-cell-separator.png"]];
        separatorView.frame = CGRectMake(8, 43, 304, 1);
        [nodeCell addSubview:separatorView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 284, 43)];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor colorWithRed:0.27 green:0.28 blue:0.29 alpha:1];
        label.tag = 1;
        [nodeCell addSubview:label];
    }
    NSString *header = int2string(indexPath.section, 'a');
//    nodeCell.textLabel.text = [[filterNodes([nodes objectForKey:header], query) objectAtIndex:indexPath.row] objectForKey:@"title"];
    UILabel *label = (UILabel *)[nodeCell viewWithTag:1];
    [label setText:[[filterNodes([nodes objectForKey:header], query) objectAtIndex:indexPath.row] objectForKey:@"title"]];
    label.font = [UIFont boldSystemFontOfSize:16];
    return nodeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *header = int2string(indexPath.section, 'a');
    NSDictionary *node = [filterNodes([nodes objectForKey:header], query) objectAtIndex:indexPath.row];
    VMNodeTimelineVC *nodeTimelineVC = [[VMNodeTimelineVC alloc] initWithNode:[node objectForKey:@"name"] title:[node objectForKey:@"title"]];
    [self.navigationController pushViewController:nodeTimelineVC animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
