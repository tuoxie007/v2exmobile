//
//  VMSettingVC.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 5/6/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMSettingVC.h"

@implementation VMSettingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    login view
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil];
    UIView *loginView = [nibViews objectAtIndex:0];
    UIImage *regBntImage = [UIImage imageNamed:@"reg-button-bg.png"];
    UIImage *strechedBntImage = [regBntImage stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    UIButton *regButton = (UIButton *)[loginView viewWithTag:1];
    [regButton setBackgroundImage:strechedBntImage forState:UIControlStateNormal];
    usernameInput = (UITextField *)[loginView viewWithTag:2];
    passwordInput = (UITextField *)[loginView viewWithTag:3];
    
    [self.view addSubview:loginView];
    
    UIButton *buttonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 26)];
    [buttonView setBackgroundImage:[UIImage imageNamed:@"nav-button-bg.png"] forState:UIControlStateNormal];
    [buttonView addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    UILabel *buttonTitleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 26)];
    buttonTitleView.text = @"登录";
    buttonTitleView.textColor = [UIColor whiteColor];
    buttonTitleView.textAlignment = UITextAlignmentCenter;
    buttonTitleView.font = [UIFont systemFontOfSize:12];
    buttonTitleView.backgroundColor = [UIColor clearColor];
    [buttonView addSubview:buttonTitleView];
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    self.navigationItem.rightBarButtonItem = postButton;
    
    self.title = @"设置";
}

- (void)showSettings
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 2) {
        [passwordInput becomeFirstResponder];
        return YES;
    } else {
        [textField resignFirstResponder];
        return YES;
    }
}

- (void)toRegister
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.v2ex.com/signup"]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
