//
//  VMTabBarController.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 5/4/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "VMTabBarController.h"

@implementation VMTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
	[self hideTabBar];
	[self addCustomElements];
}

- (void)hideTabBar
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
			break;
		}
	}
}

- (void)selectTab:(int)tabID
{
    switch(tabID)
    {
        case 0:
            [timelineButton setSelected:true];
            [notificationButton setSelected:false];
            [nodeButton setSelected:false];
            [favoriteButton setSelected:false];
            [settingButton setSelected:false];
            break;
        case 1:
            [timelineButton setSelected:false];
            [notificationButton setSelected:true];
            [nodeButton setSelected:false];
            [favoriteButton setSelected:false];
            [settingButton setSelected:false];
            break;
        case 2:
            [timelineButton setSelected:false];
            [notificationButton setSelected:false];
            [nodeButton setSelected:true];
            [favoriteButton setSelected:false];
            [settingButton setSelected:false];
            break;
        case 3:
            [timelineButton setSelected:false];
            [notificationButton setSelected:false];
            [nodeButton setSelected:false];
            [favoriteButton setSelected:true];
            [settingButton setSelected:false];
            break;
        case 4:
            [timelineButton setSelected:false];
            [notificationButton setSelected:false];
            [nodeButton setSelected:false];
            [favoriteButton setSelected:false];
            [settingButton setSelected:true];
            break;
    }	
    
    if (self.selectedIndex == tabID) {
        UINavigationController *navController = (UINavigationController *)[self selectedViewController];
        [navController popToRootViewControllerAnimated:YES];
    } else {
        self.selectedIndex = tabID;
    }
}

-(void)addCustomElements
{
	// Initialise our two images
	UIImage *btnImage = [UIImage imageNamed:@"tabbar-item-timeline.png"];
	UIImage *btnImageSelected = [UIImage imageNamed:@"tabbar-item-timeline-selected.png"];
    //Setup the button
	timelineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // Set the frame (size and position) of the button)
    timelineButton.frame = CGRectMake(0, 430, 64, 48); 
    // Set the image for the normal state of the button
	[timelineButton setBackgroundImage:btnImage forState:UIControlStateNormal];
    // Set the image for the selected state of the button
	[timelineButton setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    // Assign the button a "tag" so when our "click" event is called we know which button was pressed.
	[timelineButton setTag:0];
    // Set this button as selected (we will select the others to false as we only want Tab 1 to be selected initially
	[timelineButton setSelected:true];
    
    // Now we repeat the process for the other buttons
	btnImage = [UIImage imageNamed:@"tabbar-item-notification.png"];
	btnImageSelected = [UIImage imageNamed:@"tabbar-item-notification-selected.png"];
	notificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    notificationButton.frame = CGRectMake(64, 430, 64, 48);
	[notificationButton setBackgroundImage:btnImage forState:UIControlStateNormal];
	[notificationButton setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
	[notificationButton setTag:1];
    
	btnImage = [UIImage imageNamed:@"tabbar-item-node.png"];
	btnImageSelected = [UIImage imageNamed:@"tabbar-item-node-selected.png"];
	nodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nodeButton.frame = CGRectMake(128, 430, 64, 48);
	[nodeButton setBackgroundImage:btnImage forState:UIControlStateNormal];
	[nodeButton setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
	[nodeButton setTag:2];
    
	btnImage = [UIImage imageNamed:@"tabbar-item-favorite.png"];
	btnImageSelected = [UIImage imageNamed:@"tabbar-item-favorite-selected.png"];
	favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    favoriteButton.frame = CGRectMake(192, 430, 64, 48);
	[favoriteButton setBackgroundImage:btnImage forState:UIControlStateNormal];
	[favoriteButton setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
	[favoriteButton setTag:3];
    
	btnImage = [UIImage imageNamed:@"tabbar-item-setting.png"];
	btnImageSelected = [UIImage imageNamed:@"tabbar-item-setting-selected.png"];
	settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.frame = CGRectMake(256, 430, 64, 48);
	[settingButton setBackgroundImage:btnImage forState:UIControlStateNormal];
	[settingButton setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
	[settingButton setTag:4];
    
    // Add my new buttons to the view
	[self.view addSubview:timelineButton];
	[self.view addSubview:notificationButton];
	[self.view addSubview:nodeButton];
	[self.view addSubview:favoriteButton];
	[self.view addSubview:settingButton];
    
    // Setup event handlers so that the buttonClicked method will respond to the touch up inside event.
	[timelineButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[notificationButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[nodeButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[favoriteButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[settingButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClicked:(id)sender
{
	int tagNum = [sender tag];
	[self selectTab:tagNum];
}

@end
