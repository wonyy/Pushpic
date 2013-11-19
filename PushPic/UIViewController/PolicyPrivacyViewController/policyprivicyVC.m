

#import "policyprivicyVC.h"
#import "WebServices.h"
#import "WSList.h"
#import "AppConstant.h"

@implementation policyprivicyVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    [_wvPolicy loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[WSList strGetPrivacy] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
     [lblTitleLabel setFont:MyriadPro_Bold_23];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWvPolicy:nil];
    lblTitleLabel = nil;
    [super viewDidUnload];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
