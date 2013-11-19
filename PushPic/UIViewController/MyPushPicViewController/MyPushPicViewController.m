//
//  MyPushPicViewController.m
//  PushPic
//
//  Created by KPIteng on 8/6/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import "MyPushPicViewController.h"
#import "RemovedPushViewController.h"
#import  "DataKeeper.h"
#import "EGOImageButton.h"
#import "AppConstant.h"
#import "PushPicCell.h"
#import "Flurry.h"


@interface MyPushPicViewController ()
@property (nonatomic, strong) QBSimpleSyncRefreshControl *myRefreshControl;

@end

@implementation MyPushPicViewController
@synthesize library = _library;
@synthesize assetGroup = _assetGroup;
@synthesize arrayListFromCapture;

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
    
    // Flurry Log
    [Flurry logEvent:@"Viewfeed Class"];
    
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:NOTIFICATION_COUNT];
    
    if (str != nil && [str integerValue] > 0)
    {
        lblNewNotificationCount.text = str;
        [self showBadge];
    }
    else {
        [self hideBadge];
    }

    [self Initialize];

    [self UIInitialize];
    
    [self RegsiterNotifications];
    
    if (arrayListFromCapture == nil || arrayListFromCapture.count == 0) {
        [self callWEBDATA];
    } else {
        aryMyPushPic = [NSMutableArray arrayWithArray:arrayListFromCapture];
        arrayListFromCapture = nil;       
        [tblMyPushPic reloadData];
        [tblMyPushPic setBackgroundColor:[UIColor whiteColor]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    lblViewCount = nil;
    viewShortOptions = nil;
    btnPopular = nil;
    btnMostRecent = nil;
    btnNearest = nil;
    btnDropDown = nil;
    tvMessageContent = nil;
    viewSentMsg = nil;
    [self setM_btnBack:nil];
    [self setM_imgViewVerified:nil];
    lblNewNotificationCount = nil;
    [self setM_labelCaption:nil];
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
  //  [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - Initialize

- (void) Initialize {
    aryMyPushPic = [[NSMutableArray alloc] init];
    
    strSortType = @"Nearest"; // @"Nearest", @"Recent"
    
    nextLimit = 0;
    
    webCallInProgress  = NO;
    
    [APPDEL.aryNotification removeAllObjects];
    
    notificationIsOpen = FALSE;
}

- (void) UIInitialize {
    
    [self.view setTintColor: [UIColor greenColor]];
    
    [tblMyPushPic setRowHeight:[UIScreen mainScreen].bounds.size.height - 20 - 44];
    
    [btnPopular.titleLabel setFont:MyriadPro_Bold_20];
    [btnNearest.titleLabel setFont:MyriadPro_Bold_20];
    [btnMostRecent.titleLabel setFont:MyriadPro_Bold_20];
    
    [viewShortOptions setFrame:CGRectMake(0, 44 + 20, 320, 0)];
    
    
    objNotificationViewController = [[NotificationViewController alloc]initWithNibName:@"NotificationViewController" bundle:nil];
    
    [self.view addSubview:objNotificationViewController.view];
    
    [objNotificationViewController.view setFrame:CGRectMake(0, 0, 0, 0)];
    
    [lblPushPicTitle setFont:MyriadPro_Bold_23];
    [lblPushPicMessage setFont:MyriadPro_Bold_23];
    [_m_labelCaption setFont:MyriadPro_Bold_13];
    
    // Refresh Control
    QBSimpleSyncRefreshControl *refreshControl = [[QBSimpleSyncRefreshControl alloc] init];
    refreshControl.delegate = self;
    [tblMyPushPic addSubview:refreshControl];
    self.myRefreshControl = refreshControl;
    isRefreesh = NO;
}

- (void) RegsiterNotifications {
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFICATION_NOTIFY_GOTO object:nil queue:nil usingBlock:^(NSNotification *note)
     {
         [self HideNotificationView];
         [self GotoMedia: note.object];
     }];
}

#pragma mark - Show Badge

- (void) showBadge {
    
    [btnNotifi setImage:[UIImage imageNamed:@"notification"] forState:UIControlStateNormal];
    [btnNotifi setImage:[UIImage imageNamed:@"notification"] forState:UIControlStateSelected];
    lblNewNotificationCount.hidden = NO;
}

- (void) hideBadge {
    [btnNotifi setImage:[UIImage imageNamed:@"notificationNewIcon@2x"] forState:UIControlStateNormal];
    [btnNotifi setImage:[UIImage imageNamed:@"notificationNewIcon@2x"] forState:UIControlStateSelected];
    lblNewNotificationCount.hidden = YES;
}

#pragma mark - QBRefreshControlDelegate

- (void)refreshControlDidBeginRefreshing:(QBRefreshControl *)refreshControl {
    
    isRefreesh = YES;
    [self callWEBDATA];
    
    //[self.myRefreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:5.0];
}

#pragma mark - Load Data Functions

- (void) callWEBDATA {
    
    NSLog(@"%s", __func__);
    
    if (webCallInProgress == NO) {
        webCallInProgress = YES;
        [WebServices urlStringInBG:[WSList getNearesPost:strSortType limit:nextLimit] completionHandler:^(NSDictionary *dictJSON) {
            
            if (isRefreesh) {
                [self.myRefreshControl endRefreshing];
            }
            //[APPDEL hideWithGradient];
            webCallInProgress = NO;
            
            if ([[dictJSON valueForKey:@"MESSAGE"] isEqualToString:@"SUCCESS"]) {
                
                NSLog(@"Success call Web Data");
        
                [aryMyPushPic removeAllObjects];
                
                aryMyPushPic = [dictJSON valueForKey:@"USER_DETAIL"];
                
                [tblMyPushPic reloadData];
                [tblMyPushPic setBackgroundColor:[UIColor whiteColor]];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                
                [tblMyPushPic scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                
            } else if ([[dictJSON valueForKey:@"MESSAGE"] isEqualToString:@"NOTHING FOUND"]) {
                CMNavBarNotificationView *notification = [CMNavBarNotificationView notifyWithText:APPNAME andDetail:@"there is no photos/videos in your radious"];
                notification.delegate = self;
                [notification setBackgroundColor:[UIColor colorWithRed:39 green:43 blue:50 alpha:1.0]];
            }
        }];
    }
}



#pragma mark - Table Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UIScreen mainScreen].bounds.size.height -  20 - 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [aryMyPushPic count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"- Begin TableCell %d", indexPath.row);
    
    userAtIndex = indexPath.row;
    static NSString *cellIdentifier = @"PushPicCell";
    
    PushPicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        // NSLog(@"Cell Initialize %d",indexPath.row);
        cell = [[PushPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor blackColor]];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTapped:)];
        [tapGesture setDelegate:self];
        [tapGesture setNumberOfTapsRequired:2];
        [tapGesture setNumberOfTouchesRequired:1];
        
        [cell addGestureRecognizer:tapGesture];
        
         [cell.btnMediaThumb addTarget:self action:@selector(btnMediaThumbTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.btnInfo addTarget:self  action:@selector(btnReportAbuse:) forControlEvents:UIControlEventTouchUpInside];
        
        
        ///TO disable fullscreen button in webview or mpmovieplayer
        UIButton *btnCustome = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCustome.backgroundColor = [UIColor clearColor];
        btnCustome.frame = CGRectMake(253, 310, 70, 60);
        [cell addSubview:btnCustome];
                
    }
    
    if (moviePlayer != nil) {
        [moviePlayer stop];
    }
    
    [cell.iv setTag:indexPath.row + 1];
    
    [cell.btnMediaThumb setTag: 2000 + indexPath.row];
    
    if ([[[aryMyPushPic valueForKey:@"eMediaType"] objectAtIndex:indexPath.row] isEqualToString:@"Video"]){        
    
        [cell setM_strImgURL: [[aryMyPushPic valueForKey:@"vMediaThumbName"] objectAtIndex:indexPath.row]];
        
        cell.btnMediaThumb.hidden = NO;
        
    } else {

        [cell setM_strImgURL: [[aryMyPushPic valueForKey:@"vMediaName"] objectAtIndex:indexPath.row]];
        
        cell.btnMediaThumb.hidden = YES;
    }
    
    [cell refreshImage];
    
    //for Report Abuse
    cell.btnInfo.tag = indexPath.row + 1;
    
    //
    [cell.btnFav setTag:indexPath.row];
    
    if ([[[aryMyPushPic objectAtIndex:indexPath.row] valueForKey:@"eLikeStatus"] isEqualToString:@"Yes"]) {
        cell.btnFav.hidden = NO;
        
    } else if ([[[aryMyPushPic objectAtIndex:indexPath.row] valueForKey:@"eLikeStatus"] isEqualToString:@"No"]){
        cell.btnFav.hidden = YES;
    }
    
    
    if ([[[aryMyPushPic objectAtIndex:indexPath.row] valueForKey:@"eHideUserName"] isEqualToString:@"No"]) {
        [lblUserName setText:[NSString stringWithFormat:@"@%@", [[aryMyPushPic objectAtIndex:indexPath.row] valueForKey:@"vUserName"]]];
    } else {
        [lblUserName setText:@""];
    }
    
    if ([[[aryMyPushPic objectAtIndex:indexPath.row] valueForKey:@"eVerified"] isEqualToString:@"No"]) {
        [_m_imgViewVerified setHidden: YES];
        [lblUserName setFrame:CGRectMake(7, lblUserName.frame.origin.y, lblUserName.frame.size.width, lblUserName.frame.size.height)];
        
    } else {
        [_m_imgViewVerified setHidden: NO];
        
        [lblUserName setFrame:CGRectMake(54, lblUserName.frame.origin.y, lblUserName.frame.size.width, lblUserName.frame.size.height)];
    }
    
    if ([[[aryMyPushPic objectAtIndex:indexPath.row] valueForKey:@"eCelebrities"] isEqualToString:@"No"]) {
        [_m_imgViewVerified setHidden: YES];
        [lblUserName setFrame:CGRectMake(7, lblUserName.frame.origin.y, lblUserName.frame.size.width, lblUserName.frame.size.height)];
        
    } else {
        [_m_imgViewVerified setHidden: NO];
        
        [lblUserName setFrame:CGRectMake(54, lblUserName.frame.origin.y, lblUserName.frame.size.width, lblUserName.frame.size.height)];
    }
    
    NSInteger viewCount = [[[aryMyPushPic  objectAtIndex:indexPath.row] valueForKey:@"iMediaViewsCount"] intValue];

    if (viewCount > 0) {
        if (viewCount == 1)
            [lblViewCount setText: [NSString stringWithFormat:@"%d View", viewCount]];
        else
            [lblViewCount setText: [NSString stringWithFormat:@"%@ Views", [self getTotalCounts: viewCount]]];
    } else {
        [lblViewCount setText:@""];
    }

    
    int likeCount = [[[aryMyPushPic objectAtIndex:indexPath.row] valueForKey:@"iMediaLikesCount"] intValue];
    
    if (likeCount > 0) {
        if (likeCount == 1)
            [lblLikes setText: [NSString stringWithFormat:@"%d Like", likeCount]];
        else
            [lblLikes setText: [NSString stringWithFormat:@"%@ Likes", [self getTotalCounts: likeCount]]];
    } else {
        [lblLikes setText:@""];
    }
    
    [_m_labelCaption setText: [[aryMyPushPic objectAtIndex:indexPath.row] valueForKey:@"vMediaCaption"]];
    [_m_labelCaption setFrame:CGRectMake(15 + [[[aryMyPushPic objectAtIndex:indexPath.row] valueForKey:@"vMediaCaptionX"] floatValue], 12 + [UIScreen mainScreen].bounds.size.height * [[[aryMyPushPic objectAtIndex:indexPath.row] valueForKey:@"vMediaCaptionY"] floatValue], _m_labelCaption.frame.size.width, _m_labelCaption.frame.size.height)];
    
    //NSLog(@"Media = %@", [aryMyPushPic objectAtIndex:indexPath.row]);
    
    NSLog(@"- End TableCell %d", indexPath.row);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    userNowAtIndex = indexPath;
}

