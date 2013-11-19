//
//  CaptureViewController.m
//  PushPic
//
//  Created by KPIteng on 8/3/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import "CaptureViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Flurry.h"
#import "EGOCache.h"
#import "EGOImageLoader.h"

@interface CaptureViewController ()

@end

@implementation CaptureViewController

@synthesize cam, focusImageView;
@synthesize mplayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _assetLibrary = [[ALAssetsLibrary alloc] init];
        [self _setup];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
        
    aryDistance = [NSArray arrayWithObjects:@"250   FT", @"1000 FT", @"1/2 MILE", @"1     MILE", @"3    MILES", nil];
    aryDuration = [NSArray arrayWithObjects:@"1        HR", @"1     DAY", @"3   DAYS", @"7   DAYS", nil];
    aryDis = [NSArray arrayWithObjects:@"75", @"300", @"800", @"1609", @"4828", nil];
    aryDur = [NSArray arrayWithObjects:@"1", @"24", @"72", @"168", nil];

    durationIndex = 0;
    distanceIndex = 0;
    [Flurry logEvent:@"Capture Class"];
    

    
    /*
    longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureTapped:)];
    longPressGesture.minimumPressDuration = 2.0;
    longPressGesture.delegate = self;
    [self.view addGestureRecognizer:longPressGesture];
     */
    
    capturePhoto = YES;
    ivOverLay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PlayVideoImage@2x"]];
    [ivOverLay setContentMode:UIViewContentModeScaleToFill];
    [ivOverLay setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    [self.view addSubview:ivOverLay];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUnreadMsgCount) name:@"showUnreadMsgCount" object:nil];
    [self postCountNotification];
    
    [self.cam startSession];
    
    bFirstLoad = YES;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];

    
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:NOTIFICATION_COUNT];
    
    if (str != nil && [str integerValue] > 0 && capturePhoto) {
        lblNotCount.text = str;
        [self showBadge];
    } else {
        [self hideBadge];
    }
    
    if (bFirstLoad == YES) {
        
        [self.cam setCamMode: [self.cam getCamMode]];
    }
   }

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.view bringSubviewToFront:self.focusImageView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if (bFirstLoad == YES) {
      //  [self.cam setCamMode: [self.cam getCamMode]];
     
        if (objMyPushPicViewController == nil) {
            objMyPushPicViewController = [[MyPushPicViewController alloc] initWithNibName:@"MyPushPicViewController" bundle:nil];
        }
        
        [self.navigationController pushViewController:objMyPushPicViewController animated:NO];
        
        bFirstLoad = NO;
    }

    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [self.cam stopSession];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_setup
{
    self.view.backgroundColor = [UIColor blackColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Tap to focus indicator
    // -------------------------------------
    UIImage *defaultImage   = [UIImage imageNamed:@"focus_indicator@2x.png"];
    focusImageView         = [[UIImageView alloc] initWithImage:defaultImage];
    self.focusImageView.frame   = CGRectMake(0, 0, defaultImage.size.width, defaultImage.size.height);
    self.focusImageView.hidden = YES;
    [self.view addSubview:self.focusImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusAtTap:)];
    tap.delegate = self;
    tap.cancelsTouchesInView = false;
    [self.cam addGestureRecognizer:tap];
    
    // Thumb button
    _btnMediaThumb = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnMediaThumb setFrame:self.view.bounds];
    [_btnMediaThumb setImage: [UIImage imageNamed:@"playIcon"] forState:UIControlStateNormal];
    [_btnMediaThumb setImage: [UIImage imageNamed:@"emptyimage@2x"] forState:UIControlStateSelected];
    [_btnMediaThumb setTitleColor: [UIColor clearColor] forState:UIControlStateNormal];
    [_btnMediaThumb setHidden: YES];
    [_btnMediaThumb addTarget:self action:@selector(btnMediaThumbTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: _btnMediaThumb];

    // Add ProgressBar
    progressBar = [[UIProgressView alloc] init];
    [progressBar setFrame:CGRectMake(0, -7, 320, 7)];
    [progressBar setProgressImage:[[UIImage imageNamed:@"progressImage@2x"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)]];
    [progressBar setTrackImage:[[UIImage imageNamed:@"trackImage@2x"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)]];
    [self.view addSubview:progressBar];
    
    //Gesture
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    _longPressGestureRecognizer.delegate = self;
    _longPressGestureRecognizer.minimumPressDuration = 1.0f;
    _longPressGestureRecognizer.allowableMovement = 10.0f;
    [_longPressGestureRecognizer addTarget:self action:@selector(_handleLongPressGestureRecognizer:)];
    
    
    // Capture Button
    btnCapture = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCapture.frame = CGRectMake(121, [UIScreen mainScreen].bounds.size.height - 20 - 78, 78, 78);
    [btnCapture setImage:[UIImage imageNamed:@"photoGreen@2x"] forState:UIControlStateNormal];
    [btnCapture setImage:[UIImage imageNamed:@"pushGreen@2x"] forState:UIControlStateSelected];
    [btnCapture addTarget:self  action:@selector(btnStarStopCapturePressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnCapture addGestureRecognizer:_longPressGestureRecognizer];
    [self.view addSubview:btnCapture];
    
    // Video Button
    btnVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    btnVideo.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 12 - 60, [UIScreen mainScreen].bounds.size.height - 20 - 60, 60, 60);
    [btnVideo setImage:[UIImage imageNamed:@"videobtn@2x"] forState:UIControlStateNormal];
    [btnVideo setImage:[UIImage imageNamed:@"videobtn_sel@2x"] forState:UIControlStateSelected];
    [btnVideo addTarget:self  action:@selector(btnStarStopVideoPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnVideo setHidden: YES];
  //  [btnVideo addGestureRecognizer:_longPressGestureRecognizer];
    [self.view addSubview:btnVideo];
    
    
    //Animation Load
    NSMutableArray *aryLoadingImg = [[NSMutableArray alloc] initWithCapacity:8];
    for (int i = 0; i < 4; i++) {
        [aryLoadingImg addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading%d.png", i]]];
    }
    
    imgViewLoadAnim = [[UIImageView alloc] initWithFrame:btnCapture.frame];
    [imgViewLoadAnim setAnimationImages:[NSArray arrayWithArray:aryLoadingImg]];
    [imgViewLoadAnim setAnimationDuration:1.0];
    [imgViewLoadAnim setAnimationRepeatCount:9999];
    // [imgViewLoadAnim startAnimating];
    [self.view addSubview:imgViewLoadAnim];
    imgViewLoadAnim.hidden = YES;
    
    
    // flip button
    _flipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_flipButton setImage:[UIImage imageNamed:@"frontcam@2x"] forState:UIControlStateNormal];
    [_flipButton setImage:[UIImage imageNamed:@"backcam@2x"] forState:UIControlStateSelected];
    
    CGRect flipFrame = _flipButton.frame;
    flipFrame.size = CGSizeMake(33.0f, 33.0f);
    flipFrame.origin = CGPointMake([UIScreen mainScreen].bounds.size.width - 12 - 33, 12 + 20);
    _flipButton.frame = flipFrame;
    [_flipButton addTarget:self action:@selector(_handleFlipButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_flipButton];
    
//    [_btnMediaThumb setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width / 2) - 24, ([UIScreen mainScreen].bounds.size.height / 2) - 26, 47, 52)];
    
    _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_settingButton setImage:[UIImage imageNamed:@"settings@2x"] forState:UIControlStateNormal];
    flipFrame = _flipButton.frame;
    flipFrame.size = CGSizeMake(60.0f, 60.0f);
    flipFrame.origin = CGPointMake(10, [UIScreen mainScreen].bounds.size.height - 20 - 60);
    _settingButton.frame = flipFrame;
    [_settingButton addTarget:self action:@selector(_handleSettingButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_settingButton];
    
    _viewMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_viewMoreButton setImage:[UIImage imageNamed:@"loadOther@2x"] forState:UIControlStateNormal];
    [_viewMoreButton addTarget:self action:@selector(_viewMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    [_viewMoreButton setFrame: CGRectMake([UIScreen mainScreen].bounds.size.width - 12 - 60, [UIScreen mainScreen].bounds.size.height - 20 - 60, 60.0f, 60.0f)];
    [self.view addSubview:_viewMoreButton];
    
    viewBadge = [[UIView alloc] initWithFrame: CGRectMake(_viewMoreButton.frame.origin.x + 15, _viewMoreButton.frame.origin.y - 26 , 60.0f, 60.0f)];
    
    imgViewNotification = [[UIImageView alloc] initWithFrame: viewBadge.bounds];
    imgViewNotification.image = [UIImage imageNamed:@"notification.png"];
    [viewBadge addSubview:imgViewNotification];

    lblNotCount = [[UILabel alloc] initWithFrame:CGRectMake(viewBadge.bounds.origin.x, viewBadge.bounds.origin.y - 2 , viewBadge.bounds.size.width, viewBadge.bounds.size.height)];
    
    lblNotCount.backgroundColor = [UIColor clearColor];
    lblNotCount.font = [UIFont systemFontOfSize:20];
    lblNotCount.textAlignment = NSTextAlignmentCenter;
    lblNotCount.textColor = [UIColor whiteColor];    
    [viewBadge addSubview:lblNotCount];
    
    lblNotCount.hidden = YES;
    
    [self.view addSubview: viewBadge];
   // if([[[NSUserDefaults standardUserDefaults] valueForKey:NOTIFICATION_COUNT] integerValue]>0)
    //{
        //lblNotCount.hidden = NO;
    //}
    
    // Distance Button
    btnDistance = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDistance setImage:[UIImage imageNamed:@"blankGreenCircle@2x"] forState:UIControlStateNormal];
    [btnDistance addTarget:self action:@selector(_btnDistanceTapped:) forControlEvents:UIControlEventTouchUpInside];
    [btnDistance setFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height - 20 - 60, 60, 60)];
    [btnDistance setHidden: YES];
    [self.view addSubview:btnDistance];
    
    // UILabel Distance
    lblDistance = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 50, 60)];
    lblDistance.font = MyriadPro_Bold_15;
    lblDistance.text = @"250   FT";
    lblDistance.numberOfLines = 2;
    [lblDistance setTextAlignment:NSTextAlignmentCenter];
    [lblDistance setTextColor:[UIColor whiteColor]];
    [lblDistance setBackgroundColor:[UIColor clearColor]];
    lblDistance.lineBreakMode = NSLineBreakByWordWrapping;
    [btnDistance addSubview:lblDistance];

    // Time Button
    btnDuration = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDuration setImage:[UIImage imageNamed:@"blankGreenCircle@2x"] forState:UIControlStateNormal];
    [btnDuration addTarget:self action:@selector(_btnDurationTapped:) forControlEvents:UIControlEventTouchUpInside];
    [btnDuration setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 12 - 60, [UIScreen mainScreen].bounds.size.height - 20 - 60, 60.0f, 60.0f)];
    [btnDuration setHidden: YES];
    [self.view addSubview:btnDuration];
    
    
    // UILabel Distance
    lblDuration = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 50.0f, 60.0f)];
    lblDuration.font = MyriadPro_Bold_15;
    lblDuration.text = @"1        HR";
    lblDuration.numberOfLines = 2;
    [lblDuration setTextAlignment:NSTextAlignmentCenter];
    [lblDuration setTextColor: [UIColor whiteColor]];
    [lblDuration setBackgroundColor: [UIColor clearColor]];
    lblDuration.lineBreakMode = NSLineBreakByWordWrapping;
    [btnDuration addSubview:lblDuration];
    
    [self.view bringSubviewToFront:_viewMoreButton];
    [self.view bringSubviewToFront:_settingButton];
    [self.view bringSubviewToFront: viewBadge];
    
    //viewCapture
    //UITextField MediaCaption
    viewCaption = [[UIView alloc] initWithFrame:CGRectMake(150, 10 + 20, 150, 50)];
    [viewCaption setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *imgBackCapture = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"captionback.png"]];
    
    [imgBackCapture setFrame:CGRectMake(13, 7, 137, 43)];
    
    UIButton *btnCloseCapture = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 24)];
    [btnCloseCapture setImage:[UIImage imageNamed:@"captionclose"] forState:UIControlStateNormal];
    
    [btnCloseCapture addTarget:self action:@selector(onTouchCloseCaptionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewCaption addSubview: imgBackCapture];
    [viewCaption addSubview: btnCloseCapture];
    
    pan_gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(OnDrag:)];
    pan_gesture.maximumNumberOfTouches = 1;
    
    [viewCaption addGestureRecognizer:pan_gesture];
    
    [viewCaption setHidden: YES];
    
    tfMediaCaption = [[UITextField alloc] initWithFrame:CGRectMake(15, 12, 135, 40)];
    [tfMediaCaption setFont:MyriadPro_Regular_13];
    [tfMediaCaption setTextColor:[UIColor blackColor]];
    [tfMediaCaption setPlaceholder:@""];
    [tfMediaCaption setTextAlignment:NSTextAlignmentCenter];
    [tfMediaCaption setDelegate:self];
    [tfMediaCaption setBorderStyle:UITextBorderStyleNone];
    [tfMediaCaption setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [tfMediaCaption setBackgroundColor: [UIColor clearColor]];
    [tfMediaCaption setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    tfMediaCaption.text = @"";
    [viewCaption addSubview:tfMediaCaption];
    
    btnCaption = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    
    [btnCaption addTarget:self action:@selector(onTouchCaptionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    lblCaption = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 130, 40)];
    [lblCaption setTextAlignment: NSTextAlignmentCenter];
    [lblCaption setNumberOfLines: 2];
    [lblCaption setFont:MyriadPro_Regular_13];
    [lblCaption setText:@"Tap to add a caption. Drag to Move."];
    
    [viewCaption addSubview: lblCaption];
    [viewCaption addSubview: btnCaption];
    
    [self.view addSubview: viewCaption];

    btnCross = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCross setImage:[UIImage imageNamed:@"cross@2x"] forState:UIControlStateNormal];
    [btnCross addTarget:self action:@selector(_btnCrossTapped:) forControlEvents:UIControlEventTouchUpInside];
    [btnCross setFrame:CGRectMake(10, 10 + 20, 38.0f, 38.0f)];
    [btnCross setHidden: YES];
    [self.view addSubview:btnCross];
    
    
    
    lblCount.hidden = YES;
    imgViewLblBG.hidden = YES;


    // Setup cam
    self.cam.delegate       = self;
    
    NSString *strCameraPos = (NSString *)[[NSUserDefaults standardUserDefaults] valueForKey:CAMERAPOS];
    
    AVCaptureDevicePosition nPosition = AVCaptureDevicePositionUnspecified;
    
    if ([strCameraPos isEqualToString:@"FRONT"]) {
        [_flipButton setSelected: YES];
        nPosition = AVCaptureDevicePositionFront;
    } else {
        [_flipButton setSelected: NO];
        nPosition = AVCaptureDevicePositionBack;
    }

    
    NSDictionary *options;
    options          = @{ DIYAVSettingFlash              : @true,
                          DIYAVSettingOrientationForce   : @true,
                          DIYAVSettingOrientationDefault : [NSNumber numberWithInt:AVCaptureVideoOrientationPortrait],
                          DIYAVSettingCameraPosition     : [NSNumber numberWithInt:nPosition],
                          DIYAVSettingCameraHighISO      : @true,
                          DIYAVSettingPhotoPreset        : AVCaptureSessionPresetHigh,
                          DIYAVSettingPhotoGravity       : AVLayerVideoGravityResizeAspectFill,
                          DIYAVSettingVideoPreset        : AVCaptureSessionPreset640x480,
                          DIYAVSettingVideoGravity       : AVLayerVideoGravityResizeAspectFill,
                          DIYAVSettingVideoMaxDuration   : @300,
                          DIYAVSettingVideoFPS           : @30,
                          DIYAVSettingSaveLibrary        : @false };
    
    [cam setupWithOptions:options]; // Check DIYAV.h for options
    [self.cam setCamMode: DIYAVModePhoto];
    [self.cam setFlash: NO];
    
    [btnFlash setSelected: YES];
    [self.view bringSubviewToFront:btnFlash];
    
}

- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size
{
    float width = size.width;
    float height = size.height;
    
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio < heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    if (width > rect.size.width) {
        rect.origin.x = - ((width - rect.size.width) / 2);
    }
    
    if (height > rect.size.height) {
        rect.origin.y = - ((height - rect.size.height) / 2);
    }
    
    rect.size.width  = width;
    rect.size.height = height;
    
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return smallImage;
}


#pragma mark - Camera Delegate Methods
#pragma mark  DIYCamDelegate

- (void)camReady:(DIYCam *)cam
{
    NSLog(@"Ready");
}

- (void)camDidFail:(DIYCam *)cam withError:(NSError *)error
{
    NSLog(@"Fail");
}

- (void)camModeWillChange:(DIYCam *)cam mode:(DIYAVMode)mode
{
    NSLog(@"Mode will change");
}

- (void)camModeDidChange:(DIYCam *)cam mode:(DIYAVMode)mode
{
   // NSLog(@"Mode did change");
}

- (void)camCaptureStarted:(DIYCam *)cam {
   // NSLog(@"Capture started");
}

- (void)camCaptureStopped:(DIYCam *)cam {
    //NSLog(@"Capture stopped");
}

- (void)camCaptureProcessing:(DIYCam *)cam {
    //NSLog(@"Capture processing");
}

