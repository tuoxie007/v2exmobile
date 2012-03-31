//
//  VMNodeVC2.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/11/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMNodeVC2.h"
#import "VMNodeTimelineVC.h"
#import "Commen.h"

@implementation VMNodeVC2

#pragma mark - View lifecycle
- (id)initWithNodes:(NSArray *)nodes inCategory:(NSString *)title
{
    self = [super init];
    if (self) {
        _nodes = nodes;
        self.title = title;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_nodes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NodeIdentifier";
    UITableViewCell *nodeCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nodeCell == nil) {
        nodeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    nodeCell.textLabel.text = [[_nodes objectAtIndex:indexPath.row] objectAtIndex:1];
    return nodeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VMNodeTimelineVC *nodeTimelineVC = [[VMNodeTimelineVC alloc] initWithNode:[[_nodes objectAtIndex:indexPath.row] objectAtIndex:0]];
    [self.navigationController pushViewController:nodeTimelineVC animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
