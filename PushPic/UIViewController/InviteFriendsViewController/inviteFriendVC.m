
#import "inviteFriendVC.h"
#import "contactNumber.h"
#import <Twitter/Twitter.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "twitterShareVC.h"
#import "facebookFriendVC.h"
#import "AppConstant.h"


@implementation inviteFriendVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (PushPicAppDelegate *)[[UIApplication sharedApplication]delegate];
    btnCancelTag = 0;
    
    [self UIFontInit];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - 
#pragma mark Initialize

- (void) UIFontInit {
    [_m_labelTitle setFont: MyriadPro_Regular_23];
    [_m_labelDescription setFont: MyriadPro_Light_18];
    [_m_labelFacebook setFont: MyriadPro_Regular_18];
    [_m_labelTwitter setFont: MyriadPro_Regular_18];
    [_m_labelEmail setFont: MyriadPro_Regular_18];
    [_m_labelMessage setFont: MyriadPro_Regular_18];
}

#pragma mark -
#pragma mark Twitter

- (void)logInTwitter {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        accountStore = [[ACAccountStore alloc] init];
        ACAccountType *accountTypeTwitter = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [accountStore requestAccessToAccountsWithType:accountTypeTwitter withCompletionHandler:^(BOOL granted, NSError *error) {
             twAccountsArray = [accountStore accountsWithAccountType:accountTypeTwitter];
             twitterAccount = [[ACAccount alloc]init];
             
             dispatch_sync(dispatch_get_main_queue(), ^{
                 
                 if ([twAccountsArray count] > 0) {
                     //[self showHUD];
                     btnBackViewAlertView = [UIButton buttonWithType:UIButtonTypeCustom];
                     btnBackViewAlertView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
                     [btnBackViewAlertView addTarget:self action:@selector(removeAlertViewTwitterAccountsList:) forControlEvents:UIControlEventTouchUpInside];
                     btnBackViewAlertView.backgroundColor = [UIColor blackColor];
                     btnBackViewAlertView.alpha = 0.9;
                     [self.view addSubview:btnBackViewAlertView];
                     
                     UIView *customAlertView = [[UIView alloc]initWithFrame:CGRectMake(150,230,0,0)];
                     
                     UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 20)];
                     lblTitle.text = @"Please select your Twitter account:";
                     lblTitle.font = [UIFont fontWithName:@"Antipasto" size:17];
                     lblTitle.textColor = [UIColor whiteColor];
                     lblTitle.backgroundColor = [UIColor clearColor];
                     lblTitle.textAlignment = NSTextAlignmentCenter;
                     [customAlertView addSubview:lblTitle];
                     
                     UITableView *tblView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                     tblView.layer.cornerRadius = 8.0;
                     tblView.layer.masksToBounds = YES;
                     tblView.delegate = self;
                     tblView.dataSource = self;
                     [customAlertView addSubview:tblView];
                     [btnBackViewAlertView addSubview:customAlertView];
                     
                     [UIView beginAnimations:@"animateToolbar" context:nil];
                     [UIView setAnimationDuration:0.4];
                     [customAlertView setFrame:CGRectMake(20,150,280,180)]; //notice this is ON screen!
                     tblView.frame = CGRectMake(10, 25, 260, 160);
                     [UIView commitAnimations];
                     
                     alertTwitterAccount.tag = 100;
                     [tblView reloadData];
                 } else {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Twitter Account" message:@"There is no twitter account configured. Please add account from the settings" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                     [alert show];
                 }
             });
         }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"You can not use Twitter as you are using iOS %@ in your %@", [[UIDevice currentDevice] systemVersion], [UIDevice currentDevice].model] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert.tag = 101;
    }
}


- (void)removeAlertViewTwitterAccountsList:(id)sender
{
    [btnBackViewAlertView removeFromSuperview];
    //[alertTwitterAccount dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark
#pragma mark TableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [twAccountsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[twAccountsArray objectAtIndex:indexPath.row]valueForKey:@"username"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    twitterAccount = [twAccountsArray objectAtIndex:indexPath.row];
    accountIndexSelected = indexPath.row;
    [alertTwitterAccount dismissWithClickedButtonIndex:0 animated:YES];
    [self twitterAccountSelectedInTableView];
}

