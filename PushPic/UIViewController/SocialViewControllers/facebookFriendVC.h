//
//  facebookFriendVC.h
//  PushPic
//
//  Created by Mic mini 5 on 8/14/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

@interface facebookFriendVC : UIViewController
{
    ACAccount *facebookaccount;
    IBOutlet UITableView *table;
    
    IBOutlet UISearchBar *serachBar;
    
    IBOutlet UILabel *lblTitleLabel;
    NSMutableArray *aryFriendList;
}
- (IBAction)btnBackTapped:(id)sender;
@end
