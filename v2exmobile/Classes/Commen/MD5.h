//
//  MD5.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/16/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)
- (NSString *) md5;
@end

@interface NSData (MD5)
- (NSString*)md5;
@end
