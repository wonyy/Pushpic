//
//  DataKeeper.m
//  Cariloop
//
//  Created by Tan Hui on 08/22/13.
//  Copyright 2013 Satori Inc. All rights reserved.
//

#import "DataKeeper.h"



@implementation DataKeeper


@synthesize m_strLastErrorMessage;

@synthesize m_dictLocalImageCaches;

- (id)init
{
    self = [super init];
    if (self) {
        
        ////////////////////////////////////////////
        //// Initialize
        ////////////////////////////////////////////
        
        
        m_dictLocalImageCaches = [[NSMutableDictionary alloc] init];
        
             ////////////////////////////////////////////
    }
    
    return self;
}

#pragma mark - Image Caching

- (void)CreateThreadDownloadImages {
    [NSThread detachNewThreadSelector:@selector(DownloadImages) toTarget:self withObject:nil];
}

- (void) DownloadImages {
    NSLog(@"Start Downloading....");
    
    [self saveDataToFile];
}


// This functions is to get Image from URL
// If the image isnt in local, download and save to local
// If the image is already in local, use it.

- (UIImage *)getImage: (NSString *) strURL toSize:(CGSize)size {
    
    if (strURL == nil || [strURL isKindOfClass:[NSString class]] == NO || [strURL isEqualToString:@""]) {
        return nil;
    }
    
    // Get Local URL of image
    NSString *strLocalURL = [m_dictLocalImageCaches objectForKey:strURL];
    
    UIImage *image;
    
    // If image isnt in local, download and save it to local.
    if (strLocalURL == nil || [strLocalURL isEqualToString:@""]) {
        
        // Get image data from URL.
        NSData* imgData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: 
                                                                 strURL]];
        
        // Generate local file name
        NSString *strFileName = [CUtils generateFileName: NO];
        
        NSString *tempPath = [NSString stringWithFormat:@"%@/%@", [CUtils getDocumentDirectory], strFileName];
        
        
        // Write Image data as a local file.
        if ([imgData length] != 0) {
            
            image = [self resizeImage: [UIImage imageWithData:imgData] toSize:size];
            
            NSData *cropImageData = UIImageJPEGRepresentation(image, 1);
            
            if ([cropImageData writeToFile:tempPath atomically:YES] == YES) {
                [m_dictLocalImageCaches setObject:tempPath forKey:strURL];
                [self saveDataToFile];

            }
            
            image = [UIImage imageWithData:imgData];
            
            if (!image)
                image = nil;
            

        } else {
            image = nil;
        }
    } else {
        
        NSLog(@"Local URL = %@", strLocalURL);
    // If image is already in local, use it.
       image = [UIImage imageWithContentsOfFile: strLocalURL];
    }
    
    return image;
}

- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size
{
    float width = size.width;
    float height = size.height;
    
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio < heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    if (width > rect.size.width) {
        rect.origin.x = - ((width - rect.size.width) / 2);
    }
    
    if (height > rect.size.height) {
        rect.origin.y = - ((height - rect.size.height) / 2);
    }
    
    rect.size.width  = width;
    rect.size.height = height;
    
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return smallImage;
}




- (UIImage *)getLocalImage: (NSString *) strURL {
    
    // Get Local URL of image
    NSString *strLocalURL = [m_dictLocalImageCaches objectForKey:strURL];
    
    UIImage *image;
    
    // If image isnt in local, download and save it to local.
    if (strLocalURL == nil || [strLocalURL isEqualToString:@""]) {
        return nil;
    } else {
        // If image is already in local, use it.
        image = [UIImage imageWithContentsOfFile: strLocalURL];
    }
    
    return image;
}


#pragma mark - Local Management

// All datas will be written in local file
// Image List, User Name, User Password, User setting information

- (BOOL)saveDataToFile
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setValue:m_dictLocalImageCaches forKey:@"images"];
        
    BOOL bSuccess = [dic writeToFile:[self dataFilePath] atomically:YES];
    
    if (bSuccess) {
        NSLog(@"Write to file successfully. dic=%@", dic);
    } else {
        NSLog(@"Write to file failed");
    }

    return bSuccess;
}

- (BOOL)loadDataFromFile
{
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        
        NSLog(@"LoadDatas!, Dic = %@", dic);
        
        NSDictionary *dict = [dic objectForKey:@"images"];
        
        if (dict != nil && [dict count] > 0) {
            [self setM_dictLocalImageCaches: [dic objectForKey:@"images"]];
        }
        
        return YES;
    }
    
    // if file is not exist, set default value
    //[self setServerAddress:[NSString stringWithString:@"http://develop.sweneno.com/index.php/"]];
    
    return NO;
}

- (NSString*)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"pushpic.plist"];
}

@end