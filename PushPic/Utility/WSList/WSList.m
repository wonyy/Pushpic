//
//  WSList.m
//  PushPic
//
//  Created by KPIteng on 8/8/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import "WSList.h"
#define WEBSERVICE_DOMAIN @"http://pushpic.com/ws/"

@implementation WSList

+ (NSString *)getSignUpLink:(NSString *)eFbStatus vName:(NSString *)vName vEmail:(NSString *)vEmail vPassword:(NSString *)vPassword vUserLat:(NSString *)vUserLat vUserLong:(NSString *)vUserLong vDeviceToken:(NSString *)vDeviceToken vFbID:(NSString *)vFbID {
    
    NSString *strReturnURL;
    
    if ([eFbStatus isEqualToString:@"Yes"]) {
        strReturnURL = [NSString stringWithFormat:@"%@index.php?c=user&func=add&vUserName=%@&vEmail=%@&eFbStatus=%@&vUserLat=%@&vUserLong=%@&vDeviceToken=%@&vFbID=%@", WEBSERVICE_DOMAIN, vName, vEmail, eFbStatus, vUserLat, vUserLong, vDeviceToken, vFbID];
    } else if([eFbStatus isEqualToString:@"No"]) {
        strReturnURL = [NSString stringWithFormat:@"%@index.php?c=user&func=add&vUserName=%@&vEmail=%@&vPassword=%@&eFbStatus=%@&vUserLat=%@&vUserLong=%@&vDeviceToken=%@", WEBSERVICE_DOMAIN, vName, vEmail, vPassword, eFbStatus, vUserLat, vUserLong, vDeviceToken];
    }
    
    return strReturnURL;
}

+ (NSString *)getSignInLink:(NSString *)FbStatus vEmail:(NSString *)vEmail vPassword:(NSString *)vPassword vUserLat:(NSString *)vUserLat vUserLong:(NSString *)vUserLong vDeviceToken:(NSString *)vDeviceToken vFbID:(NSString *)vFbID {
    
    NSString *strReturnURL;
    
    if ([FbStatus isEqualToString:@"Yes"]) {
        strReturnURL = [NSString stringWithFormat:@"%@index.php?c=login&func=check&vLoginID=%@&eFbStatus=%@&vUserLat=%@&vUserLong=%@&vDeviceToken=%@&vFbID=%@", WEBSERVICE_DOMAIN, vEmail, FbStatus,vUserLat, vUserLong, vDeviceToken, vFbID];
    } else if([FbStatus isEqualToString:@"No"]) {
        strReturnURL = [NSString stringWithFormat:@"%@index.php?c=login&func=check&vLoginID=%@&vPassword=%@&eFbStatus=%@&vUserLat=%@&vUserLong=%@&vDeviceToken=%@", WEBSERVICE_DOMAIN, vEmail, vPassword, FbStatus, vUserLat, vUserLong, vDeviceToken];
    }
    
    return strReturnURL;
}

+ (NSString *)getResetLink: (NSString *)vEmail {
    return [NSString stringWithFormat:@"%@index.php?c=user&func=ResetPassword&vEmail=%@", WEBSERVICE_DOMAIN, vEmail];
    ;
}


//www.openxcellaus.info/pushpic/ws/index.php?c=media&func=upload&iUserID=19&vMedialong=454&vMedialat=56454


+ (NSString *)getUploadMedia:(NSString *)iUserID vMedialat:(float)vMedialat vMedialong:(float)vMedialong strDur:(NSString *)strDur strDis:(NSString *)strDis vMediaCaption:(NSString *)vMediaCaption left: (float) x top: (float) y {
    
    NSString *strReturnURL;
    strReturnURL = [NSString stringWithFormat:@"%@index.php?c=media&func=upload&iUserID=%@&vMedialat=%f&vMedialong=%f&iMediaTime=%@&fMediaDistance=%@&vMediaCaption=%@&vMediaCaptionX=%f&vMediaCaptionY=%f", WEBSERVICE_DOMAIN, iUserID,vMedialat, vMedialong, strDur, strDis, vMediaCaption, x, y];
    return strReturnURL;
}

+ (NSString *)getNearesPost:(NSString *)strSortType limit:(int)limit {
    
    NSString *strReturnURL;
    
    strReturnURL = [NSString stringWithFormat:@"%@index.php?c=radius&func=GetData&iUserID=%@&vUserLat=%f&vUserLong=%f&SortOrder=%@&iLimit=%d", WEBSERVICE_DOMAIN, [[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] valueForKey:@"iUserID"], APPDEL.userLat, APPDEL.userLong, strSortType, limit];
    
    NSLog(@"%@",strReturnURL);
    
    return strReturnURL;
}


+ (NSString *)iMediaID:(NSString *)iMediaID LikeStatus:(NSString *)LikeStatus {
    NSString *strReturnURL;
    strReturnURL = [NSString stringWithFormat:@"%@index.php?c=like&func=likepost&iUserID=%@&iMediaID=%@&LikeStatus=%@", WEBSERVICE_DOMAIN, [[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] valueForKey:@"iUserID"], iMediaID, LikeStatus];
    return strReturnURL;
}


