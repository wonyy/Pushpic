//
//  RemovedPushViewController.m
//  PushPic
//
//  Created by wonymini on 10/9/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import "RemovedPushViewController.h"

@interface RemovedPushViewController ()

@end

@implementation RemovedPushViewController

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
    // Do any additional setup after loading the view from its nib.
    
    NSDictionary *dictMedia = [_m_dictItem objectForKey:@"Media"];
    
    if ([[dictMedia objectForKey:@"eHideUserName"] isEqualToString:@"No"]) {
        [_m_labelUserName setText:[NSString stringWithFormat:@"@%@", [dictMedia objectForKey:@"vUserName"]]];
    }
    
    int likeCount = [[dictMedia valueForKey:@"iMediaLikesCount"] intValue];
    
    if (likeCount > 0) {
        if (likeCount == 1)
            [_m_labelLikeCnt setText:[NSString stringWithFormat:@"%d Like", likeCount]];
        else
            [_m_labelLikeCnt setText:[NSString stringWithFormat:@"%d Likes", likeCount]];
    } else {
        [_m_labelLikeCnt setText:@""];
    }
    
    
    [_m_labelViewCnt setText:[NSString stringWithFormat:@"%@ Views", [dictMedia valueForKey:@"iMediaViewsCount"]]];
    
    if ([[dictMedia valueForKey:@"eVerified"] isEqualToString:@"No"]) {
        [_m_imageViewVerified setHidden: YES];
        [_m_labelUserName setFrame:CGRectMake(7, _m_labelUserName.frame.origin.y, _m_labelUserName.frame.size.width, _m_labelUserName.frame.size.height)];
        
    } else {
        [_m_imageViewVerified setHidden: NO];
        
        [_m_labelUserName setFrame:CGRectMake(54, _m_labelUserName.frame.origin.y, _m_labelUserName.frame.size.width, _m_labelUserName.frame.size.height)];
    }
    
    if ([[dictMedia valueForKey:@"eCelebrities"] isEqualToString:@"No"]) {
        [_m_imageViewVerified setHidden: YES];
        [_m_labelUserName setFrame:CGRectMake(7, _m_labelUserName.frame.origin.y, _m_labelUserName.frame.size.width, _m_labelUserName.frame.size.height)];
        
    } else {
        [_m_imageViewVerified setHidden: NO];
        
        [_m_labelUserName setFrame:CGRectMake(54, _m_labelUserName.frame.origin.y, _m_labelUserName.frame.size.width, _m_labelUserName.frame.size.height)];
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setM_imageViewVerified:nil];
    [self setM_labelUserName:nil];
    [self setM_labelLikeCnt:nil];
    [self setM_labelViewCnt:nil];
    [super viewDidUnload];
}

#pragma mark - Actions

- (IBAction)onTouchNavBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}


@end
