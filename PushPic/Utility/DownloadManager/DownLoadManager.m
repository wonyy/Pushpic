//
//  DownLoadManager.m
//  DownlodCell
//
//  Created by openxcell on 8/1/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import "DownLoadManager.h"

@interface DownLoadManager()

@property (nonatomic) double expectedDataLenth;
@property (nonatomic, strong) NSURL *activeURL;
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;

@end

@implementation DownLoadManager
@synthesize strUrl;
@synthesize progressViewActive;
@synthesize postRequest;

-(id)initWithURL:(NSMutableURLRequest*)postReqst progressBar:(UIProgressView*)progressView
{
    self = [super init];
    if(self)
    {
        self.postRequest = postReqst;
        progressViewActive = progressView;
        
    }
    return self;
}

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:self.postRequest delegate:self];
    
    self.imageConnection = conn;
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

#pragma mark - NSURLConnectionDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _expectedDataLenth = (double)[response expectedContentLength];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
    
    //NSLog(@"Connection Current  size: %f", (double)[self.activeDownload length]);
   // NSLog(@"%f",(double)[self.activeDownload length]/_expectedDataLenth);
    progressViewActive.progress = (double)[self.activeDownload length]/_expectedDataLenth;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // call our delegate and tell it that our icon is ready for display
    if (self.completionHandler)
        self.completionHandler(self.activeDownload);
    
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{

}

/*
– connection:didWriteData:totalBytesWritten:expectedTotalBytes:
– connectionDidResumeDownloading:totalBytesWritten:expectedTotalBytes:
– connectionDidFinishDownloading:destinationURL:
 */

@end
