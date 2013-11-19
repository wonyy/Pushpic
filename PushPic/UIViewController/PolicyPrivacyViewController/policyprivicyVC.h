//
//  policyprivicyVC.h
//  PushPic
//
//  Created by Mic mini 5 on 8/14/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface policyprivicyVC : UIViewController
{
    IBOutlet UILabel *lblTitleLabel;
    IBOutlet UITextView *tv;
}
@property (strong, nonatomic) IBOutlet UIWebView *wvPolicy;
-(IBAction)back:(id)sender;
@end
