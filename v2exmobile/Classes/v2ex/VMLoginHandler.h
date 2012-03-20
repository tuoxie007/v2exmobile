//
//  VMLoginHandler.h
//  v2exmobile
//
//  Created by 徐 可 on 3/20/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VMAccount.h"

@protocol LoginHandlerDelegate;
@interface VMLoginHandler : NSObject <VMAccountDalegate, UIAlertViewDelegate>
{
    id<LoginHandlerDelegate> _delegate;
}

@property id<LoginHandlerDelegate> delegate;

- (id)initWithDelegate:(id<LoginHandlerDelegate>)delegate;
- (void)login;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)accountLoginSuccess;
- (void)accountLoginFailed;

@end


@protocol LoginHandlerDelegate <NSObject>

- (void)loginSuccess;

@end