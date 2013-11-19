//
//  PushPicViewController.m
//  PushPic
//
//  Created by KPIteng on 8/2/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import "PushPicViewController.h"
#define hll_color(r,g,b,a) [UIColor colorWithRed:(float)r/255.f green:(float)g/255.f blue:(float)b/255.f  alpha:a]

@interface UIColor (HLLAdditions)

//the background color for the current cell
+ (UIColor*)hll_backgroundColorForIndex:(NSUInteger)index;

@end

@interface PushPicViewController ()

@end

@implementation PushPicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [lblNavTitle setFont:MyriadPro_Bold_20];
    [btnSignIn setFrame:CGRectMake(0, 364, 320, 48)];
    [btnSignUp setFrame:CGRectMake(0, 412, 320, 48)];
    if(ISiPhone5)
        [ivBG setImage:[UIImage imageNamed:@"Default-568h@2x"]];
    else
        [ivBG setImage:[UIImage imageNamed:@"Default@2x"]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


#pragma mark - UIButton Methods
- (IBAction)btnSignInTapped:(id)sender{
    objSignInViewController = [[SignInViewController alloc] init];
    [self.navigationController pushViewController:objSignInViewController animated:YES];
}

- (IBAction)btnSignUpTapped:(id)sender {
    objSignUpViewController = [[SignUpViewController alloc] init];
    [self.navigationController pushViewController:objSignUpViewController animated:YES];
}

- (IBAction)btnStartTourTapped:(id)sender{
    objCaptureViewController = [[CaptureViewController alloc]initWithNibName:@"CaptureViewController" bundle:nil];
    [self.navigationController pushViewController:objCaptureViewController animated:YES];
}



/*
#pragma mark - Table Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.aryAccounts count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Default Cell
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    ACAccount *act = [self.aryAccounts objectAtIndex:indexPath.row];
    cell.textLabel.text = act.username;
    [cell.textLabel setFont:MyriadPro_Regular_11];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACAccount *act = [self.aryAccounts objectAtIndex:indexPath.row];
    NSLog(@"%@",act.accountDescription);
    NSLog(@"%@",act.accountType);
    [self hidePopOver];
    objCaptureViewController = [[CaptureViewController alloc]initWithNibName:@"CaptureViewController" bundle:nil];
    [self.navigationController pushViewController:objCaptureViewController animated:YES];
    //NSDictionary *dictUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:act.username,@"Email", nil];
}
*/

@end


@implementation UIColor (HLLAdditions)

/* the cyclic background colors */
+ (NSArray*)hll_backgroundColors
{
    return @[hll_color(255, 117, 96, 1), hll_color(254, 89, 121, 1), hll_color(233, 71, 144, 1), hll_color(255, 103, 193, 1), hll_color(197, 130, 236, 1), hll_color(164, 158, 255, 1), hll_color(159, 182, 249, 1), hll_color(164, 158, 255, 1), hll_color(197, 130, 236, 1), hll_color(255, 103, 193, 1),  hll_color(233, 71, 144, 1)];
}

+ (UIColor*)hll_backgroundColorForIndex:(NSUInteger)index
{
    index = index % [self hll_backgroundColors].count;
    UIColor *color = [self hll_backgroundColors][index];
    
    NSAssert(nil != color, @"nil color");
    return color;
}




@end