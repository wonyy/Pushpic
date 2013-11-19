//
//  CommentsViewController.m
//  PushPic
//
//  Created by KPIteng on 8/15/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import "CommentsViewController.h"
#import "EGOImageView.h"
#import "WebServices.h"
#import "WSList.h"
#import "AppConstant.h"

@interface CommentsViewController ()

@end

@implementation CommentsViewController
@synthesize dictUserComment;

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
     [lblTitleLabel setFont:MyriadPro_Bold_23];
    aryComments = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [WebServices urlStringInBG:[WSList getAllComment_iMediaID:[dictUserComment valueForKey:@"iMediaID"]] completionHandler:^(NSDictionary *dictResponse){
       // NSLog(@"%@",dictResponse);
        if ([[dictResponse valueForKey:@"MESSAGE"] isEqualToString:@"UNSUCCESS"]) {
            
        } else {
            aryComments = [dictResponse valueForKey:@"USER_DETAIL"];
            [tblCommentsList reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    lblTitleLabel = nil;
    [super viewDidUnload];
}


#pragma mark - UITextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }    
    return YES;
}
#pragma mark - Table Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [aryComments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Default Cell
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    
    NSMutableParagraphStyle *psytle = [[NSMutableParagraphStyle alloc]init];
    psytle.lineSpacing = 2.0f;
    
    NSDictionary *attribsBOLD = @{
                                  NSForegroundColorAttributeName:commentUserName,
                                  NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:13.0f],
                                  NSParagraphStyleAttributeName:psytle,
                                  };
    
    NSDictionary *attribsLIGHT = @{
                                   NSForegroundColorAttributeName: [UIColor darkGrayColor],
                                   NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:13.0f],
                                   NSParagraphStyleAttributeName:psytle,
                                   };
    
    NSString *strString = [NSString stringWithFormat:@"%@ %@", [[aryComments objectAtIndex:indexPath.row] valueForKey:@"vUserName"], [[aryComments objectAtIndex:indexPath.row] valueForKey:@"tComment"]];
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:strString
                                           attributes:attribsBOLD];
    
    NSRange redTextRange = [strString rangeOfString:[[aryComments objectAtIndex:indexPath.row] valueForKey:@"vUserName"]];
    [attributedText setAttributes:attribsBOLD range:redTextRange];
    
    NSRange lightTextRange = [strString rangeOfString:[[aryComments objectAtIndex:indexPath.row] valueForKey:@"tComment"]];
    [attributedText setAttributes:attribsLIGHT range:lightTextRange];
    
    CGSize size = [strString sizeWithFont:MyriadPro_Regular_13 constrainedToSize:CGSizeMake(290, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, [UIScreen mainScreen].bounds.size.width - 30, size.height + 10)];
    [lblMessage setAttributedText:attributedText];
    [lblMessage setLineBreakMode:NSLineBreakByWordWrapping];
    [lblMessage setNumberOfLines:0];
    [lblMessage sizeToFit];
    [cell addSubview:lblMessage];
    
    UILabel *lblLine = [[UILabel alloc] initWithFrame:CGRectMake(10, lblMessage.frame.origin.y + lblMessage.frame.size.height + 14, 300, 1)];
    lblLine.backgroundColor = [UIColor grayColor];
    [cell addSubview:lblLine];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *strString = [NSString stringWithFormat:@"%@ %@", [[aryComments objectAtIndex:indexPath.row] valueForKey:@"vUserName"], [[aryComments objectAtIndex:indexPath.row] valueForKey:@"tComment"]];
    
    CGSize size = [strString sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13.0f] constrainedToSize:CGSizeMake(290, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height + 30;
}

- (void)postComment {
    
    [WebServices urlStringInBG:[WSList iMediaID:[dictUserComment valueForKey:@"iMediaID"] tComment:tvCommentField.text] completionHandler:^(NSDictionary *dictRes) {
        /*[tvCommentField setText:@""];
        if ([[dictRes valueForKey:@"MESSAGE"] isEqualToString:@"SUCCESS"]){
           
            
            [aryComments insertObject:[[dictRes valueForKey:@"USER_DETAIL"] objectAtIndex:0]  atIndex:0];
            NSIndexPath *insertIndexPaths = [NSIndexPath indexPathForRow:0 inSection:0];
            NSArray *ar = [NSArray arrayWithObjects:insertIndexPaths, nil];
            [tblCommentsList beginUpdates];
            [tblCommentsList insertRowsAtIndexPaths:ar withRowAnimation:UITableViewRowAnimationFade];
            [tblCommentsList endUpdates];
            
        }*/
    }];
    
    [self btnBackTapped:nil];
}


- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSentMsgTapped:(id)sender {
    [self performSelector:@selector(postComment)];
}

@end