- (BOOL) GotoMedia: (NSDictionary *) dictMedia {
    
    NSString *strMediaID = [dictMedia objectForKey:@"iMediaID"];
    
    for (NSInteger nIndex = 0; nIndex < [aryMyPushPic count]; nIndex++) {
        if ([[[aryMyPushPic objectAtIndex:nIndex] valueForKey:@"iMediaID"] isEqualToString: strMediaID]) {
            [tblMyPushPic scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:nIndex inSection: 0] atScrollPosition:UITableViewScrollPositionBottom animated: YES];
            
            return YES;
        }
    }
    
    RemovedPushViewController *removedPushVC = [[RemovedPushViewController alloc] initWithNibName:@"RemovedPushViewController" bundle: nil];
    
    [removedPushVC setM_dictItem: dictMedia];
    
    [self.navigationController pushViewController: removedPushVC animated: YES];
    
    return NO;
}

#pragma mark - String Convert Function

- (NSString *) getTotalCounts: (NSInteger) nCount {
    if (nCount < 10000) {
        return [NSString stringWithFormat:@"%d", nCount];
    } else if (nCount < 1000000) {
        return [NSString stringWithFormat:@"%.1fk", (float)nCount / 1000.0f];
    } else if (nCount >= 1000000) {
        return [NSString stringWithFormat:@"%.1f million", (float)nCount / 1000000.0f];
    }

    return @"Invalid";
}


