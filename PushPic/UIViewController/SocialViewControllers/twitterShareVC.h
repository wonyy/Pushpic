
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <Accounts/Accounts.h>

@interface twitterShareVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *aryContactUsers;
    
    NSMutableArray *numbersArray;
    NSMutableArray *numberSelectArray;
    
    
    IBOutlet UILabel *lblNavTitle;
    IBOutlet UIButton *btnSelectAll;
    
    //Index No Table
    NSMutableArray *selectedArray;
    NSMutableDictionary *sections;
    IBOutlet UITableView *table;
    
    IBOutlet UISearchBar *serachBar;

    IBOutlet UILabel *lblTitleLabel;
    
    MBProgressHUD *hud;
    
    int index;
}

@property (nonatomic,retain)NSMutableDictionary *twitterUserInfo;
@property (nonatomic,retain) ACAccount *twitterAccount;

- (IBAction)selectAll: (UIButton *)sender;
- (IBAction)done:(UIButton *)sender;


-(void)reloadTableVew:(NSMutableArray *)arr;
@end
