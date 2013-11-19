//
//  PushPicViewController.h
//  PushPic
//
//  Created by KPIteng on 8/2/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DRNRealTimeBlurView.h"
#import "AppConstant.h"

#import "CaptureViewController.h"
#import "SignInViewController.h"
#import "SignUpViewController.h"

@interface PushPicViewController : UIViewController {
    
    IBOutlet UIButton *btnSignIn,*btnSignUp,*btnStartTour;
    IBOutlet UILabel *lblNavTitle, *lblWelcome;
    
    DRNRealTimeBlurView *popOverView;
    CaptureViewController *objCaptureViewController;
    SignInViewController *objSignInViewController;
    SignUpViewController *objSignUpViewController;
    
    IBOutlet UIImageView *ivBG;
}
- (IBAction)btnSignInTapped:(id)sender;
- (IBAction)btnSignUpTapped:(id)sender;
- (IBAction)btnStartTourTapped:(id)sender;
@end
