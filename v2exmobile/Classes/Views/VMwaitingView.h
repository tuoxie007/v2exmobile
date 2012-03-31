//
//  VMwaitingView.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/17/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import <UIKit/UIKit.h>

@interface VMwaitingView : UIView

- (void)setLoadingCenter:(CGPoint)center;
- (id)initWithMessage:(NSString *)message;

@end
