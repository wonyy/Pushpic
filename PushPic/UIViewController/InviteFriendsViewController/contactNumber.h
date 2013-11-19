
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface contactNumber : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
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
}

@property (nonatomic, retain) NSString *strPhone;


- (IBAction)selectAll:(UIButton *)sender;
- (IBAction)done:(UIButton *)sender;
- (IBAction)btnBackTapped:(id)sender;

- (void)reloadTableVew:(NSMutableArray *)arr;

@end
