//
//  VMwaitingView.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/17/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMwaitingView.h"
#import "Config.h"

#define BG_VIEW_TAG 1
#define WAITING_VIEW_TAG 2
#define MESSAGE_VIEW_TAG 3

@implementation VMwaitingView

- (id)initWithMessage:(NSString *)message
{
    self = [super init];
    self.frame = CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    bgView.center = self.center;
    bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.9];
    bgView.tag = BG_VIEW_TAG;
    [self addSubview:bgView];
    
    UIActivityIndicatorView *waitingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    waitingView.center = self.center;
    waitingView.tag = WAITING_VIEW_TAG;
    [self addSubview:waitingView];
    [waitingView startAnimating];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    messageLabel.tag = MESSAGE_VIEW_TAG;
    messageLabel.textColor = [UIColor whiteColor];
    if (message == nil) {
        message = @"正在加载";
    }
    messageLabel.text = message;
    messageLabel.textAlignment = UITextAlignmentCenter;
    messageLabel.font = [UIFont systemFontOfSize:14];
    messageLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [messageLabel sizeToFit];
    [self addSubview:messageLabel];
    
    return self;
}

- (void)setLoadingCenter:(CGPoint)center
{
    [self viewWithTag:BG_VIEW_TAG].center = center;
    UIView *waitingView = [self viewWithTag:WAITING_VIEW_TAG];
    waitingView.center = center;
    UIView *msgLabel = [self viewWithTag:MESSAGE_VIEW_TAG];
    msgLabel.center = center;
    CGRect msgLabelFrame = msgLabel.frame;
    msgLabelFrame.origin.y += waitingView.frame.size.height;
    msgLabel.frame = msgLabelFrame;
}

@end
