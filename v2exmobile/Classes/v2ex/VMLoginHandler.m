//
//  VMLoginHandler.m
//  v2exmobile
//
//  Created by 徐 可 on 3/20/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import "VMLoginHandler.h"
#import "VMAccount.h"
#define ASK_LOGIN_TAG 19
#define LOGIN_PROMPT_TAG 20
#define INFO_VIEW_TAG 21

@implementation VMLoginHandler

@synthesize delegate = _delegate;

- (id)initWithDelegate:(id<LoginHandlerDelegate>)delegate
{
    self = [super init];
    _delegate = delegate;
    return self;
}

- (void)login
{
    UIAlertView *askWillLoginAlertView = [[UIAlertView alloc] initWithTitle:@"回帖需要登录" message:@"您尚未登录，现在就去登录吗？" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"是的", nil];
    askWillLoginAlertView.tag = ASK_LOGIN_TAG;
    [askWillLoginAlertView show];
}

#pragma mark - alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ASK_LOGIN_TAG) {
        if (buttonIndex) {
            UIAlertView *loginPromptAlertView = [[UIAlertView alloc] initWithTitle:@"请输入用户名和密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"提交", nil];
            loginPromptAlertView.tag = LOGIN_PROMPT_TAG;
            loginPromptAlertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            [loginPromptAlertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeEmailAddress;
            [loginPromptAlertView show];
        }
    } else if (alertView.tag == LOGIN_PROMPT_TAG) {
        if (buttonIndex) {
            // do login
            NSString *username = [alertView textFieldAtIndex:0].text;
            NSString *password = [alertView textFieldAtIndex:1].text;
            VMAccount *account = [VMAccount getInstance];
            account.delegate = self;
            [account login:username password:password];
        }
    }
}

#pragma mark - account delegate
- (void)accountLoginSuccess
{
    [_delegate loginSuccess];
}

- (void)accountLoginFailed
{
    UIAlertView *errAlertView = [[UIAlertView alloc] initWithTitle:@"登录错误" message:@"请稍后再试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil];
    [errAlertView show];
}
@end
