/**
 * Copyright (c) 2010 Muh Hon Cheng
 * Created by honcheng on 12/11/10.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining 
 * a copy of this software and associated documentation files (the 
 * "Software"), to deal in the Software without restriction, including 
 * without limitation the rights to use, copy, modify, merge, publish, 
 * distribute, sublicense, and/or sell copies of the Software, and to 
 * permit persons to whom the Software is furnished to do so, subject 
 * to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be 
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT 
 * WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR 
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT 
 * SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
 * IN CONNECTION WITH THE SOFTWARE OR 
 * THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * @author 		Muh Hon Cheng <honcheng@gmail.com>
 * @copyright	2010	Muh Hon Cheng
 * @version
 * 
 */

#import "SliderPageControl.h"

#define MASK_VISIBLE_ALPHA 0.5
#define UPPER_TOUCH_LIMIT -50

@interface SliderPageControl()
- (void)showMaskView:(BOOL)show;
- (void)displayHintForPage:(int)page;
- (void)removeMaskView;
@end

@implementation SliderPageControl
@synthesize delegate, showsHint, backgroundView, slider;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		[self setBackgroundColor:[UIColor clearColor]];
		backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
		[backgroundView setBackgroundColor:[UIColor clearColor]];
		[self addSubview:backgroundView];
		[backgroundView release];
		
		slider = [[UIImageView alloc] initWithFrame:CGRectZero];
		[slider setBackgroundColor:[UIColor clearColor]];
		[slider setAlpha:0.8];
		[self addSubview:slider];
		[slider release];
		
		[backgroundView setImage:[[UIImage imageNamed:@"SliderPageControl.bundle/images/sliderPageControlBg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
		[slider setImage:[[UIImage imageNamed:@"SliderPageControl.bundle/images/sliderPageControl.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    }
    return self;
}

- (void)setNumberOfPages:(int)page
{
	numberOfPages = page;
	[self setNeedsDisplay];
	
	int width = self.frame.size.width/numberOfPages;
	int x = width*currentPage;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[slider setFrame:CGRectMake(x,0,width,self.frame.size.height)];
	[UIView commitAnimations];
}

- (int)currentPage
{
	return currentPage;
}

- (void)setCurrentPage:(int)_currentPage animated:(BOOL)animated
{
	currentPage = _currentPage;
	
	if (animated)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	}
	
	int width = self.frame.size.width/numberOfPages;
	int x = width*currentPage;
	[slider setFrame:CGRectMake(x,0,width,self.frame.size.height)];
	if (animated) [UIView commitAnimations];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGContextRef myContext = UIGraphicsGetCurrentContext();
	float diameter = 5;
	
	CGFloat blackColor[4];
	blackColor[0]=0.0;
	blackColor[1]=0.0;
	blackColor[2]=0.0;
	blackColor[3]=1.0;
	float width = self.frame.size.width/numberOfPages;
	
	int i;
	for (i=0; i<numberOfPages; i++)
	{
		int x = i*width + (width-diameter)/2;
		CGContextSetFillColor(myContext, blackColor);
		CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
	}
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark mask view

- (void)showMaskView:(BOOL)show
{
	if (show)
	{
		if (maskView==nil)
		{
			maskView = [[UIView alloc] initWithFrame:CGRectMake(0,0,[self window].frame.size.width,[self window].frame.size.height)];
			[maskView setBackgroundColor:[UIColor blackColor]];
			[[self superview] insertSubview:maskView belowSubview:self];
			[maskView release];
			
			hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20,maskView.frame.size.width-40,maskView.frame.size.height-40)];
			[hintLabel setBackgroundColor:[UIColor clearColor]];
			[hintLabel setFont:[UIFont boldSystemFontOfSize:30]];
			[hintLabel setNumberOfLines:10];
			[hintLabel setTextAlignment:UITextAlignmentCenter];
			[hintLabel setTextColor:[UIColor whiteColor]];
			[hintLabel setShadowColor:[UIColor blackColor]];
			[hintLabel setShadowOffset:CGSizeMake(0,-1)];
			[maskView addSubview:hintLabel];
			[hintLabel release];
			
			[maskView setAlpha:0.0];
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[maskView setAlpha:MASK_VISIBLE_ALPHA];
			[UIView commitAnimations];
		}
	}
	else
	{
		if (maskView!=nil)
		{
			[maskView setAlpha:MASK_VISIBLE_ALPHA];
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(removeMaskView)];
			[maskView setAlpha:0.0];
			[UIView commitAnimations];
		}
		
	}
}

- (void)displayHintForPage:(int)page
{
	if (hintLabel!=nil)
	{
		if (showsHint)
		{
			if ([delegate respondsToSelector:@selector(sliderPageController:hintTitleForPage:)])
			{
				NSString *hintText = [delegate sliderPageController:self hintTitleForPage:page];
				[hintLabel setText:hintText];
			}
			else
			{
				[hintLabel setText:[NSString stringWithFormat:@"%i", page]];
			}
		}
		else
		{
			[hintLabel setText:@""];
		}
	}
	
}

- (void)removeMaskView
{
	[maskView removeFromSuperview];
	maskView = nil;
	hintLabel = nil;
}

#pragma mark touch delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	beganPoint = CGPointMake(slider.frame.origin.x, slider.frame.origin.y);
	CGPoint movedPoint = [[touches anyObject] locationInView:self];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	CGRect sliderFrame = [slider frame];
	float x = movedPoint.x - sliderFrame.size.width/2;
	if (x<0) x=0;
	else if (x>self.frame.size.width-sliderFrame.size.width) x = self.frame.size.width-sliderFrame.size.width;
	
	sliderFrame.origin.x = x;
	[slider setFrame:sliderFrame];
	
	[UIView commitAnimations];
	
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (!hasDragged) [self showMaskView:YES];
	
	hasDragged = YES;
	CGPoint movedPoint = [[touches anyObject] locationInView:self];
	
	CGRect sliderFrame = [slider frame];
	float x = movedPoint.x - sliderFrame.size.width/2;
	if (x<0) x=0;
	else if (x>self.frame.size.width-sliderFrame.size.width) x = self.frame.size.width-sliderFrame.size.width;
	
	sliderFrame.origin.x = x;
	[slider setFrame:sliderFrame];
	
	[super touchesMoved:touches withEvent:event];

	int hintPage = 0;
	float center_x = [slider frame].origin.x + [slider frame].size.width/2;
	int i;
	for (i=0; i<numberOfPages; i++)
	{
		float max_x = (i+1)*(self.frame.size.width/numberOfPages);
		if (center_x<=max_x)
		{
			hintPage = i;
			break;
		}
	}
	[self displayHintForPage:hintPage];
	
	if (movedPoint.y<UPPER_TOUCH_LIMIT)
	{
		float difference = UPPER_TOUCH_LIMIT - movedPoint.y;
		float full = 300;
		float ratio = 1 - difference/full;
		if (ratio<0) ratio = 0;
		[maskView setAlpha:MASK_VISIBLE_ALPHA*ratio];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesEnded:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (hasDragged) [self showMaskView:NO];
	hasDragged = NO;
	
	CGPoint endPoint = [[touches anyObject] locationInView:self];
	
	if (endPoint.y<UPPER_TOUCH_LIMIT || endPoint.y>self.frame.size.height)
	{
		// ended outside, considered a cancel, should snap to original location

		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		CGRect sliderFrame = [slider frame];
		sliderFrame.origin.x = beganPoint.x;
		[slider setFrame:sliderFrame];
		[UIView commitAnimations];
	}
	else
	{
		// touch ended inside, should snap to new location
		float center_x = [slider frame].origin.x + [slider frame].size.width/2;
		int i;
		for (i=0; i<numberOfPages; i++)
		{
			float max_x = (i+1)*(self.frame.size.width/numberOfPages);
			if (center_x<=max_x)
			{
				[UIView beginAnimations:nil context:nil];
				[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
				CGRect sliderFrame = [slider frame];
				sliderFrame.origin.x = (i)*(self.frame.size.width/numberOfPages);
				[slider setFrame:sliderFrame];
				[UIView commitAnimations];
				currentPage = i;
			
				[self sendActionsForControlEvents:UIControlEventValueChanged];
				
				break;
			}
		}
	}
	[super touchesEnded:touches withEvent:event];
}

@end
