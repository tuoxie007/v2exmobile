//
//  VMSettingVC.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 5/6/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import <UIKit/UIKit.h>

@interface VMSettingVC : UIViewController <UITextFieldDelegate>
{
    UITextField *usernameInput;
    UITextField *passwordInput;
}

- (IBAction) toRegister;
- (void)showSettings;

@end
