//
//  QBSimpleSyncRefreshControl.m
//  QBRefreshControlDemo
//
//  Created by Katsuma Tanaka on 2012/11/23.
//  Copyright (c) 2012年 Katsuma Tanaka. All rights reserved.
//

#import "QBSimpleSyncRefreshControl.h"

#import "QBAnimationSequence.h"
#import "QBAnimationGroup.h"
#import "QBAnimationItem.h"

@interface QBSimpleSyncRefreshControl ()
{
    QBAnimationSequence *_sequence;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGFloat angle;

@end

@implementation QBSimpleSyncRefreshControl

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.frame = CGRectMake(0, 0, 320, 80);
        self.threshold = -80;
        waekObj = self;
        self.backgroundColor = [UIColor whiteColor];
        
        self.angle = 0;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 10, 60, 60)];
        _imageView.image = [UIImage imageNamed:@"load1.png"];
        
        [self addSubview:_imageView];
        //self.imageView = _imageView;
        
        [_imageView setAnimationImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"load1.png"],[UIImage imageNamed:@"load2.png"],[UIImage imageNamed:@"load3.png"],[UIImage imageNamed:@"load4.png"],[UIImage imageNamed:@"load3.png"],[UIImage imageNamed:@"load2.png"], nil ]];
        [_imageView setAnimationDuration:1.8];
        [_imageView setAnimationRepeatCount:9999];
       // [_imageView startAnimating];
        
        
        // QBAnimationSequence
       /*         
        QBAnimationItem *item2 = [QBAnimationItem itemWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^ {
            _imageView.transform = CGAffineTransformMakeScale(1.01, 1.01);
            
        }];
        
        QBAnimationItem *item3 = [QBAnimationItem itemWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^ {
            _imageView.transform = CGAffineTransformMakeScale(1, 1);
           
        }];
        
        QBAnimationGroup *group1 = [QBAnimationGroup groupWithItems:@[item2]];
        QBAnimationGroup *group2 = [QBAnimationGroup groupWithItems:@[item3]];
        
        _sequence = [[QBAnimationSequence alloc] initWithAnimationGroups:@[group1, group2] repeat:YES];
        [_sequence start];
        */

        
    }
    
    return self;
}

- (void)setState:(QBRefreshControlState)state
{
    [super setState:state];
    
    switch(state) {
        case QBRefreshControlStateHidden:
            break;
        case QBRefreshControlStatePullingDown:
            // NSLog(@"QBRefreshControlStatePullingDown");
            //break;
        case QBRefreshControlStateOveredThreshold:
        {
           // NSLog(@"QBRefreshControlStateOveredThreshold");
            CGPoint contentOffset = self.scrollView.contentOffset;
            
            CGFloat angle = contentOffset.y * 180.0 / M_PI * 0.001;
            //self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, self.angle - angle);
            //self.imageView.transform = CGA
            self.angle = angle;
        }
            break;
        case QBRefreshControlStateStopping:
            break;
    }
}

- (void)beginRefreshing
{
    [super beginRefreshing];
    [_imageView startAnimating];
    
    //[_sequence start];
   // _imageView.image = [UIImage imageNamed:@"load1.png"];
   // index=0;
   // isStartAnimation = YES;
   // [self startImageAnimation];
   
}

- (void)endRefreshing
{
    [super endRefreshing];    
    [_imageView stopAnimating];
   // [_sequence stop];
    
   // isStartAnimation=NO;
}

-(void)startImageAnimation
{
    index++;
    if(index==5)
        index=1;
    
    [UIView transitionWithView:_imageView
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        
                        _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"load%d",index]];
                        
                        
                    } completion:^(BOOL finished) {
                        if(isStartAnimation && waekObj)
                            //[waekObj performSelector:@selector(startImageAnimation) withObject:nil afterDelay:0.2];
                            [waekObj startImageAnimation];
                    }
     ];
}

-(void)stoptImageAnimation
{
    
}

@end
