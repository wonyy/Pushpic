//
//  CustomMoviePlayerViewController.m
//
//  Copyright iOSDeveloperTips.com All rights reserved.
//

#import "CustomMoviePlayerViewController.h"

#pragma mark -
#pragma mark Compiler Directives & Static Variables

@implementation CustomMoviePlayerViewController

/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
- (id)initWithPath:(NSString *)moviePath
{
	// Initialize and create movie URL
  if (self = [super init])
  {
	  movieURL = [NSURL fileURLWithPath:moviePath];    
  }
	return self;
}

/*---------------------------------------------------------------------------
* For 3.2 and 4.x devices
* For 3.1.x devices see moviePreloadDidFinish:
*--------------------------------------------------------------------------*/
- (void) moviePlayerLoadStateChanged:(NSNotification*)notification 
{
	// Unless state is unknown, start playback
	if ([mp loadState] != MPMovieLoadStateUnknown)
  {
  	// Remove observer
    [[NSNotificationCenter 	defaultCenter] 
    												removeObserver:self
                         		name:MPMoviePlayerLoadStateDidChangeNotification 
                         		object:nil];

    // When tapping movie, status bar will appear, it shows up
    // in portrait mode by default. Set orientation to landscape
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];

		// Rotate the view for landscape playback
	  [[self view] setBounds:CGRectMake(0, 0, 768, 1024)];//0, 0, 768,1004
		[[self view] setCenter:CGPointMake(384, 502)];
		[[self view] setTransform:CGAffineTransformMakeRotation(0)]; 

		// Set frame of movieplayer
		[[mp view] setFrame:CGRectMake(0, 0, 768, 1024)];
    
    // Add movie player as subview
	  [[self view] addSubview:[mp view]];   

		// Play the movie
		[mp play];
	}
}

/*---------------------------------------------------------------------------
* For 3.1.x devices
* For 3.2 and 4.x see moviePlayerLoadStateChanged: 
*--------------------------------------------------------------------------*/
- (void) moviePreloadDidFinish:(NSNotification*)notification 
{
	// Remove observer
	[[NSNotificationCenter 	defaultCenter] 
													removeObserver:self
                        	name:MPMoviePlayerLoadStateDidChangeNotification
                        	object:nil];

	// Play the movie
 	[mp play];
}

/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
- (void) moviePlayBackDidFinish:(NSNotification*)notification 
{    
 // [[UIApplication sharedApplication] setStatusBarHidden:NO];

 	// Remove observer
  [[NSNotificationCenter 	defaultCenter] 
  												removeObserver:self
  		                   	name:MPMoviePlayerPlaybackDidFinishNotification 
      		               	object:nil];

    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    //UIViewAnimationTransitionFlipFromLeft
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.375];
    [self.navigationController popViewControllerAnimated:NO];
    [UIView commitAnimations];
    
    
	//[self dismissModalViewControllerAnimated:YES];	
}

/*---------------------------------------------------------------------------
*
*--------------------------------------------------------------------------*/
- (void) readyPlayer
{
 	mp =  [[MPMoviePlayerController alloc] initWithContentURL:movieURL];

  if ([mp respondsToSelector:@selector(loadState)]) 
  {
  	// Set movie player layout
  	[mp setControlStyle:MPMovieControlStyleFullscreen];
    [mp setFullscreen:YES];

		// May help to reduce latency
		[mp prepareToPlay];

		// Register that the load state changed (movie is ready)
		[[NSNotificationCenter defaultCenter] addObserver:self 
                       selector:@selector(moviePlayerLoadStateChanged:) 
                       name:MPMoviePlayerLoadStateDidChangeNotification 
                       object:nil];
	}  
  else
  {
    // Register to receive a notification when the movie is in memory and ready to play.
    [[NSNotificationCenter defaultCenter] addObserver:self 
                         selector:@selector(moviePreloadDidFinish:) 
                         name:MPMoviePlayerLoadStateDidChangeNotification 
                         object:nil];
      
  }

  // Register to receive a notification when the movie has finished playing. 
  [[NSNotificationCenter defaultCenter] addObserver:self 
                        selector:@selector(moviePlayBackDidFinish:) 
                        name:MPMoviePlayerPlaybackDidFinishNotification 
                        object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
- (void) loadView
{
  [self setView:[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]]];
	[[self view] setBackgroundColor:[UIColor blackColor]];
}

/*---------------------------------------------------------------------------
*  
*--------------------------------------------------------------------------*/

@end
