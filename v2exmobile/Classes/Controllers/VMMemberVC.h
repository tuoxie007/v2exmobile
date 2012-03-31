//
//  VMMemberVC.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/22/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import <UIKit/UIKit.h>
#import "VMMemberLoader.h"
#import "VMLoginHandler.h"

@class VMwaitingView;
@interface VMMemberVC : UITableViewController <LoaderDalegate, LoginHandlerDelegate, UIAlertViewDelegate>
{
    NSDictionary *_member;
    VMLoginHandler *loginHandler;
    BOOL following;
    BOOL followed;
    VMwaitingView *waittingView;
    BOOL myself;
    UIView *bakupView;
}

- (id)initWithMember:(NSDictionary *)member;
- (id)initWithName:(NSString *)name;
- (void)loadMember;
- (UITableViewCell *)tableviewMemberCellWithReuseIdentifier:(NSString *)identifier;
- (void)configureMemberCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableviewTopicCellWithReuseIdentifier:(NSString *)indexPath;
- (void)configureTopicCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)identifier;
- (void)follow;
- (void)login;
- (void)logout;
- (void)setViewAsNotLogin;
@end
