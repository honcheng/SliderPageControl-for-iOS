SliderPageControl for iOS
=========================

This is an alternative for UIPageControl. See video [here](http://www.honcheng.com/2010/12/SliderPageControl---open-source-alternative-for-UIPageControl-in-iOS)

Required Files
--------------
1. SliderPageControl.h
2. SliderPageControl.m
3. SliderPageControl.bundle/images/sliderPageControl.png
4. SliderPageControl.bundle/images/sliderPageControlBg.png

Usage
-----

1) To integrate SliderPageControl, drag the files above to your XCode Project, and add to your view. 

     #import SliderPageControl.h
    
2) set number of pages

    - (void)setNumberOfPages:(int)page

3) returns the current page

    - (int)currentPage
	
4) set the current page. set animated=YES to animate the control

    - (void)setCurrentPage:(int)_currentPage animated:(BOOL)animated
	
5) set page title that is visible when the control is dragged

    - (NSString *)sliderPageController:(id)controller hintTitleForPage:(NSInteger)page

6) Skinning SliderPageControl
To skin SliderPageControl, use the provided PSD file to change the control image (sliderPageControl.png) and the background (sliderPageControlBg.png)

You can find more information about SliderPageControl at the link below

Requirements
------------
* ARC
* XCode 4.4 (auto-synthesis)

Contact
-------

[@honcheng](http://twitter.com/honcheng)  
[honcheng.com](http://honcheng.com)

![](http://www.cocoacontrols.com/analytics/honcheng/sliderpagecontrol-for-ios.png)