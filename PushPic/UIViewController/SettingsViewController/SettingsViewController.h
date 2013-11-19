

#import <UIKit/UIKit.h>
#import "RCSwitchClone.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
@interface SettingsViewController : UIViewController{
    
    IBOutlet RCSwitchClone *switchHideUserName, *switchSaveToLibrary, *switchRecveMessage, *switchPushNotification;
    
    IBOutlet UILabel *lblTotalPushesMade;
    IBOutlet UILabel *lblTotalPushesVews;
    IBOutlet UILabel *lblTotalPushesLikes;
    
    MBProgressHUD *hud;
    BOOL firstTimeLoad;

    IBOutlet UIScrollView *scrSettings;
    
    BOOL isFirstLoad;
    //Chnage UserName Views
    IBOutlet UIView *viewChangeUserName;
    IBOutlet UITextField *tfNewUserName;
    
    //Change Password Views
    IBOutlet UIView *viewChangePassword;
    IBOutlet UITextField *tfOPassword, *tfNewPass, *tfConfPass;
    IBOutlet UIImageView *ivShadowBG;
    IBOutlet UILabel *lblSettingChange;
    __weak IBOutlet UILabel *lblSettingTitle;
}

//Change UserName Views
- (IBAction)btbOkCUTapped:(id)sender;
- (IBAction)btnCancelCUTapped:(id)sender;
- (IBAction)btnCloseCUTapped:(id)sender;

//Change Password Views
- (IBAction)btbOkCPTapped:(id)sender;
- (IBAction)btnCancelCPTapped:(id)sender;
- (IBAction)btnCloseCPTapped:(id)sender;

- (IBAction)backToCaptureViewTapped:(id)sender;

- (IBAction)inviteFriend:(id)sender;
- (IBAction)terms:(id)sender;
- (IBAction)policy:(id)sender;

- (IBAction)switchChange:(id)sender;

@end
