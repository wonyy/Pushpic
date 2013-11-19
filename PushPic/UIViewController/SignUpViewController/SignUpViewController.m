//
//  SignUpViewController.m
//  PushPic
//
//  Created by KPIteng on 8/7/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import "SignUpViewController.h"
#import "CreateUserViewController.h"
#import "WebServices.h"
#import "Flurry.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController



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
    
    [Flurry logEvent:@"SignUp Class"];
    
    [tfUserName setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [tfPassword setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [tfEmail setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:APPDEL.myCurrentLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (error){
                           NSLog(@"Geocode failed with error: %@", error);
                           return;
                       }
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       NSLog(@"placemark.ISOcountryCode %@", [placemark.addressDictionary valueForKey:@"Country"]);
                       NSLog(@"placemark.ISOcountryCode %@", [placemark.addressDictionary valueForKey:@"State"]);
                       NSLog(@"placemark.ISOcountryCode %@", [placemark.addressDictionary valueForKey:@"Street"]);
                   }];
    
    
    [tfUserName setFont:[UIFont fontWithName:@"DIN 1451 Std" size:19.0f]];
    [tfPassword setFont:[UIFont fontWithName:@"DIN 1451 Std" size:19.0f]];
    [tfEmail setFont:[UIFont fontWithName:@"DIN 1451 Std" size:19.0f]];
    
    [_m_scrollView scrollsToTop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setM_scrollView:nil];
    [super viewDidUnload];
}

#pragma mark - IBAction Methods

- (IBAction)btnSignUpTapped:(id)sender {
    
    NSArray *fUN = [tfUserName.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* tUN = [fUN componentsJoinedByString:@""];
    
    NSArray *fPW = [tfPassword.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* tPW = [fPW componentsJoinedByString:@""];
    
    NSArray *fEM = [tfEmail.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* tEM = [fEM componentsJoinedByString:@""];
    
    BOOL usernameValidate = [self validateEmailWithString:tfUserName.text];
    
    BOOL emailValidate = [self validateEmailWithString:tfEmail.text];
    
    
    if ([tUN length] == 0) {
        showAlertDelNil(@"Please enter a username.");
        return;
    }
    
    if ([tPW length] == 0) {
        showAlertDelNil(@"Please enter a password.");
        return;
    }
    
    if ([tEM length] == 0) {
        showAlertDelNil(@"Please enter a email.");
        return;
    }
    
    if (usernameValidate == TRUE) {
        showAlertDelNil(@"Don't use email address as username.");
        return;
    }
    
    if (emailValidate == FALSE) {
        showAlertDelNil(@"Please enter a valid email.");
        return;
    }
    
    
    if ([tUN length] > 0 && [tPW length] > 0 && [tEM length] > 0 && emailValidate == YES && usernameValidate == FALSE) {
        
        UIAlertView *alertConfirm = [[UIAlertView alloc] initWithTitle:APPNAME message:@"By signing up you agree to our accept our Terms of Service and Privacy Policy." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
        alertConfirm.tag = CONFIRM_ALERT_TAG;
        [alertConfirm show];
    } else {
        showAlertDelNil(@"Please fill all fields");
    }
    
}

- (IBAction) btnSignUpWithFBTapped: (id)sender {
    
    CreateUserViewController *createUserVC = [[CreateUserViewController alloc] initWithNibName:@"CreateUserViewController" bundle: nil];
    
    [self.navigationController pushViewController: createUserVC animated: YES];
}

- (IBAction)btnCancelTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onTouchBackground:(id)sender {
    [tfEmail resignFirstResponder];
    [tfUserName resignFirstResponder];
    [tfPassword resignFirstResponder];
    
    [_m_scrollView setContentSize:CGSizeMake(_m_scrollView.frame.size.width, _m_scrollView.frame.size.height)];
    [_m_scrollView setContentOffset:CGPointMake(0, 0) animated: YES];

}



#pragma mark - UITextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [textField setValue:[UIColor clearColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_m_scrollView setContentSize:CGSizeMake(_m_scrollView.frame.size.width, _m_scrollView.frame.size.height + 200)];
    if (textField == tfUserName) {
        [_m_scrollView setContentOffset:CGPointMake(0, 70) animated: YES];
    } else if (textField == tfEmail) {
        [_m_scrollView setContentOffset:CGPointMake(0, 70) animated: YES];
    } else if (textField == tfPassword) {
        [_m_scrollView setContentOffset:CGPointMake(0, 70) animated: YES];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [textField resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    [_m_scrollView setContentSize:CGSizeMake(_m_scrollView.frame.size.width, _m_scrollView.frame.size.height)];
    [_m_scrollView setContentOffset:CGPointMake(0, 0) animated: YES];

    return YES;
}


#pragma mark - UIAlertView Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        if (alertView.tag == USE_THIS_TAG) {
            
        } else if (alertView.tag == CONFIRM_ALERT_TAG) {
            
            [APPDEL showWithoutGradient:HUDLABEL views:self.view];
            
            NSString *strUrl = [WSList getSignUpLink:@"No" vName:tfUserName.text vEmail:tfEmail.text vPassword:tfPassword.text vUserLat:[NSString stringWithFormat:@"%f",APPDEL.userLat] vUserLong:[NSString stringWithFormat:@"%f",APPDEL.userLong] vDeviceToken:APPDEL.UDID vFbID:@""];
            
            [WebServices urlStringInBG:strUrl completionHandler:^(NSDictionary *dicResult) {
                
                [APPDEL hideWithGradient];
                
                if ([[dicResult valueForKey:@"MESSAGE"] isEqualToString:@"SUCCESS"]) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[dicResult valueForKey:@"USER_DETAIL"] forKey:USERDETAIL];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:tfUserName.text forKey:USERNAME];
                    [[NSUserDefaults standardUserDefaults] setObject:tfPassword.text forKey:PASSWORD];
                    [[NSUserDefaults standardUserDefaults] setObject:@"LOGIN" forKey:LOGINTYPE];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:NOTIFICATION_COUNT];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    APPDEL.dictUserDetails = (NSDictionary *)[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL];
                    
                    CaptureViewController *objCaptureViewController = [[CaptureViewController alloc]initWithNibName:@"CaptureViewController" bundle:nil];
                    
                    [self.navigationController pushViewController:objCaptureViewController animated:NO];
                    
                    
                } else if ([[dicResult valueForKey:@"MESSAGE"] isEqualToString:@"USERNAME_EXISTS"]) {
                    
                    UIAlertView *alertUserExists = [[UIAlertView alloc]initWithTitle:APPNAME message:@"An account already exists with that username." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertUserExists show];
                    
                } else if ([[dicResult valueForKey:@"MESSAGE"] isEqualToString:@"EMAIL_EXISTS"]) {
                    
                    UIAlertView *alertUserExists = [[UIAlertView alloc]initWithTitle:APPNAME message:@"An account already exists with that email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertUserExists show];
                    
                }
            }];
        }
    }
    else if (buttonIndex == 0) {
       // NSLog(@"NO");
    }
}
#pragma mark - Email Validation

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


@end
