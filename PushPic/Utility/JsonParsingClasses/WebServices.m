//
//  WebServices.m
//  demo
//
//  Created by Shivam on 6/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#define ALERT(TITLE,MSG) {  [[[UIAlertView alloc] initWithTitle:TITLE message:MSG delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show]; }

#import "WebServices.h"



@implementation WebServices

@synthesize strProcessLable;
@synthesize delegate;

-(void)showProgressBar:(UIView*)view
{    
    HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.dimBackground = YES;   
    //[HUD setLable:strProcessLable];
    [HUD show:TRUE]; 
}

-(void)hideWithGradient
{
    [HUD hide:TRUE];
    [HUD removeFromSuperview];
}


+(NSDictionary *) urlString:(NSString*)strUrl progressView:(UIView*)view
{ 
    
    return  [WebServices urlString:strUrl progressView:view Lable:@"Loading..."];    
}


+(NSDictionary *) urlString:(NSString*)strUrl progressView:(UIView*)view Lable:(NSString*)strLable
{ 
    
    WebServices *webServoceObj = [[WebServices alloc] init];
    webServoceObj.strProcessLable =strLable;
    [webServoceObj performSelectorInBackground:@selector(showProgressBar:) withObject:view];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    [webServoceObj hideWithGradient]; 
    
    NSError *error;
    NSDictionary *dicResult;
    @try {
        dicResult= [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&error];
    }
    @catch (NSException *exception) {
        ALERT(APPNAME, @"Error Occured! Please check internet connection.");
    }     
    return dicResult;    
}

+ (NSDictionary *) urlString:(NSString*)strUrl
{   
   
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    
    
    NSError *error;
    NSDictionary *dicResult;
    @try {
        dicResult = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&error];
    }
    @catch (NSException *exception) {
        ALERT(APPNAME, @"Error Occured! Please check internet connection.");
    }     
    return dicResult;    
}

+ (void) urlStringInBG:(NSString*)strUrl delegate:(id)dele
{    
    WebServices *webServoceObj = [[WebServices alloc] init];
    webServoceObj.delegate = dele;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
      
                                         timeoutInterval:60.0];    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *err) {
        
        NSError *error;
        NSDictionary *dicResult;
        @try {
            dicResult = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
            
            if ([webServoceObj.delegate respondsToSelector:@selector(recievedResponse:)]) {
                [webServoceObj.delegate performSelector:@selector(recievedResponse:) withObject:dicResult];
            }
        }
        @catch (NSException *exception) {
            ALERT(APPNAME, @"Error Occured! Please check internet connection.");         
            
            if ([webServoceObj.delegate respondsToSelector:@selector(webServicesError:)])
            {
                [webServoceObj.delegate performSelector:@selector(webServicesError:) withObject:err];
            }
        }          
        
    }];
    
    //return dicResult;    
}


+ (void) urlStringInBG:(NSString*)strUrl completionHandler:(void (^)(NSDictionary*))callbackBlock
{ 
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                             
                                         timeoutInterval:60.0];    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *err) {
        
        NSError *error;
        NSDictionary *dicResult;
        @try {
            
            dicResult = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
            
            if (callbackBlock != nil) {
                callbackBlock(dicResult);
            }
            
        }
        @catch (NSException *exception) {
            ALERT(APPNAME, @"Error Occured! Please check internet connection.");
        }          
        
    }];
    
    //return dicResult;    
}






@end
