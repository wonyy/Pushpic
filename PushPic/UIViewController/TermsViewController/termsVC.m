//
//  termsVC.m
//  PushPic
//
//  Created by Mic mini 5 on 8/14/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import "termsVC.h"
#import "WebServices.h"
#import "WSList.h"
#import "AppConstant.h"

@implementation termsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_wvTerms loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[WSList strGetTerms] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    
    [lblTitleLabel setFont:MyriadPro_Bold_23];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWvTerms:nil];
    lblTitleLabel = nil;
    lblTitleLabel = nil;
    [super viewDidUnload];
}

#pragma mark - Touch Actions

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
