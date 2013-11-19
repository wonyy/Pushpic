#import "twitterShareVC.h"
#import "AppConstant.h"
#import <Twitter/Twitter.h>


@implementation twitterShareVC

@synthesize twitterUserInfo, twitterAccount;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [lblTitleLabel setFont:MyriadPro_Bold_23];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    
    /// Search bar search button--------
    
    
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
    //------------------
    
    table.tableHeaderView=serachBar;
    
    
    //Reduce Width for searchbar
    
    
    UITextField *txfSearchField = [serachBar valueForKey:@"_searchField"];
    //    [txfSearchField setBackgroundColor:[UIColor whiteColor]];
    //    [txfSearchField setBorderStyle:UITextBorderStyleRoundedRect];
    //    txfSearchField.layer.borderWidth = 8.0f;
    //    txfSearchField.layer.cornerRadius = 10.0f;
    //    txfSearchField.layer.borderColor = [UIColor clearColor].CGColor;
    CGRect r = txfSearchField.frame;
    txfSearchField.frame = CGRectMake(r.origin.x, r.origin.y, r.size.height, r.size.width - 100);
    
    

//    [self performSelector:@selector(dataLoad) withObject:nil afterDelay:0.5];
    [self dataLoad];
}

- (void)viewDidUnload {
    lblTitleLabel = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataLoad {
    
    NSURL *userShow = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/followers/list.json"]];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[twitterUserInfo valueForKey:@"screen_name"], @"screen_name", nil];
    TWRequest *twitterRequest = [[TWRequest alloc] initWithURL:userShow
                                                    parameters:parameters
                                                 requestMethod:TWRequestMethodGET];
    [twitterRequest setAccount:twitterAccount];
    
    [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            //DisplayAlertWithTitle(@"Maptune",@"Sorry, we’re unable to get your Twitter user information. Please try again.");
        } else {
            NSError *jsonError = nil;
            
            
            id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
            NSLog(@"%@", jsonObject);
            
            NSArray *arrayUsers = [jsonObject objectForKey:@"users"];
            
            
            if (arrayUsers == nil) {
                
                numbersArray = [[NSMutableArray alloc] init];
               
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:@"y" forKey:@"select"];
                    [numbersArray addObject:dict];
               
            } else {
                
                numbersArray = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < [arrayUsers count]; i++) {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:[[arrayUsers objectAtIndex:i] valueForKey:@"name"] forKey:@"name"];
                    [dict setObject:@"y" forKey:@"select"];
                    [dict setObject:[[arrayUsers objectAtIndex:i] valueForKey:@"screen_name"] forKey:@"number"];
                    [numbersArray addObject:dict];
                }
            }
            
            [self reloadTableVew:numbersArray];

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];          
        }
    }];
}

