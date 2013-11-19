
#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import "MBProgressHUD.h"
#import "PushPicAppDelegate.h"

@interface inviteFriendVC : UIViewController<UITableViewDataSource, UITableViewDelegate, FBRequestDelegate>
{
    
    // Twitter
    ACAccountStore *accountStore;
    NSArray *twAccountsArray;
    ACAccount *twitterAccount;
    int accountIndexSelected;
    UIAlertView* alertTwitterAccount;
    UIButton *btnBackViewAlertView;

    MBProgressHUD *hud;
    
    PushPicAppDelegate *appDelegate;
    
    int btnCancelTag;
}

@property (weak, nonatomic) IBOutlet UILabel *m_labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *m_labelDescription;
@property (weak, nonatomic) IBOutlet UILabel *m_labelFacebook;
@property (weak, nonatomic) IBOutlet UILabel *m_labelTwitter;
@property (weak, nonatomic) IBOutlet UILabel *m_labelEmail;
@property (weak, nonatomic) IBOutlet UILabel *m_labelMessage;

- (IBAction)back:(id)sender;
- (IBAction)twitter:(id)sender;
- (IBAction)facebook:(id)sender;
- (IBAction)message:(id)sender;
- (IBAction)Email:(id)sender;

@end