#pragma mark - IBAction Methods

- (IBAction)backToCaptureViewTapped:(id)sender {
    //[aryMyPushPic removeAllObjects];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnMediaThumbTapped:(id)sender {
    
    UIButton *btnSender = (UIButton*)sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: btnSender.tag - 2000 inSection:0];
    
    if (btnSender.selected == NO) {
        [btnSender setSelected: YES];
        
        PushPicCell *tblCell = (PushPicCell*)[tblMyPushPic cellForRowAtIndexPath:indexPath];
        
        [tblCell.iv setHidden:YES];

        NSString *stringURL = [[aryMyPushPic objectAtIndex:indexPath.row] valueForKey:@"vMediaName"];
        
       [tblCell playCurrentVideo: stringURL];
        
        moviePlayer = tblCell.player;
    } else {
        
        PushPicCell *tblCell = (PushPicCell*)[tblMyPushPic cellForRowAtIndexPath:indexPath];
        
        [tblCell.player pause];
        
        [btnSender setSelected: NO];
    }
}

- (IBAction)btnFavTapped: (id)sender {
    
    NSString *strLikeStatus;
    if ([[[aryMyPushPic objectAtIndex:[sender tag]]valueForKey:@"eFavouriteStatus"] isEqualToString:@"Yes"])
        strLikeStatus = @"No";
    else if ([[[aryMyPushPic objectAtIndex:[sender tag]]valueForKey:@"eFavouriteStatus"] isEqualToString:@"No"])
        strLikeStatus = @"Yes";
    
    [WebServices urlStringInBG:[WSList iMediaID:[[aryMyPushPic objectAtIndex:[sender tag]]valueForKey:@"iMediaID"] FavStatus:strLikeStatus] completionHandler:^(NSDictionary *dictResponse) {
        
        if ([[dictResponse valueForKey:@"MESSAGE"] isEqualToString:@"SUCCESS"]) {
            [[aryMyPushPic objectAtIndex:[sender tag]] setValue:strLikeStatus forKey:@"eFavouriteStatus"];
            
            [[aryMyPushPic objectAtIndex:[sender tag]] setValue:[[dictResponse valueForKey:@"DETAILS"] valueForKey:@"iNoOfFav"] forKey:@"iMediaLikesCount"];
            
            UIButton *btn = (UIButton*)sender;
            
            if ([strLikeStatus isEqualToString:@"No"])
                [btn setBackgroundImage:[UIImage imageNamed:@"favNo"] forState:UIControlStateNormal];
            else
                [btn setBackgroundImage:[UIImage imageNamed:@"favYes"] forState:UIControlStateNormal];
        }
    }];
}

