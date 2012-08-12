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

#import "SliderPageControlDemoViewController.h"


@implementation SliderPageControlDemoViewController

- (id)init
{
	if (self = [super init])
	{
		[self.view setBackgroundColor:[UIColor blackColor]];
		
		_demoContent = [NSMutableArray array];
		NSMutableDictionary *page1 = [NSMutableDictionary dictionary];
		[page1 setObject:@"RED" forKey:@"title"];
		[page1 setObject:[UIColor redColor] forKey:@"color"];
		[_demoContent addObject:page1];
		NSMutableDictionary *page2 = [NSMutableDictionary dictionary];
		[page2 setObject:@"ORANGE" forKey:@"title"];
		[page2 setObject:[UIColor orangeColor] forKey:@"color"];
		[_demoContent addObject:page2];
		NSMutableDictionary *page3 = [NSMutableDictionary dictionary];
		[page3 setObject:@"YELLOW" forKey:@"title"];
		[page3 setObject:[UIColor yellowColor] forKey:@"color"];
		[_demoContent addObject:page3];
		NSMutableDictionary *page4 = [NSMutableDictionary dictionary];
		[page4 setObject:@"GREEN" forKey:@"title"];
		[page4 setObject:[UIColor greenColor] forKey:@"color"];
		[_demoContent addObject:page4];
		NSMutableDictionary *page5 = [NSMutableDictionary dictionary];
		[page5 setObject:@"BLUE" forKey:@"title"];
		[page5 setObject:[UIColor blueColor] forKey:@"color"];
		[_demoContent addObject:page5];
		NSMutableDictionary *page6 = [NSMutableDictionary dictionary];
		[page6 setObject:@"PURPLE" forKey:@"title"];
		[page6 setObject:[UIColor purpleColor] forKey:@"color"];
		[_demoContent addObject:page6];
		
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,[self.view bounds].size.width,[self.view bounds].size.height)];
		[_scrollView setPagingEnabled:YES];
		[_scrollView setContentSize:CGSizeMake([self.demoContent count]*self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
		[_scrollView setShowsHorizontalScrollIndicator:NO];
		[_scrollView setDelegate:self];
		[self.view addSubview:_scrollView];
		
		_sliderPageControl = [[SliderPageControl  alloc] initWithFrame:CGRectMake(0,[self.view bounds].size.height-20,[self.view bounds].size.width,20)];
		[_sliderPageControl addTarget:self action:@selector(onPageChanged:) forControlEvents:UIControlEventValueChanged];
		[_sliderPageControl setDelegate:self];
		[_sliderPageControl setShowsHint:YES];
		[self.view addSubview:_sliderPageControl];
		[_sliderPageControl setNumberOfPages:[self.demoContent count]];
		[_sliderPageControl setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
		
		
		for (int i=0; i<[_demoContent count]; i++)
		{
			UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*_scrollView.frame.size.width,0,_scrollView.frame.size.width,_scrollView.frame.size.height)];
			[view setBackgroundColor:[[_demoContent objectAtIndex:i] objectForKey:@"color"]];
			[_scrollView addSubview:view];
		}
		
		[self changeToPage:1 animated:NO];
	}
	return self;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark scrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_
{
	self.pageControlUsed = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.pageControlUsed) 
	{
        return;
    }
	
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	[self.sliderPageControl setCurrentPage:page animated:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView_
{
	self.pageControlUsed = NO;
}

#pragma mark sliderPageControlDelegate

- (NSString *)sliderPageController:(id)controller hintTitleForPage:(NSInteger)page
{
	NSString *hintTitle = [[self.demoContent objectAtIndex:page] objectForKey:@"title"];
	return hintTitle;
}

- (void)onPageChanged:(id)sender
{
	self.pageControlUsed = YES;
	[self slideToCurrentPage:YES];
}

- (void)slideToCurrentPage:(bool)animated 
{
	int page = self.sliderPageControl.currentPage;
	
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:animated];
}

- (void)changeToPage:(int)page animated:(BOOL)animated
{
	[self.sliderPageControl setCurrentPage:page animated:YES];
	[self slideToCurrentPage:animated];
}

@end
