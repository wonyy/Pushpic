//
//  NotificationViewController.h
//  PushPic
//
//  Created by KPIteng on 8/21/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServices.h"
#import "WSList.h"
#import "EGOImageView.h"

@interface NotificationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *tblNotification;
    NSMutableArray *aryAllNotifi;
    IBOutlet UILabel *lblNoNotification;
}

@end