+ (NSString *)iMediaID:(NSString *)iMediaID FavStatus:(NSString *)FavStatus {
    NSString *strReturnURL;
    strReturnURL = [NSString stringWithFormat:@"%@index.php?c=favourite&func=favouritepost&iUserID=%@&iMediaID=%@&FavStatus=%@", WEBSERVICE_DOMAIN, [[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] valueForKey:@"iUserID"], iMediaID, FavStatus];
    return strReturnURL;
}

+ (NSString *)iMediaID:(NSString *)iMediaID tComment:(NSString *)tComment{
    NSString *strReturnURL;
    strReturnURL = [NSString stringWithFormat:@"%@index.php?c=comment&func=GetData&iUserID=%@&iMediaID=%@&tComment=%@", WEBSERVICE_DOMAIN, [[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] valueForKey:@"iUserID"], iMediaID, tComment];
    return strReturnURL;
}

+ (NSString *)getAllComment_iMediaID:(NSString *)iMediaID {
    NSString *strReturnURL;
    strReturnURL = [NSString stringWithFormat:@"%@index.php?c=comment&func=GetData&iUserID=%@&iMediaID=%@", WEBSERVICE_DOMAIN, [[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] valueForKey:@"iUserID"], iMediaID];
    return strReturnURL;
}

+ (NSString *)sendMessage:(NSString *)iReceiverID tMessage:(NSString *)tMessage iMediaID:(NSString *)iMediaID {
    NSString *strReturnURL;
    strReturnURL = [NSString stringWithFormat:@"%@index.php?c=message&func=send&iSenderID=%@&iRecieverID=%@&tMessage=%@&iMediaID=%@", WEBSERVICE_DOMAIN, [[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] valueForKey:@"iUserID"], iReceiverID, tMessage, iMediaID];
    return strReturnURL;
}

+ (NSString *)getMessage {
    NSString *strReturnURL;
    strReturnURL = [NSString stringWithFormat:@"%@index.php?c=message&func=GetMsg&iUserID=%@", WEBSERVICE_DOMAIN, [[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] valueForKey:@"iUserID"]];
    return strReturnURL;
}

+ (NSString *)getNotificationList {
   // http://pushpic.com/ws/index.php?c=login&func=CheckNotStatus&iUserID=82
    NSString *strReturnURL;
    strReturnURL = [NSString stringWithFormat:@"%@index.php?c=login&func=CheckNotStatus&iUserID=%@", WEBSERVICE_DOMAIN, [[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] valueForKey:@"iUserID"]];
    return strReturnURL;
}

+ (NSString *)getSettingInformation {
    NSString *strReturnURL;
    strReturnURL = [NSString stringWithFormat:@"%@index.php?c=settings&func=data&iUserID=%@", WEBSERVICE_DOMAIN, [[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] valueForKey:@"iUserID"]];
    return strReturnURL;
}


+ (NSString *)strGetPrivacy {
    NSString *strReturnURL;
    strReturnURL = [NSString stringWithFormat:@"%@index.php?c=content&func=privacy", WEBSERVICE_DOMAIN];
    return strReturnURL;
}

+ (NSString *)strGetTerms {
    NSString *strReturnURL;
    strReturnURL = [NSString stringWithFormat:@"%@index.php?c=content&func=terms", WEBSERVICE_DOMAIN];
    return strReturnURL;
}

+ (NSString *)strGetNotificationEnable {
    NSString *strReturnURL;
    strReturnURL = [NSString stringWithFormat:@"%@index.php?c=recnot&func=Recieved&iUserID=%@",WEBSERVICE_DOMAIN, [[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] valueForKey:@"iUserID"]];
    return strReturnURL;
}

+ (NSString *)strChangeUserName:(NSString *)strNewUserName{
    NSString *strReturnURL;
    strReturnURL = [NSString stringWithFormat:@"%@index.php?c=user&func=ChangeUsername&iUserID=%@&vUserName=%@", WEBSERVICE_DOMAIN, [[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] valueForKey:@"iUserID"], strNewUserName];
    return strReturnURL;
}

+ (NSString *)strChangePassword:(NSString *)strNewPassword strOldPassword:(NSString *)strOldPassword {
    NSString *strReturnURL;
    strReturnURL = [NSString stringWithFormat:@"%@index.php?c=user&func=ChangePass&iUserID=%@&vNewPass=%@&vPass=%@", WEBSERVICE_DOMAIN, [[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] valueForKey:@"iUserID"], strNewPassword, strOldPassword];
    return strReturnURL;
}

+ (NSString *)strCountUnreadMessage {
    //http://pushpic.com/ws/index.php?c=login&func=countUnread&iUserID=81
    NSString *strReturnURL;
    strReturnURL = [NSString stringWithFormat:@"%@index.php?c=login&func=countUnread&iUserID=%@",WEBSERVICE_DOMAIN, [[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] valueForKey:@"iUserID"]];
    return strReturnURL;
}

@end
