//
//	The MIT License (MIT)
//
//	Copyright © 2015-2016 Jacopo Filié
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//

////////////////////////////////////////////////////////////////////////////////////////////////////

#import "UIButton+JFFramework.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

NS_ASSUME_NONNULL_BEGIN
@interface JFActivityIndicatorView : UIView

// MARK: Properties - Data
@property (copy, nonatomic, nullable)	NSString*			buttonTitle; // The button will be removed if 'nil' or empty.
@property (copy, nonatomic, nullable)	NSArray<UIImage*>*	indicatorImages; // The indicator will be replaced by an animated image view if the array is not 'nil' nor empty.
@property (copy, nonatomic, nullable)	NSString*			text; // Use 'setText:animated:' to animate the transition.

// MARK: Properties - User interface (Actions)
@property (strong, nonatomic, nullable)	JFButtonBlock	buttonActionBlock; // The button will be removed if 'nil'.

// MARK: Properties - User interface (Appearance)
@property (strong, nonatomic, null_resettable)	UIColor*						backgroundColor;
@property (strong, nonatomic, nullable)			UIColor*						buttonTitleColor;
@property (strong, nonatomic, null_resettable)	UIColor*						containerBackgroundColor;
@property (strong, nonatomic, nullable)			UIImage*						containerBackgroundImage;
@property (assign, nonatomic)					CGFloat							containerCornerRadius; // Default is '8.0'.
@property (strong, nonatomic, null_resettable)	UIColor*						indicatorColor;
@property (assign, nonatomic)					NSTimeInterval					indicatorImagesAnimationDuration; // Default is '0'.
@property (assign, nonatomic)					CGSize							indicatorImagesSize; // Default is 'CGSizeZero'.
@property (assign, nonatomic)					UIActivityIndicatorViewStyle	indicatorStyle; // Default is 'UIActivityIndicatorViewStyleWhiteLarge'.
@property (strong, nonatomic, null_resettable)	UIColor*						textColor;

// MARK: Properties - User interface (Flags)
@property (assign, nonatomic, getter=isContainerHidden)	BOOL	containerHidden; // Default is 'NO'.

// MARK: Properties accessors - Data
- (void)	setText:(NSString* __nullable)text animated:(BOOL)animated;

// MARK: Methods - Memory management
- (instancetype __nullable)	initWithCoder:(NSCoder*)aDecoder NS_DESIGNATED_INITIALIZER;
- (instancetype)			initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
