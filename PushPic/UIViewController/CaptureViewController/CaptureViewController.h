//
//  CaptureViewController.h
//  PushPic
//
//  Created by KPIteng on 8/3/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  <AssetsLibrary/ALAssetRepresentation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "MyPushPicViewController.h"
#import "WSList.h"
#import "SettingsViewController.h"
#import "AppConstant.h"
#import "DownLoadManager.h"
#import "DIYCam.h"

typedef void(^SaveImageCompletion)(NSError* error);

@interface CaptureViewController : UIViewController <UITextFieldDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate, DIYCamDelegate, UIGestureRecognizerDelegate>
{
    UIButton *btnCapture, *btnVideo, *btnDistance, *btnDuration, *btnCross;
    UIButton *_flipButton, *_settingButton, *_viewMoreButton;
    IBOutlet UIButton *btnFlash;
    
    UIButton *btnCaption;
    
    UILabel *lblDistance;
    UILabel *lblDuration;
    UILabel *lblNotCount;
    __weak IBOutlet UILabel *lblCount;
    UILabel *lblCaption;

    
    UIImageView *focusImageView;
    UIImageView *imgViewNotification;
    UIImageView *imgViewLoadAnim;
    UIImageView *ivOverLay;
    __weak IBOutlet UIImageView *test;
    __weak IBOutlet UIImageView *imgViewLblBG;


    UITextField *tfMediaCaption;

    UIProgressView *progressBar;
    
    IBOutlet DIYCam *cam;
    
    UIView *viewCaption;
    UIView *viewBadge;
    
    UIPanGestureRecognizer * pan_gesture;

    CGPoint m_dragstart;
    CGPoint m_dragstartObject;

    NSTimer *timer;
    
    NSArray *aryDuration, *aryDistance, *aryDur, *aryDis;
    int durationIndex, distanceIndex;
    
    UILongPressGestureRecognizer *_longPressGestureRecognizer;
    UILongPressGestureRecognizer *longPressGesture;
    
    NSURLConnection *ConnectionRequest;
    NSURL *assetPhotoURL;

    ALAssetsLibrary *_assetLibrary;
    
    NSMutableData *_responseData;
    NSData *dataUploadedImage;
    NSDictionary *uploadDataDictionary;
    
    MyPushPicViewController *objMyPushPicViewController;

    BOOL capturePhoto;
    BOOL isUploading;
    BOOL bFirstLoad;
}

@property (strong, nonatomic) MPMoviePlayerController *mplayer;
@property (strong, nonatomic) IBOutlet DIYCam *cam;
@property (strong, nonatomic) UIImageView *focusImageView;
@property (strong, nonatomic) IBOutlet UIButton *btnMediaThumb;


- (void)UploadMedia:(NSData *)mediaData;

- (IBAction)btnFlashTapped:(id)sender;

@end
