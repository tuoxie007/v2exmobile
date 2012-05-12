//
//  VMTopicCell.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 5/9/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

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
