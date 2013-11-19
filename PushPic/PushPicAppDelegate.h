//
//  PushPicAppDelegate.h
//  PushPic
//
//  Created by KPIteng on 8/2/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MBProgressHUD.h"

@class PushPicViewController;
@class PreviewViewController;

@interface PushPicAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate, MBProgressHUDDelegate, UIAlertViewDelegate> {
    
    NSDictionary *dictUserDetails;
    CLLocationManager *locationMngr;
    double userLat,userLong;
    MBProgressHUD *HUD;
    CLLocation *myCurrentLocation;
    NSMutableArray *aryNotification;
    
    NSTimer *timer;
}

@property (strong, nonatomic) FBSession *session;
@property (strong, nonatomic) CLLocation *myCurrentLocation;
@property (strong, nonatomic) CLLocationManager *locationMngr;

@property (nonatomic, readwrite) double userLat, userLong;

@property (strong, nonatomic) NSDictionary *dictUserDetails;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) PreviewViewController *viewController;
@property (strong, nonatomic) NSMutableArray *aryNotification;
@property (strong, nonatomic) NSString *UDID;



+ (PushPicAppDelegate*)sharedInstance;

- (void)showWithoutGradient:(NSString *)str views:(UIView*)myView;
- (void)hideWithGradient;

@end
