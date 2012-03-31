//
//  Commen.m
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/18/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#import "Commen.h"

@implementation Commen

+ (NSString *)getFilePathWithFilename:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:filename];
}

@end
