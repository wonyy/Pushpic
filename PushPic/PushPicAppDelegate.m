//
//  PushPicAppDelegate.m
//  PushPic
//
//  Created by KPIteng on 8/2/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import "PushPicAppDelegate.h"
#import "PushPicViewController.h"
#import "PreviewViewController.h"
#import "DataKeeper.h"

#import "Flurry.h"
#import "Appirater.h"

@implementation PushPicAppDelegate
@synthesize dictUserDetails;
@synthesize locationMngr;
@synthesize userLat,userLong;
@synthesize myCurrentLocation;
@synthesize aryNotification;
@synthesize UDID;
@synthesize session = _session;

static PushPicAppDelegate *appDEL;

+ (PushPicAppDelegate*)sharedInstance {
    
    if (appDEL != nil) {
        return appDEL;
    } else {
        appDEL = (PushPicAppDelegate *)[[UIApplication sharedApplication]delegate];
    }
    
    return appDEL;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    [dataKeeper loadDataFromFile];

    
    [Flurry startSession:@"JQJBRMF7QQYRTZG3V2RX"];
    [Flurry logEvent:@"App Started"];
    
    [Appirater setAppId:@"672083051"];
    [Appirater setUsesUntilPrompt:6];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setDebug:YES];

    
    //Temporory For testing on simulator
    NSString *model = [[UIDevice currentDevice] model];
    if (![model isEqualToString:@"iPhone Simulator"] && ![model isEqualToString:@"iPad Simulator"]) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeNewsstandContentAvailability];
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
//    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    
 //   self.facebook = [[Facebook alloc] initWithAppId:FBAppId andDelegate:Nil];
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[PreviewViewController alloc] initWithNibName:@"PreviewViewController" bundle:nil];
    } else {
        self.viewController = [[PreviewViewController alloc] initWithNibName:@"PreviewViewController" bundle:nil];
    }
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    self.window.rootViewController = self.navController;
    
    [self.navController setNavigationBarHidden: YES];
    [self.navController setToolbarHidden: YES];

    [self.window makeKeyAndVisible];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL]){
        dictUserDetails = (NSDictionary *)[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL];
    }
    
    APPDEL.aryNotification = [[NSMutableArray alloc] init];
   // [WebServices urlStringInBG:[WSList getMessage] completionHandler:^(NSDictionary *dictMsg) {
       // APPDEL.aryNotification = [[dictMsg valueForKey:@"MESSAGE_DETAIL"] mutableCopy];
       // NSLog(@"%@",APPDEL.aryNotification);
    //}];
    
    locationMngr = [[CLLocationManager alloc] init];
    [locationMngr setDelegate:self];
    locationMngr.distanceFilter = kCLDistanceFilterNone;
    locationMngr.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationMngr startUpdatingLocation];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
   // NSLog(@"%@",url);
  //  return [facebook handleOpenURL:url];
    return [self.session handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSession.activeSession handleDidBecomeActive];

   
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self.session close];

}

/*
#pragma mark - FB
- (void)fbDidLogin {
     [defaults setObject: [self.session accessTokenData].accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject: [self.session accessTokenData].expirationDate forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)fbDidLogout {
    // NSLog(@"fbDidLogout");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    
}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt {
    
}

- (void)fbSessionInvalidated {
    
}
 
 */

#pragma mark - Pushpic Notification Delegate Methods
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *token = [[[[deviceToken description]
                         stringByReplacingOccurrencesOfString: @"<" withString: @""]
                        stringByReplacingOccurrencesOfString: @">" withString: @""]
                       stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"deviceToken: %@", token);
    UDID = token;
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"DEVICETOKEN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    if (error) {
        NSLog(@"%@",[error description]);
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [alert show];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
   //NSLog(@"-- %@",userInfo);
    if ([[userInfo valueForKey:@"MsgType"] isEqualToString:@"MediaUpload"]) {
        
        UIAlertView *alertUseThis = [[UIAlertView alloc] initWithTitle:APPNAME message:[NSString stringWithFormat:@"%@", [[userInfo valueForKey:@"aps"] valueForKey:@"alert"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertUseThis setTag:786];
        [alertUseThis show];
    } else {
        UIAlertView *alertUseThis = [[UIAlertView alloc] initWithTitle:APPNAME message:[NSString stringWithFormat:@"%@", [[userInfo valueForKey:@"aps"] valueForKey:@"alert"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertUseThis show];
    }
    
}


#pragma mark - CLLocation Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"update location (%f, %f)", userLat, userLong);

    myCurrentLocation = [locations objectAtIndex:0];
    userLat = myCurrentLocation.coordinate.latitude;
    userLong = myCurrentLocation.coordinate.longitude;
    
    [locationMngr stopUpdatingLocation];

    timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(_turnOnLocationManager)  userInfo:nil repeats:NO];

}

- (void)_turnOnLocationManager {
    [locationMngr startUpdatingLocation];
}


#pragma mark - MBProgress
- (void)showWithoutGradient:(NSString *)str views:(UIView*)myView {
    HUD = [[MBProgressHUD alloc] initWithView:myView];
    
    MBPushPicProgressView* pushPicLoadingView = [[MBPushPicProgressView alloc] init];
    [HUD setMode: MBProgressHUDModeCustomView];
    [HUD setCustomView: pushPicLoadingView];
    [myView addSubview:HUD];
    HUD.dimBackground = YES;
    HUD.delegate = self;
    if (str.length > 0) {
        [HUD setLabelText:str];
    }
    [HUD show:TRUE];
}

- (void)hideWithGradient {
    [HUD hide:TRUE];
    [HUD removeFromSuperview];
}

#pragma mark - UIAlertView Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 786) {
        
        if (buttonIndex == alertView.cancelButtonIndex) {
            
            [WebServices urlStringInBG:[WSList strGetNotificationEnable] completionHandler:^(NSDictionary *dictResponse) {
                    //UIAlertView *alertUseThis = [[UIAlertView alloc]initWithTitle:APPNAME message:@"Now you get all notification" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    //[alertUseThis show];
            }];
        }
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
}
@end
