//
//  VMNodeTimelineVC.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/17/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMTimelineVC.h"
#import "VMLoginHandler.h"

@interface VMNodeTimelineVC : VMTimelineVC <LoginHandlerDelegate>
{
    NSString *_node;
    NSString *nodeTitle;
    VMLoginHandler *loginHandler;
}

- (id)initWithNode:(NSString *)node title:(NSString *)title;
- (void)post;
- (void)postSuccess;
- (void)removeInfoView;
@end
