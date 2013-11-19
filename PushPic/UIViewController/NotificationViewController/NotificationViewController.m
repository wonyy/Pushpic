//
//  NotificationViewController.m
//  PushPic
//
//  Created by KPIteng on 8/21/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import "NotificationViewController.h"
#import "AppConstant.h"
@interface NotificationViewController ()

@end

@implementation NotificationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [lblNoNotification setHidden:TRUE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [tblNotification reloadData];
}

- (void)viewDidUnload {
    lblNoNotification = nil;
    [super viewDidUnload];
}

- (void)loadAndReloadTableData {
    
   /*[WebServices urlStringInBG:[WSList getMessage] completionHandler:^(NSDictionary *dictJSON) {
        //[APPDEL hideWithGradient];
        if([[dictJSON valueForKey:@"MESSAGE"] isEqualToString:@"SUCCESS"])
        {            
            [lblNoNotification setHidden:TRUE];
            APPDEL.aryNotification = [dictJSON valueForKey:@"MESSAGE_DETAIL"];
            [tblNotification reloadData];
        }
        else if([[dictJSON valueForKey:@"MESSAGE"] isEqualToString:@"NOTHING FOUND"]){
            [lblNoNotification setHidden:FALSE];
        }
    }];
     [tblNotification reloadData];
    */
}

#pragma mark - Table Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   // NSLog(@" not count %d",APPDEL.aryNotification.count);
    return [APPDEL.aryNotification count];
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
    
    NSString *strString = [NSString stringWithFormat:@"%@ %@", [[APPDEL.aryNotification objectAtIndex:indexPath.row] valueForKey:@"name"], [[APPDEL.aryNotification objectAtIndex:indexPath.row] valueForKey:@"tMsg"]];
    
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:strString
                                           attributes:attribsBOLD];
    
    NSRange redTextRange = [strString rangeOfString:[[APPDEL.aryNotification objectAtIndex:indexPath.row] valueForKey:@"name"]];
    [attributedText setAttributes:attribsBOLD range:redTextRange];
    
    NSRange lightTextRange = [strString rangeOfString:[[APPDEL.aryNotification objectAtIndex:indexPath.row] valueForKey:@"tMsg"]];
    [attributedText setAttributes:attribsLIGHT range:lightTextRange];

    
    CGSize size = [strString sizeWithFont:MyriadPro_Regular_13 constrainedToSize:CGSizeMake(290, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, [UIScreen mainScreen].bounds.size.width - 30, size.height + 15)];
    [lblMessage setAttributedText:attributedText];
    [lblMessage setLineBreakMode:NSLineBreakByWordWrapping];
    [lblMessage setNumberOfLines:0];
    [lblMessage sizeToFit];
    
    UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(10, size.height + 25, 310, 20)];
    lblTime.backgroundColor = [UIColor clearColor];
    lblTime.textColor = [UIColor lightGrayColor];
    lblTime.font = MyriadPro_Regular_15;
    lblTime.text = [[APPDEL.aryNotification objectAtIndex:indexPath.row] valueForKey:@"TimeLeft"];
    
    
    [cell addSubview:lblMessage];
    [cell addSubview:lblTime];
    /*
    EGOImageView *ivThumb = [[EGOImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-70, 5, 60, 60)];
    [ivThumb setImageURL:[NSURL URLWithString:[[APPDEL.aryNotification objectAtIndex:indexPath.row] valueForKey:@"vMediaThumbName"]]];
    [ivThumb setContentMode:UIViewContentModeScaleAspectFit];
    [cell addSubview:ivThumb];
    */
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", APPDEL.aryNotification);
    
    NSDictionary *dictConetent = [APPDEL.aryNotification objectAtIndex: indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NOTIFY_GOTO object: dictConetent];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *strString = [NSString stringWithFormat:@"%@ %@", [[APPDEL.aryNotification objectAtIndex:indexPath.row] valueForKey:@"name"], [[APPDEL.aryNotification objectAtIndex:indexPath.row] valueForKey:@"tMsg"]];
    CGSize size = [strString sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13.0f] constrainedToSize:CGSizeMake(290, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height + 30 + 20;
}

@end