- (void)camCaptureComplete:(DIYCam *)cam withAsset:(NSDictionary *)asset {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIImage *img = nil;
        
        if ([[asset valueForKey:@"type"] isEqualToString:@"video"]){
            NSData *videoData = [NSData dataWithContentsOfURL:[asset valueForKey:@"path"]];
            NSLog(@"%d", [videoData length]);
            NSData *thumbData = [NSData dataWithContentsOfURL:[asset valueForKey:@"thumb"]];
            NSLog(@"%d", [thumbData length]);
        
            if (capturePhoto == NO) {
                img = [UIImage imageWithData: thumbData];
                img = [self rotateUIImage:img angleDegress:90];
                [test setImage: [self resizeImage:img toSize:test.frame.size]];
                
                [self playCurrentVideo: [asset valueForKey:@"path"]];
                
                [_btnMediaThumb setHidden: NO];
            }
        } else {
            img  = [UIImage imageWithData: [NSData dataWithContentsOfURL: [asset valueForKey:@"path"]]];
            [test setImage: [self resizeImage:img toSize:test.frame.size]];

        }
        
    });
    
    //NSData *videoData = [NSData dataWithContentsOfURL:[asset valueForKey:@"path"]];
    //NSLog(@"Capture complete. Asset: %@", asset);
    
    uploadDataDictionary = [[NSDictionary alloc] initWithDictionary:asset];
    
}