// User selecte Twitter account in tableView
#pragma mark - Twitter

- (void)twitterAccountSelectedInTableView
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    
    NSURL *userShow = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com/1/users/show.json"]];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:twitterAccount.accountDescription, @"screen_name", nil];
    TWRequest *twitterRequest = [[TWRequest alloc] initWithURL:userShow
                                                    parameters:parameters
                                                 requestMethod:TWRequestMethodGET];
    [twitterRequest setAccount:twitterAccount];
    
    [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } else {
            NSError *jsonError = nil;
            NSMutableDictionary *twitterUserInfo = [[NSMutableDictionary alloc]initWithDictionary:[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONWritingPrettyPrinted error:&jsonError]];
            
            //NSLog(@"User Info:%@",twitterUserInfo);
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                twitterShareVC *obj = [[twitterShareVC alloc] initWithNibName:@"twitterShareVC" bundle:nil];
                obj.twitterUserInfo = [[NSMutableDictionary alloc] initWithDictionary:twitterUserInfo];
                obj.twitterAccount =  twitterAccount;
                
                [self.navigationController pushViewController:obj animated:YES];
            });
            
        }
    }];
}
#pragma mark - FACEBOOK
#pragma mark - FB login and Delegate Methods

- (void)fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"didnotlogin");
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[appDelegate.session accessTokenData].accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:[appDelegate.session accessTokenData].expirationDate forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    [self performSelector:@selector(InviteFBFriend:) withObject:nil afterDelay:0.2];
}

- (void)InviteFBFriend:(id)sender {
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Check this app out...",  @"message",nil];
 //   [appDelegate.session dialog:@"apprequests" andParams:params andDelegate:self];
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    NSLog(@"Request successfull");
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Request failed with error");
}
/*
- (void)dialogDidComplete:(FBDialog *)dialog {
    if (btnCancelTag == 1) {
       NSLog(@"Button Cancel Clicked");
    } else {

       NSLog(@"Dialog Complete");
    }
}

- (void)dialogCompleteWithUrl:(NSURL *)url {
    NSString *myString = [url absoluteString];
    //NSLog(@"url:%@",myString);
    if ([myString length] < 20) {
        NSLog(@"Send button not Clicked");
        btnCancelTag = 1;
    } else {
        NSLog(@"Send button Clicked");
        btnCancelTag = 0;
    }
    
}

- (void)dialogDidNotCompleteWithUrl:(NSURL *)url {
    NSLog(@"url error:%@",url);
}

- (void)dialogDidNotComplete:(FBDialog *)dialog {
   NSLog(@"Cancel by user");
}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt {
    
}

- (void)fbSessionInvalidated {
    
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
*/
#pragma mark - Touch Actions

- (IBAction)ClickBtnInviteFB:(id)sender {
    
    /*
    appDelegate.facebook = [[Facebook alloc] initWithAppId:FBAppId andDelegate:self];
    appDelegate.facebook.sessionDelegate = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"FBAccessTokenKey"]
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        appDelegate.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        appDelegate.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if (![appDelegate.facebook isSessionValid]) {
        
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"user_photos,publish_stream,friends_photos,email,offline_access,user_status",nil];
        [appDelegate.facebook authorize:permissions];
        
    } else {
        [self performSelector:@selector(InviteFBFriend:) withObject:sender afterDelay:0.2];
    }
     */
}

- (IBAction)twitter:(id)sender {
    [self logInTwitter];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)message:(id)sender {
    
    contactNumber *obj = [[contactNumber alloc]initWithNibName:@"contactNumber" bundle:nil];
    obj.strPhone = @"yes";
    [self.navigationController pushViewController:obj animated:YES];
    
}

- (IBAction)Email:(id)sender {
    contactNumber *obj = [[contactNumber alloc]initWithNibName:@"contactNumber" bundle:nil];
    obj.strPhone = @"no";
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)facebook:(id)sender {
    facebookFriendVC *obj = [[facebookFriendVC alloc]initWithNibName:@"facebookFriendVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}


@end
