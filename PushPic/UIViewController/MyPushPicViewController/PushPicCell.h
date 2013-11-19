//
//  PushPicCell.h
//  PushPic
//
//  Created by openxcell on 9/9/13.
//  Copyright (c) 2013 KPIteng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PushPicCell : UITableViewCell {
    
}

@property (strong, nonatomic) MPMoviePlayerController *player;
//@property (strong, nonatomic) EGOImageView *iv;
@property (strong, nonatomic) UIImageView *iv;
@property (strong, nonatomic) NSString *m_strImgURL;
@property (strong, nonatomic) UIButton  *btnMediaThumb, *btnInfo, *btnFav;

- (void) playCurrentVideo: (NSString *) strVideoURL;
- (void) refreshImage;

@end
