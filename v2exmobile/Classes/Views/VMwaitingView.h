//
//  VMwaitingView.h
//  v2exmobile
//
//  Created by 徐 可 on 3/17/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VMwaitingView : UIView

- (void)setLoadingCenter:(CGPoint)center;
- (id)initWithMessage:(NSString *)message;

@end
