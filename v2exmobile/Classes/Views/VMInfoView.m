//
//  VMInfoView.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/17/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMInfoView.h"
#import "Config.h"
#define BG_VIEW_TAG 1
#define MESSAGE_VIEW_TAG 2

@implementation VMInfoView

- (id)initWithMessage:(NSString *)message
{
    self = [super init];
    self.frame = CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    bgView.center = self.center;
    bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.9];
    bgView.tag = BG_VIEW_TAG;
    bgView.center = self.center;
    [self addSubview:bgView];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    messageLabel.tag = MESSAGE_VIEW_TAG;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.text = message;
    messageLabel.textAlignment = UITextAlignmentCenter;
    messageLabel.font = [UIFont systemFontOfSize:14];
    messageLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [messageLabel sizeToFit];
    messageLabel.center = self.center;
    [self addSubview:messageLabel];
    
    return self;
}

@end
