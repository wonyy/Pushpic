//
//  WSList.h
//  PushPic
//
//  Created by ; on 8/8/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSList : NSObject{
    
    
}
+ (NSString *)getSignUpLink:(NSString *)eFbStatus vName:(NSString *)vName vEmail:(NSString *)vEmail vPassword:(NSString *)vPassword vUserLat:(NSString *)vUserLat vUserLong:(NSString *)vUserLong vDeviceToken:(NSString *)vDeviceToken vFbID:(NSString *)vFbID;
+ (NSString *)getSignInLink:(NSString *)FbStatus vEmail:(NSString *)vEmail vPassword:(NSString *)vPassword vUserLat:(NSString *)vUserLat vUserLong:(NSString *)vUserLong vDeviceToken:(NSString *)vDeviceToken vFbID:(NSString *)vFbID;

+ (NSString *)getResetLink: (NSString *)vEmail;

+ (NSString *)getUploadMedia:(NSString *)iUserID vMedialat:(float)vMedialat vMedialong:(float)vMedialong strDur:(NSString *)strDur strDis:(NSString *)strDis vMediaCaption:(NSString *)vMediaCaption left: (float) x top: (float) y;
+ (NSString *)getNearesPost:(NSString *)strSortType limit:(int)limit;
+ (NSString *)iMediaID:(NSString *)iMediaID LikeStatus:(NSString *)LikeStatus;
+ (NSString *)iMediaID:(NSString *)iMediaID FavStatus:(NSString *)FavStatus;
+ (NSString *)iMediaID:(NSString *)iMediaID tComment:(NSString *)tComment;
+ (NSString *)getAllComment_iMediaID:(NSString *)iMediaID;
+ (NSString *)sendMessage:(NSString *)iReceiverID tMessage:(NSString *)tMessage iMediaID:(NSString *)iMediaID;
+ (NSString *)getMessage;
+ (NSString *)getSettingInformation;
+ (NSString *)strGetPrivacy;
+ (NSString *)strGetTerms;
+ (NSString *)strGetNotificationEnable;
+ (NSString *)getNotificationList;
+ (NSString *)strChangeUserName:(NSString *)strNewUserName;
+ (NSString *)strChangePassword:(NSString *)strNewPassword strOldPassword:(NSString *)strOldPassword;
+ (NSString *)strCountUnreadMessage;
@end
