
#import "contactNumber.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <QuartzCore/QuartzCore.h>
#import "AppConstant.h"
@implementation contactNumber
@synthesize strPhone;

- (void)viewDidLoad
{
    [super viewDidLoad];

     [lblNavTitle setFont:MyriadPro_Bold_23];
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
    txfSearchField.frame = CGRectMake(r.origin.x, r.origin.y, r.size.height, r.size.width-100);
    
    
    if ([strPhone isEqualToString:@"yes"])
    {
        [self loadContactRecords];
    }
    else
    {
        [self loadContactEmail];
    }
}
-(void)loadContactEmail{
    
    
    numbersArray = [[NSMutableArray alloc] init];
    
    if (ABAddressBookRequestAccessWithCompletion != NULL)
    {
        //6.0
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
        {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
                                                     {
                                                         CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
                                                         CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBookRef);
                                                         
                                                         for(int i = 0; i < numberOfPeople; i++)
                                                         {
                                                             ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
                                                             
                                                             NSString *name = @"";
                                                             NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
                                                             if(firstName == nil || firstName==NULL)
                                                             {
                                                                 //firstName = @"No name";
                                                                 
                                                             }
                                                             else
                                                             {
                                                                 name = [NSString stringWithFormat:@"%@",firstName];
                                                             }
                                                             
                                                             
                                                             NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
                                                             if(lastName == nil || lastName==NULL)
                                                             {
                                                                 //firstName = @"No name";
                                                             }
                                                             else
                                                             {
                                                                 name = [NSString stringWithFormat:@"%@ %@",name,lastName];
                                                             }
                                                             
                                                             
                                                             if ([name isEqualToString:@""])
                                                             {
                                                                 name = @"No Name";
                                                             }
                                                             
                                                             
                                                             
                                                             //fetch multiple phone nos.
                                                             NSString *number = @"";
                                                             ABMultiValueRef multi = (__bridge ABMultiValueRef)((__bridge NSString *)(ABRecordCopyValue(person, kABPersonEmailProperty)));
                                                             for (CFIndex j=0; j < ABMultiValueGetCount(multi); j++)
                                                             {
                                                                 NSString* phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multi, j);
                                                                 number = phone;
                                                             }
                                                             
                                                             if (![number isEqualToString:@""])
                                                             {
                                                                 NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                                                                 [dict setObject:name forKey:@"name"];
                                                                 [dict setObject:number forKey:@"number"];
                                                                 [dict setObject:@"y" forKey:@"select"];
                                                                 
                                                                 [numbersArray addObject:dict];
                                                             }
                                                         }
                                                         
                                                     });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
        {
            CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
            CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBookRef);
            
            for(int i = 0; i < numberOfPeople; i++)
            {
                ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
                
                NSString *name = @"";
                NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
                if(firstName == nil || firstName==NULL)
                {
                    //firstName = @"No name";
                    
                }
                else
                {
                    name = [NSString stringWithFormat:@"%@",firstName];
                }
                
                
                NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
                if(lastName == nil || lastName==NULL)
                {
                    //firstName = @"No name";
                }
                else
                {
                    name = [NSString stringWithFormat:@"%@ %@",name,lastName];
                }
                
                
                if ([name isEqualToString:@""])
                {
                    name = @"No Name";
                }
                
                
                
                //fetch multiple phone nos.
                NSString *number = @"";
                ABMultiValueRef multi = (__bridge ABMultiValueRef)((__bridge NSString *)(ABRecordCopyValue(person, kABPersonEmailProperty)));
                for (CFIndex j=0; j < ABMultiValueGetCount(multi); j++)
                {
                    NSString* phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multi, j);
                    number = phone;
                }
                
                if (![number isEqualToString:@""])
                {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:name forKey:@"name"];
                    [dict setObject:number forKey:@"number"];
                    [dict setObject:@"y" forKey:@"select"];
                    
                    [numbersArray addObject:dict];
                }
            }
            
        }
    }
    else
    {
        
        ABAddressBookRef addressBook = ABAddressBookCreate();
        NSArray *people = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
        for(id person in people)
        {
            NSString *name = @"";
            NSString *firstName = (__bridge NSString *)(ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonFirstNameProperty));
            if(firstName == nil || firstName==NULL)
            {
                //firstName = @"No name";
            }
            else
            {
                name = [NSString stringWithFormat:@"%@",firstName];
            }
            
            NSString *lastName = (__bridge NSString *)(ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonLastNameProperty));
            if(lastName == nil || lastName==NULL)
            {
                //firstName = @"No name";
            }
            else
            {
                name = [NSString stringWithFormat:@"%@ %@",name,lastName];
            }
            if ([name isEqualToString:@""])
            {
                name = @"No Name";
            }
            
            
            //fetch multiple phone nos.
            NSString *number = @"";
            ABMultiValueRef multi = ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonEmailProperty);
            for (CFIndex j=0; j < ABMultiValueGetCount(multi); j++)
            {
                NSString* phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multi, j);
                number = phone;
            }
            
            if (![number isEqualToString:@""])
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:name forKey:@"name"];
                [dict setObject:number forKey:@"number"];
                [dict setObject:@"y" forKey:@"select"];
                
                [numbersArray addObject:dict];
            }
            
            
        }
    }
    [self reloadTableVew:numbersArray];
}
-(void)loadContactRecords{
    
    
    numbersArray = [[NSMutableArray alloc] init];
    
    if (ABAddressBookRequestAccessWithCompletion != NULL)
    {
        //6.0
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
        {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
            {
                CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
                CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBookRef);
                
                for(int i = 0; i < numberOfPeople; i++)
                {
                    ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
                      
                    NSString *name = @"";
                    NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
                    if(firstName == nil || firstName==NULL)
                    {
                        //firstName = @"No name";
                        
                    }
                    else
                    {
                        name = [NSString stringWithFormat:@"%@",firstName];
                    }
                    
                    
                    NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
                    if(lastName == nil || lastName==NULL)
                    {
                        //firstName = @"No name";
                    }
                    else
                    {
                        name = [NSString stringWithFormat:@"%@ %@",name,lastName];
                    }
                    
                    
                    if ([name isEqualToString:@""])
                    {
                        name = @"No Name";
                    }
                    
                    
                    
                    //fetch multiple phone nos.
                    NSString *number = @"";
                    ABMultiValueRef multi = (__bridge ABMultiValueRef)((__bridge NSString *)(ABRecordCopyValue(person, kABPersonPhoneProperty)));
                    for (CFIndex j=0; j < ABMultiValueGetCount(multi); j++)
                    {
                        NSString* phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multi, j);
                        number = phone;
                    }
                    
                    if (![number isEqualToString:@""])
                    {
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                        [dict setObject:name forKey:@"name"];
                        [dict setObject:number forKey:@"number"];
                        [dict setObject:@"y" forKey:@"select"];
                        
                        [numbersArray addObject:dict];
                    }
                }
                
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
            CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBookRef);
            
            for (int i = 0; i < numberOfPeople; i++)
            {
                ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
                
                NSString *name = @"";
                NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
                
                if (firstName == nil || firstName == NULL) {
                    //firstName = @"No name";
                    
                } else {
                    name = [NSString stringWithFormat:@"%@", firstName];
                }
                
                
                NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
                
                if (lastName == nil || lastName == NULL) {
                    //firstName = @"No name";
                } else {
                    name = [NSString stringWithFormat:@"%@ %@", name, lastName];
                }
                
                
                if ([name isEqualToString:@""]) {
                    name = @"No Name";
                }
                
                //fetch multiple phone nos.
                NSString *number = @"";
                ABMultiValueRef multi = (__bridge ABMultiValueRef)((__bridge NSString *)(ABRecordCopyValue(person, kABPersonPhoneProperty)));
                for (CFIndex j = 0; j < ABMultiValueGetCount(multi); j++) {
                    NSString* phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multi, j);
                    number = phone;
                }
                
                if (![number isEqualToString:@""]) {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:name forKey:@"name"];
                    [dict setObject:number forKey:@"number"];
                    [dict setObject:@"y" forKey:@"select"];
                    
                    [numbersArray addObject:dict];
                }
            }

        }
    } else {
        
        ABAddressBookRef addressBook = ABAddressBookCreate();
        NSArray *people = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
        for (id person in people) {
            NSString *name = @"";
            NSString *firstName = (__bridge NSString *)(ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonFirstNameProperty));
            if (firstName == nil || firstName == NULL) {
                //firstName = @"No name";
            } else {
                name = [NSString stringWithFormat:@"%@",firstName];
            }
            
            NSString *lastName = (__bridge NSString *)(ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonLastNameProperty));
            if (lastName == nil || lastName == NULL) {
                //firstName = @"No name";
            } else {
                name = [NSString stringWithFormat:@"%@ %@", name, lastName];
            }
            
            if ([name isEqualToString:@""]) {
                name = @"No Name";
            }
            
            
            //fetch multiple phone nos.
            NSString *number = @"";
            ABMultiValueRef multi = ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonPhoneProperty);
            
            for (CFIndex j = 0; j < ABMultiValueGetCount(multi); j++) {
                NSString* phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multi, j);
                number = phone;
            }
            
            if (![number isEqualToString:@""])
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:name forKey:@"name"];
                [dict setObject:number forKey:@"number"];
                [dict setObject:@"y" forKey:@"select"];
            
                [numbersArray addObject:dict];
            }
        }
    }
    [self reloadTableVew:numbersArray];
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
        
        if (numberSelectArray) {
            [numberSelectArray removeAllObjects];
            numberSelectArray = nil;
        }
        
        numberSelectArray = [[NSMutableArray alloc] initWithArray:arr];
        [self reloadTableVew:numberSelectArray];
        
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [numbersArray count]; i++)
        {
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

- (IBAction)done:(UIButton *)sender {
    
    
    BOOL notSelectOne = NO;
    
    for (int i = 0; i < [numberSelectArray count]; i++) {
        if ([[[numberSelectArray objectAtIndex:i] valueForKey:@"select"] isEqualToString:@"y"]) {
            notSelectOne = YES;
            break;
        }
    }
    
    if (!notSelectOne && [numberSelectArray count] != 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if ([numberSelectArray count] == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if ([strPhone isEqualToString:@"yes"]) {
            [self showSMSPicker];
        } else {
            [self showMailPicker];
        }
    }
    
    /*
    BOOL notSelectOne = YES;
    for (int i=0; i<[numberSelectArray count]; i++)
    {
        if ([[[numberSelectArray objectAtIndex:i] valueForKey:@"select"] isEqualToString:@"y"])
        {
            notSelectOne = NO;
            break;
        }
    }
    
    
    if (notSelectOne && [numberSelectArray count]!=1)
    {
        btnSelectAll.selected = FALSE;
        [btnSelectAll setTitle:@"Select All" forState:UIControlStateNormal];
        [btnSelectAll setTitle:@"Select All" forState:UIControlStateHighlighted];
        [btnSelectAll setTitle:@"Select All" forState:UIControlStateSelected];
        
        
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int i=0; i<[numberSelectArray count]; i++)
        {
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
        for (int i=0; i<[numbersArray count]; i++)
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[[numbersArray objectAtIndex:i] valueForKey:@"name"] forKey:@"name"];
            [dict setObject:[[numbersArray objectAtIndex:i] valueForKey:@"number"] forKey:@"number"];
            [dict setObject:@"y" forKey:@"select"];
            [arr1 addObject:dict];
        }
        
        if (numbersArray)
        {
            [numbersArray removeAllObjects];
            numbersArray = nil;
        }
        numbersArray = [[NSMutableArray alloc] initWithArray:arr1];
    }*/
    
}

- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [serachBar resignFirstResponder];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
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




#pragma mark -
#pragma mark Table
- (void)reloadTableVew:(NSMutableArray *)arr{
    
    numberSelectArray = [[NSMutableArray alloc] initWithArray:arr];
    
    //Reload Table
    if ([arr count] == 1)
        lblNavTitle.text = [NSString stringWithFormat:@"%i Contact", [arr count]];
    else
        lblNavTitle.text = [NSString stringWithFormat:@"%i Contacts", [arr count]];

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
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue ] >= 7.0)
    {
        //table.sectionIndexBackgroundColor = [UIColor clearColor];
        table.sectionIndexColor = [UIColor whiteColor];
        table.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue ] >= 6.0) {
        table.sectionIndexColor = [UIColor whiteColor];
        table.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    }
    
    table.dataSource = self;
    table.delegate = self;
    // table.backgroundColor = [UIColor blackColor];
    [table reloadData];

    
   // NSLog(@"%@",sections);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
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
    
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 320, 20)];
    lblName.font = [UIFont boldSystemFontOfSize:13];
    lblName.textColor = [UIColor whiteColor];
    lblName.text = [[[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"name"];
    lblName.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:lblName];
    
    UILabel *lblNumber = [[UILabel alloc] initWithFrame:CGRectMake(45, 22, 320, 20)];
    lblNumber.font = [UIFont systemFontOfSize:12];
    lblNumber.textColor = [UIColor grayColor];
    lblNumber.text = [[[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"number"];
    lblNumber.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:lblNumber];

    

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
    favButton.tag = 1000+indexPath.row;
    favButton.userInteractionEnabled = FALSE;
    [cell.contentView addSubview:favButton];
    
    UILabel *lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
    lblLine.backgroundColor = [UIColor grayColor];
    [cell addSubview:lblLine];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = [[[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"name"];
    NSString *number= [[[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"number"];
    
    for (int i=0; i<[numberSelectArray count]; i++)
    {
        
        if ([[[numberSelectArray objectAtIndex:i] valueForKey:@"name"] isEqualToString:name] &&
            [[[numberSelectArray objectAtIndex:i] valueForKey:@"number"] isEqualToString:number])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[[numberSelectArray objectAtIndex:i] valueForKey:@"name"] forKey:@"name"];
            [dict setObject:[[numberSelectArray objectAtIndex:i] valueForKey:@"number"] forKey:@"number"];
            
            if ([[[numberSelectArray objectAtIndex:i] valueForKey:@"select"] isEqualToString:@"y"])
            {
               [ dict setObject:@"n" forKey:@"select"];
            }
            else
            {
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
    
    
    for (int i=0; i<[numbersArray count]; i++)
    {

        if ([[[numbersArray objectAtIndex:i] valueForKey:@"name"] isEqualToString:name] &&
            [[[numbersArray objectAtIndex:i] valueForKey:@"number"] isEqualToString:number])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[[numbersArray objectAtIndex:i] valueForKey:@"name"] forKey:@"name"];
            [dict setObject:[[numbersArray objectAtIndex:i] valueForKey:@"number"] forKey:@"number"];
            
            if ([[[numbersArray objectAtIndex:i] valueForKey:@"select"] isEqualToString:@"y"])
            {
                [dict setObject:@"n" forKey:@"select"];
            }
            else
            {
                [dict setObject:@"y" forKey:@"select"];
            }
            [numbersArray replaceObjectAtIndex:i withObject:dict];
            break;
        }
    }
    
   // NSLog(@"%@",numberSelectArray);
    
    BOOL notSelectOne = YES;
    for (int i=0; i<[numberSelectArray count]; i++)
    {
        if ([[[numberSelectArray objectAtIndex:i] valueForKey:@"select"] isEqualToString:@"y"])
        {
            notSelectOne = NO;
            break;
        }
    }
    
    
    
    if (notSelectOne && [numberSelectArray count]!=1)
    {
        btnSelectAll.selected = FALSE;
//        [btnSelectAll setTitle:@"Select All" forState:UIControlStateNormal];
//        [btnSelectAll setTitle:@"Select All" forState:UIControlStateHighlighted];
//        [btnSelectAll setTitle:@"Select All" forState:UIControlStateSelected];
        
        [btnSelectAll setBackgroundImage:[UIImage imageNamed:@"selectAll@2x"] forState:UIControlStateNormal];
        [btnSelectAll setBackgroundImage:[UIImage imageNamed:@"selectAll@2x"] forState:UIControlStateHighlighted];
        [btnSelectAll setBackgroundImage:[UIImage imageNamed:@"selectAll@2x"] forState:UIControlStateSelected];
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int i=0; i<[numberSelectArray count]; i++)
        {
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
        for (int i=0; i<[numbersArray count]; i++)
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[[numbersArray objectAtIndex:i] valueForKey:@"name"] forKey:@"name"];
            [dict setObject:[[numbersArray objectAtIndex:i] valueForKey:@"number"] forKey:@"number"];
            [dict setObject:@"y" forKey:@"select"];
            [arr1 addObject:dict];
        }
        
        if (numbersArray)
        {
            [numbersArray removeAllObjects];
            numbersArray = nil;
        }
        numbersArray = [[NSMutableArray alloc] initWithArray:arr1];
    }
}

#pragma mark -
#pragma mark Email
-(IBAction)showMailPicker {
	// The MFMailComposeViewController class is only available in iPhone OS 3.0 or later.
	// So, we must verify the existence of the above class and provide a workaround for devices running
	// earlier versions of the iPhone OS.
	// We display an email composition interface if MFMailComposeViewController exists and the device
	// can send emails.	Display feedback message, otherwise.
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
	if (mailClass != nil) {
        //[self displayMailComposerSheet];
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail]) {
			[self displayMailComposerSheet];
		}
		else
        {
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle: @"Device not configured to send mail."
                                                             message:@""
                                                            delegate:nil
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"OK", nil];
            [alert1 show];
		}
	}
	else
    {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle: @"Device not configured to send mail."
                                                         message:@""
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil];
        [alert1 show];
	}
}
-(void)displayMailComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	[picker setSubject:@"Pushpic"];
	
	
    
    NSMutableArray *number =[[NSMutableArray alloc] init];
    for (int i=0; i<[numberSelectArray count]; i++)
    {
        if ([[[numberSelectArray objectAtIndex:i] valueForKey:@"select"] isEqualToString:@"y"])
        {
            [number addObject:[[numberSelectArray objectAtIndex:i] valueForKey:@"number"]];
        }
        
    }
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithArray:number];
	NSArray *ccRecipients = [NSArray arrayWithObject:@""];
	NSArray *bccRecipients = [NSArray arrayWithObject:@""];
	
	[picker setToRecipients:toRecipients];
	[picker setCcRecipients:ccRecipients];
	[picker setBccRecipients:bccRecipients];
	
	// Attach an image to the email
	[picker setSubject:@"PushPic"];
	// Fill out the email body text
	NSString *emailBody = [NSString stringWithFormat:@"<Application Link>"];
	[picker setMessageBody:emailBody isHTML:NO];
	
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch (result)
	{
		case MFMailComposeResultCancelled:
		{
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle: @"Messsage Canceled"
                                                             message:@""
                                                            delegate:nil
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"OK", nil];
            [alert1 show];
		}   break;
		case MFMailComposeResultSaved:
		{
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle: @"Messsage saved"
                                                             message:@""
                                                            delegate:nil
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"OK", nil];
            [alert1 show];
		}	break;
		case MFMailComposeResultSent:
		{
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle: @"Messsage sent"
                                                             message:@""
                                                            delegate:nil
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"OK", nil];
            [alert1 show];
		}	break;
		case MFMailComposeResultFailed:
		{
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle: @"Messsage failed"
                                                             message:@""
                                                            delegate:nil
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"OK", nil];
            [alert1 show];
		}	break;
		default:
		{
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle: @"Messsage not sent"
                                                             message:@""
                                                            delegate:nil
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"OK", nil];
            [alert1 show];
		}	break;
	}
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
#pragma mark SMS
-(void)showSMSPicker{
    
    //	The MFMessageComposeViewController class is only available in iPhone OS 4.0 or later.
    //	So, we must verify the existence of the above class and log an error message for devices
    //		running earlier versions of the iPhone OS. Set feedbackMsg if device doesn't support
    //		MFMessageComposeViewController API.
	Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	
	if (messageClass != nil) {
		// Check whether the current device is configured for sending SMS messages
		if ([messageClass canSendText])
        {
			[self displaySMSComposerSheet];
		}
		else
        {
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle: @"Device not configured to send SMS."
                                                             message:@""
                                                            delegate:nil
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"OK", nil];
            [alert1 show];
		}
	}
	else
    {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle: @"Device not configured to send SMS."
                                                         message:@""
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil];
        [alert1 show];        
	}
}
-(void)displaySMSComposerSheet{
    
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    
    NSMutableArray *number =[[NSMutableArray alloc] init];
    for (int i=0; i<[numberSelectArray count]; i++)
    {
        if ([[[numberSelectArray objectAtIndex:i] valueForKey:@"select"] isEqualToString:@"y"])
        {
            [number addObject:[[numberSelectArray objectAtIndex:i] valueForKey:@"number"]];
        }

    }
   // NSLog(@"%@",number);
    
    picker.recipients = [NSArray arrayWithArray:number];
	picker.messageComposeDelegate = self;
	picker.body = [NSString stringWithFormat:@"<Applcation Link>"];
    [self presentViewController:picker animated:YES completion:nil];
}

