//
//  VMNodeTimelineVC.h
//  v2exmobile
//
//  Created by 徐 可 on 3/17/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import "VMTimelineVC.h"

@interface VMNodeTimelineVC : VMTimelineVC <VMAccountDalegate>
{
    NSString *_node;
}

- (id)initWithNode:(NSString *)node;
- (void)post;
- (void)postSuccess;
- (void)removeInfoView;
@end
