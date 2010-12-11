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

#import <UIKit/UIKit.h>

@protocol SliderPageControlDelegate
@optional
- (NSString *)sliderPageController:(id)controller hintTitleForPage:(NSInteger)page;
- (BOOL)respondsToSelector:(SEL)aSelector;
@end


@interface SliderPageControl : UIControl {
	UIImageView *backgroundView;
	int numberOfPages;
	int currentPage;
	UIImageView *slider;
	CGPoint beganPoint;
	BOOL hasDragged;
	UIView *maskView;
	UILabel *hintLabel;
	id<SliderPageControlDelegate> delegate;
	BOOL showsHint;
}

@property (nonatomic, retain) id<SliderPageControlDelegate> delegate;
@property (nonatomic, assign) BOOL showsHint;
@property (nonatomic, retain) UIImageView *backgroundView;
@property (nonatomic, retain) UIImageView *slider;

- (void)setNumberOfPages:(int)page;
- (int)currentPage;
- (void)setCurrentPage:(int)_currentPage animated:(BOOL)animated;

@end
