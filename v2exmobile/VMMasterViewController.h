//
//  VMMasterViewController.h
//  v2exmobile
//
//  Created by 徐 可 on 3/11/12.
//  Copyright (c) 2012 TVie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VMDetailViewController;

@interface VMMasterViewController : UITableViewController

@property (strong, nonatomic) VMDetailViewController *detailViewController;

@end
