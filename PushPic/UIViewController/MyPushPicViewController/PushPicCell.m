//
//  PushPicCell.m
//  PushPic
//
//  Created by openxcell on 9/9/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import "PushPicCell.h"
#import "DataKeeper.h"

@implementation PushPicCell
@synthesize iv, m_strImgURL, btnMediaThumb, btnFav, btnInfo;
//@synthesize wv;
@synthesize player;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 20 - 44)];
        iv.userInteractionEnabled = YES;
        iv.backgroundColor = [UIColor whiteColor];
        iv.hidden = YES;
        
        btnMediaThumb = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnMediaThumb setFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 20 -  88)];
        [btnMediaThumb setImage:[UIImage imageNamed:@"playIcon"] forState:UIControlStateNormal];
        [btnMediaThumb setImage:[UIImage imageNamed:@"emptyimage@2x"] forState:UIControlStateSelected];
        
        btnFav = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnFav setFrame:CGRectMake(7, 7, 33, 33)];
        [btnFav setBackgroundImage:[UIImage imageNamed:@"like@2x"] forState:UIControlStateNormal];
        

        btnInfo = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnInfo setFrame:CGRectMake(320 - 37, 7, 30, 30)];
        [btnInfo setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
        
        [self addSubview:iv];
        [self addSubview:btnMediaThumb];
        [self addSubview:btnFav];
        [self addSubview:btnInfo];
    }
    return self;
}

- (void) playerPlaybackDidFinish:(NSNotification*)notification
{
    NSLog(@"WHY?");
    [self.iv setHidden: NO];
    [self.btnMediaThumb setSelected: NO];
    [self.btnMediaThumb setHidden: NO];
    
    if (player != nil) {
        [player.view removeFromSuperview];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) playCurrentVideo: (NSString *) strVideoURL {
    
    
 //   if (player != nil && player.view != nil) {
 //       [player.view removeFromSuperview];
 //   }
   
    if (player == nil) {
        NSURL *url = [[NSURL alloc] initWithString: strVideoURL];
    
    
        player = [[MPMoviePlayerController alloc] initWithContentURL: url];
        player.shouldAutoplay = NO;
        player.scalingMode = MPMovieScalingModeAspectFill;
        [player setControlStyle: MPMovieControlStyleNone];
        [player prepareToPlay];
        
        [player.view setFrame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];  // player's frame must match parent's
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.player];
    }
    
    [self addSubview: player.view];
    [self bringSubviewToFront: btnMediaThumb];
    
    [player play];
}

#pragma mark - Set Image to cell

- (void) refreshImage {
    [NSThread detachNewThreadSelector:@selector(getImage) toTarget:self withObject:nil];
}

- (void) getImage {
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    NSLog(@"Image URL: %@", m_strImgURL);
    
    UIImage *image = [dataKeeper getImage: m_strImgURL toSize:self.frame.size];
    
//    UIImage *image = [dataKeeper getImage: m_strImgURL];
    
    if (image != nil) {
        [iv setImage: image];
        self.iv.hidden = NO;
    }
    

}




@end
