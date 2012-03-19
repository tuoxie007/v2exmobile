//
//  VMNodeVC.m
//  v2exmobile
//
//  Created by 徐 可 on 3/11/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import "VMNodeVC.h"
#import "Commen.h"
#import "VMNodeVC2.h"

@implementation VMNodeVC

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"节点";
    NSString *nodesFilePath = [Commen getFilePathWithFilename:@"nodes.txt"];
    nodes = [[NSDictionary alloc] initWithContentsOfFile:nodesFilePath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"常用节点";
    } else {
        return @"全部节点";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *categoryLevel1;
    if (section == 0) {
        categoryLevel1 = @"commen";
    } else {
        categoryLevel1 = @"all";
    }
    return [[[nodes objectForKey:categoryLevel1] allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NodeIdentifier";
    UITableViewCell *nodeCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nodeCell == nil) {
        nodeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSString *categoryLevel1;
    if (indexPath.section == 0) {
        categoryLevel1 = @"commen";
    } else {
        categoryLevel1 = @"all";
    }
    nodeCell.textLabel.text = [[[nodes objectForKey:categoryLevel1] allKeys] objectAtIndex:indexPath.row];
    return nodeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *categoryLevel1;
    if (indexPath.section == 0) {
        categoryLevel1 = @"commen";
    } else {
        categoryLevel1 = @"all";
    }
    NSString *categoryLevel2 = [[[nodes objectForKey:categoryLevel1] allKeys] objectAtIndex:indexPath.row];
    NSArray *nodesInCategory = [[nodes objectForKey:categoryLevel1] objectForKey:categoryLevel2];
    VMNodeVC2 *nodeVC2 = [[VMNodeVC2 alloc] initWithNodes:nodesInCategory inCategory:categoryLevel2];
    [self.navigationController pushViewController:nodeVC2 animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
