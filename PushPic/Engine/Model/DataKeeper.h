//
//  DataKeeper.h
//  Cariloop
//
//  Created by Tan Hui on 08/22/13.
//  Copyright 2013 Satori Inc. All rights reserved.
//  

#import "SingletonClass.h"

@interface DataKeeper : SingletonClass {
    
    NSString    *m_strLastErrorMessage;
    
    NSMutableDictionary *m_dictLocalImageCaches;
}

@property (nonatomic, retain) NSString    *m_strLastErrorMessage;
@property (nonatomic, retain) NSMutableDictionary *m_dictLocalImageCaches;

- (UIImage *)getImage: (NSString *) strURL toSize:(CGSize)size;
- (UIImage *)getLocalImage: (NSString *) strURL;

- (BOOL)saveDataToFile;
- (BOOL)loadDataFromFile;
- (NSString*)dataFilePath;


- (void) CreateThreadDownloadImages;
- (void) DownloadImages;

@end
