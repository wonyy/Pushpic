//
//  termsVC.h
//  PushPic
//
//  Created by Mic mini 5 on 8/14/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface termsVC : UIViewController
{
    IBOutlet UITextView *tv;
    IBOutlet UILabel *lblTitleLabel;
}

@property (strong, nonatomic) IBOutlet UIWebView *wvTerms;

- (IBAction)back:(id)sender;

@end
