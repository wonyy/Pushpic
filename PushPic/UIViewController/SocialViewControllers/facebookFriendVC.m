
#import "facebookFriendVC.h"
#import "AccountClass.h"
#import <Accounts/Accounts.h>
#import "ASIFormDataRequest.h"
#import "AppConstant.h"
@implementation facebookFriendVC

- (void)forfirends {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    aryFriendList = [[NSMutableArray alloc]init];
    
    ///Search bar search button--------
    UITextField *searchField = nil;
    
    for (UIView *subview in serachBar.subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            searchField = (UITextField *)subview;
            break;
        }
    }
    if (searchField) {
        searchField.enablesReturnKeyAutomatically = NO;
    }
    table.tableHeaderView = serachBar;
    [ACCOUNTSHAREINS getFacebookUsersList:@"KPIteng" completionHandler:^(NSMutableArray *aryUsers) {
        
        
        if ([aryUsers count] == 0)
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                showAlertDelNil(@"Please go to Settings->Facebook and login in!");
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            facebookaccount = [aryUsers lastObject];
            [ACCOUNTSHAREINS getFriendList:[aryUsers lastObject] completionHandler:^(NSMutableArray *aryFrdsList) {
                aryFriendList = [[NSMutableArray alloc] initWithArray:aryFrdsList];
                
               // NSLog(@"%@",aryFriendList);
                
                [UIView animateWithDuration:1.0 animations:^{
                    
                } completion:^(BOOL finished) {
                    [table reloadData];
                }];
            }];
        }
    }];
    
    [lblTitleLabel setFont:MyriadPro_Bold_23];
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

#pragma mark - Table Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [aryFriendList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Default Cell
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 320, 20)];
    lblName.font = [UIFont boldSystemFontOfSize:13];
    lblName.textColor = [UIColor whiteColor];
    lblName.text = [[aryFriendList objectAtIndex:indexPath.row] valueForKey:@"first_name"];
    lblName.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:lblName];

    UILabel *lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
    lblLine.backgroundColor = [UIColor grayColor];
    [cell addSubview:lblLine];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - Touch Actions

- (IBAction)btnBackTapped:(id)sender {
    
    NSDictionary *parameters = @{@"message": @"this is a ressdource picture 2", ACFacebookAppIdKey: @"201225786706583", @"100003713236058":@"from", @"100004399000160":@"to"};
    
    SLRequest *facebookRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:[NSURL URLWithString:@"https://graph.facebook.com/feed"]
                                                       parameters:parameters];
    
    NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"iconMessage"]);
    
    [facebookRequest addMultipartData:data
                             withName:@"media"
                                 type:@"image/jpeg"
                             filename:@"msg.jpg"];
    
    facebookRequest.account = facebookaccount;
    
    [facebookRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
    {
         if (error) {
         }
         else
         {
            // NSLog(@"Post successful");
             NSString *dataString = [[NSString alloc] initWithData:responseData encoding:NSStringEncodingConversionAllowLossy];
             //NSLog(@"Response Data: %@", dataString);
         }
     }];
}

@end
