//
//  DownLoadManager.h
//  DownlodCell
//
//  Created by openxcell on 8/1/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoadManager : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSString *strUrl;
@property (nonatomic, strong) UIProgressView *progressViewActive;
@property (nonatomic, strong) NSMutableURLRequest *postRequest;
@property (nonatomic, copy) void (^completionHandler)(NSData*);
-(id)initWithURL:(NSMutableURLRequest*)postReqst progressBar:(UIProgressView*)progressView;

- (void)startDownload;
- (void)cancelDownload;

@end
