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
    UISearchBar *searchBar;
//    UISearchDisplayController *searchDC;
    // Create a search bar - you can add this in the viewDidLoad
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.keyboardType = UIKeyboardTypeAlphabet;
    searchBar.showsCancelButton = YES;
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
//    
//    // Create the search display controller
//    searchDC = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//    searchDC.searchResultsDataSource = self;
//    searchDC.searchResultsDelegate = self;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
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
    query = searchBar.text;
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    query = nil;
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}

- (void)cancel
{
//    TODO
    NSLog(@"load nodes failed");
}

- (void)didFinishedLoadingWithData:(NSArray *)data
{
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
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 26;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = int2string(section, 'A');
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *header = int2string(section, 'a');
    NSArray *filteredNodes = filterNodes([nodes objectForKey:header], query);
    return filteredNodes.count;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    static NSArray *indexTitles;
    if (indexTitles == nil) {
        indexTitles = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"S", @"R", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    }
    return indexTitles;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NodeIdentifier";
    UITableViewCell *nodeCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nodeCell == nil) {
        nodeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSString *header = int2string(indexPath.section, 'a');
    nodeCell.textLabel.text = [[filterNodes([nodes objectForKey:header], query) objectAtIndex:indexPath.row] objectForKey:@"title"];
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