- (void)camCaptureLibraryOperationComplete: (DIYCam *)cam {
    //NSLog(@"Library save complete");
}

#pragma mark - UIGesture
- (void)focusAtTap: (UIGestureRecognizer *)gestureRecognizer {
    
    if (btnCross.hidden == YES) {
        self.focusImageView.center = [gestureRecognizer locationInView:self.cam];
        [self animateFocusImage: 16];
    }
}

#pragma mark - Focus reticle
- (void)animateFocusImage: (NSInteger) nIndex {
    if (nIndex == 0) {
        self.focusImageView.alpha = 0.0;
        self.focusImageView.hidden = YES;

        return;
    }
    
    self.focusImageView.hidden = NO;
    
    if (nIndex == 16) {
        CGPoint ptCenter = self.focusImageView.center;
        self.focusImageView.alpha = 1.0;
        self.focusImageView.frame   = CGRectMake(0, 0, self.focusImageView.image.size.width, self.focusImageView.image.size.height);
        self.focusImageView.center   =  ptCenter;

        
        [UIView animateWithDuration:0.2 animations:^{
            self.focusImageView.frame = CGRectMake(ptCenter.x - self.focusImageView.frame.size.width / 4, ptCenter.y - self.focusImageView.frame.size.height / 4, self.focusImageView.frame.size.width / 2, self.focusImageView.frame.size.height / 2);
            self.focusImageView.center = ptCenter;
            self.focusImageView.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            [self animateFocusImage: nIndex - 1];
        }];
    } else if (nIndex % 2 == 1) {
        [UIView animateWithDuration:0.1 animations:^{
            self.focusImageView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self animateFocusImage: nIndex - 1];
        }];
    } else  {
        [UIView animateWithDuration:0.1 animations:^{
            self.focusImageView.alpha = 0.5;
        } completion:^(BOOL finished) {
            [self animateFocusImage: nIndex - 1];
        }];
    }
}

- (void) onTouchCloseCaptionBtn: (id) sender {
    [viewCaption setHidden: YES];
    [tfMediaCaption resignFirstResponder];
}

- (void) onTouchCaptionBtn: (id) sender {
    [sender setHidden: YES];
    [lblCaption setHidden: YES];
    [tfMediaCaption becomeFirstResponder];
}

- (IBAction) OnDrag:(id)sender {
    
    
    UIPanGestureRecognizer * gesture = sender;
    
    CGPoint start = [gesture locationInView:self.view];
    
    //    NSLog(@"x = %f y = %f %d", start.x, start.y, gesture.state);
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        m_dragstart = start;
        m_dragstartObject = gesture.view.center;
        return;
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint delta = CGPointMake(start.x - m_dragstart.x, start.y - m_dragstart.y);
        gesture.view.center = CGPointMake(m_dragstartObject.x + delta.x, m_dragstartObject.y + delta.y);
        //   m_Outline.center = m_myPicture.center;
        
    }
}


#pragma mark - private start/stop helper methods
- (void)btnStarStopCapturePressed:(UIButton*) btn {
    if ([self.cam getCamMode] == DIYAVModePhoto) {
        if ([btn isSelected]) {
            btn.selected = !btn.isSelected;
            imgViewLoadAnim.hidden = NO;
            [imgViewLoadAnim startAnimating];
            
            [self UploadMedia:nil];
        } else {
            
            [self.cam capturePhoto];
            [test setImage:nil];
            
            btn.selected = !btn.isSelected;
           
            [btnDistance setHidden: NO];
            [btnDuration setHidden: NO];
            
            [_settingButton setHidden: YES];
            [_viewMoreButton setHidden: YES];
            [_flipButton setHidden: YES];
            [btnFlash setHidden: YES];
            [focusImageView setHidden: YES];
            [viewBadge setHidden: YES];
            [viewCaption setHidden: NO];
            
            [btnCross setHidden: NO];
        }
    } else {
        if ([btn isSelected]) {
            btn.selected = !btn.isSelected;
            imgViewLoadAnim.hidden = NO;
            [imgViewLoadAnim startAnimating];
            [self UploadMedia:nil];
            
        } else {
            [self GotoPhotoCaptureMode];
        }
    }
}

