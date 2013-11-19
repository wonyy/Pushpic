//
//  FriendListView.m
//  PushPic
//
//  Created by KPIteng on 8/7/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import "FriendListView.h"

@implementation FriendListView
@synthesize btnCancel,tblFriendList;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self setBackgroundColor:[UIColor blackColor]];
        
        self.btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnCancel setFrame:CGRectMake(6, 7, 70, 30)];
        [self.btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:self.btnCancel];
        
        self.tblFriendList = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, frame.size.height-44) style:UITableViewStylePlain];
        //[self.tblFriendList setDelegate:self];
        //[self.tblFriendList setDataSource:self];
        [self addSubview:self.tblFriendList];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
