

#import "SettingsViewController.h"
#import "inviteFriendVC.h"
#import "termsVC.h"
#import "policyprivicyVC.h"
#import "WebServices.h"
#import "WSList.h"
#import "AppConstant.h"
#import "Flurry.h"

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [Flurry logEvent:@"Setting Class"];
    [self.view addSubview:scrSettings];
    
    if (ISiPhone5) {
        [scrSettings setFrame:CGRectMake(0, 64, 320, 504)];
    } else {
        [scrSettings setFrame:CGRectMake(0, 64, 320, 416)];
    }
    [scrSettings setContentSize:CGSizeMake(320, 504)];
    
    isFirstLoad = YES;
    
    
    // By Kp
    [self.view addSubview:viewChangePassword];
    [self.view addSubview:viewChangeUserName];
    
    [viewChangeUserName setFrame:CGRectMake(12, 0, 295, 0 )];
    [viewChangePassword setFrame:CGRectMake(12, 0, 295, 0)];
    
    [ivShadowBG setHidden:TRUE];
    
    [lblSettingChange.layer setCornerRadius:10.0];
    [lblSettingChange.layer setBorderWidth:1.0];
    [lblSettingChange.layer setBorderColor:[UIColor blackColor].CGColor];
     
    
    [lblSettingTitle setFont:MyriadPro_Bold_23];
    
    [tfNewPass setFont:[UIFont fontWithName:@"DIN 1451 Std" size:19.0f]];
    [tfConfPass setFont:[UIFont fontWithName:@"DIN 1451 Std" size:19.0f]];
    [tfNewPass setFont:[UIFont fontWithName:@"DIN 1451 Std" size:19.0f]];
    [tfNewUserName setFont:[UIFont fontWithName:@"DIN 1451 Std" size:19.0f]];
    [tfOPassword setFont:[UIFont fontWithName:@"DIN 1451 Std" size:19.0f]];
    
    [tfNewPass setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [tfConfPass setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [tfNewPass setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [tfNewUserName setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [tfOPassword setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
     
}

- (void) viewWillAppear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (!isFirstLoad) {
        return;
    }
    
    isFirstLoad = NO;
    
    NSDictionary *dictUserInfo1 = [[NSUserDefaults standardUserDefaults] dictionaryForKey:USERDETAIL];
    
    if ([[dictUserInfo1 valueForKey:@"eHideUserName"] isEqualToString:@"Yes"] ) {
        switchHideUserName.on = TRUE;
    } else  {
        switchHideUserName.on = FALSE;
    }
    
    if ([[dictUserInfo1 valueForKey:@"eSavePushStatus"] isEqualToString:@"Yes"]) {
        switchSaveToLibrary.on = TRUE;
    } else {
        switchSaveToLibrary.on = FALSE;
    }
    
    if ([[dictUserInfo1 valueForKey:@"eMessageReceiveStatus"] isEqualToString:@"Yes"])  {
        switchRecveMessage.on = TRUE;
    } else {
        switchRecveMessage.on = FALSE;
    }
    
   /*
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    MBPushPicProgressView* pushPicLoadingView = [[MBPushPicProgressView alloc] init];
    [hud setCustomView: pushPicLoadingView];

    hud.labelText = @"Loading...";
    */
   // firstTimeLoad = YES;
    
    [WebServices urlStringInBG:[WSList getSettingInformation] completionHandler:^(NSDictionary * response) {
        
       // NSLog(@"%@",[response valueForKey:@"SettingsData"]);
        
        if ([[[response valueForKey:@"SettingsData"] valueForKey:@"eHideUserName"] isEqualToString:@"Yes"]) {
            switchHideUserName.on = TRUE;
        } else {
            switchHideUserName.on = FALSE;
        }
        
        
        if ([[[response valueForKey:@"SettingsData"] valueForKey:@"eSavePushStatus"] isEqualToString:@"Yes"]) {
            switchSaveToLibrary.on = TRUE;
        } else {
            switchSaveToLibrary.on = FALSE;
        }

        if ([[[response valueForKey:@"SettingsData"] valueForKey:@"eMessageReceiveStatus"] isEqualToString:@"Yes"]) {
            switchRecveMessage.on = TRUE;
        } else {
            switchRecveMessage.on = FALSE;
        }
        
        lblTotalPushesMade.text = [self getTotalCounts: [[[response valueForKey:@"SettingsData"] valueForKey:@"iUserTotalPushes"] integerValue]];
        
        lblTotalPushesVews.text = [self getTotalCounts: [[[response valueForKey:@"SettingsData"] valueForKey:@"iUserViewsCount"] integerValue]];
        
        lblTotalPushesLikes.text = [self getTotalCounts: [[[response valueForKey:@"SettingsData"] valueForKey:@"iUserLikesCount"] integerValue]];
        
       // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([lblTotalPushesMade.text isEqualToString:@""]) {
            lblTotalPushesMade.text = @"0";
        }
        
        if ([lblTotalPushesVews.text isEqualToString:@""]) {
            lblTotalPushesVews.text = @"0";
        }
        
        if ([lblTotalPushesLikes.text isEqualToString:@""]) {
            lblTotalPushesLikes.text = @"0";
        }
        
        firstTimeLoad = NO;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload {
    scrSettings = nil;
    lblSettingTitle = nil;
    [super viewDidUnload];
}

#pragma mark - String Convert Function

- (NSString *) getTotalCounts: (NSInteger) nCount {
    if (nCount < 10000) {
        return [NSString stringWithFormat:@"%d", nCount];
    } else if (nCount < 1000000) {
        return [NSString stringWithFormat:@"%.1fk", (float)nCount / 1000.0f];
    } else if (nCount >= 1000000){
        return [NSString stringWithFormat:@"%.1f million", (float)nCount / 1000000.0f];
    }
    
    return @"Invalid";
}

#pragma mark - IB Actions

- (IBAction)switchChange:(id)sender{
    
    if (firstTimeLoad) {
        return;
    }
    
    
   // NSLog(@"%@", [NSString stringWithFormat:@"http://pushpic.com/ws/index.php?c=settings&func=UpdateData&iUserID=%@&eHideUserName=%@&eSavePushStatus=%@&eMessageReceiveStatus=%@",[[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] valueForKey:@"iUserID"],(switchHideUserName.on)?@"Yes":@"No",(switchSaveToLibrary.on)?@"Yes":@"No",(switchRecveMessage.on)?@"Yes":@"No"]);
        
    
    [WebServices urlStringInBG: [NSString stringWithFormat:@"http://pushpic.com/ws/index.php?c=settings&func=UpdateData&iUserID=%@&eHideUserName=%@&eSavePushStatus=%@&eMessageReceiveStatus=%@",[[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] valueForKey:@"iUserID"],(switchHideUserName.on)?@"Yes":@"No",(switchSaveToLibrary.on)?@"Yes":@"No",(switchRecveMessage.on)?@"Yes":@"No"] completionHandler:^(NSDictionary * response) {
        
        if([[response valueForKey:@"MESSAGE"] isEqualToString:@"SUCCESS"]){
            NSString *strStatus = (switchSaveToLibrary.on)?@"Yes":@"No";
            
            //NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL]);
            
            
            NSMutableDictionary *dictUserInfo = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:USERDETAIL]mutableCopy];
            [dictUserInfo setValue:strStatus forKey:@"eSavePushStatus"];
            [[NSUserDefaults standardUserDefaults] setObject:dictUserInfo forKey:USERDETAIL];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
           // NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL]);
           // NSLog(@"Switch Response:%@",response);
        }
    }];

}


- (IBAction)inviteFriend:(id)sender {
    inviteFriendVC *obj = [[inviteFriendVC alloc] initWithNibName:@"inviteFriendVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)terms:(id)sender {
    termsVC *obj = [[termsVC alloc] initWithNibName:@"termsVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)policy:(id)sender {
    policyprivicyVC *obj = [[policyprivicyVC alloc] initWithNibName:@"policyprivicyVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)backToCaptureViewTapped:(id)sender {
    
   /* [UIView animateWithDuration:1.0 animations:^{
        [self.view setFrame:CGRectMake(-[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        
    }];*/
    
    //[self.navigationController popViewControllerAnimated:YES];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromRight; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [[self navigationController] popViewControllerAnimated:NO];
    
}

- (IBAction)btnLogOutPressed:(id)sender{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDETAIL];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: USERNAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: PASSWORD];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: LOGINTYPE];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
//   NSNotification *notification = [NSNotification notificationWithName:@"LOGOUT" object:self];
//	[[NSNotificationCenter defaultCenter] postNotification:notification];

}

- (IBAction)btnChangeUserNameTapped:(id)sender {
    
    
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] valueForKey:@"eFbStatus"] isEqualToString:@"Yes"]) {
        showAlertDelNil(@"You can not change your username.");
    } else {
        [ivShadowBG setHidden:FALSE];
       // NSLog(@"-- %@",[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL]);

        tfNewUserName.text = [[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] valueForKey:@"vUserName"];
        [self.view bringSubviewToFront:ivShadowBG];
        [self.view bringSubviewToFront:viewChangeUserName];
        [viewChangeUserName setFrame:CGRectMake(12, -167, 295, 167)];
        
        [UIView animateWithDuration:0.5 animations:^{
            [viewChangeUserName setFrame:CGRectMake(12, 60, 295, 167)];
        } completion:^(BOOL finished) {
            
        }];
    }
}


