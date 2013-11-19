//
//  CreateUserViewController.m
//  PushPic
//
//  Created by wonymini on 10/14/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import "CreateUserViewController.h"
#import "CaptureViewController.h"
#import "WebServices.h"


@interface CreateUserViewController ()

@end

@implementation CreateUserViewController

static ACAccountStore *accountStore;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_m_textField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setM_textField:nil];
    [self setM_scrollView:nil];
    [super viewDidUnload];
}

- (IBAction)onTouchEnterBtn:(id)sender {
    
     
     NSArray *fUN = [_m_textField.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     NSString* tUN = [fUN componentsJoinedByString:@""];
     
    
     if ([tUN length] == 0) {
         showAlertDelNil(@"Please enter a username.");
         return;
     }
        
     [APPDEL showWithoutGradient:HUDLABEL views:self.view];
     
     [ACCOUNTSHAREINS getFacebookUsersList:@"" completionHandler:^(NSMutableArray *aryUsers) {
         aryFBUsers = [aryUsers mutableCopy];
         
         if ([aryFBUsers count] != 0) {
         
             myAct = [aryFBUsers lastObject];
             
             if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedSame){

                 [self setM_strEmail: [[myAct valueForKey:@"properties"] valueForKey:@"ACUIDisplayUsername"]];
                 [self setM_strUserName: _m_textField.text];
                 
             } else {
                 [self setM_strEmail: [myAct valueForKey:@"username"]];
                 [self setM_strUserName: _m_textField.text];
             }
             
             [self setM_strFBID: [[myAct valueForKey:@"properties"] valueForKey:@"uid"]];
             
             UIAlertView *alertUseThis = [[UIAlertView alloc]initWithTitle:APPNAME message:[NSString stringWithFormat:@"Would you like to sign up with %@?", _m_strEmail] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Continue", nil];
             
             [alertUseThis show];
         } else {
             
             dispatch_sync(dispatch_get_main_queue(), ^{
                 [self FacebookLogin];
             });

         }
     }];
}

- (void) FacebookLogin {
    PushPicAppDelegate *appDelegate = (PushPicAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        //dataKeeper.m_bFacebookLink = YES;
        [appDelegate.session closeAndClearTokenInformation];
        
        [self FacebookLogin];

        //[self GetFacebookInfo];

    } else {
        // Create a new, logged out session.
        appDelegate.session = [[FBSession alloc] initWithPermissions:[NSArray arrayWithObjects:@"publish_actions, email", nil]];
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            //[m_loadingView setHidden: YES];
            
            if (status == FBSessionStateOpen) {
                [self GetFacebookInfo];

                //dataKeeper.m_bFacebookLink = YES;
            } else {
                //[switchView setOn:NO animated: YES];
            }
        }];
        
    }
}

- (void) GetFacebookInfo {
    PushPicAppDelegate *appDelegate = (PushPicAppDelegate *)[[UIApplication sharedApplication] delegate];

    FBRequest *request = [[FBRequest alloc] initWithSession:appDelegate.session graphPath:@"me"];
    
    [request startWithCompletionHandler:  ^(FBRequestConnection *connection,
                                            NSDictionary<FBGraphUser> *user,
                                            NSError *error) {
        if (error) {
            NSLog(@"FB Error: %@", error);
            //error
        }else{
            NSLog(@"Email = %@, Name = %@", [user objectForKey:@"email"], user.name);
            [self setM_strEmail: [user objectForKey:@"email"]];
            [self setM_strUserName: _m_textField.text];
            [self setM_strFBID: user.id];
         //   [dataKeeper setM_strUserEmail: [user objectForKey:@"email"]];
         //   [dataKeeper setM_strUserName: user.name];
         //   [dataKeeper setM_strFBToken: user.id];
            UIAlertView *alertUseThis = [[UIAlertView alloc]initWithTitle:APPNAME message:[NSString stringWithFormat:@"Would you like to sign up with %@?", _m_strEmail] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Continue", nil];
            
            [alertUseThis show];
        }
    }];
}

- (IBAction)onTouchBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onTouchBackground:(id)sender {
    [_m_textField resignFirstResponder];
}

#pragma mark - UITextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField setValue:[UIColor clearColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [_m_scrollView setContentSize:CGSizeMake(_m_scrollView.frame.size.width, _m_scrollView.frame.size.height + 200)];
    
    [_m_scrollView setContentOffset:CGPointMake(0, 70) animated: YES];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [textField resignFirstResponder];
    
    [_m_scrollView setContentSize:CGSizeMake(_m_scrollView.frame.size.width, _m_scrollView.frame.size.height)];

    [_m_scrollView setContentOffset:CGPointMake(0, 0) animated: YES];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIAlertView Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
         [_m_textField setText:@""];
         
         NSString *strUrl = [WSList getSignUpLink:@"Yes" vName:_m_strUserName vEmail:_m_strEmail vPassword:@"" vUserLat:[NSString stringWithFormat:@"%f",APPDEL.userLat] vUserLong:[NSString stringWithFormat:@"%f",APPDEL.userLong] vDeviceToken:APPDEL.UDID vFbID:_m_strFBID];
         
         
         [WebServices urlStringInBG:strUrl completionHandler:^(NSDictionary *dicResult) {
             [APPDEL hideWithGradient];

             // NSLog(@"%@", dicResult);
             if ([[dicResult valueForKey:@"MESSAGE"] isEqualToString:@"SUCCESS"]) {
             
                 [[NSUserDefaults standardUserDefaults] setObject:[dicResult valueForKey:@"USER_DETAIL"] forKey:USERDETAIL];
                 
                 [[NSUserDefaults standardUserDefaults] setObject:_m_strEmail forKey:USERNAME];
                 [[NSUserDefaults standardUserDefaults] setObject:_m_strFBID forKey:PASSWORD];
                 [[NSUserDefaults standardUserDefaults] setObject:@"FBLOGIN" forKey:LOGINTYPE];
                 
                 [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:NOTIFICATION_COUNT];
                 
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 
                 APPDEL.dictUserDetails = (NSDictionary *)[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL];
                 
                 CaptureViewController *objCaptureViewController = [[CaptureViewController alloc]initWithNibName:@"CaptureViewController" bundle:nil];
                 
                 [self.navigationController pushViewController:objCaptureViewController animated:YES];
             
             } else if ([[dicResult valueForKey:@"MESSAGE"] isEqualToString:@"USERNAME_EXISTS"]) {
             
                 UIAlertView *alertUserExists = [[UIAlertView alloc]initWithTitle:APPNAME message:@"User already exists" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [alertUserExists show];
             
             } else if ([[dicResult valueForKey:@"MESSAGE"] isEqualToString:@"EMAIL_EXISTS"]) {
             
                 UIAlertView *alertUserExists = [[UIAlertView alloc]initWithTitle:APPNAME message:@"Email already exists" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 
                 [alertUserExists show];
             }
         }];

    }
    else if (buttonIndex == 0) {
        [APPDEL hideWithGradient];

        // NSLog(@"NO");
    }
}

@end
