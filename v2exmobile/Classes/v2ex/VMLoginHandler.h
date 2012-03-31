//
//  VMLoginHandler.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/20/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
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