- (IBAction)btnChangePasswordTapped:(id)sender {
    
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] valueForKey:@"eFbStatus"] isEqualToString:@"Yes"]) {
        showAlertDelNil(@"You can not change your password.");
    } else {
        [ivShadowBG setHidden: NO];
        [self.view bringSubviewToFront:ivShadowBG];
        [self.view bringSubviewToFront:viewChangePassword];
        [viewChangePassword setFrame: CGRectMake(12, -245, 295, 245)];
        
        [UIView animateWithDuration:0.5 animations:^{
            [viewChangePassword setFrame: CGRectMake(12, 60, 295, 245)];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (IBAction)btbOkCUTapped:(id)sender {
    
    [tfNewUserName resignFirstResponder];
    
    NSArray *fUN = [tfNewUserName.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* tUN = [fUN componentsJoinedByString:@""];
    
    if ([tUN length] == 0) {
        showAlertDelNil(@"Please enter a username.");
        return;
    }
    
    [WebServices urlStringInBG:[WSList strChangeUserName:tfNewUserName.text] completionHandler:^(NSDictionary *dictResponse) {
        NSLog(@"%@", dictResponse);
        
        if ([[dictResponse valueForKey:@"MESSAGE"] isEqualToString:@"SUCCESS"]){
            
            NSMutableDictionary *dicInfo =  [[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] mutableCopy];
            [dicInfo setValue:tfNewUserName.text forKey:@"vUserName"];
            
            [[NSUserDefaults standardUserDefaults] setObject:dicInfo forKey:USERDETAIL];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [UIView animateWithDuration:0.5 animations:^{
                [viewChangeUserName setFrame:CGRectMake(12, -167, 295, 167)];
            } completion:^(BOOL finished) {
                [ivShadowBG setHidden:TRUE];
            }];
        }
        else if([[dictResponse valueForKey:@"MESSAGE"] isEqualToString:@"USER_EXISTS"]){
            showAlertDelNil(@"An account already exists with that username.");
        }
    }];
}

// Touch Cancel Button of Change UserName Popup
- (IBAction)btnCancelCUTapped:(id)sender {
    [tfNewUserName setText:@""];
    [tfNewUserName resignFirstResponder];
    
    [UIView animateWithDuration:0.5 animations:^{
        [viewChangeUserName setFrame:CGRectMake(12, -167, 295, 167)];
    } completion:^(BOOL finished) {
        [ivShadowBG setHidden:TRUE];
    }];
}

- (IBAction)btbOkCPTapped:(id)sender {
    [tfOPassword resignFirstResponder];
    [tfNewPass resignFirstResponder];
    [tfConfPass resignFirstResponder];
    
    NSArray *fUN = [tfOPassword.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* tUN = [fUN componentsJoinedByString:@""];
    
    if ([tUN length] == 0){
        showAlertDelNil(@"Please enter a Old Password.");
        return;
    }
    
    NSArray *ANP = [tfNewPass.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *fNP = [ANP componentsJoinedByString:@""];
    
    if ([fNP length] == 0){
        showAlertDelNil(@"Please enter a New Password.");
        return;
    }
    
    NSArray *ACP = [tfConfPass.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *fCP = [ACP componentsJoinedByString:@""];
    
    if ([fCP length] == 0){
        showAlertDelNil(@"Please enter a Confirm Password.");
        return;
    }
    
    
    if (![tfNewPass.text isEqualToString:tfConfPass.text]){
        showAlertDelNil(@"New password & confirm password should be same.");
        return;
    }
    
    [WebServices urlStringInBG:[WSList strChangePassword:tfNewPass.text strOldPassword:tfOPassword.text] completionHandler:^(NSDictionary *dictResponse) {
        if ([[dictResponse valueForKey:@"MESSAGE"] isEqualToString:@"SUCCESS"]) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                [viewChangePassword setFrame:CGRectMake(12, -245, 295, 245)];
                
            } completion:^(BOOL finished) {
                
                [tfOPassword setText:@""];
                [tfNewPass setText:@""];
                [tfConfPass setText:@""];
                
                [ivShadowBG setHidden:TRUE];
            }];
        }
    }];
    
}

- (IBAction)btnCancelCPTapped:(id)sender {
    [tfOPassword setText:@""];
    [tfNewPass setText:@""];
    [tfConfPass setText:@""];
    
    [tfOPassword resignFirstResponder];
    [tfNewPass resignFirstResponder];
    [tfConfPass resignFirstResponder];
    
    [UIView animateWithDuration:0.5 animations:^{
        [viewChangePassword setFrame:CGRectMake(12, -245, 295, 245)];
    } completion:^(BOOL finished) {
        [ivShadowBG setHidden:TRUE];
    }];
}

- (IBAction)btnCloseCUTapped:(id)sender {
    tfNewUserName.text = @"";
    [tfNewUserName resignFirstResponder];
    
    [UIView animateWithDuration:0.5 animations:^{
        [viewChangeUserName setFrame:CGRectMake(12, -167, 295, 167)];
    } completion:^(BOOL finished) {
        [ivShadowBG setHidden:TRUE];
    }];
}
- (IBAction)btnCloseCPTapped:(id)sender{
    
    [tfOPassword setText:@""];
    [tfNewPass setText:@""];
    [tfConfPass setText:@""];
    
    [tfOPassword resignFirstResponder];
    [tfNewPass resignFirstResponder];
    [tfConfPass resignFirstResponder];
    
    [UIView animateWithDuration:0.5 animations:^{
        [viewChangePassword setFrame:CGRectMake(12, -245, 295, 245)];
    } completion:^(BOOL finished) {
        [ivShadowBG setHidden:TRUE];
    }];
}


#pragma mark - UITextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
