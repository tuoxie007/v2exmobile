//
//  VMTopicCell.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 5/9/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#define PADDING_LEFT 11
#define PADDDING_TOP 10
#define AVATAR_WIDTH 35

#import <UIKit/UIKit.h>

@interface VMTopicCell : UITableViewCell
{
    NSDictionary *topic;
    BOOL withAvatar;
    BOOL withSeperator;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSeperator:(BOOL)_withSeperator withAvatar:(BOOL)withAvatar;

- (void)setTopic:(NSDictionary *)_topic;
- (void)showTopicContent;

@end
