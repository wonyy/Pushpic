/*
 Copyright (c) 2010 Robert Chin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "RCSwitchClone.h"
#import "AppConstant.h"

@implementation RCSwitchClone

- (void)initCommon
{
	[super initCommon];
	
	useImage = NO;
	NSArray *langs = [NSLocale preferredLanguages];
	if([langs count] > 0){
		NSString *langCode = [langs objectAtIndex:0];
		/* Note that the japanese localization for the switch will only load if you have
		 a Japanese Localizable.strings file in your app bundle. */
		if(![langCode isEqualToString:@"en"] && [langCode isEqualToString:@"ja"])
			useImage = NO;
	}	
	
	if(useImage){
		onImage = [[UIImage imageNamed:@"btn_slider_international_on"] retain];
		offImage = [[UIImage imageNamed:@"btn_slider_international_off"] retain];
	} else {
		onText = [UILabel new];
		onText.text =@"On";
		onText.textColor = [UIColor blackColor];
		onText.font = MyriadPro_Bold_15;
        onText.shadowOffset = CGSizeMake(0.0, -0.5);
		onText.shadowColor = [UIColor colorWithWhite:0.2 alpha:0.5];
       // onText.frame = CGRectMake(onText.frame.origin.x, onText.frame.origin.y+5, onText.frame.size.width, onText.frame.size.height-5);
		
		offText = [UILabel new];
		offText.text = @"Off";
		offText.textColor = [UIColor blackColor];
		offText.font = MyriadPro_Bold_15;
       // offText.frame = CGRectMake(offText.frame.origin.x, offText.frame.origin.y+5, offText.frame.size.width, offText.frame.size.height-5);
	}
}

- (void)dealloc
{
	[onText release];
	[offText release];
	[onImage release];
	[offImage release];
	[super dealloc];
}

- (void)drawUnderlayersInRect:(CGRect)aRect withOffset:(float)offset inTrackWidth:(float)trackWidth
{
	if (useImage){
		{
			CGPoint imagePoint = [self bounds].origin;
			imagePoint.x += 25.0 + (offset - trackWidth);
			imagePoint.y += 6.0;
			[onImage drawAtPoint:imagePoint];
			 
		}
		{
			CGPoint imagePoint = [self bounds].origin;
			imagePoint.x += -6 + (offset + trackWidth);
			imagePoint.y += 6.0;			
			[offImage drawAtPoint:imagePoint];			
		}
	} else {
		{
			CGRect textRect = [self bounds];
			textRect.origin.x += 19.0 + (offset - trackWidth);
            textRect.origin.y+= 3.0 ;

			[onText drawTextInRect:textRect];
		}
		
		{
			CGRect textRect = [self bounds];
			textRect.origin.x += -14 + (offset + trackWidth);
            textRect.origin.y+= 3.0 ;
			[offText drawTextInRect:textRect];
		}
	}
}

@end
