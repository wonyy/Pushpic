//
//  CUtils.h
//  Cariloop
//
//  Created by Tan Hui on 08/22/13.
//  Copyright 2013 Satori Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>


@interface CUtils : NSObject {

}

+ (NSString *)getFilePath:(NSString *)fileName;
+ (BOOL)isFileInDocumentDirectory:(NSString *)fileName;
+ (void)copyFileToDocumentDirectory:(NSString *)fileName;
+ (NSString *)getDocumentDirectory;
+ (NSString *)generateFileName: (BOOL) bMovie;

+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

// Time and Date
+ (NSString *)convertToLocalTime:(NSString *)GMTtime;
+ (NSString *)getCurrentTime;
+ (NSInteger)getAge:(NSString *)dateOfBirth;

// image
+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size;

// iPhone 5
+ (BOOL) isIphone5;

+ (void) makeRoundedText: (UITextField *) textField;
+ (BOOL) IsEmptyString : (NSString *) str;

+ (CGFloat) getRealHeight: (NSString *) text size: (CGSize) textSize font: (UIFont *) font min_height: (float) minHeight lineBreakMode:(NSLineBreakMode)lineBreakMode;


@end
