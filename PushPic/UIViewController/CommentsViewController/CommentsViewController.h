//
//  CommentsViewController.h
//  PushPic
//
//  Created by KPIteng on 8/15/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsViewController : UIViewController <UITextViewDelegate>
{
    NSDictionary *dictUserComment;
    IBOutlet UITableView *tblCommentsList;
    IBOutlet UITextView *tvCommentField;
    
    IBOutlet UILabel *lblTitleLabel;
    NSMutableArray *aryComments;
}

@property(nonatomic, strong) NSDictionary *dictUserComment;

- (IBAction)btnBackTapped:(id)sender;
- (IBAction)btnSentMsgTapped:(id)sender;

@end
