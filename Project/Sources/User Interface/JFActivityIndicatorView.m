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

#import "JFActivityIndicatorView.h"

#import "JFColor.h"
#import "JFString.h"
#import "JFUtilities.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN
@interface JFActivityIndicatorView ()

// MARK: Properties - User interface
@property (weak, nonatomic, nullable)	UIButton*					button;
@property (weak, nonatomic, nullable)	UIImageView*				containerImageView;
@property (weak, nonatomic, nullable)	UIView*						containerView;
@property (weak, nonatomic, nullable)	UIImageView*				imageView;
@property (weak, nonatomic, nullable)	UIActivityIndicatorView*	indicatorView;
@property (weak, nonatomic, nullable)	UILabel*					textLabel;

// MARK: Properties - User interface (Constraints)
@property (strong, nonatomic, readonly)	NSMutableArray<NSLayoutConstraint*>*	constraints;

// MARK: Properties - User interface (Flags)
@property (assign, nonatomic, getter=isButtonHidden)		BOOL	buttonHidden;
@property (assign, nonatomic, getter=isIndicatorViewHidden)	BOOL	indicatorViewHidden;
@property (assign, nonatomic, getter=isTextLabelHidden)		BOOL	textLabelHidden;

// MARK: Methods - Memory management
+ (void)	initializeProperties:(JFActivityIndicatorView*)object;

// MARK: Methods - User interface management
- (void)	toggleAnimation;
- (void)	updateDisplay;

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

NS_ASSUME_NONNULL_BEGIN
@implementation JFActivityIndicatorView

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize buttonTitle		= _buttonTitle;
@synthesize indicatorImages	= _indicatorImages;
@synthesize text			= _text;

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

@synthesize button				= _button;
@synthesize containerImageView	= _containerImageView;
@synthesize containerView		= _containerView;
@synthesize imageView			= _imageView;
@synthesize indicatorView		= _indicatorView;
@synthesize textLabel			= _textLabel;

// =================================================================================================
// MARK: Properties - User interface (Actions)
// =================================================================================================

@synthesize buttonActionBlock	= _buttonActionBlock;

// =================================================================================================
// MARK: Properties - User interface (Appearance)
// =================================================================================================

@dynamic	backgroundColor;

@synthesize buttonTitleColor					= _buttonTitleColor;
@synthesize containerBackgroundColor			= _containerBackgroundColor;
@synthesize containerBackgroundImage			= _containerBackgroundImage;
@synthesize containerCornerRadius				= _containerCornerRadius;
@synthesize indicatorColor						= _indicatorColor;
@synthesize indicatorImagesAnimationDuration	= _indicatorImagesAnimationDuration;
@synthesize indicatorImagesSize					= _indicatorImagesSize;
@synthesize indicatorStyle						= _indicatorStyle;
@synthesize textColor							= _textColor;

// =================================================================================================
// MARK: Properties - User interface (Constraints)
// =================================================================================================

@synthesize constraints	= _constraints;

// =================================================================================================
// MARK: Properties - User interface (Flags)
// =================================================================================================

@synthesize buttonHidden		= _buttonHidden;
@synthesize containerHidden		= _containerHidden;
@synthesize indicatorViewHidden	= _indicatorViewHidden;
@synthesize textLabelHidden		= _textLabelHidden;

// =================================================================================================
// MARK: Properties accessors - Data
// =================================================================================================

- (void)setButtonTitle:(NSString* __nullable)buttonTitle
{
	if(JFAreObjectsEqual(_buttonTitle, buttonTitle))
		return;
	
	buttonTitle = [buttonTitle copy];
	_buttonTitle = buttonTitle;
	
	self.buttonHidden = (JFStringIsNullOrEmpty(buttonTitle) || !self.buttonActionBlock);
	
	if(self.window)
		[self.button setTitle:buttonTitle forState:UIControlStateNormal];
}

- (void)setIndicatorImages:(NSArray<UIImage*>* __nullable)indicatorImages
{
	if(JFAreObjectsEqual(_indicatorImages, indicatorImages))
		return;
	
	indicatorImages = [indicatorImages copy];
	_indicatorImages = indicatorImages;
	
	self.indicatorViewHidden = (indicatorImages.count > 0);
	
	if(self.window)
		self.imageView.animationImages = indicatorImages;
}

- (void)setText:(NSString* __nullable)text
{
	[self setText:text animated:NO];
}

- (void)setText:(NSString* __nullable)text animated:(BOOL)animated
{
	if(JFAreObjectsEqual(_text, text))
		return;
	
	text = [text copy];
	_text = text;
	
	self.textLabelHidden = JFStringIsNullOrEmpty(text);
	
	if(self.window)
	{
		UILabel* label = self.textLabel;
		
		JFBlock animations = ^(void)
		{
			label.text = text;
		};
		
		[UIView transitionWithView:self duration:(animated ? JFAnimationDuration : 0) options:UIViewAnimationOptionTransitionCrossDissolve animations:animations completion:nil];
	}
}

// =================================================================================================
// MARK: Properties - User interface (Appearance)
// =================================================================================================

- (void)setBackgroundColor:(UIColor* __nullable)backgroundColor
{}

- (void)setButtonTitleColor:(UIColor* __nullable)buttonTitleColor
{}

- (void)setContainerBackgroundColor:(UIColor* __nullable)containerBackgroundColor
{}

- (void)setContainerBackgroundImage:(UIImage* __nullable)containerBackgroundImage
{}

- (void)setContainerCornerRadius:(CGFloat)containerCornerRadius
{}

- (void)setIndicatorColor:(UIColor* __nullable)indicatorColor
{}

- (void)setIndicatorImagesAnimationDuration:(NSTimeInterval)indicatorImagesAnimationDuration
{}

- (void)setIndicatorImagesSize:(CGSize)indicatorImagesSize
{}

- (void)setIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle
{}

- (void)setTextColor:(UIColor* __nullable)textColor
{}

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

+ (void)initializeProperties:(JFActivityIndicatorView*)object
{
	// User interface (Appearance)
	object->_containerBackgroundColor			= [UIColor blackColor];
	object->_containerBackgroundImage			= nil;
	object->_containerCornerRadius				= 8;
	object->_indicatorColor						= [UIColor whiteColor];
	object->_indicatorImagesAnimationDuration	= 0;
	object->_indicatorImagesSize				= CGSizeZero;
	object->_indicatorStyle						= UIActivityIndicatorViewStyleWhiteLarge;
	object->_textColor							= [UIColor lightTextColor];
	
	// User interface (Constraints)
	object->_constraints	= [NSMutableArray<NSLayoutConstraint*> new];
	
	// User interface (Flags)
	object->_buttonHidden			= YES;
	object->_containerHidden		= NO;
	object->_indicatorViewHidden	= NO;
	object->_textLabelHidden		= YES;
	
	// User interface (Inherited)
	object.backgroundColor = nil;
	object.opaque = NO;
	object.userInteractionEnabled = YES;
}

- (instancetype __nullable)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		// Initializes the datamembers.
		[JFActivityIndicatorView initializeProperties:self];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	// Initializes the datamembers.
	[JFActivityIndicatorView initializeProperties:self];
	
	return self;
}

// =================================================================================================
// MARK: Methods - User interface management
// =================================================================================================

- (void)toggleAnimation
{}

- (void)updateDisplay
{}

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