- (void)btnStarStopVideoPressed:(UIButton*) btn {
    if (btn.selected == NO) {
  // Start Video Capturing
        [self.cam captureVideoStart];

        btn.selected = YES;        
        _flipButton.hidden = YES;
        focusImageView.hidden = YES;
        
        [progressBar setProgress:0];
        
        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [progressBar setFrame:CGRectMake(0, 0, 320, 7)];
        } completion:^(BOOL finished) {
            
        }];
        
        imgViewLblBG.hidden = NO;
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setDownloadProgress) userInfo:nil repeats:YES];

    } else {
  // Goto Video Preview Screen
        [self GotoVideoPreviewMode];
    }
}


- (IBAction)_viewMoreButton:(id)sender {
    if (objMyPushPicViewController == nil) {
       objMyPushPicViewController = [[MyPushPicViewController alloc] initWithNibName:@"MyPushPicViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:objMyPushPicViewController animated:YES];
    
    if (imgViewNotification.hidden == NO) {
        [objMyPushPicViewController btnShowNotificationTapped: nil];
    }
}

#pragma mark - UIButton

- (void)_handleFlipButton:(UIButton *)button {
    [self.cam flipCamera];
    [button setSelected: !button.selected];
    
    AVCaptureDevicePosition cameraPos = [self.cam getCameraPosition];
    
    if (cameraPos == AVCaptureDevicePositionFront) {
        [[NSUserDefaults standardUserDefaults] setObject:@"FRONT" forKey:CAMERAPOS];

    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"BACK" forKey:CAMERAPOS];
    }
}

- (IBAction)_handleSettingButton:(id)sender {
    
    SettingsViewController *objSettingsViewController1 = [[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
     
    [self.navigationController pushViewController:objSettingsViewController1 animated:NO];
    
}


- (IBAction)_btnDistanceTapped:(id)sender {
    distanceIndex++;
    
    if (distanceIndex < 5) {
        [lblDistance setText:[aryDistance objectAtIndex:distanceIndex]];
    } else {
        distanceIndex = 0;
        [lblDistance setText:[aryDistance objectAtIndex:distanceIndex]];
    }
}

- (IBAction)_btnDurationTapped:(id)sender {
    durationIndex++;
    
    if (durationIndex < 4) {
        [lblDuration setText:[aryDuration objectAtIndex:durationIndex]];
    } else {
        durationIndex = 0;
        [lblDuration setText:[aryDuration objectAtIndex:durationIndex]];
    }
}

- (IBAction)_btnCrossTapped:(id)sender {
    
    //[self.cam startSession];
    
    [imgViewLoadAnim stopAnimating];
    imgViewLoadAnim.hidden = YES;
    
    btnFlash.hidden = NO;
     _flipButton.hidden = NO;
    _btnMediaThumb.hidden = YES;
    
    [test setImage:nil];
    
    if (isUploading) {
        
        [progressBar setFrame:CGRectMake(0, -7, [UIScreen mainScreen].bounds.size.width, 7)];
        [ivOverLay setFrame:CGRectMake(0, 0, 0, 0)];
        [ConnectionRequest cancel];
        isUploading = FALSE;
        
        if ([self.cam getCamMode] == DIYAVModePhoto) {
            
            [self GotoPhotoCaptureMode];
        } else {
            
            [self.mplayer stop];

            [self GotoVideoCaptureMode];
        }
        
    } else {
        
        [progressBar setFrame:CGRectMake(0, -7, [UIScreen mainScreen].bounds.size.width, 7)];
        [ivOverLay setFrame:CGRectMake(0, 0, 0, 0)];
        
        if ([self.cam getCamMode] == DIYAVModePhoto) {
            
            [self GotoPhotoCaptureMode];
            
            [btnCapture setSelected:!btnCapture.isSelected];
        
        } else {
            
            [self.mplayer stop];
            
            [self GotoVideoCaptureMode];
        }
    }
    
    viewBadge.hidden = NO;
}

#pragma mark - UIGestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return true;
}

-  (void)longPressGestureTapped:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        
    } else if (sender.state == UIGestureRecognizerStateBegan) {
        
        if ([btnCapture isSelected]) {
            
            [UIView animateWithDuration:1.0 animations:^{
                [tfMediaCaption setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 216 - 30, 320, 30)];
            } completion:^(BOOL finished) {
                [tfMediaCaption becomeFirstResponder];
            }];
        } else {
        }
    }
}

- (void)_handleLongPressGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if ([btnCapture isSelected]) {
                
            } else {
                if ([self.cam getCamMode] == DIYAVModePhoto) {
                    [self GotoVideoCaptureMode];
                }
                /*
                else {
                    [self.cam setCamMode:DIYAVModePhoto];
                    [btnCapture setImage:[UIImage imageNamed:@"photoGreen"] forState:UIControlStateNormal];
                    capturePhoto = YES;
                }
                 */
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            //[self _pauseCapture];
            break;
        }
        default:
            break;
    }
}

- (void) GotoVideoCaptureMode {
    
    NSLog(@"Video Capture Mode");
    
    [self.cam setCamMode:DIYAVModeVideo];

    [btnFlash setHidden: YES];
    [_settingButton setHidden: YES];
    [_viewMoreButton setHidden: YES];
    
    [btnDistance setHidden: YES];
    [btnDuration setHidden: YES];
    [btnCross setHidden: YES];
    [viewCaption setHidden: YES];
    [tfMediaCaption resignFirstResponder];
    
    [_flipButton setHidden: NO];
    [btnVideo setHidden: NO];
    
    [btnCapture setUserInteractionEnabled: YES];
    [btnCapture setSelected: NO];
    
    [_btnMediaThumb setHidden: YES];
    
    [self hideBadge];
    
    capturePhoto = NO;
}