// Dismisses the message composition interface when users tap Cancel or Send. Proceeds to update the
// feedback message field with the result of the operation.
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
	
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MessageComposeResultCancelled:
        {
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle: @"SMS sending canceled"
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert1 show];
        }
			break;
		case MessageComposeResultSent:
        {
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle: @"SMS sent"
                                                             message:@""
                                                            delegate:nil
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"OK", nil];
            [alert1 show];
        }
			break;
		case MessageComposeResultFailed:
        {
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle: @"SMS sending failed"
                                                             message:@""
                                                            delegate:nil
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"OK", nil];
            [alert1 show];
        }
			break;
		default:
        {
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle: @"SMS not sent"
                                                             message:@""
                                                            delegate:nil
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"OK", nil];
            [alert1 show];
        }
			break;
	}
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    
    
    /*
    
    
    if (ABAddressBookRequestAccessWithCompletion != NULL)   {
        
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                
                aryContactUsers = [[NSMutableArray alloc] init];
                CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
                CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBookRef);
                
                for(int i = 0; i < numberOfPeople; i++) {
                    
                    ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
                    
                    NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
                    if(firstName == nil || firstName==NULL){
                        firstName = @"No name";
                    }
                    
                    ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
                    NSMutableArray *arEmail = [[NSMutableArray alloc] init];
                    for(CFIndex idx = 0; idx < ABMultiValueGetCount(emails); idx++)
                    {
                        CFStringRef emailRef = ABMultiValueCopyValueAtIndex(emails, idx);
                        NSString *strEmailType = (NSString*) CFBridgingRelease(ABAddressBookCopyLocalizedLabel (ABMultiValueCopyLabelAtIndex (emails, idx)));
                        NSString *strEmailID = (NSString*)CFBridgingRelease(emailRef);
                        
                        NSDictionary *dictEmail = [NSDictionary dictionaryWithObjectsAndKeys:strEmailID,@"Email",strEmailType,@"EmailType", nil];
                        [arEmail addObject:dictEmail];
                    }
                    NSDictionary *dictName = [NSDictionary dictionaryWithObjectsAndKeys:firstName,@"Name",arEmail,@"EmailID", nil];
                    [aryContactUsers addObject:dictName];
                }
                
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            
            aryContactUsers = [[NSMutableArray alloc] init];
            CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
            CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBookRef);
            
            for(int i = 0; i < numberOfPeople; i++) {
                
                ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
                
                NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
                if(firstName == nil || firstName==NULL){
                    firstName = @"No name";
                }
                
                ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
                NSMutableArray *arEmail = [[NSMutableArray alloc] init];
                for(CFIndex idx = 0; idx < ABMultiValueGetCount(emails); idx++)
                {
                    CFStringRef emailRef = ABMultiValueCopyValueAtIndex(emails, idx);
                    NSString *strEmailType = (NSString*) CFBridgingRelease(ABAddressBookCopyLocalizedLabel (ABMultiValueCopyLabelAtIndex (emails, idx)));
                    NSString *strEmailID = (NSString*)CFBridgingRelease(emailRef);
                    NSDictionary *dictEmail = [NSDictionary dictionaryWithObjectsAndKeys:strEmailID,@"Email",strEmailType,@"EmailType", nil];
                    [arEmail addObject:dictEmail];
                }
                NSDictionary *dictName = [NSDictionary dictionaryWithObjectsAndKeys:firstName,@"Name",arEmail,@"EmailID", nil];
                [aryContactUsers addObject:dictName];
            }
        }
        else {
        }
        
    }
    else{
        ABAddressBookRef addressBookRef = ABAddressBookCreate();
        aryContactUsers = [[NSMutableArray alloc] init];
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
        CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBookRef);
        
        for(int i = 0; i < numberOfPeople; i++) {
            
            ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
            
            NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
            if(firstName == nil || firstName==NULL){
                firstName = @"No name";
            }
            
            ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
            NSMutableArray *arEmail = [[NSMutableArray alloc] init];
            for(CFIndex idx = 0; idx < ABMultiValueGetCount(emails); idx++)
            {
                CFStringRef emailRef = ABMultiValueCopyValueAtIndex(emails, idx);
                NSString *strEmailType = (NSString*) CFBridgingRelease(ABAddressBookCopyLocalizedLabel (ABMultiValueCopyLabelAtIndex (emails, idx)));
                NSString *strEmailID = (NSString*)CFBridgingRelease(emailRef);
                NSDictionary *dictEmail = [NSDictionary dictionaryWithObjectsAndKeys:strEmailID,@"Email",strEmailType,@"EmailType", nil];
                [arEmail addObject:dictEmail];
            }
            NSDictionary *dictName = [NSDictionary dictionaryWithObjectsAndKeys:firstName,@"Name",arEmail,@"EmailID", nil];
            [aryContactUsers addObject:dictName];
        }
    }
    
    
    
    NSLog(@"%@",aryContactUsers);
    
}*/

@end