- (IBAction)tapGestureTapped: (UITapGestureRecognizer *)tapGesture {
    
    EGOImageView *iButton = (EGOImageView *)(((PushPicCell *)tapGesture.view).iv);
    int tagId = [iButton tag] - 1;
    
    NSString *strLikeStatus;
    
    if ([[[aryMyPushPic objectAtIndex:tagId] valueForKey:@"eLikeStatus"] isEqualToString:@"Yes"])
        strLikeStatus = @"No";
    else if ([[[aryMyPushPic objectAtIndex:tagId] valueForKey:@"eLikeStatus"] isEqualToString:@"No"])
        strLikeStatus = @"Yes";
    
    int likeCount;
    
    if ([strLikeStatus isEqualToString:@"Yes"]) {   
        likeCount = [[[aryMyPushPic objectAtIndex:tagId] valueForKey:@"iMediaLikesCount"] intValue] + 1;
    } else {
        likeCount = [[[aryMyPushPic objectAtIndex:tagId] valueForKey:@"iMediaLikesCount"] intValue] - 1;
    }
    
    [[aryMyPushPic objectAtIndex: tagId] setValue:[NSString stringWithFormat:@"%d", likeCount] forKey:@"iMediaLikesCount"];
    [[aryMyPushPic objectAtIndex: tagId] setValue:strLikeStatus forKey:@"eLikeStatus"];
   
    if (likeCount > 0) {
        if (likeCount == 1)
            [lblLikes setText:[NSString stringWithFormat:@"%d Like", likeCount]];
        else
            [lblLikes setText:[NSString stringWithFormat:@"%d Likes", likeCount]];
    } else {
        [lblLikes setText:[NSString stringWithFormat:@""]];
    }
    
    
    NSIndexPath *iPath = [NSIndexPath indexPathForRow:tagId inSection:0];
    
    NSArray *ar = [[NSArray alloc] initWithObjects:iPath, nil];
    
    [tblMyPushPic reloadRowsAtIndexPaths:ar withRowAnimation:UITableViewRowAnimationNone];
            
    [WebServices urlStringInBG: [WSList iMediaID: [[aryMyPushPic objectAtIndex:tagId] valueForKey:@"iMediaID"] LikeStatus:strLikeStatus] completionHandler:^(NSDictionary *dictResponse) {

        if ([[dictResponse valueForKey:@"MESSAGE"] isEqualToString:@"SUCCESS"]) {
            NSLog(@"--Like %@", dictResponse);
        }
    }];
}

- (IBAction)btnOptionsTapped:(UIButton*)sender {
    
    if (aryMyPushPic == nil || aryMyPushPic.count <= userAtIndex) {
        return;
    }
    
    if ([btnOptions isSelected]) {
        [self HideOption: nil];
    } else {
        [self ShowOption];
    }
}

- (IBAction)btnSortOptionTapped:(id)sender {
    
    if ([sender tag] == 1) {
        strSortType = @"Popular";
    } else if ([sender tag] == 3) {
        strSortType = @"Nearest";
    } else if ([sender tag] == 2) {
        strSortType = @"Recent";
    }
    
    [viewShortOptions setFrame:CGRectMake(0, 44 + 20, 320, 118)];
    
    [UIView animateWithDuration:0.3 animations: ^{
        
        [viewShortOptions setFrame:CGRectMake(0, 44 + 20, 320, 0)];
        
    } completion:^(BOOL finished) {
        
    }];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[aryMyPushPic count] - 1 inSection:0];
    
    [tblMyPushPic scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [btnDropDown setSelected: NO];
    [_m_btnBack setHidden: YES];
    nextLimit = 0;
    
    [self callWEBDATA];
    
}

- (IBAction)btnDropDownTapped:(id)sender {
    
    if (![btnDropDown isSelected]) {
        [viewShortOptions setFrame:CGRectMake(0, 44 + 20, 320, 0)];
        [UIView animateWithDuration:0.3 animations:^{
            [viewShortOptions setFrame:CGRectMake(0, 44 + 20, 320, 118)];
        } completion:^(BOOL finished) {
            
        }];
        [btnDropDown setSelected: YES];
        [_m_btnBack setHidden: NO];
    } else {
        [viewShortOptions setFrame:CGRectMake(0, 44 + 20, 320, 90)];
        [UIView animateWithDuration:0.3 animations:^{
            [viewShortOptions setFrame:CGRectMake(0, 44 + 20, 320, 0)];
        } completion:^(BOOL finished) {
            
        }];
        [btnDropDown setSelected: NO];
        [_m_btnBack setHidden: YES];
    }
}


