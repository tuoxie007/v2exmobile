//
//  Commen.m
//  v2exmobile
//
//  Created by 徐 可 on 3/18/12.
//  Copyright (c) 2012 TVie. All rights reserved.
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
