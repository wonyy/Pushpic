//
//  RemovedPushViewController.h
//  PushPic
//
//  Created by wonymini on 10/9/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemovedPushViewController : UIViewController

@property (strong, nonatomic) NSDictionary *m_dictItem;
@property (weak, nonatomic) IBOutlet UIImageView *m_imageViewVerified;
@property (weak, nonatomic) IBOutlet UILabel *m_labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *m_labelLikeCnt;
@property (weak, nonatomic) IBOutlet UILabel *m_labelViewCnt;


- (IBAction)onTouchNavBackBtn:(id)sender;

@end
