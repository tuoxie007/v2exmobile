//
//  VMSettingVC.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 5/6/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import <UIKit/UIKit.h>
#import "IASKAppSettingsViewController.h"

@interface VMSettingVC : UIViewController <UITextFieldDelegate, IASKSettingsDelegate>
{
    UITextField *usernameInput;
    UITextField *passwordInput;
    IASKAppSettingsViewController *inAppSettingVC;
}

- (void)toRegister;
- (void)showLogin;
- (void)showSettings;
- (void)login;
- (void)logout;
- (void)didLogin;

@end