- (void)reloadTableVew:(NSMutableArray *)arr {
    
    numberSelectArray = [[NSMutableArray alloc] initWithArray:arr];
    
    NSLog(@"friends array = %@", arr);
    
    //Reload Table
    if ([arr count] == 1)
        lblNavTitle.text = [NSString stringWithFormat:@"%i Follower", [arr count]];
    else
        lblNavTitle.text = [NSString stringWithFormat:@"%i Followers", [arr count]];
    
    
    
    if (selectedArray != nil) {
        [selectedArray removeAllObjects];
        selectedArray = nil;
    }
    
    selectedArray = [[NSMutableArray alloc]init];
    
    if (sections != nil) {
        [sections removeAllObjects];
        sections = nil;
    }
    
    sections = [[NSMutableDictionary alloc] init];
    
    BOOL found;
    
    for (NSDictionary *book in arr) {
        
        NSString *c = [[book objectForKey:@"name"] substringToIndex:1];
        
        found = NO;
        
        if (c == nil) {
            continue;
        }
        
        for (NSString *str in [sections allKeys]) {
            if ([str isEqualToString:c]) {
                found = YES;
            }
        }
        
        if (!found) {
            [sections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
    }
    
    // Loop again and sort the books into their respective keys
    for (NSDictionary *book in arr) {
        [[sections objectForKey:[[book objectForKey:@"name"] substringToIndex:1]] addObject:book];
    }
    
    
    
    
    // Sort each section array
    for (NSString *key in [sections allKeys]) {
        [[sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    }
    
   // NSLog(@"%@",sections);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue ] >= 7.0) {
        //table.sectionIndexBackgroundColor = [UIColor clearColor];
        table.sectionIndexColor = [UIColor whiteColor];
        table.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue ] >= 6.0) {
        table.sectionIndexColor = [UIColor whiteColor];
        table.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    }
    
    table.dataSource = self;
    table.delegate = self;
    // table.backgroundColor = [UIColor blackColor];
    [table reloadData];
    
    
   // NSLog(@"%@",sections);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //NSLog(@"Key :%@",[sections allKeys]);
    return [[sections allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 15, 200, 2)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iPhoneNavBar@2x.png"]];
    
    
    // UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(5, 20, 245, 1.5)];
    //  view2.backgroundColor = [UIColor blackColor];
    //  [view addSubview:view2];
    
    UILabel *lblUserName = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 50, 20)];
    lblUserName.backgroundColor = [UIColor clearColor];
    lblUserName.font = [UIFont boldSystemFontOfSize:15];
    lblUserName.textColor = [UIColor whiteColor];
    lblUserName.text = [[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    [view addSubview:lblUserName];
    
    return view;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // if(cell == nil){
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    // }
    
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 320, 20)];
    lblName.font = [UIFont boldSystemFontOfSize:13];
    lblName.textColor = [UIColor whiteColor];
    lblName.text = [[[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"name"];
    lblName.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:lblName];
     
    UIButton *favButton = [[UIButton alloc] init];
    
    if ([[[[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"select"] isEqualToString:@"y"]) {
        
        [favButton setImage:[UIImage imageNamed:@"selectedbutton.png"] forState:UIControlStateNormal];
        [favButton setImage:[UIImage imageNamed:@"selectedbutton.png"] forState:UIControlStateHighlighted];
        [favButton setImage:[UIImage imageNamed:@"selectedbutton.png"] forState:UIControlStateSelected];
        
    } else {
        
        [favButton setImage:[UIImage imageNamed:@"unselectedbutton.png"] forState:UIControlStateNormal];
        [favButton setImage:[UIImage imageNamed:@"unselectedbutton.png"] forState:UIControlStateHighlighted];
        [favButton setImage:[UIImage imageNamed:@"unselectedbutton.png"] forState:UIControlStateSelected];
        
    }
    
    //    [favButton addTarget:self action:@selector(clickOnSelect:)
    //      forControlEvents:UIControlEventTouchUpInside];
    [favButton setFrame:CGRectMake(5, 8, 25  , 25)];
    favButton.tag = 1000 + indexPath.row;
    favButton.userInteractionEnabled = FALSE;
    [cell.contentView addSubview:favButton];
    
    UILabel *lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
    lblLine.backgroundColor = [UIColor grayColor];
    [cell addSubview:lblLine];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name = [[[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    for (int i = 0; i < [numberSelectArray count]; i++) {
        
        if ([[[numberSelectArray objectAtIndex:i] valueForKey:@"name"] isEqualToString:name]) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[[numberSelectArray objectAtIndex:i] valueForKey:@"name"] forKey:@"name"];
            [dict setObject:[[numberSelectArray objectAtIndex:i] valueForKey:@"number"] forKey:@"number"];
            
            if ([[[numberSelectArray objectAtIndex:i] valueForKey:@"select"] isEqualToString:@"y"]) {
                [dict setObject:@"n" forKey:@"select"];
            } else {
                [dict setObject:@"y" forKey:@"select"];
            }
            
            [numberSelectArray replaceObjectAtIndex:i withObject:dict];
            break;
        }
    }
    
    /* NSIndexPath *myIP = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];//Indexpath for row which want to reload
     
     [tableView canCancelContentTouches];
     [tableView beginUpdates];
     [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:myIP]
     withRowAnimation:UITableViewRowAnimationNone];//You can change animation option.
     [tableView endUpdates];*/
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadTableVew:numberSelectArray];
    });
    
    
    for (int i = 0; i < [numbersArray count]; i++) {
        
        if ([[[numbersArray objectAtIndex:i] valueForKey:@"name"] isEqualToString:name]) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[[numbersArray objectAtIndex:i] valueForKey:@"name"] forKey:@"name"];
            [dict setObject:[[numbersArray objectAtIndex:i] valueForKey:@"number"] forKey:@"number"];
            
            if ([[[numbersArray objectAtIndex:i] valueForKey:@"select"] isEqualToString:@"y"]) {
                [dict setObject:@"n" forKey:@"select"];
            } else {
                [dict setObject:@"y" forKey:@"select"];
            }
            
            [numbersArray replaceObjectAtIndex:i withObject:dict];
            break;
        }
    }
    
   // NSLog(@"%@",numberSelectArray);
    
    BOOL notSelectOne = YES;
    for (int i = 0; i < [numberSelectArray count]; i++) {
        if ([[[numberSelectArray objectAtIndex:i] valueForKey:@"select"] isEqualToString:@"y"]) {
            notSelectOne = NO;
            break;
        }
    }
    
    
    
    if (notSelectOne && [numberSelectArray count] != 1) {
        btnSelectAll.selected = FALSE;
//        [btnSelectAll setTitle:@"Select All" forState:UIControlStateNormal];
//        [btnSelectAll setTitle:@"Select All" forState:UIControlStateHighlighted];
//        [btnSelectAll setTitle:@"Select All" forState:UIControlStateSelected];
        
        [btnSelectAll setBackgroundImage:[UIImage imageNamed:@"deselectAll@2x"] forState:UIControlStateNormal];
        [btnSelectAll setBackgroundImage:[UIImage imageNamed:@"deselectAll@2x"] forState:UIControlStateHighlighted];
        [btnSelectAll setBackgroundImage:[UIImage imageNamed:@"deselectAll@2x"] forState:UIControlStateSelected];
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int i = 0; i < [numberSelectArray count]; i++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[[numberSelectArray objectAtIndex:i] valueForKey:@"name"] forKey:@"name"];
            [dict setObject:[[numberSelectArray objectAtIndex:i] valueForKey:@"number"] forKey:@"number"];
            [dict setObject:@"y" forKey:@"select"];
            [arr addObject:dict];
        }
        
        if (numberSelectArray) {
            [numberSelectArray removeAllObjects];
            numberSelectArray = nil;
        }
        
        numberSelectArray = [[NSMutableArray alloc] initWithArray:arr];
        [self reloadTableVew:numberSelectArray];
        
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        for (int i = 0; i < [numbersArray count]; i++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[[numbersArray objectAtIndex:i] valueForKey:@"name"] forKey:@"name"];
            [dict setObject:[[numbersArray objectAtIndex:i] valueForKey:@"number"] forKey:@"number"];
            [dict setObject:@"y" forKey:@"select"];
            [arr1 addObject:dict];
        }
        
        if (numbersArray) {
            [numbersArray removeAllObjects];
            numbersArray = nil;
        }
        
        numbersArray = [[NSMutableArray alloc] initWithArray:arr1];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [serachBar resignFirstResponder];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    [self performSelector:@selector(searchText) withObject:nil afterDelay:0.3];
    
    return TRUE;
}

