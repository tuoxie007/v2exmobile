//
//  VMTabBarController.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 5/4/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import <UIKit/UIKit.h>

@interface VMTabBarController : UITabBarController
{
    UIButton *timelineButton;
    UIButton *notificationButton;
    UIButton *nodeButton;
    UIButton *favoriteButton;
    UIButton *settingButton;
}

-(void) hideTabBar;
-(void) addCustomElements;
-(void) selectTab:(int)tabID;
- (void)buttonClicked:(id)sender;
@end