- (void) GotoVideoPreviewMode {
    btnVideo.hidden = YES;
    btnVideo.selected = NO;
    
    [btnDistance setHidden: NO];
    [btnDistance setUserInteractionEnabled: YES];
    
    [btnDuration setHidden: NO];
    [btnDuration setUserInteractionEnabled: YES];
    
    [btnCross setHidden: NO];
    [viewCaption setHidden: NO];
    
    [btnCapture setSelected: YES];
    
    lblCount.hidden = YES;
    imgViewLblBG.hidden = YES;
    [progressBar setProgress:1.0];
    
    [self performSelector:@selector(resetTimer) withObject:nil afterDelay:1.0];

    [self.cam captureVideoStop];

}

- (void) GotoPhotoCaptureMode {
    [self.cam setCamMode:DIYAVModePhoto];
    
    [btnFlash setHidden: NO];
    [_flipButton setHidden: NO];
    [_settingButton setHidden: NO];
    [_viewMoreButton setHidden: NO];
    [btnDuration setHidden: YES];
    [btnDistance setHidden: YES];
    
    [_flipButton setUserInteractionEnabled: YES];
    [_settingButton setUserInteractionEnabled: YES];
    [_viewMoreButton setUserInteractionEnabled: YES];
    [btnCapture setUserInteractionEnabled: YES];
    
    btnVideo.hidden = YES;
    btnVideo.selected = NO;
    
    [self resetTimer];
    
    lblCount.hidden = YES;
    imgViewLblBG.hidden = YES;
    
    [btnCross setHidden: YES];
    [viewCaption setHidden: YES];
    
    [_btnMediaThumb setHidden: YES];
    
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:NOTIFICATION_COUNT];
    
    if (str != nil && [str integerValue] > 0)
    {
        lblNotCount.text = str;
        [self showBadge];
    }
    else {
        [self hideBadge];
    }
    
    capturePhoto = YES;
    
   // [self performSelector:@selector(clearPreview) withObject:nil afterDelay:1.0];
}

- (void) clearPreview {
    [test setImage: nil];
}

#pragma mark - UIImage Customize Methods
- (UIImage *)getThumbNail:(NSString*)stringPath
{
    NSURL *videoURL = [NSURL fileURLWithPath:stringPath];
    
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    
    UIImage *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    //Player autoplays audio on init
    [player stop];
    return thumbnail;
}

- (UIImage*)resizeImage:(UIImage*) image {
    CGSize newSize = CGSizeMake(150, 150);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (UIImage *)rotateUIImage:(UIImage*)src  angleDegress:(float)angleDegrees{
    UIView* rotatedViewBox = [[UIView alloc] initWithFrame: CGRectMake(0, 0, src.size.width, src.size.height)];
    float angleRadians = angleDegrees * ((float)M_PI / 180.0f);
    CGAffineTransform t = CGAffineTransformMakeRotation(angleRadians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width / 2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, angleRadians);
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-src.size.width / 2, -src.size.height / 2, src.size.width, src.size.height), [src CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)compressImage:(UIImage*)img {
    
    float actualHeight = img.size.height;
    float actualWidth = img.size.width;
    float imgRatio = actualWidth/actualHeight;
    
    float screenHight = 960.0;
    if (ISiPhone5)
        screenHight = 1136.0;
    
    float maxRatio = 640.0 / screenHight;
    
    if (imgRatio != maxRatio) {
        if (imgRatio < maxRatio) {
            imgRatio = screenHight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = screenHight;
        } else {
            imgRatio = 640.0 / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = 640.0;
        }
    }
    CGSize newSize = CGSizeMake(actualWidth, actualHeight);
    UIGraphicsBeginImageContext(newSize);
    [img drawInRect:CGRectMake(0, 0, actualWidth, actualHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - ProgressBar Change

- (void)setDownloadProgress {
    if (progressBar.progress == 0.0)
        progressBar.progress = 0.05;
    else if (progressBar.progress == 0.05)
        progressBar.progress = 0.1;
    else
        progressBar.progress += 0.1;
    
    if (progressBar.progress <= 0.1) {
        lblCount.text = @"10";
    } else {
        lblCount.text = [NSString stringWithFormat:@"%d", [lblCount.text integerValue] - 1];
    }
    
    lblCount.hidden = NO;
    
    if (progressBar.progress == 1.0) {
        [self GotoVideoPreviewMode];
    }
}

- (void)resetTimer {
    [timer invalidate];
    [progressBar setProgress:0.0];
    [progressBar setFrame:CGRectMake(0, -7, [UIScreen mainScreen].bounds.size.width, 7)];
}

#pragma mark - Upload Video
- (void)UploadMedia:(NSData *)mediaData
{
    isUploading = TRUE;
    NSString *urlStr;
    urlStr = [WSList getUploadMedia:[APPDEL.dictUserDetails valueForKey:@"iUserID"] vMedialat:APPDEL.userLat vMedialong:APPDEL.userLong strDur:[aryDur objectAtIndex:durationIndex] strDis:[aryDis objectAtIndex:distanceIndex] vMediaCaption:tfMediaCaption.text left:viewCaption.frame.origin.x top: viewCaption.frame.origin.y / [UIScreen mainScreen].bounds.size.height];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
    [postRequest setURL:url];
    [postRequest setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData  *body = [[NSMutableData alloc] init];
    [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    if ([self.cam getCamMode] == DIYAVModePhoto) {
        NSData *pData =  [NSData dataWithContentsOfURL:[uploadDataDictionary valueForKey:@"path"]];
        
        UIImage *image = [UIImage imageWithData:pData];
        image = [self compressImage:image];
        pData = UIImageJPEGRepresentation(image, 1);
        dataUploadedImage = pData;
        
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"image.jpg\"\r\n"]] dataUsingEncoding:NSUTF8StringEncoding]]; //img name
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:pData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
    } else if ([self.cam getCamMode] == DIYAVModeVideo) {
        
        NSData *vData =  [NSData dataWithContentsOfURL:[uploadDataDictionary valueForKey:@"path"]];
        NSData *tData =  [NSData dataWithContentsOfURL:[uploadDataDictionary valueForKey:@"thumb"]];
        
        UIImage *image = [UIImage imageWithData:tData];
        image = [self rotateUIImage:image angleDegress:90];            
        tData = UIImageJPEGRepresentation(image, 1);
        dataUploadedImage = tData;           
        
        // Video
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"image.mov\"\r\n"]] dataUsingEncoding:NSUTF8StringEncoding]]; //img name
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:vData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Thumb
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"videothumb\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"videothumb\"; filename=\"image.jpg\"\r\n"]] dataUsingEncoding:NSUTF8StringEncoding]]; //img name
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:tData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [postRequest setHTTPBody:body];
        
        /*
        NSData* data = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:nil error:nil];
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
      
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [APPDEL hideWithGradient];
            if([result isEqualToString:@"SUCCESS"]){
                UIAlertView *ale =[[UIAlertView alloc]initWithTitle:APPNAME message:@"Post uploaded !!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [ale show];
            }
        });
         
         
        */
    
        dispatch_async(dispatch_get_main_queue(), ^{
   
            _viewMoreButton.userInteractionEnabled = FALSE;
            _settingButton.userInteractionEnabled = FALSE;
            btnCapture.userInteractionEnabled = FALSE;
            _flipButton.userInteractionEnabled = FALSE;
            btnDuration.userInteractionEnabled = FALSE;
            btnDistance.userInteractionEnabled = FALSE;
            
            _responseData = [[NSMutableData alloc] init];
            [progressBar setFrame:CGRectMake(0, 0, 320, 15)];
            [progressBar setProgress:0];

            [ivOverLay setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            [self.view bringSubviewToFront:ivOverLay];
            [self.view bringSubviewToFront:progressBar];
            [self.view bringSubviewToFront:btnCross];
            
        });
    
        ConnectionRequest = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
        [ConnectionRequest scheduleInRunLoop:[NSRunLoop mainRunLoop]
                          forMode:NSDefaultRunLoopMode];
        [ConnectionRequest start];
}

