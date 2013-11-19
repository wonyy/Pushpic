//
//  PreviewViewController.m
//  PushPic
//
//  Created by wonymini on 9/27/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import "PreviewViewController.h"
#import "AppConstant.h"
#import "SignInViewController.h"
#import "SignUpViewController.h"
#import "CaptureViewController.h"
#import "CreateUserViewController.h"

@interface PreviewViewController ()

@end

@implementation PreviewViewController

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
    
    if (ISiPhone5) {
        [_m_imageSplash setImage: [UIImage imageNamed:@"Default-568h@2x.png"]];
    } else {
        [_m_imageSplash setImage: [UIImage imageNamed:@"Default"]];
    }

}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    // iOS 7.0 or later
    [self setNeedsStatusBarAppearanceUpdate];
#else
    // less than 7
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
#endif
    
    self.navigationController.navigationBar.frame = CGRectOffset(self.navigationController.navigationBar.frame, 0.0, -20.0);

    
    NSString *strUserName = (NSString *)[[NSUserDefaults standardUserDefaults] valueForKey:USERNAME];
    NSString *strPassword = (NSString *)[[NSUserDefaults standardUserDefaults] valueForKey:PASSWORD];
    
    NSString *strLoginType = (NSString *)[[NSUserDefaults standardUserDefaults] valueForKey:LOGINTYPE];
    

    [_m_imageSplash setHidden: NO];
    
    if ([strLoginType isEqualToString:@"LOGIN"] && [strUserName isEqualToString:@""] == NO) {

        NSString *strUrl = [WSList getSignInLink:@"No" vEmail:strUserName vPassword:strPassword vUserLat:[NSString stringWithFormat:@"%f", APPDEL.userLat] vUserLong:[NSString stringWithFormat:@"%f",APPDEL.userLong] vDeviceToken:APPDEL.UDID vFbID:@""];
        [WebServices urlStringInBG:strUrl completionHandler:^(NSDictionary *dicResult) {
            
            
            [APPDEL hideWithGradient];
            
            NSLog(@"Login Result = %@", dicResult);
            
            NSString *strResult = [dicResult valueForKey:@"MESSAGE"];
            
            // Sign in Success
            if ([strResult isEqualToString:@"SUCCESS"]) {
                
                [[NSUserDefaults standardUserDefaults] setObject: [dicResult valueForKey:@"USER_DETAIL"] forKey:USERDETAIL];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                APPDEL.dictUserDetails = (NSDictionary *)[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL];
                
                CaptureViewController* objCaptureViewController = [[CaptureViewController alloc]initWithNibName:@"CaptureViewController" bundle:nil];
                [self.navigationController pushViewController:objCaptureViewController animated:NO];
                
            } else if ([strResult isEqualToString:@"UNSUCCESS"]) {
                
                UIAlertView *alertUserExists = [[UIAlertView alloc] initWithTitle:APPNAME message:@"We can't find an account with that username." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertUserExists show];
                
                [_m_imageSplash setHidden: YES];
                
            } else if ([strResult isEqualToString:@"WRONGPASSWORD"]) {
                
                UIAlertView *alertUserExists = [[UIAlertView alloc] initWithTitle:APPNAME message:@"You changed your password. Please try with new password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertUserExists show];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:USERNAME];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:PASSWORD];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:LOGINTYPE];
                
                [_m_imageSplash setHidden: YES];
            }
        }];
        
    } else if ([strLoginType isEqualToString:@"FBLOGIN"] && [strUserName isEqualToString:@""] == NO) {
    
        NSString *strUrl = [WSList getSignInLink:@"Yes" vEmail:strUserName vPassword:@"" vUserLat:[NSString stringWithFormat:@"%f", APPDEL.userLat] vUserLong:[NSString stringWithFormat:@"%f", APPDEL.userLong] vDeviceToken:APPDEL.UDID vFbID:strPassword];
        
        [WebServices urlStringInBG:strUrl completionHandler:^(NSDictionary *dicResult) {
            
            // NSLog(@"%@",dicResult);
            
            NSString *strResult = [dicResult valueForKey:@"MESSAGE"];
            
            if ([strResult isEqualToString:@"SUCCESS"]){
                
                [[NSUserDefaults standardUserDefaults] setObject:[dicResult valueForKey:@"USER_DETAIL"] forKey:USERDETAIL];
                
                NSString *strCount = [NSString stringWithFormat:@"%@", [dicResult valueForKey:@"UnreadNotification"]];
                
                [[NSUserDefaults standardUserDefaults] setValue:strCount forKey:NOTIFICATION_COUNT];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                APPDEL.dictUserDetails = (NSDictionary *)[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL];
                
                CaptureViewController *objCaptureViewController = [[CaptureViewController alloc]initWithNibName:@"CaptureViewController" bundle:nil];
                [self.navigationController pushViewController:objCaptureViewController animated:NO];
                
            } else if ([strResult isEqualToString:@"UNSUCCESS"]) {
                
                UIAlertView *alertUserExists = [[UIAlertView alloc] initWithTitle:APPNAME message:@"User doesn't exists" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertUserExists show];
            }
        }];

        
    } else {
        [_m_imageSplash setHidden: YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setM_signupCell:nil];
    [self setM_tableView:nil];
    [self setM_previewCell:nil];
    [self setM_lastsignupCell:nil];
    [self setM_dotView:nil];
    [self setM_imageSplash:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (ISiPhone5) {
        return 568;
    }
    
    return 480;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 1;
}

//UPDATE - to handle filtering
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

//UPDATE - to handle filtering
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        [[NSBundle mainBundle] loadNibNamed:@"SignupCell" owner:self options:nil];
        
        return _m_signupCell;
    } else if (indexPath.row == 6) {
        [[NSBundle mainBundle] loadNibNamed:@"LastSignupCell" owner:self options:nil];
        
        return _m_lastsignupCell;
    } else {
        [[NSBundle mainBundle] loadNibNamed:@"PreviewCell" owner:self options:nil];
        
        if (ISiPhone5) {
            [_m_previewCell.m_imageView setImage: [UIImage imageNamed: [NSString stringWithFormat:@"preview%d-568h.png", indexPath.row]]];
        } else {
            [_m_previewCell.m_imageView setImage: [UIImage imageNamed: [NSString stringWithFormat:@"preview%d.png", indexPath.row]]];
            
        }
        return _m_previewCell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat fHeight = (ISiPhone5) ? 548.0f : 460.0f;

    NSInteger nCurPage = (int)(scrollView.contentOffset.y / fHeight);
    
    if (nCurPage > 0) {
        [_m_dotView setHidden: NO];
    } else {
        [_m_dotView setHidden: YES];
    }
    
    NSLog(@"nCurPage = %d", nCurPage);
    
    for (NSInteger nIndex = 1; nIndex <= 6; nIndex++) {
        UIImageView *imgView = (UIImageView *)[_m_dotView viewWithTag: nIndex + 200];
        
        if (nIndex == nCurPage) {
            [imgView setImage: [UIImage imageNamed:@"dot_sel.png"]];
        } else {
            [imgView setImage: [UIImage imageNamed:@"dot.png"]];
        }
    }
}

#pragma mark - Touch Actions

- (IBAction)onTouchSignupWithFB:(id)sender {
    CreateUserViewController *createUserVC = [[CreateUserViewController alloc] init];
    
    [self.navigationController pushViewController: createUserVC animated: YES];
}

- (IBAction)onTouchSignup:(id)sender {
    SignUpViewController *objSignUpViewController = [[SignUpViewController alloc] init];
    [self.navigationController pushViewController:objSignUpViewController animated:YES];
}

- (IBAction)onTouchLogin:(id)sender {
    SignInViewController *objSignInViewController = [[SignInViewController alloc] init];
    [self.navigationController pushViewController:objSignInViewController animated:YES];
}

- (IBAction)onTouchTakeATourBtn:(id)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection: 0];
    [_m_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated: YES];
}



@end
