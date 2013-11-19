//
//  SignInViewController.h
//  PushPic
//
//  Created by KPIteng on 8/7/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountClass.h"
#import "FriendListView.h"
#import "CaptureViewController.h"
#import "WebServices.h"
#import "WSList.h"

@interface SignInViewController : UIViewController <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    
    NSMutableArray *aryFBUsers;
    NSMutableArray *aryFriends;
    
    IBOutlet UITableView *tblFriendList;
    IBOutlet UITextField *tfUserName,*tfPassword;
    
    FriendListView *viewFriends;
    CaptureViewController *objCaptureViewController;
    
    ACAccount *myAct;
    
    NSInteger nWrongCount;
}

@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;

@property (strong, nonatomic) NSString *m_strUserName;
@property (strong, nonatomic) NSString *m_strEmail;
@property (strong, nonatomic) NSString *m_strFBID;

- (IBAction)btnSiginInWithFBTapped:(id)sender;
- (IBAction)btnSignInTapped:(id)sender;
- (IBAction)btnCancelBackTapped:(id)sender;
- (IBAction)btnForgotPasswordTapped:(id)sender;
- (IBAction)btnBackgroundTapped:(id)sender;


@end
