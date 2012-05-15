//
//  Commen.h
//  v2exmobile
//
//  Created by Xu Ke <tuoxie007@gmail.com> on 3/18/12.
//  Copyright (c) 2012 Xu Ke.
//  Released under the MIT Licenses.
//

#define PADDING_LEFT 8
#define PADDING_TOP 10
#define CONTENT_WIDTH 320-PADDING_LEFT*2
#define CONTENT_PADDING_LEFT 6
#define CONTENT_PADDING_TOP 6
#define AVATAR_WIDTH 35
#define AVATAR_WIDTH_MINI 16

@interface Commen : NSObject

+ (NSString *)getFilePathWithFilename:(NSString *)filename;
+ (NSString *)urlencode:(NSString *)text;
+ (NSString *)timeAsDisplay:(NSDate *)time;
+ (UIColor *)defaultTextColor;
+ (UIColor *)defaultLightTextColor;
+ (UIColor *)backgroundColor;
+ (void)printRect:(CGRect)frame;
@end
