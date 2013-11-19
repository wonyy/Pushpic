//
//  PreviewViewController.h
//  PushPic
//
//  Created by wonymini on 9/27/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SignupCell.h"
#import "PreviewCell.h"
#import "LastSignupCell.h"

@interface PreviewViewController : UIViewController {
    
}

@property (weak, nonatomic) IBOutlet UITableView *m_tableView;
@property (strong, nonatomic) IBOutlet SignupCell *m_signupCell;
@property (strong, nonatomic) IBOutlet PreviewCell *m_previewCell;
@property (strong, nonatomic) IBOutlet LastSignupCell *m_lastsignupCell;

@property (weak, nonatomic) IBOutlet UIView *m_dotView;
@property (weak, nonatomic) IBOutlet UIImageView *m_imageSplash;

- (IBAction)onTouchSignupWithFB:(id)sender;
- (IBAction)onTouchSignup:(id)sender;
- (IBAction)onTouchLogin:(id)sender;
- (IBAction)onTouchTakeATourBtn:(id)sender;


@end
