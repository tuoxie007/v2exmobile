//
//  VMSettingVC.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 5/6/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMSettingVC.h"
#import "IASKAppSettingsViewController.h"

@implementation VMSettingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (YES) {
        [self showLogin];
    } else {
        [self didLogin];
    }
    self.title = @"设置";
}

- (void)showSettings
{
    inAppSettingVC = [[IASKAppSettingsViewController alloc] init];
    inAppSettingVC.showDoneButton = NO;
    inAppSettingVC.showCreditsFooter = NO;
    inAppSettingVC.delegate = self;
    [self.navigationController pushViewController:inAppSettingVC animated:YES];
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

- (void)showLogin
{
    [[self.view viewWithTag:102] removeFromSuperview];
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil];
    UIView *loginView = [nibViews objectAtIndex:0];
    loginView.tag = 101;
    
    UIButton *regButton = (UIButton *)[loginView viewWithTag:1];
    [regButton addTarget:self action:@selector(toRegister) forControlEvents:UIControlEventTouchUpInside];
    [regButton setBackgroundImage:[[UIImage imageNamed:@"button-bg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
    
    usernameInput = (UITextField *)[loginView viewWithTag:2];
    passwordInput = (UITextField *)[loginView viewWithTag:3];
    
    [self.view addSubview:loginView];
    
    UIButton *buttonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 26)];
    [buttonView setBackgroundImage:[UIImage imageNamed:@"nav-button-bg.png"] forState:UIControlStateNormal];
    [buttonView addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    UILabel *buttonTitleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 26)];
    buttonTitleView.text = @"登录";
    buttonTitleView.textColor = [UIColor whiteColor];
    buttonTitleView.textAlignment = UITextAlignmentCenter;
    buttonTitleView.font = [UIFont systemFontOfSize:12];
    buttonTitleView.backgroundColor = [UIColor clearColor];
    [buttonView addSubview:buttonTitleView];
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    self.navigationItem.rightBarButtonItem = postButton;
}

- (void)login
{
    [self didLogin];
}

- (void)logout
{
    [self showLogin];
}

- (void)didLogin
{
    [[self.view viewWithTag:101] removeFromSuperview];
    
    // Set Account Settings
    NSUserDefaults *accountSettings = [NSUserDefaults standardUserDefaults];
    [accountSettings setValue:@"Livid" forKey:@"username"];;
    [accountSettings setValue:@"livid@v2ex.com" forKey:@"email"];;
    [accountSettings setValue:@"www.livid.cn" forKey:@"website"];;
    [accountSettings setValue:@"中國" forKey:@"location"];;
    [accountSettings setValue:@"Beautifully Advanced" forKey:@"tagline"];;
    [accountSettings setBool:YES forKey:@"list_rich"];
    [accountSettings setInteger:2000 forKey:@"current_rich"];
    [accountSettings setBool:YES forKey:@"show_home_top"];
    [accountSettings setValue:@"livid" forKey:@"twitter"];
    [accountSettings setValue:@"" forKey:@"btc"];
    [accountSettings setValue:@"" forKey:@"psn"];
    [accountSettings setValue:@"" forKey:@"github"];
    [accountSettings setValue:@"" forKey:@"my_home"];
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"SettingsView" owner:self options:nil];
    UIView *settingsView = [nibViews objectAtIndex:0];
    settingsView.tag = 102;
    
    UILabel *usernameLabel = (UILabel *)[settingsView viewWithTag:1];
    usernameLabel.text = @"Livid";
    
    UIButton *logoutButton = (UIButton *)[settingsView viewWithTag:2];
    [logoutButton setBackgroundImage:[[UIImage imageNamed:@"button-bg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *showSettingsButton = (UIButton *)[settingsView viewWithTag:3];
    [showSettingsButton setBackgroundImage:[[UIImage imageNamed:@"button-bg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
    [showSettingsButton addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:settingsView];
}

- (void)toRegister
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.v2ex.com/signup"]];
}

- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController *)sender
{
//    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
//    NSString *username = [settings stringForKey:@"website"];
    // TODO : Save to v2ex server
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
