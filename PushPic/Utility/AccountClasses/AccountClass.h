//
//  AccountClass.h
//  PushPic
//
//  Created by KPIteng on 8/7/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface AccountClass : NSObject {
    
   NSDictionary *list;
}

+ (AccountClass *) AcccountShareClass;
- (void)getFacebookUsersList:(NSString *)tempStr completionHandler:(void (^) (NSMutableArray *))callBackBlock;
- (void)getTwitterUsersList:(NSString *)tempStr completionHandler:(void (^) (NSMutableArray *))callBackBlock;
- (void)getFriendList:(ACAccount*)facebookAccount completionHandler:(void (^) (NSMutableArray *))callBackBlock;
@end
