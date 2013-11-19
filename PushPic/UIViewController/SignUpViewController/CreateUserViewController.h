//
//  CreateUserViewController.h
//  PushPic
//
//  Created by wonymini on 10/14/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountClass.h"
#import "WSList.h"



@interface CreateUserViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate> {
    NSMutableArray *aryFBUsers;
    NSMutableArray *aryFriends;
    
    ACAccount *myAct;
}

@property (weak, nonatomic) IBOutlet UITextField *m_textField;
@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;

@property (strong, nonatomic) NSString *m_strUserName;
@property (strong, nonatomic) NSString *m_strEmail;
@property (strong, nonatomic) NSString *m_strFBID;

- (IBAction)onTouchEnterBtn:(id)sender;
- (IBAction)onTouchBackBtn:(id)sender;
- (IBAction)onTouchBackground:(id)sender;
    
@end
