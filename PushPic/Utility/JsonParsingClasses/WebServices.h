//
//  WebServices.h
//  demo
//
//  Created by Shivam on 6/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//


//Call Methods
 /*
 // NSString *strUrl = [NSString stringWithFormat:@"%@index.php?c=glossary&func=glossarylist",WEBSERVICE_DOMAIN]; 
  
#pragma Mark - Call WebService Syncronus
  
     //NSDictionary *dic = [WebServices urlString:strUrl];
     //NSDictionary *dic = [WebServices urlString:strUrl progressView:self.view];
     //NSDictionary *dic = [WebServices urlString:strUrl progressView:self.view Lable:@"Song Download"];
     //NSLog(@"-- Result %@",dic);

#pragma Mark - Call Web Service In BG(Asyncronous) With Handler
  
     //[WebServices urlStringInBG:strUrl completionHandler:^(NSDictionary *dicResult) {
     //NSLog(@"-- cal back %@",dicResult);
     //}];

#pragma Mark - Call Web Service In BG(Asyncronous) with delegate
  
    //[WebServices urlStringInBG:strUrl delegate:self];

*/



#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"


@protocol WebServicesDelegate <NSObject>

@optional
- (void)recievedResponse:(NSDictionary*)dicResult;
- (void)webServicesError:(NSError*)error;

@end


@interface WebServices : NSObject {
    MBProgressHUD *HUD; 
    NSString *strProcessLable;
    
    __weak id <WebServicesDelegate> delegate;
}

@property (nonatomic, weak) __weak id <WebServicesDelegate> delegate;
@property (nonatomic, strong) NSString *strProcessLable;

+ (NSDictionary *) urlString:(NSString*)strUrl progressView:(UIView*)view;
+ (NSDictionary *) urlString:(NSString*)strUrl progressView:(UIView*)view Lable:(NSString*)strLable;
+ (NSDictionary *) urlString:(NSString*)strUrl;

+ (void) urlStringInBG:(NSString*)strUrl delegate:(id)dele;
+ (void) urlStringInBG:(NSString*)strUrl completionHandler:(void (^)(NSDictionary*))callbackBlock;

@end