- (IBAction)btnFlashTapped:(id)sender {
    
    if ([self.cam getFlash]) {
        [self.cam setFlash: NO];
        [btnFlash setSelected:TRUE];
    } else {
        [self.cam setFlash: YES];
        [btnFlash setSelected:FALSE];
    }
}


#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[_responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [test setImage:nil];
    [imgViewLoadAnim stopAnimating];
    imgViewLoadAnim.hidden = YES;
    isUploading = FALSE;
    btnFlash.hidden = NO;
    _flipButton.hidden = NO;
    viewBadge.hidden = NO;
    
    [self.view bringSubviewToFront:_settingButton];
    [self.view bringSubviewToFront:_viewMoreButton];
    [self.view bringSubviewToFront: viewBadge];

    
    [progressBar setFrame:CGRectMake(0, -7, [UIScreen mainScreen].bounds.size.width, 7)];
    [ivOverLay setFrame:CGRectMake(0, 0, 0, 0)];
    [btnCapture setUserInteractionEnabled:FALSE];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    isUploading = FALSE;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [imgViewLoadAnim stopAnimating];
        imgViewLoadAnim.hidden = YES;
        
        [test setImage:nil];
        
        if ([self.cam getCamMode] == DIYAVModePhoto) {
            
            [self GotoPhotoCaptureMode];
            
            /*
        
            btnFlash.hidden = NO;
            _flipButton.hidden = NO;
            viewBadge.hidden = NO;
            
            [btnCross setHidden: YES];
            
            [self.view bringSubviewToFront:_settingButton];
            [self.view bringSubviewToFront:_viewMoreButton];
            [self.view bringSubviewToFront: viewBadge];
            
            _viewMoreButton.userInteractionEnabled = YES;
            _settingButton.userInteractionEnabled = YES;
            btnCapture.userInteractionEnabled = YES;
            _flipButton.userInteractionEnabled = YES;
             */
            
            
        } else {
            [self GotoVideoCaptureMode];
        }
        
        [progressBar setFrame:CGRectMake(0, -7, [UIScreen mainScreen].bounds.size.width, 7)];
        [ivOverLay setFrame:CGRectMake(0, 0, 0, 0)];
        
        
        __unused NSString *result = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
        
        NSLog(@"result = %@", result);
        
        NSDictionary *dicResult;
        NSError *error;
        
        @try {
            dicResult = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingMutableContainers error:&error];
            NSLog(@"-- %@", dicResult);
            if (dicResult != nil && [[dicResult valueForKey:@"MESSAGE"] isEqualToString:@"SUCCESS"]) {
                
                //[[EGOCache currentCache] setData:dataUploadedImage forKey:[self keyForURL:[NSURL URLWithString:@"http://d1fem9dqph53t.cloudfront.net/media/b9b632c60279c1b0fa1d52964c3dad58.jpg"] Style:nil] withTimeoutInterval:604800];
                
              
                
                if ([[dicResult valueForKey:@"USER_DETAIL"] count] > 0) {
                    
                    NSDictionary *dicMedia = [[dicResult valueForKey:@"USER_DETAIL"] objectAtIndex:0];
                    if ([[dicMedia valueForKey:@"eMediaType"] isEqualToString:@"Image"]) {
                        [[EGOCache currentCache] setData:dataUploadedImage forKey:[self keyForURL:[NSURL URLWithString:[dicMedia valueForKey:@"vMediaName"]] Style:nil] withTimeoutInterval:604800];
                    } else if([[dicMedia valueForKey:@"eMediaType"] isEqualToString:@"Video"]) {
                       [[EGOCache currentCache] setData:dataUploadedImage forKey:[self keyForURL:[NSURL URLWithString:[dicMedia valueForKey:@"vMediaThumbName"]] Style:nil] withTimeoutInterval:604800]; 
                    }
                    
                    [self.mplayer stop];
                    
                    if (objMyPushPicViewController == nil) {
                        objMyPushPicViewController = [[MyPushPicViewController alloc] initWithNibName:@"MyPushPicViewController" bundle:nil];
                    }
                    
                    NSLog(@"User Detail %@", [dicResult valueForKey:@"USER_DETAIL"]);
                    
                    objMyPushPicViewController.arrayListFromCapture = [dicResult valueForKey:@"USER_DETAIL"];
                    [self.navigationController pushViewController:objMyPushPicViewController animated:YES];
                }           
            }
        }
        @catch (NSException *exception) {
            
        }

    });    
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    progressBar.progress = (double)totalBytesWritten/totalBytesExpectedToWrite;
   // NSLog(@"%f",progressBar.progress);
        
    if (progressBar.progress == 1) {
        
        //isUploading = FALSE;
        dispatch_async(dispatch_get_main_queue(), ^{
            [btnCross setHidden: YES];
            [viewCaption setHidden: YES];
            [tfMediaCaption resignFirstResponder];
        });
    }
}

