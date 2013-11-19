//
//  SignInViewController.m
//  PushPic
//
//  Created by KPIteng on 8/7/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import "SignInViewController.h"
#import "Flurry.h"

@interface SignInViewController ()

@end

#define SIGNIN_ALERT  2000
#define FORGOT_ALERT  2001

@implementation SignInViewController

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
    [Flurry logEvent:@"SignIn Class"];
    
    viewFriends = [[FriendListView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, [UIScreen mainScreen].bounds.size.height-20)];
    [viewFriends.tblFriendList setDelegate:self];
    [viewFriends.tblFriendList setDataSource:self];
    [viewFriends.btnCancel addTarget:self action:@selector(btnCancelTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewFriends];
    
    aryFBUsers = [[NSMutableArray alloc] init];
    aryFriends = [[NSMutableArray alloc] init];
    
    [tfUserName setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [tfPassword setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [tfUserName setFont:[UIFont fontWithName:@"DIN 1451 Std" size:19.0f]];
    [tfPassword setFont:[UIFont fontWithName:@"DIN 1451 Std" size:19.0f]];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardwillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    nWrongCount = 0;
    
    [super viewWillAppear: animated];
}

#pragma mark - IBAction Methods

- (IBAction)btnSiginInWithFBTapped:(id)sender {
    
    /*
    if([aryFBUsers count]>0){
        [ACCOUNTSHAREINS getFriendList:[aryFBUsers lastObject] completionHandler:^(NSMutableArray *aryFriendsList) {
            aryFriends = [aryFriendsList mutableCopy];
            NSLog(@"%@",aryFriends);
            [UIView animateWithDuration:1.0 animations:^{
                [viewFriends setFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
            } completion:^(BOOL finished) {
                [viewFriends.tblFriendList reloadData];
            }];
        }];
    }
    else{
        [ACCOUNTSHAREINS getFacebookUsersList:@"KPIteng" completionHandler:^(NSMutableArray *aryUsers) {
            aryFBUsers = [aryUsers mutableCopy];
            NSLog(@"%@",aryFBUsers);
            [ACCOUNTSHAREINS getFriendList:[aryFBUsers lastObject] completionHandler:^(NSMutableArray *aryFriendsList) {
                aryFriends = [aryFriendsList mutableCopy];
                NSLog(@"%@",aryFriends);
                [UIView animateWithDuration:1.0 animations:^{
                    [viewFriends setFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
                } completion:^(BOOL finished) {
                    [viewFriends.tblFriendList reloadData];
                }];
            }];
        }];
    }
    */
    [APPDEL showWithoutGradient:@"Signing in" views:self.view];
    
    [ACCOUNTSHAREINS getFacebookUsersList:@"KPIteng" completionHandler:^(NSMutableArray *aryUsers) {
        aryFBUsers = [aryUsers mutableCopy];
        
        if ([aryFBUsers count] != 0) {
            myAct = [aryFBUsers lastObject];
            //NSLog(@"%@",myAct);
            if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedSame){
                
                [self setM_strEmail: [[myAct valueForKey:@"properties"] valueForKey:@"ACUIDisplayUsername"]];
                
            } else {
                [self setM_strEmail: [myAct valueForKey:@"username"]];
            }
            
            [self setM_strFBID: [[myAct valueForKey:@"properties"] valueForKey:@"uid"]];
            
            UIAlertView *alertUseThis = [[UIAlertView alloc] initWithTitle:APPNAME message:[NSString stringWithFormat:@"Would you like to sign in with %@", _m_strEmail] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Continue", nil];
            
            alertUseThis.tag = SIGNIN_ALERT;
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
            [self setM_strFBID: user.id];
            //   [dataKeeper setM_strUserEmail: [user objectForKey:@"email"]];
            //   [dataKeeper setM_strUserName: user.name];
            //   [dataKeeper setM_strFBToken: user.id];
            UIAlertView *alertUseThis = [[UIAlertView alloc]initWithTitle:APPNAME message:[NSString stringWithFormat:@"Would you like to sign in with %@?", _m_strEmail] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Continue", nil];
            alertUseThis.tag = SIGNIN_ALERT;

            [alertUseThis show];
        }
    }];
}

- (IBAction)btnSignInTapped:(id)sender {
    
    NSArray *fUN = [tfUserName.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* tUN = [fUN componentsJoinedByString:@""];
    
    NSArray *fPW = [tfPassword.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* tPW = [fPW componentsJoinedByString:@""];
    
    if ([tUN length] == 0) {
        showAlertDelNil(@"Please enter a username/email.");
        return;
    }
    
    if ([tPW length] == 0) {
        showAlertDelNil(@"Please enter a password.");
        return;
    }
    
    if ([tUN length] > 0 && [tPW length] > 0) {
        
        [APPDEL showWithoutGradient:@"Signing in" views:self.view];
        
        NSString *strUrl = [WSList getSignInLink:@"No" vEmail:tfUserName.text vPassword:tfPassword.text vUserLat:[NSString stringWithFormat:@"%f", APPDEL.userLat] vUserLong:[NSString stringWithFormat:@"%f",APPDEL.userLong] vDeviceToken:APPDEL.UDID vFbID:@""];
        [WebServices urlStringInBG:strUrl completionHandler:^(NSDictionary *dicResult) {
            
            
            [APPDEL hideWithGradient];
            
            NSLog(@"Login Result = %@", dicResult);
            
            NSString *strResult = [dicResult valueForKey:@"MESSAGE"];
            
            // Sign in Success
            if ([strResult isEqualToString:@"SUCCESS"]) {
                
                [[NSUserDefaults standardUserDefaults] setObject: [dicResult valueForKey:@"USER_DETAIL"] forKey:USERDETAIL];
                
                [[NSUserDefaults standardUserDefaults] setObject:tfUserName.text forKey:USERNAME];
                [[NSUserDefaults standardUserDefaults] setObject:tfPassword.text forKey:PASSWORD];
                [[NSUserDefaults standardUserDefaults] setObject:@"LOGIN" forKey:LOGINTYPE];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                APPDEL.dictUserDetails = (NSDictionary *)[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL];
                
                objCaptureViewController = [[CaptureViewController alloc]initWithNibName:@"CaptureViewController" bundle:nil];
                [self.navigationController pushViewController:objCaptureViewController animated:NO];
                
            } else if ([strResult isEqualToString:@"UNSUCCESS"]) {
                
                UIAlertView *alertUserExists = [[UIAlertView alloc] initWithTitle:APPNAME message:@"We can't find an account with that username." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertUserExists show];
                
            } else if ([strResult isEqualToString:@"WRONGPASSWORD"]) {
                
                nWrongCount++;
                
                if (nWrongCount >= 3) {
                    UIAlertView *alertForgot = [[UIAlertView alloc] initWithTitle:APPNAME message:@"Did you forget your password? Touch Forgot Password to reset your password" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Forgot Password", nil];
                    
                    alertForgot.tag = FORGOT_ALERT;

                    [alertForgot show];
                } else {
                    UIAlertView *alertUserExists = [[UIAlertView alloc] initWithTitle:APPNAME message:@"You input wrong password. Please type right password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertUserExists show];
                    
                }
            }
        }];
        
    } else {
        showAlertDelNil(@"Please fill all fields.");
    }
    
    
}

- (IBAction)btnCancelBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnForgotPasswordTapped:(id)sender {
    UIAlertView *alertForgot = [[UIAlertView alloc] initWithTitle:APPNAME message:@"Did you forget your password? Touch Forgot Password to reset your password" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Forgot Password", nil];
    
    alertForgot.tag = FORGOT_ALERT;
    
    [alertForgot show];

}

- (IBAction)btnBackgroundTapped:(id)sender {
    [tfUserName resignFirstResponder];
    [tfPassword resignFirstResponder];
}

- (IBAction)btnCancelTapped:(id)sender {
    [UIView animateWithDuration:1.0 animations:^{
        [viewFriends setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, [UIScreen mainScreen].bounds.size.height)];
    } completion:^(BOOL finished) {
        
    }];
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

#pragma mark - Table Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [aryFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Default Cell
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    cell.textLabel.text = [[aryFriends objectAtIndex:indexPath.row]valueForKey:@"first_name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - UIAlertView Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == SIGNIN_ALERT) {
    
        if (buttonIndex == 1) {
           // NSLog(@"%@",myAct);

            NSString *strUrl = [WSList getSignInLink:@"Yes" vEmail:_m_strEmail vPassword:@"" vUserLat:[NSString stringWithFormat:@"%f", APPDEL.userLat] vUserLong:[NSString stringWithFormat:@"%f", APPDEL.userLong] vDeviceToken:APPDEL.UDID vFbID:_m_strFBID];
            
            [WebServices urlStringInBG:strUrl completionHandler:^(NSDictionary *dicResult) {
                
               // NSLog(@"%@",dicResult);
                [APPDEL hideWithGradient];

                NSString *strResult = [dicResult valueForKey:@"MESSAGE"];
                
                if ([strResult isEqualToString:@"SUCCESS"]){
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[dicResult valueForKey:@"USER_DETAIL"] forKey:USERDETAIL];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:_m_strEmail forKey:USERNAME];
                    [[NSUserDefaults standardUserDefaults] setObject:_m_strFBID forKey:PASSWORD];
                    [[NSUserDefaults standardUserDefaults] setObject:@"FBLOGIN" forKey:LOGINTYPE];
                    
                    NSString *strCount = [NSString stringWithFormat:@"%@", [dicResult valueForKey:@"UnreadNotification"]];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:strCount forKey:NOTIFICATION_COUNT];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    APPDEL.dictUserDetails = (NSDictionary *)[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL];
                    
                    objCaptureViewController = [[CaptureViewController alloc]initWithNibName:@"CaptureViewController" bundle:nil];
                    [self.navigationController pushViewController:objCaptureViewController animated:NO];
                    
                } else if ([strResult isEqualToString:@"UNSUCCESS"]) {
                    UIAlertView *alertUserExists = [[UIAlertView alloc] initWithTitle:APPNAME message:@"User doesn't exists" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertUserExists show];
                }
            }];
        } else if (buttonIndex == 0) {
            [APPDEL hideWithGradient];

           // NSLog(@"NO");
        }
    } else if (alertView.tag == FORGOT_ALERT) {
        if (buttonIndex == 1) {
            
            if ([tfUserName.text length] <= 0) {
                UIAlertView *alertInputEmail = [[UIAlertView alloc] initWithTitle:APPNAME message:@"Please input User email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertInputEmail show];
            } else {
                NSString *strUrl = [WSList getResetLink: tfUserName.text];
                
                [WebServices urlStringInBG:strUrl completionHandler:^(NSDictionary *dicResult) {
                    
                    // NSLog(@"%@",dicResult);
                    
                    NSString *strResult = [dicResult valueForKey:@"MESSAGE"];
                    
                    if ([strResult isEqualToString:@"SUCCESS"]){
                        UIAlertView *alertUserExists = [[UIAlertView alloc] initWithTitle:APPNAME message:@"Successfully reset your password. Please check your email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertUserExists show];
                        
                    } else if ([strResult isEqualToString:@"UNSUCCESS"]) {
                        UIAlertView *alertUserExists = [[UIAlertView alloc] initWithTitle:APPNAME message:@"Failed to reset password. Please check if you input valid email address and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertUserExists show];
                    }
                }];

            }
            
            nWrongCount = 0;
        }
    }
}

#pragma mark -
#pragma mark Keyboard Notification
- (void)keyboardWillShow: (NSNotification *)notif
{
    NSDictionary *info = [notif userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    CGRect keyboardEndFrame;
    
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.transform = CGAffineTransformMakeTranslation(0, -100);
    [UIView commitAnimations];
}

- (void)keyboardwillHide: (NSNotification *)notif
{
    
    NSDictionary *info = [notif userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    CGRect keyboardEndFrame;
    
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

- (void)viewDidUnload {
    [self setM_scrollView:nil];
    [super viewDidUnload];
}
@end
