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

+ (NSString *)urlencode:(NSString *)text
{
    NSString *temp = @"";
    
    for(int i=0, max=[text length]; i<max; i++) {
        char t = [text characterAtIndex:i];
        int b = (int) t;
        
        if(
           t == (char) '.' ||
           t == (char) '_' ||
           t == (char) '-' ||
           t == (char) '~' ||
           t == (char) '#' ||
           (b>=0x30 && b<=0x39) ||
           (b>=0x41 && b<=0x5A) ||
           (b>=0x61 && b<=0x7A)
           ) {
            temp = [temp stringByAppendingFormat:@"%c", t];
        } else {
            temp = [temp stringByAppendingString:@"%"];
            if (b <= 0xf) temp = [temp stringByAppendingString:@"0"];
            temp = [NSString stringWithFormat:@"%@%X", temp, b];
        }
    }
    
    return temp;
}

@end