- (void)searchText {
    
    if ([serachBar.text isEqualToString:@""]) {
        [self reloadTableVew:numbersArray];
    } else {
        NSMutableArray* containsAnother2 = [NSMutableArray array];
        
        for (int i = 0; i < [numbersArray count]; i++) {
            NSString *item = [[numbersArray objectAtIndex:i] valueForKey:@"name"];
            NSRange range = [item rangeOfString:serachBar.text options:NSCaseInsensitiveSearch];
            
            if (range.length > 0) {
                [containsAnother2 addObject:[numbersArray objectAtIndex:i]];
            }
        }
        
        [self reloadTableVew:containsAnother2];
    }
}


- (IBAction)selectAll: (UIButton *)sender {
    if (sender.selected) {
        sender.selected = FALSE;
        //        [sender setTitle:@"Deselect All" forState:UIControlStateNormal];
        //        [sender setTitle:@"Deselect All" forState:UIControlStateHighlighted];
        //        [sender setTitle:@"Deselect All" forState:UIControlStateSelected];
        
        [sender setBackgroundImage:[UIImage imageNamed:@"deselectAll@2x"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"deselectAll@2x"] forState:UIControlStateHighlighted];
        [sender setBackgroundImage:[UIImage imageNamed:@"deselectAll@2x"] forState:UIControlStateSelected];
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [numberSelectArray count]; i++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[[numberSelectArray objectAtIndex:i] valueForKey:@"name"] forKey:@"name"];
            [dict setObject:[[numberSelectArray objectAtIndex:i] valueForKey:@"number"] forKey:@"number"];
            [dict setObject:@"y" forKey:@"select"];
            [arr addObject:dict];
        }
        
        if (numberSelectArray)
        {
            [numberSelectArray removeAllObjects];
            numberSelectArray = nil;
        }
        numberSelectArray = [[NSMutableArray alloc] initWithArray:arr];
        [self reloadTableVew:numberSelectArray];
        
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        for (int i = 0; i < [numbersArray count]; i++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[[numbersArray objectAtIndex:i] valueForKey:@"name"] forKey:@"name"];
            [dict setObject:[[numbersArray objectAtIndex:i] valueForKey:@"number"] forKey:@"number"];
            [dict setObject:@"y" forKey:@"select"];
            [arr1 addObject:dict];
        }
        
        if (numbersArray) {
            [numbersArray removeAllObjects];
            numbersArray = nil;
        }
        
        numbersArray = [[NSMutableArray alloc] initWithArray:arr1];
    } else {
        sender.selected = TRUE;
        //        [sender setTitle:@"Select All" forState:UIControlStateNormal];
        //        [sender setTitle:@"Select All" forState:UIControlStateHighlighted];
        //        [sender setTitle:@"Select All" forState:UIControlStateSelected];
        
        [sender setBackgroundImage:[UIImage imageNamed:@"selectAll@2x"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"selectAll@2x"] forState:UIControlStateHighlighted];
        [sender setBackgroundImage:[UIImage imageNamed:@"selectAll@2x"] forState:UIControlStateSelected];
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [numberSelectArray count]; i++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[[numberSelectArray objectAtIndex:i] valueForKey:@"name"] forKey:@"name"];
            [dict setObject:[[numberSelectArray objectAtIndex:i] valueForKey:@"number"] forKey:@"number"];
            [dict setObject:@"n" forKey:@"select"];
            [arr addObject:dict];
        }
        
        if (numberSelectArray) {
            [numberSelectArray removeAllObjects];
            numberSelectArray = nil;
        }
        
        numberSelectArray = [[NSMutableArray alloc] initWithArray:arr];
        [self reloadTableVew:numberSelectArray];
        
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [numbersArray count]; i++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[[numbersArray objectAtIndex:i] valueForKey:@"name"] forKey:@"name"];
            [dict setObject:[[numbersArray objectAtIndex:i] valueForKey:@"number"] forKey:@"number"];
            [dict setObject:@"n" forKey:@"select"];
            [arr1 addObject:dict];
        }
        
        if (numbersArray) {
            [numbersArray removeAllObjects];
            numbersArray = nil;
        }
        
        numbersArray = [[NSMutableArray alloc] initWithArray:arr1];
    }
}

