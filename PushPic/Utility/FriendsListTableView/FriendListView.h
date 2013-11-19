//
//  FriendListView.h
//  PushPic
//
//  Created by KPIteng on 8/7/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendListView : UIView <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIButton *btnCancel;
    IBOutlet UITableView *tblFriendList;
}
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UITableView *tblFriendList;
@end
