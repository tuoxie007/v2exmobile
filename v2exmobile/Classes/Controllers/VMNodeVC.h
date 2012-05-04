//
//  VMNodeVC.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/11/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import <UIKit/UIKit.h>
#import "VMAPI.h"

@interface VMNodeVC : UITableViewController <APIDalegate, UISearchBarDelegate>
{
    NSDictionary *nodes;
    NSString *query;
//    NSArray *nodes;
}
@end
