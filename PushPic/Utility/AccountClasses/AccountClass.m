//
//  AccountClass.m
//  PushPic
//
//  Created by KPIteng on 8/7/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import "AccountClass.h"

@implementation AccountClass

static AccountClass *sharedInstance;
static ACAccountStore *accountStore;
static NSMutableArray *aryAccounts;

+ (AccountClass *)AcccountShareClass{
    
    if (sharedInstance == nil) {
        sharedInstance = [[AccountClass alloc] init];
        accountStore = [[ACAccountStore alloc] init];
        aryAccounts = [[NSMutableArray alloc] init];
    }
    return sharedInstance;

}

- (void)getFacebookUsersList:(NSString *)tempStr completionHandler:(void (^)(NSMutableArray *))callBackBlock {
    NSDictionary *options = @{
                              @"ACFacebookAppIdKey" : @"646005418776832", //@"646005418776832", // @"542050529187192"
                              @"ACFacebookPermissionsKey" : @[@"email"],
                              @"ACFacebookAudienceKey" : ACFacebookAudienceEveryone};//ACFacebookAudienceFriends//
                            //publish_stream,
    
    ACAccountType *accountTypeFacebook = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    [accountStore requestAccessToAccountsWithType:accountTypeFacebook options:options completion:^(BOOL granted, NSError *error) {
       // NSLog(@"%@",error);
        if (granted) {
            aryAccounts = [NSMutableArray arrayWithArray:[accountStore accountsWithAccountType:accountTypeFacebook]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                callBackBlock(aryAccounts);
            });
        }
        else{
            callBackBlock(aryAccounts);
        }
    }];
}

- (void)getTwitterUsersList:(NSString *)tempStr completionHandler:(void (^)(NSMutableArray *))callBackBlock{
    ACAccountType *accountTypeTwitter = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountTypeTwitter options:nil completion:^(BOOL granted, NSError *error) {
        if(granted) {
            aryAccounts = [NSMutableArray arrayWithArray:[accountStore accountsWithAccountType:accountTypeTwitter]];
            dispatch_sync(dispatch_get_main_queue(), ^{

                callBackBlock(aryAccounts);
            });
        }
    }];
}


- (void)getFriendList:(ACAccount*)facebookAccount completionHandler:(void (^) (NSMutableArray *))callBackBlock{
    
    NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/me/friends"];
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:requestURL
                                               parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"picture,id,name,link,gender,last_name,first_name,email",@"fields",nil]];
    request.account = facebookAccount;
    
    [request performRequestWithHandler:^(NSData *data,
                                         NSHTTPURLResponse *response,
                                         NSError *error) {
        
        if (!error) {
            
            list = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if ([list objectForKey:@"error"] != nil) {
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableArray *aryFriendList = [[NSMutableArray alloc]initWithArray:[list valueForKey:@"data"]];
                callBackBlock(aryFriendList);
            });
        } else {
           // NSLog(@"error from get%@",error);
        }
        
    }];

}

@end
