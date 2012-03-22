//
//  VMMemberVC.h
//  v2exmobile
//
//  Created by 徐 可 on 3/22/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VMMemberLoader.h"
#import "VMLoginHandler.h"

@interface VMMemberVC : UITableViewController <LoaderDalegate, LoginHandlerDelegate>
{
    NSDictionary *_member;
}

- (id)initWithMember:(NSDictionary *)member;
- (void)loadMember;
- (UITableViewCell *)tableviewMemberCellWithReuseIdentifier:(NSString *)identifier;
- (void)configureMemberCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableviewTopicCellWithReuseIdentifier:(NSString *)indexPath;
- (void)configureTopicCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)identifier;
- (void)follow;

@end