- (IBAction)done:(UIButton *) sender {
    
    BOOL notSelectOne = NO;
    
    for (int i = 0; i < [numberSelectArray count]; i++) {
        if ([[[numberSelectArray objectAtIndex:i] valueForKey:@"select"] isEqualToString:@"y"]) {
            notSelectOne = YES;
            break;
        }
    }
    
    
    if (!notSelectOne && [numberSelectArray count] == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if ([numberSelectArray count] == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        //Code To send Message
        index = 0;
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Loading...";
        [self startMessageSend];
    }
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startMessageSend {
    
    
    if (index == [numberSelectArray count]) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    if ([[[numberSelectArray objectAtIndex:index] valueForKey:@"select"] isEqualToString:@"y"]) {
        [self sendMessage];
    } else {
        index++;
        [self performSelector:@selector(startMessageSend) withObject:nil afterDelay:0.5];
    }
}

- (void)sendMessage {
    
    NSURL *userShow = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/direct_messages/new.json"]];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[numberSelectArray objectAtIndex:index] valueForKey:@"number"], @"screen_name", nil];
    TWRequest *twitterRequest = [[TWRequest alloc] initWithURL:userShow
                                                    parameters:parameters
                                                 requestMethod:TWRequestMethodPOST];
    [twitterRequest setAccount:twitterAccount];
    
    [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            index++;
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(startMessageSend) withObject:nil afterDelay:0.5];
            });
            
        } else {
            NSError *jsonError = nil;
            index++;
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(startMessageSend) withObject:nil afterDelay:0.5];
            });
        }
    }];
    
}

@end
