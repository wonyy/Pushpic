//
//  MyPushPicViewController.h
//  PushPic
//
//  Created by KPIteng on 8/6/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "WSList.h"
#import "WebServices.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CMNavBarNotificationView.h"
#import "CommentsViewController.h"
#import "NotificationViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "QBRefreshControl.h"
#import "QBSimpleSyncRefreshControl.h"

@interface MyPushPicViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, UIGestureRecognizerDelegate, CMNavBarNotificationViewDelegate, UIScrollViewDelegate, QBRefreshControlDelegate, UIAlertViewDelegate>
{
    ALAssetsLibrary *library;
    ALAssetsGroup *assetGroup;
    
    IBOutlet UITableView *tblMyPushPic;
    
    IBOutlet UITextView *tvMessageContent;
    
    IBOutlet UILabel *lblUserName, *lblLikes, *lblViewCount;
    IBOutlet UILabel *lblLoading, *lblPushPicTitle, *lblPushPicMessage;
    __weak IBOutlet UILabel *lblNewNotificationCount;
    
    IBOutlet UIButton *btnAddComment, *btnMessage, *btnLikes, *btnOptions;
    IBOutlet UIButton *btnDropDown, *btnNotifi;
    IBOutlet UIButton *btnNearest;
    IBOutlet UIButton *btnMostRecent;
    IBOutlet UIButton *btnPopular;
    
    IBOutlet UIView *viewShortOptions;
    IBOutlet UIView *viewSentMsg;
    IBOutlet UIView *viewFooter;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;

    MPMoviePlayerController *moviePlayer;
    CommentsViewController *objCommentsViewController;
    NotificationViewController *objNotificationViewController;

    NSMutableArray *aryMyPushPic;
    
    int userAtIndex, nextLimit;
    
    NSString *strSortType;
    __block NSString *strAlbumID;

    BOOL webCallInProgress, notificationIsOpen;
    BOOL isRefreesh;

    NSIndexPath *userNowAtIndex;
}

@property (nonatomic, strong) ALAssetsGroup *assetGroup;
@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, strong) NSArray *arrayListFromCapture;

@property (weak, nonatomic) IBOutlet UIButton *m_btnBack;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgViewVerified;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgViewNavBack;
@property (weak, nonatomic) IBOutlet UILabel *m_labelCaption;



- (IBAction)backToCaptureViewTapped:(id)sender;
- (IBAction)btnAddCommentTapped:(id)sender;
- (IBAction)btnMessageTapped:(id)sender;
- (IBAction)btnLikesTapped:(id)sender;
- (IBAction)btnOptionsTapped:(id)sender;
- (IBAction)btnSortOptionTapped:(id)sender;
- (IBAction)btnDropDownTapped:(id)sender;
- (IBAction)btnSentMsgTapped:(id)sender;
- (IBAction)btnDismissTapped:(id)sender;
- (IBAction)btnShowNotificationTapped:(id)sender;
- (IBAction)onTouchBackgroundBtn:(id)sender;


@end