- (IBAction)btnAddCommentTapped:(UIButton *)sender {
    
    if ([[[aryMyPushPic objectAtIndex:userAtIndex] valueForKey:@"distance"] floatValue] < [[[aryMyPushPic objectAtIndex:userAtIndex] valueForKey:@"fMediaDistance"] floatValue]) {
        
        [self HideOption:^(BOOL finished) {
            CommentsViewController *objCommentsViewController1 = [[CommentsViewController alloc]initWithNibName:@"CommentsViewController" bundle:nil];
            objCommentsViewController1.dictUserComment = [aryMyPushPic objectAtIndex:userAtIndex];
            [self.navigationController pushViewController:objCommentsViewController1 animated:YES];
        }];
    }
}

- (IBAction)btnMessageTapped:(UIButton*)sender {
    
    if ([[[aryMyPushPic objectAtIndex:userAtIndex] valueForKey:@"distance"] floatValue] < [[[aryMyPushPic objectAtIndex:userAtIndex] valueForKey:@"fMediaDistance"] floatValue]) {
        
        [self HideOption:^(BOOL finished) {
             [self.view addSubview:viewSentMsg];
            [UIView animateWithDuration:0.7 animations:^{
                [viewSentMsg setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
}

- (IBAction)btnLikesTapped:(id)sender {
    
    [self HideOption:^(BOOL finished) {
        
        NSString *strLikeStatus;
        if ([[[aryMyPushPic objectAtIndex:[sender tag]] valueForKey:@"eLikeStatus"] isEqualToString:@"Yes"])
            strLikeStatus = @"No";
        else if ([[[aryMyPushPic objectAtIndex:[sender tag]] valueForKey:@"eLikeStatus"] isEqualToString:@"No"])
            strLikeStatus = @"Yes";
        
        
        int likeCount;
        
        if ([strLikeStatus isEqualToString:@"Yes"]) {
            likeCount=  [[[aryMyPushPic objectAtIndex:[sender tag]] valueForKey:@"iMediaLikesCount"] intValue] + 1;
        } else {
            likeCount=  [[[aryMyPushPic objectAtIndex:[sender tag]] valueForKey:@"iMediaLikesCount"] intValue] - 1;
        }
        
        [[aryMyPushPic objectAtIndex:[sender tag]] setValue:[NSString stringWithFormat:@"%d", likeCount] forKey:@"iMediaLikesCount"];
        [[aryMyPushPic objectAtIndex:[sender tag]] setValue:strLikeStatus forKey:@"eLikeStatus"];
        
        if (likeCount > 0) {
            if (likeCount == 1) {
                [lblLikes setText:[NSString stringWithFormat:@"%d Like", likeCount]];
            } else {
                [lblLikes setText:[NSString stringWithFormat:@"%d Likes", likeCount]];
            }
        } else {
            [lblLikes setText:[NSString stringWithFormat:@""]];
        }
        
        NSIndexPath *iPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
        NSArray *ar = [[NSArray alloc] initWithObjects:iPath, nil];
        [tblMyPushPic reloadRowsAtIndexPaths:ar withRowAnimation:UITableViewRowAnimationNone];
        
        [WebServices urlStringInBG:[WSList iMediaID:[[aryMyPushPic objectAtIndex:[sender tag]]valueForKey:@"iMediaID"] LikeStatus:strLikeStatus] completionHandler:^(NSDictionary *dictResponse) {
            
            if ([[dictResponse valueForKey:@"MESSAGE"] isEqualToString:@"SUCCESS"]) {
                
            }
        }];
    }];
}


- (IBAction)btnSentMsgTapped:(id)sender {

    if ([[tvMessageContent.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        return;
    }
    
    [UIView animateWithDuration:0.7 animations:^{
    
        [viewSentMsg setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        [WebServices urlStringInBG:[WSList sendMessage:[[aryMyPushPic valueForKey:@"iUserID"] objectAtIndex:userAtIndex] tMessage:tvMessageContent.text iMediaID:[[aryMyPushPic valueForKey:@"iMediaID"] objectAtIndex:userAtIndex]] completionHandler:^(NSDictionary *dictJSON) {
            [tvMessageContent setText:@""];
            [APPDEL hideWithGradient];
            
            if ([[dictJSON valueForKey:@"MESSAGE"] isEqualToString:@"SUCCESS"]) {
                
            } else if ([[dictJSON valueForKey:@"MESSAGE"] isEqualToString:@"FAIL"]) {
                CMNavBarNotificationView *notification = [CMNavBarNotificationView notifyWithText:APPNAME andDetail:@"please try again"];
                notification.delegate = self;
                [notification setBackgroundColor:[UIColor colorWithRed:39 green:43 blue:50 alpha:1.0]];
            }
            
        }];
    } completion:^(BOOL finished) {
        [viewSentMsg removeFromSuperview];
    }];
}

- (IBAction)btnDismissTapped:(id)sender {
    
    [viewSentMsg setFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    [self.view addSubview:viewSentMsg];
    
    [UIView animateWithDuration:0.7 animations:^{
        [viewSentMsg setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    } completion:^(BOOL finished) {
        [viewSentMsg removeFromSuperview];
    }];

}

- (IBAction)btnShowNotificationTapped:(id)sender {
    
    if ([btnNotifi isSelected]) {
        [self HideNotificationView];
    } else {
        NSDictionary *dictMsg = [WebServices urlString:[WSList getNotificationList]];
        
        NSLog(@"dictMsg = %@", dictMsg);
        
        [APPDEL.aryNotification removeAllObjects];
        [APPDEL.aryNotification addObjectsFromArray:[dictMsg valueForKey:@"NOTIFICATION_DETAILS"]];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:NOTIFICATION_COUNT];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([APPDEL.aryNotification count] == 0) {
            UIAlertView *alertNoNotification = [[UIAlertView alloc] initWithTitle:APPNAME message:@"No new Notifications" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertNoNotification show];
        } else {
            [btnNotifi setSelected:TRUE];
            [objNotificationViewController viewWillAppear:YES];
            [objNotificationViewController.view setFrame:CGRectMake(0, 44 + 20, [UIScreen mainScreen].bounds.size.width, 0)];
            
            float viewHeight = 0.0f;
            for (int x = 0; x < [APPDEL.aryNotification count]; x++) {
                NSString *strString = [NSString stringWithFormat:@"%@ %@", [[APPDEL.aryNotification objectAtIndex:x] valueForKey:@"name"], [[APPDEL.aryNotification objectAtIndex:x] valueForKey:@"tMsg"]];
                CGSize size = [strString sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13.0f] constrainedToSize:CGSizeMake(290, 9999) lineBreakMode:NSLineBreakByWordWrapping];
                viewHeight = viewHeight + size.height + 30 + 20;
                
                if (viewHeight >= [UIScreen mainScreen].bounds.size.height - 44 - 20) {
                    viewHeight = [UIScreen mainScreen].bounds.size.height - 44 - 20;
                    break;
                }
            }
           
            [UIView animateWithDuration:0.3 animations:^{
                [objNotificationViewController.view setFrame:CGRectMake(0, 44 + 20, [UIScreen mainScreen].bounds.size.width, viewHeight + 11)];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

- (IBAction)onTouchBackgroundBtn:(id)sender {
    
    if ([btnDropDown isSelected]) {
        [viewShortOptions setFrame:CGRectMake(0, 44 + 20, 320, 90)];
        
        [UIView animateWithDuration:0.3 animations:^{
            [viewShortOptions setFrame:CGRectMake(0, 44 + 20, 320, 0)];
        } completion:^(BOOL finished) {
            
        }];
        
        [btnDropDown setSelected: NO];
        [_m_btnBack setHidden: YES];
    }
    
    if (aryMyPushPic == nil || aryMyPushPic.count <= userAtIndex) {
        return;
    }

    if ([btnOptions isSelected]) {
        [self HideOption: nil];
    }
}

- (void)btnReportAbuse: (UIButton *) sender {
    
    NSString *strMediaType = [[aryMyPushPic valueForKey:@"eMediaType"] objectAtIndex: userAtIndex];
    
    NSString *strContent = nil;
    
    if ([strMediaType isEqualToString: @"Image"]) {
        strContent = @"Photo";
    } else if ([strMediaType isEqualToString: @"Video"]) {
        strContent = @"Video";
    }
    
    if ([[[aryMyPushPic valueForKey:@"iUserID"] objectAtIndex:userAtIndex] isEqualToString:[[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] valueForKey:@"iUserID"]]) {

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Pushpic" message:[NSString stringWithFormat:@"Would you like to remove your %@?", strContent] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        
        alertView.tag = sender.tag;
        
        [alertView show];

    } else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Pushpic" message:[NSString stringWithFormat: @"Would you like to report this %@ as inappropriate/spam?", strContent] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        
        alertView.tag = sender.tag;
        
        [alertView show];
    }
}

#pragma mark - Notification Functions

- (void) HideNotificationView {
    [btnNotifi setSelected:FALSE];
    [UIView animateWithDuration:0.3 animations:^{
        [objNotificationViewController.view setFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width,0)];
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Video Functions

- (void)playVideo:(NSString *)urlString withWebView:(UIWebView*)videoView andThumbnailLink:(NSString*)thumbnailImageLink {
    NSString *embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    color: white;\
    }\
    </style>\
    <script>\
    function load(){document.getElementById(\"yt\").play();}\
    </script>\
    </head><body onload=\"load()\"style=\"margin:0\">\
    <video id=\"yt\" src=\"%@\" \
    width=\"%0.0f\" height=\"%0.0f\" poster=\"%@\" autoplay controls webkit-playsinline></video>\
    </body></html>";
    videoView.backgroundColor   =  [UIColor redColor];
    NSString *html = [NSString stringWithFormat:embedHTML, urlString, videoView.frame.size.width, videoView.frame.size.height - 60,thumbnailImageLink];
    [videoView loadHTMLString:html baseURL:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayStarted:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayFinished:) name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];
}

- (void)videoPlayStarted:(NSNotification *)notification{
    //self.isInFullScreenMode = YES;
}

- (void)videoPlayFinished:(NSNotification *)notification{
    // your code here
    // self.isInFullScreenMode = NO;
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    MPMoviePlayerController *theMovie = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
    
}

#pragma mark - Option buttons Animation

- (void) ShowOption {
    
    if ([[[aryMyPushPic valueForKey:@"distance"] objectAtIndex:userAtIndex] floatValue] <= [[[aryMyPushPic valueForKey:@"fMediaDistance"] objectAtIndex:userAtIndex] floatValue]) {
        
        [btnMessage setEnabled: YES];
        [btnAddComment setEnabled: YES];
        
        if ([[[aryMyPushPic valueForKey:@"iUserID"] objectAtIndex:userAtIndex] isEqualToString:[[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] valueForKey:@"iUserID"]])
        {
            [btnMessage setEnabled: NO];
        } else if ([[[aryMyPushPic valueForKey:@"eMessageReceiveStatus"] objectAtIndex:userAtIndex] isEqualToString:@"No"]) {
            [btnMessage setEnabled: NO];
        } else {
            [btnMessage setEnabled: YES];
        }
        
               
    } else {
        [btnMessage setEnabled: NO];
        [btnAddComment setEnabled: NO];
        
    }
    
    
    CGRect rect = btnOptions.frame;

    [btnLikes setTag:userAtIndex];
    [btnOptions setSelected:TRUE];
    [_m_btnBack setHidden: NO];
    
    if ([[[aryMyPushPic objectAtIndex:userAtIndex] valueForKey:@"distance"] floatValue] > [[[aryMyPushPic objectAtIndex:userAtIndex] valueForKey:@"fMediaDistance"] floatValue]) {
        [btnAddComment setUserInteractionEnabled:FALSE];
        [btnMessage setUserInteractionEnabled:FALSE];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [btnAddComment setFrame:CGRectMake(rect.origin.x - 69, rect.origin.y - 22, 45, 45)];
        [btnLikes setFrame:CGRectMake(rect.origin.x - 54, rect.origin.y - 69, 45, 45)];
        [btnMessage setFrame:CGRectMake(rect.origin.x + 1, rect.origin.y - 79, 45, 45)];
    } completion:^(BOOL finished) {
        
    }];
}

- (void) HideOption : (void (^)(BOOL finished))completion {
    CGRect rect = btnOptions.frame;
    
    [btnOptions setSelected: NO];
    [_m_btnBack setHidden: YES];
    
    [UIView animateWithDuration:0.5 animations:^{
        [btnAddComment setFrame:CGRectMake(rect.origin.x, rect.origin.y, 40, 40)];
        [btnLikes setFrame:CGRectMake(rect.origin.x, rect.origin.y, 40, 40)];
        [btnMessage setFrame:CGRectMake(rect.origin.x, rect.origin.y, 40, 40)];
    } completion: completion];
}

#pragma mark - UITextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - UIScrollView Delegate

- (void)setTableCell
{
    NSArray *arryCell  = [tblMyPushPic visibleCells];
    NSIndexPath *indexPath;
    
    if (arryCell.count == 1) {
       indexPath = [tblMyPushPic indexPathForCell:[arryCell objectAtIndex:0]];
        
    } else if (arryCell.count == 2) {
        UITableViewCell *ccell = (UITableViewCell*) [arryCell objectAtIndex:0];
         CGRect ccellRect = [self.view.window convertRect:ccell.bounds fromView:ccell];
        
        //float hight = tblMyPushPic.rowHeight;
        if (ccellRect.origin.y < -145.0)  {
           indexPath = [tblMyPushPic indexPathForCell:[arryCell objectAtIndex:1]];           
        } else {
           indexPath = [tblMyPushPic indexPathForCell:[arryCell objectAtIndex:0]];            
        }
    }
    
    userAtIndex = indexPath.row;
    [tblMyPushPic scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    int likeCount = [[[aryMyPushPic objectAtIndex:indexPath.row] valueForKey:@"iMediaLikesCount"] intValue];
    
    if (likeCount > 0) {
        if (likeCount == 1)
            [lblLikes setText:[NSString stringWithFormat:@"%d Like",likeCount]];
        else
            [lblLikes setText:[NSString stringWithFormat:@"%d Likes",likeCount]];
    } else {
        [lblLikes setText:@""];
    }
    
    if ([[[aryMyPushPic objectAtIndex:indexPath.row] valueForKey:@"eHideUserName"] isEqualToString:@"No"]) {
        [lblUserName setText:[NSString stringWithFormat:@"@%@", [[aryMyPushPic objectAtIndex:indexPath.row] valueForKey:@"vUserName"]]];
    } else {
        [lblUserName setText:@""];
    }
    
    if ([[[aryMyPushPic objectAtIndex:indexPath.row] valueForKey:@"eVerified"] isEqualToString:@"No"]) {
        [_m_imgViewVerified setHidden: YES];
        [lblUserName setFrame:CGRectMake(7, lblUserName.frame.origin.y, lblUserName.frame.size.width, lblUserName.frame.size.height)];

    } else {
        [_m_imgViewVerified setHidden: NO];
        
        [lblUserName setFrame:CGRectMake(54, lblUserName.frame.origin.y, lblUserName.frame.size.width, lblUserName.frame.size.height)];
    }
    
    if ([[[aryMyPushPic objectAtIndex:indexPath.row] valueForKey:@"eCelebrities"] isEqualToString:@"No"]) {
        [_m_imgViewVerified setHidden: YES];
        [lblUserName setFrame:CGRectMake(7, lblUserName.frame.origin.y, lblUserName.frame.size.width, lblUserName.frame.size.height)];
        
    } else {
        [_m_imgViewVerified setHidden: NO];
        
        [lblUserName setFrame:CGRectMake(54, lblUserName.frame.origin.y, lblUserName.frame.size.width, lblUserName.frame.size.height)];
    }
    
    [lblViewCount setText:[NSString stringWithFormat:@"%@ Views", [[aryMyPushPic  objectAtIndex:indexPath.row] valueForKey:@"iMediaViewsCount"]]];

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    // NSLog(@"DidEndDragging");
    if (!decelerate) {
        [self setTableCell];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (![scrollView isDecelerating] && ![scrollView isDragging]) {
        
        [self setTableCell];
    }
    
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height; 
    
    
    if (webCallInProgress == NO) {
        
        if (maximumOffset - currentOffset == 0) {
            
            [tblMyPushPic setTableFooterView:viewFooter];
            [activityIndicator startAnimating];
            [lblLoading setFont:MyriadPro_Regular_11];
            
            webCallInProgress = YES;
            nextLimit = nextLimit + 15;
            
            if (nextLimit < 184){
                [WebServices urlStringInBG:[WSList getNearesPost:strSortType limit:nextLimit] completionHandler:^(NSDictionary *dictJSON) {
                    webCallInProgress = NO;
                    if ([[dictJSON valueForKey:@"MESSAGE"] isEqualToString:@"SUCCESS"])
                    {
                        [tblMyPushPic setTableFooterView:nil];
                        [aryMyPushPic addObjectsFromArray:[dictJSON valueForKey:@"USER_DETAIL"]];
                        [tblMyPushPic reloadData];
                        //[tblMyPushPic setContentOffset:CGPointMake(0, scrollView.contentSize.height-scrollView.frame.size.height) animated:YES];
                    }
                    else if ([[dictJSON valueForKey:@"MESSAGE"] isEqualToString:@"NOTHING FOUND"]) {
                        CMNavBarNotificationView *notification = [CMNavBarNotificationView notifyWithText:APPNAME andDetail:@"no more record found"];
                        notification.delegate = self;
                        [notification setBackgroundColor:[UIColor colorWithRed:39 green:43 blue:50 alpha:1.0]];
                    }
                }];
            }
            
        }
    }
}

#pragma mark - UIAlertView Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        if ([[[aryMyPushPic valueForKey:@"iUserID"] objectAtIndex:userAtIndex] isEqualToString:[[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAIL] valueForKey:@"iUserID"]]) {
            
            int buttonTag = alertView.tag - 1;
            NSDictionary *dic = [aryMyPushPic objectAtIndex:buttonTag];
            
            NSString *stringReportAbuse = [NSString stringWithFormat:@"http://pushpic.com/ws/index.php?c=media&func=remove&iUserID=%@&iMediaID=%@",[dic valueForKey:@"iUserID"], [dic valueForKey:@"iMediaID"]];
            
            NSLog(@"ReportAbuse URL = %@", stringReportAbuse);
            
            [WebServices urlStringInBG:stringReportAbuse completionHandler:^(NSDictionary *dicResult) {
                if (dicResult != nil && [[dicResult valueForKey:@"MESSAGE"] isEqualToString:@"SUCCESS"]) {
                    
                    isRefreesh = YES;
                    [self callWEBDATA];
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"PushPic" message:@"You have removed this successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }];

            
        } else {
            int buttonTag = alertView.tag - 1;
            NSDictionary *dic = [aryMyPushPic objectAtIndex:buttonTag];
            
            NSString *stringReportAbuse = [NSString stringWithFormat:@"http://pushpic.com/ws/index.php?c=abuse&func=Insert&iUserID=%@&iMediaID=%@",[dic valueForKey:@"iUserID"],[dic valueForKey:@"iMediaID"]];
            
            NSLog(@"ReportAbuse URL = %@", stringReportAbuse);
            
            [WebServices urlStringInBG:stringReportAbuse completionHandler:^(NSDictionary *dicResult) {
                if (dicResult != nil && [[dicResult valueForKey:@"MESSAGE"] isEqualToString:@"SUCCESS"]) {
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"PushPic" message:@"You have marked this as inappropriate." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }];
        }

    }
    else if (buttonIndex == 0) {
        // NSLog(@"NO");
    }
}


@end
