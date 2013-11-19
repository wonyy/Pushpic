//
//  SignUpViewController.h
//  PushPic
//
//  Created by KPIteng on 8/7/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptureViewController.h"
#import "FriendListView.h"
#import "WSList.h"

#define CONFIRM_ALERT_TAG   201
#define USE_THIS_TAG        202

@interface SignUpViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate>
{
    //Outlet Declaration
    IBOutlet UITextField *tfEmail, *tfUserName, *tfPassword;
}

@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;

- (IBAction)btnSignUpTapped:(id)sender;
- (IBAction)btnSignUpWithFBTapped:(id)sender;
- (IBAction)btnCancelTapped:(id)sender;
- (IBAction)onTouchBackground:(id)sender;


@end