- (NSString*) keyForURL:(NSURL*) url Style:(NSString*) style {
	if (style) {
		return [NSString stringWithFormat:@"EGOImageLoader-%u-%u", [[url description] hash], [style hash]];
	} else {
		return [NSString stringWithFormat:@"EGOImageLoader-%u", [[url description] hash]];
	}
}

#pragma mark - UITextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    /*
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        [tfMediaCaption setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, 30)];
    } completion:^(BOOL finished) {
        
    }];
     */
    
    if (textField == tfMediaCaption) {
        [btnCaption setHidden: NO];
        
        if ([textField.text isEqualToString:@""]) {
            [lblCaption setHidden: NO];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    /*
    [UIView animateWithDuration:0.5 animations:^{
        [tfMediaCaption setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, 30)];
    } completion:^(BOOL finished) {
        
    }];
     */
    return YES;
}

- (void)postCountNotification
{
    
   // NSLog(@"uunread count");
     NSNotification *goToFirstTab = [NSNotification notificationWithName:@"showUnreadMsgCount" object:self];
     [[NSNotificationCenter defaultCenter] postNotification:goToFirstTab];
     
     
}

- (void)showUnreadMsgCount {
    if ([[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] == nil) {
        return;
    }
    
    [WebServices urlStringInBG:[WSList strCountUnreadMessage] completionHandler:^(NSDictionary *dicResult) {
         if (dicResult != nil && [[dicResult valueForKey:@"MESSAGE"] isEqualToString:@"SUCCESS"]) {
             NSString *str = [NSString stringWithFormat:@"%@", [dicResult valueForKey:@"UnreadNotification"]];
             
             [[NSUserDefaults standardUserDefaults] setValue:str forKey:NOTIFICATION_COUNT];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             if (str != nil && [str integerValue] > 0 && capturePhoto == YES) {
                 lblNotCount.text = str;
                 [self showBadge];
             } else {
                 [self hideBadge];
             }
         }
    
         if ([[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] != nil) {
             [self performSelector:@selector(postCountNotification) withObject:nil afterDelay:30.0];
         }
    }
  ];
}

- (void) showBadge {
    
    imgViewNotification.hidden = NO;
    lblNotCount.hidden = NO;
}

- (void) hideBadge {
    imgViewNotification.hidden = YES;
    lblNotCount.hidden = YES;
}

- (void) playerPlaybackDidFinish:(NSNotification*)notification
{
    NSLog(@"WHY?");

    [mplayer.view setHidden: YES];
    [test setHidden: NO];
    [_btnMediaThumb setSelected: NO];
    [_btnMediaThumb setHidden: NO];
    
}

- (void) playCurrentVideo: (NSURL *) strVideoURL {
    
    if (mplayer != nil && mplayer.view != nil) {
        [mplayer.view removeFromSuperview];
    }
    
    mplayer = [[MPMoviePlayerController alloc] initWithContentURL: strVideoURL];
    mplayer.shouldAutoplay = NO;
    [mplayer setFullscreen: YES];
    [mplayer setControlStyle: MPMovieControlStyleNone];
    [mplayer prepareToPlay];

    [mplayer.view setFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];  // player's frame must match parent's
    mplayer.scalingMode = MPMovieScalingModeAspectFill;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.mplayer];


    [self.view addSubview: mplayer.view];
    [mplayer.view setHidden: YES];

    [self.view bringSubviewToFront: _btnMediaThumb];
    [self.view bringSubviewToFront: btnCross];
    [self.view bringSubviewToFront: btnDuration];
    [self.view bringSubviewToFront: btnDistance];
    [self.view bringSubviewToFront: btnCapture];
    [self.view bringSubviewToFront: viewCaption];
    //[player play];
}

- (void) btnMediaThumbTapped {
 //   [btnMediaThumb setHidden: YES];
    if (_btnMediaThumb.selected == NO) {
        _btnMediaThumb.selected = YES;
        [mplayer.view setHidden: NO];
        [test setHidden: YES];
        [mplayer play];
    } else {
        [mplayer pause];
        _btnMediaThumb.selected = NO;
    }
}



@end
