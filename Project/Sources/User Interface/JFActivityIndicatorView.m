//
//	The MIT License (MIT)
//
//	Copyright © 2015-2019 Jacopo Filié
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

#import "JFBlocks.h"
#import "JFColors.h"
#import "JFShortcuts.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface JFActivityIndicatorView ()

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@property (class, strong, nonatomic, readonly) NSSet<NSNumber*>* buttonDictionaryKeys;
@property (strong, nonatomic, readonly) NSMutableDictionary<NSNumber*, NSString*>* buttonTitles;

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

@property (assign, nonatomic, getter=isAlertBackgroundImageHidden) BOOL alertBackgroundImageHidden;
@property (assign, nonatomic, getter=areAnimationImagesHidden) BOOL animationImagesHidden;
@property (assign, nonatomic, getter=isButtonHidden) BOOL buttonHidden;
@property (assign, nonatomic, getter=isTextHidden) BOOL textHidden;

// =================================================================================================
// MARK: Properties - User interface (Appearance)
// =================================================================================================

@property (strong, nonatomic, readonly) NSMutableDictionary<NSNumber*, UIImage*>* buttonBackgroundImages;
@property (strong, nonatomic, readonly) NSMutableDictionary<NSNumber*, UIImage*>* buttonImages;
@property (strong, nonatomic, readonly) NSMutableDictionary<NSNumber*, UIColor*>* buttonTitleColors;

// =================================================================================================
// MARK: Properties - User interface (Layout)
// =================================================================================================

@property (weak, nonatomic, nullable) UIView* alertView;
@property (weak, nonatomic, nullable) UIImageView* alertBackgroundView;
@property (weak, nonatomic, nullable) UIView* animationView;
@property (weak, nonatomic, nullable) UIButton* button;
@property (weak, nonatomic, nullable) UIImageView* imageView;
@property (assign, nonatomic) BOOL needsRebuildLayout;
@property (weak, nonatomic, nullable) UIActivityIndicatorView* spinnerView;
@property (weak, nonatomic, nullable) UILabel* textLabel;

// =================================================================================================
// MARK: Properties - User interface (Layout constraints)
// =================================================================================================

@property (strong, nonatomic, nullable) NSArray<NSLayoutConstraint*>* customConstraints;
@property (weak, nonatomic, nullable) NSLayoutConstraint* alertViewMaxHeightConstraint;
@property (weak, nonatomic, nullable) NSLayoutConstraint* alertViewMaxWidthConstraint;
@property (weak, nonatomic, nullable) NSLayoutConstraint* alertViewMinHeightConstraint;
@property (weak, nonatomic, nullable) NSLayoutConstraint* alertViewMinWidthConstraint;
@property (weak, nonatomic, nullable) NSLayoutConstraint* imageViewHeightConstraint;
@property (weak, nonatomic, nullable) NSLayoutConstraint* imageViewWidthConstraint;

// =================================================================================================
// MARK: Properties accessors - User interface (Layout)
// =================================================================================================

- (void)setNeedsRebuildLayout;

// =================================================================================================
// MARK: Methods - Memory
// =================================================================================================

+ (void)initializeProperties:(JFActivityIndicatorView*)view;

// =================================================================================================
// MARK: Methods - Layout
// =================================================================================================

- (void)toggleAnimations;

// =================================================================================================
// MARK: Methods - Layout (Layout)
// =================================================================================================

- (void)rebuildLayout;
- (void)rebuildLayoutIfNeeded;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFActivityIndicatorView

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

@synthesize animationImages = _animationImages;
@synthesize buttonTitles = _buttonTitles;
@synthesize text = _text;

// =================================================================================================
// MARK: Properties - User interface
// =================================================================================================

@synthesize alertBackgroundImageHidden = _alertBackgroundImageHidden;
@synthesize alertHidden = _alertHidden;
@synthesize animationDuration = _animationDuration;
@synthesize animationImagesHidden = _animationImagesHidden;
@synthesize animationImageSize = _animationImageSize;
@synthesize buttonHidden = _buttonHidden;
@synthesize spinnerHidden = _spinnerHidden;
@synthesize textHidden = _textHidden;

// =================================================================================================
// MARK: Properties - User interface (Actions)
// =================================================================================================

@synthesize buttonBlock = _buttonBlock;

// =================================================================================================
// MARK: Properties - User interface (Appearance)
// =================================================================================================

@synthesize alertBackgroundColor = _alertBackgroundColor;
@synthesize alertBackgroundImage = _alertBackgroundImage;
@synthesize alertBorderColor = _alertBorderColor;
@synthesize alertBorderWidth = _alertBorderWidth;
@synthesize alertCornerRadius = _alertCornerRadius;
@synthesize alertMargin = _alertMargin;
@synthesize alertMaxSize = _alertMaxSize;
@synthesize alertMinSize = _alertMinSize;
@synthesize alertPadding = _alertPadding;
@synthesize alertShadowColor = _alertShadowColor;
@synthesize alertShadowOffset = _alertShadowOffset;
@synthesize alertShadowOpacity = _alertShadowOpacity;
@synthesize alertShadowRadius = _alertShadowRadius;
@synthesize alertSpacing = _alertSpacing;
@synthesize buttonBackgroundImages = _buttonBackgroundImages;
@synthesize buttonImages = _buttonImages;
@synthesize buttonTitleColors = _buttonTitleColors;
@synthesize spinnerColor = _spinnerColor;
@synthesize spinnerStyle = _spinnerStyle;
@synthesize textColor = _textColor;
@synthesize textFont = _textFont;

// =================================================================================================
// MARK: Properties - User interface (Layout)
// =================================================================================================

@synthesize alertView = _alertView;
@synthesize alertBackgroundView = _alertBackgroundView;
@synthesize animationView = _animationView;
@synthesize button = _button;
@synthesize imageView = _imageView;
@synthesize needsRebuildLayout = _needsRebuildLayout;
@synthesize spinnerView = _spinnerView;
@synthesize textLabel = _textLabel;

// =================================================================================================
// MARK: Properties - User interface (Layout constraints)
// =================================================================================================

@synthesize customConstraints = _customConstraints;
@synthesize alertViewMaxHeightConstraint = _alertViewMaxHeightConstraint;
@synthesize alertViewMaxWidthConstraint = _alertViewMaxWidthConstraint;
@synthesize alertViewMinHeightConstraint = _alertViewMinHeightConstraint;
@synthesize alertViewMinWidthConstraint = _alertViewMinWidthConstraint;
@synthesize imageViewHeightConstraint = _imageViewHeightConstraint;
@synthesize imageViewWidthConstraint = _imageViewWidthConstraint;

// =================================================================================================
// MARK: Properties accessors - Data
// =================================================================================================

+ (NSSet<NSNumber*>*)buttonDictionaryKeys
{
	static NSSet<NSNumber*>* retObj = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSMutableSet<NSNumber*>* keys = [NSMutableSet<NSNumber*> setWithCapacity:5];
		[keys addObject:@(UIControlStateDisabled)];
		if(@available(iOS 9.0, *))
			[keys addObject:@(UIControlStateFocused)];
		[keys addObject:@(UIControlStateHighlighted)];
		[keys addObject:@(UIControlStateNormal)];
		[keys addObject:@(UIControlStateSelected)];
		retObj = [keys copy];
	});
	return retObj;
}

- (void)setAnimationImages:(NSArray<UIImage*>* __nullable)animationImages
{
	animationImages = [animationImages copy];
	if(JFAreObjectsEqual(_animationImages, animationImages))
		return;
	
	_animationImages = animationImages;
	
	self.animationImagesHidden = (!animationImages || (animationImages.count == 0));
	
	if(self.window)
		self.imageView.animationImages = animationImages;
}

- (NSString* __nullable)buttonTitle
{
	return [self buttonTitleForState:UIControlStateNormal];
}

- (NSString* __nullable)buttonTitleForState:(UIControlState)state
{
	return self.buttonTitles[@(state)];
}

- (void)setButtonTitle:(NSString* __nullable)buttonTitle
{
	[self setButtonTitle:buttonTitle forState:UIControlStateNormal];
}

- (void)setButtonTitle:(NSString* __nullable)buttonTitle forState:(UIControlState)state
{
	NSNumber* key = @(state);
	if(![[self.class buttonDictionaryKeys] containsObject:key])
	{
		NSLog(@"%@: State '%@' not supported.", ClassName, key.stringValue);
		return;
	}
	
	NSMutableDictionary<NSNumber*, NSString*>* buttonTitles = self.buttonTitles;
	
	buttonTitle = [buttonTitle copy];
	if(JFAreObjectsEqual(buttonTitles[key], buttonTitle))
		return;
	
	buttonTitles[key] = buttonTitle;
	
	self.buttonHidden = (buttonTitles.count == 0);
	
	if(self.window)
		[self.button setTitle:buttonTitle forState:state];
}

- (void)setText:(NSString* __nullable)text
{
	[self setText:text animated:NO];
}

- (void)setText:(NSString* __nullable)text animated:(BOOL)animated
{
	text = [text copy];
	if(JFAreObjectsEqual(_text, text))
		return;
	
	_text = text;
	
	self.textHidden = !text;
	
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
// MARK: Properties accessors - User interface
// =================================================================================================

- (void)setAlertBackgroundImageHidden:(BOOL)alertBackgroundImageHidden
{
	if(_alertBackgroundImageHidden == alertBackgroundImageHidden)
		return;
	
	_alertBackgroundImageHidden = alertBackgroundImageHidden;
	
	if(self.window)
		[self setNeedsRebuildLayout];
}

- (void)setAlertHidden:(BOOL)alertHidden
{
	if(_alertHidden == alertHidden)
		return;
	
	_alertHidden = alertHidden;
	
	if(self.window)
		[self setNeedsRebuildLayout];
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration
{
	if(_animationDuration == animationDuration)
		return;
	
	_animationDuration = animationDuration;
	
	if(self.window)
		self.imageView.animationDuration = animationDuration;
}

- (void)setAnimationImagesHidden:(BOOL)animationImagesHidden
{
	if(_animationImagesHidden == animationImagesHidden)
		return;
	
	_animationImagesHidden = animationImagesHidden;
	
	if(self.window)
		[self setNeedsRebuildLayout];
}

- (void)setAnimationImageSize:(CGSize)animationImageSize
{
	if(CGSizeEqualToSize(_animationImageSize, animationImageSize))
		return;
	
	_animationImageSize = animationImageSize;
	
	if(self.window)
	{
		self.imageViewHeightConstraint.constant = animationImageSize.height;
		self.imageViewWidthConstraint.constant = animationImageSize.width;
	}
}

- (void)setButtonHidden:(BOOL)buttonHidden
{
	if(_buttonHidden == buttonHidden)
		return;
	
	_buttonHidden = buttonHidden;
	
	if(self.window)
		[self setNeedsRebuildLayout];
}

- (void)setHidden:(BOOL)hidden
{
	super.hidden = hidden;
	[self toggleAnimations];
}

- (void)setSpinnerHidden:(BOOL)spinnerHidden
{
	if(_spinnerHidden == spinnerHidden)
		return;
	
	_spinnerHidden = spinnerHidden;
	
	if(self.window)
		[self setNeedsRebuildLayout];
}

- (void)setTextHidden:(BOOL)textHidden
{
	if(_textHidden == textHidden)
		return;
	
	_textHidden = textHidden;
	
	if(self.window)
		[self setNeedsRebuildLayout];
}

// =================================================================================================
// MARK: Properties accessors - User interface (Actions)
// =================================================================================================

- (void)setButtonBlock:(JFButtonBlock __nullable)buttonBlock
{
	if(JFAreObjectsEqual(_buttonBlock, buttonBlock))
		return;
	
	_buttonBlock = buttonBlock;
	
	if(self.window)
		self.button.jf_actionBlock = buttonBlock;
}

// =================================================================================================
// MARK: Properties accessors - User interface (Appearance)
// =================================================================================================

- (UIColor*)alertBackgroundColor
{
	if(!_alertBackgroundColor)
		_alertBackgroundColor = JFColorAlpha(192.0);
	return _alertBackgroundColor;
}

- (void)setAlertBackgroundColor:(UIColor* __nullable)alertBackgroundColor
{
	if(JFAreObjectsEqual(_alertBackgroundColor, alertBackgroundColor))
		return;
	
	_alertBackgroundColor = alertBackgroundColor;
	
	if(self.window)
		self.alertView.backgroundColor = self.alertBackgroundColor;
}

- (void)setAlertBackgroundImage:(UIImage* __nullable)alertBackgroundImage
{
	if(JFAreObjectsEqual(_alertBackgroundImage, alertBackgroundImage))
		return;
	
	_alertBackgroundImage = alertBackgroundImage;
	
	self.alertBackgroundImageHidden = !alertBackgroundImage;
	
	if(self.window)
		self.alertBackgroundView.image = alertBackgroundImage;
}

- (void)setAlertBorderColor:(UIColor* __nullable)alertBorderColor
{
	if(JFAreObjectsEqual(_alertBorderColor, alertBorderColor))
		return;
	
	_alertBorderColor = alertBorderColor;
	
	if(self.window)
		self.alertView.layer.borderColor = alertBorderColor.CGColor;
}

- (void)setAlertBorderWidth:(CGFloat)alertBorderWidth
{
	if(_alertBorderWidth == alertBorderWidth)
		return;
	
	_alertBorderWidth = alertBorderWidth;
	
	if(self.window)
		self.alertView.layer.borderWidth = alertBorderWidth;
}

- (void)setAlertCornerRadius:(CGFloat)alertCornerRadius
{
	if(_alertCornerRadius == alertCornerRadius)
		return;
	
	_alertCornerRadius = alertCornerRadius;
	
	if(self.window)
		self.alertView.layer.cornerRadius = alertCornerRadius;
}

- (void)setAlertMargin:(CGFloat)alertMargin
{
	if(_alertMargin == alertMargin)
		return;
	
	_alertMargin = alertMargin;
	
	if(self.window)
		[self setNeedsUpdateConstraints];
}

- (void)setAlertMaxSize:(CGSize)alertMaxSize
{
	alertMaxSize.height = MAX(0.0, alertMaxSize.height);
	alertMaxSize.width = MAX(0.0, alertMaxSize.width);
	if(CGSizeEqualToSize(_alertMaxSize, alertMaxSize))
		return;
	
	_alertMaxSize = alertMaxSize;
	
	if(self.window)
	{
		CGFloat dimension = alertMaxSize.width;
		NSLayoutConstraint* constraint = self.alertViewMaxWidthConstraint;
		constraint.constant = dimension;
		constraint.active = (dimension > 0);
		
		dimension = alertMaxSize.height;
		constraint = self.alertViewMaxHeightConstraint;
		constraint.constant = dimension;
		constraint.active = (dimension > 0);
	}
}

- (void)setAlertMinSize:(CGSize)alertMinSize
{
	alertMinSize.height = MAX(0.0, alertMinSize.height);
	alertMinSize.width = MAX(0.0, alertMinSize.width);
	if(CGSizeEqualToSize(_alertMinSize, alertMinSize))
		return;
	
	_alertMinSize = alertMinSize;
	
	if(self.window)
	{
		CGFloat dimension = alertMinSize.width;
		NSLayoutConstraint* constraint = self.alertViewMinWidthConstraint;
		constraint.constant = dimension;
		constraint.active = (dimension > 0);
		
		dimension = alertMinSize.height;
		constraint = self.alertViewMinHeightConstraint;
		constraint.constant = dimension;
		constraint.active = (dimension > 0);
	}
}

- (void)setAlertPadding:(CGFloat)alertPadding
{
	if(_alertPadding == alertPadding)
		return;
	
	_alertPadding = alertPadding;
	
	if(self.window)
		[self setNeedsUpdateConstraints];
}

- (void)setAlertShadowColor:(UIColor* __nullable)alertShadowColor
{
	if(JFAreObjectsEqual(_alertShadowColor, alertShadowColor))
		return;
	
	_alertShadowColor = alertShadowColor;
	
	if(self.window)
		self.alertView.layer.backgroundColor = self.alertShadowColor.CGColor;
}

- (void)setAlertShadowOffset:(CGSize)alertShadowOffset
{
	if(CGSizeEqualToSize(_alertShadowOffset, alertShadowOffset))
		return;
	
	_alertShadowOffset = alertShadowOffset;
	
	if(self.window)
		self.alertView.layer.shadowOffset = alertShadowOffset;
}

- (void)setAlertShadowOpacity:(CGFloat)alertShadowOpacity
{
	if(_alertShadowOpacity == alertShadowOpacity)
		return;
	
	_alertShadowOpacity = alertShadowOpacity;
	
	if(self.window)
		self.alertView.layer.shadowOpacity = alertShadowOpacity;
}

- (void)setAlertShadowRadius:(CGFloat)alertShadowRadius
{
	if(_alertShadowRadius == alertShadowRadius)
		return;
	
	_alertShadowRadius = alertShadowRadius;
	
	if(self.window)
		self.alertView.layer.shadowRadius = alertShadowRadius;
}

- (void)setAlertSpacing:(CGFloat)alertSpacing
{
	if(_alertSpacing == alertSpacing)
		return;
	
	alertSpacing = alertSpacing;
	
	if(self.window)
		[self setNeedsUpdateConstraints];
}

- (UIImage* __nullable)buttonBackgroundImage
{
	return [self buttonBackgroundImageForState:UIControlStateNormal];
}

- (UIImage* __nullable)buttonBackgroundImageForState:(UIControlState)state
{
	return self.buttonBackgroundImages[@(state)];
}

- (void)setButtonBackgroundImage:(UIImage* __nullable)buttonBackgroundImage
{
	[self setButtonBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
}

- (void)setButtonBackgroundImage:(UIImage* __nullable)buttonBackgroundImage forState:(UIControlState)state
{
	NSNumber* key = @(state);
	if(![[self.class buttonDictionaryKeys] containsObject:key])
	{
		NSLog(@"%@: State '%@' not supported.", ClassName, key.stringValue);
		return;
	}
	
	NSMutableDictionary<NSNumber*, UIImage*>* buttonBackgroundImages = self.buttonBackgroundImages;
	
	if(JFAreObjectsEqual(buttonBackgroundImages[key], buttonBackgroundImage))
		return;
	
	buttonBackgroundImages[key] = buttonBackgroundImage;
	
	if(self.window)
		[self.button setBackgroundImage:buttonBackgroundImage forState:state];
}

- (UIImage* __nullable)buttonImage
{
	return [self buttonImageForState:UIControlStateNormal];
}

- (UIImage* __nullable)buttonImageForState:(UIControlState)state
{
	return self.buttonImages[@(state)];
}

- (void)setButtonImage:(UIImage* __nullable)buttonImage
{
	[self setButtonImage:buttonImage forState:UIControlStateNormal];
}

- (void)setButtonImage:(UIImage* __nullable)buttonImage forState:(UIControlState)state
{
	NSNumber* key = @(state);
	if(![[self.class buttonDictionaryKeys] containsObject:key])
	{
		NSLog(@"%@: State '%@' not supported.", ClassName, key.stringValue);
		return;
	}
	
	NSMutableDictionary<NSNumber*, UIImage*>* buttonImages = self.buttonImages;
	
	if(JFAreObjectsEqual(buttonImages[key], buttonImage))
		return;
	
	buttonImages[key] = buttonImage;
	
	if(self.window)
		[self.button setImage:buttonImage forState:state];
}

- (UIColor* __nullable)buttonTitleColor
{
	return [self buttonTitleColorForState:UIControlStateNormal];
}

- (UIColor* __nullable)buttonTitleColorForState:(UIControlState)state
{
	return self.buttonTitleColors[@(state)];
}

- (void)setButtonTitleColor:(UIColor* __nullable)buttonTitleColor
{
	[self setButtonTitleColor:buttonTitleColor forState:UIControlStateNormal];
}

- (void)setButtonTitleColor:(UIColor* __nullable)buttonTitleColor forState:(UIControlState)state
{
	NSNumber* key = @(state);
	if(![[self.class buttonDictionaryKeys] containsObject:key])
	{
		NSLog(@"%@: State '%@' not supported.", ClassName, key.stringValue);
		return;
	}
	
	NSMutableDictionary<NSNumber*, UIColor*>* buttonTitleColors = self.buttonTitleColors;
	
	if(JFAreObjectsEqual(buttonTitleColors[key], buttonTitleColor))
		return;
	
	buttonTitleColors[key] = buttonTitleColor;
	
	if(self.window)
		[self.button setTitleColor:buttonTitleColor forState:state];
}

- (UIColor*)spinnerColor
{
	if(!_spinnerColor)
		_spinnerColor = [UIColor whiteColor];
	return _spinnerColor;
}

- (void)setSpinnerColor:(UIColor* __nullable)spinnerColor
{
	if(JFAreObjectsEqual(_spinnerColor, spinnerColor))
		return;
	
	_spinnerColor = spinnerColor;
	
	if(self.window)
		self.spinnerView.color = self.spinnerColor;
}

- (void)setSpinnerStyle:(UIActivityIndicatorViewStyle)spinnerStyle
{
	if(_spinnerStyle == spinnerStyle)
		return;
	
	_spinnerStyle = spinnerStyle;
	
	if(self.window)
		[self setNeedsRebuildLayout];
}

- (UIColor*)textColor
{
	if(!_textColor)
		_textColor = [UIColor whiteColor];
	return _textColor;
}

- (void)setTextColor:(UIColor* __nullable)textColor
{
	if(JFAreObjectsEqual(_textColor, textColor))
		return;
	
	_textColor = textColor;
	
	if(self.window)
		self.textLabel.textColor = self.textColor;
}

- (void)setTextFont:(UIFont* __nullable)textFont
{
	if(JFAreObjectsEqual(_textFont, textFont))
		return;
	
	_textFont = textFont;
	
	if(self.window)
		self.textLabel.font = self.textFont;
}

// =================================================================================================
// MARK: Properties accessors - User interface (Layout)
// =================================================================================================

- (void)setNeedsRebuildLayout
{
	self.needsRebuildLayout = YES;
}

- (void)setNeedsRebuildLayout:(BOOL)needsRebuildLayout
{
	if(_needsRebuildLayout == needsRebuildLayout)
		return;
	
	_needsRebuildLayout = needsRebuildLayout;
	
	if(needsRebuildLayout)
	{
		JFWeakifySelf;
		[MainOperationQueue addOperationWithBlock:^{
			[weakSelf rebuildLayoutIfNeeded];
		}];
	}
}

// =================================================================================================
// MARK: Methods - Memory
// =================================================================================================

+ (void)initializeProperties:(JFActivityIndicatorView*)view
{
	// Data
	view->_buttonTitles = [NSMutableDictionary<NSNumber*, NSString*> new];
	
	// User interface
	view->_alertBackgroundImageHidden = YES;
	view->_animationImagesHidden = YES;
	view->_buttonHidden = YES;
	view->_textHidden = YES;
	
	// User interface (Appearance)
	view->_alertCornerRadius = 8.0;
	view->_alertMargin = 20.0f;
	view->_alertPadding = 15.0f;
	view->_alertShadowOffset = CGSizeMake(0.0, -3.0);
	view->_alertShadowRadius = 3.0;
	view->_alertSpacing = 20.0f;
	view->_buttonBackgroundImages = [NSMutableDictionary<NSNumber*, UIImage*> new];
	view->_buttonImages = [NSMutableDictionary<NSNumber*, UIImage*> new];
	view->_buttonTitleColors = [NSMutableDictionary<NSNumber*, UIColor*> new];
	view->_spinnerStyle = UIActivityIndicatorViewStyleWhiteLarge;
	
	// User interface (Inherited)
	view.backgroundColor = JFColorAlpha(80.0);
	view.opaque = NO;
	view.userInteractionEnabled = YES;
}

- (instancetype __nullable)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		[JFActivityIndicatorView initializeProperties:self];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	[JFActivityIndicatorView initializeProperties:self];
	
	return self;
}

// =================================================================================================
// MARK: Methods - Layout
// =================================================================================================

- (void)toggleAnimations
{
	UIImageView* imageView = self.imageView;
	UIActivityIndicatorView* spinnerView = self.spinnerView;
	
	if([self isHidden] || [self isAlertHidden])
	{
		[imageView stopAnimating];
		[spinnerView stopAnimating];
		return;
	}
	
	if([self areAnimationImagesHidden])
		[imageView stopAnimating];
	else
		[imageView startAnimating];
	
	if([self isSpinnerHidden])
		[spinnerView stopAnimating];
	else
		[spinnerView startAnimating];
}

// =================================================================================================
// MARK: Methods - Layout (Layout)
// =================================================================================================

- (void)didMoveToWindow
{
	[super didMoveToWindow];
	
	if(self.window)
	{
		[self setNeedsRebuildLayout];
		[self rebuildLayoutIfNeeded];
	}
}

- (void)rebuildLayout
{
	UIImageView* alertBackgroundView = self.alertBackgroundView;
	UIView* alertView = self.alertView;
	UIView* animationView = self.animationView;
	UIButton* button = self.button;
	UIImageView* imageView = self.imageView;
	UIActivityIndicatorView* spinnerView = self.spinnerView;
	UILabel* textLabel = self.textLabel;
	
	if([self isAlertHidden])
	{
		[alertBackgroundView removeFromSuperview];
		[alertView removeFromSuperview];
		[animationView removeFromSuperview];
		[button removeFromSuperview];
		[imageView removeFromSuperview];
		[spinnerView removeFromSuperview];
		[textLabel removeFromSuperview];
	}
	else
	{
		if(!alertView)
		{
			alertView = [UIView new];
			alertView.backgroundColor = self.alertBackgroundColor;
			alertView.opaque = NO;
			alertView.translatesAutoresizingMaskIntoConstraints = NO;
			
			CALayer* layer = alertView.layer;
			layer.borderColor = self.alertBorderColor.CGColor;
			layer.borderWidth = self.alertBorderWidth;
			layer.cornerRadius = self.alertCornerRadius;
			layer.shadowColor = self.alertShadowColor.CGColor;
			layer.shadowOffset = self.alertShadowOffset;
			layer.shadowOpacity = self.alertShadowOpacity;
			layer.shadowRadius = self.alertShadowRadius;
			
			self.alertView = alertView;
			[self addSubview:alertView];
		}
		
		if([self isAlertBackgroundImageHidden])
			[alertBackgroundView removeFromSuperview];
		else
		{
			if(!alertBackgroundView)
			{
				alertBackgroundView = [[UIImageView alloc] initWithFrame:alertView.bounds];
				alertBackgroundView.autoresizingMask = ViewAutoresizingFlexibleSize;
				alertBackgroundView.backgroundColor = [UIColor clearColor];
				alertBackgroundView.clipsToBounds = YES;
				alertBackgroundView.image = self.alertBackgroundImage;
				alertBackgroundView.opaque = NO;
				
				CALayer* layer = alertBackgroundView.layer;
				layer.cornerRadius = self.alertCornerRadius;
				
				self.alertBackgroundView = alertBackgroundView;
			}
			[alertView addSubview:alertBackgroundView];
		}
		
		if([self isButtonHidden])
			[button removeFromSuperview];
		else
		{
			if(!button)
			{
				button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
				button.jf_actionBlock = self.buttonBlock;
				button.translatesAutoresizingMaskIntoConstraints = NO;
				
				NSMutableDictionary<NSNumber*, UIImage*>* buttonBackgroundImages = self.buttonBackgroundImages;
				NSMutableDictionary<NSNumber*, UIColor*>* buttonTitleColors = self.buttonTitleColors;
				NSMutableDictionary<NSNumber*, NSString*>* buttonTitles = self.buttonTitles;
				
				NSSet<NSNumber*>* keys = [self.class buttonDictionaryKeys];
				for(NSNumber* key in keys)
				{
					UIControlState state = key.unsignedIntegerValue;
					[button setBackgroundImage:buttonBackgroundImages[key] forState:state];
					[button setTitle:buttonTitles[key] forState:state];
					[button setTitleColor:buttonTitleColors[key] forState:state];
				}
				
				self.button = button;
			}
			[alertView addSubview:button];
		}
		
		BOOL animationImagesHidden = [self areAnimationImagesHidden];
		BOOL spinnerHidden = [self isSpinnerHidden];
		
		if(animationImagesHidden && spinnerHidden)
			[animationView removeFromSuperview];
		else
		{
			if(!animationView)
			{
				animationView = [UIView new];
				animationView.backgroundColor = [UIColor clearColor];
				animationView.opaque = NO;
				animationView.translatesAutoresizingMaskIntoConstraints = NO;
				
				self.animationView = animationView;
			}
			[alertView addSubview:animationView];
		}
		
		if(animationImagesHidden)
			[imageView removeFromSuperview];
		else
		{
			if(!imageView)
			{
				imageView = [UIImageView new];
				imageView.animationDuration = self.animationDuration;
				imageView.animationImages = self.animationImages;
				imageView.autoresizingMask = ViewAutoresizingFlexibleSize;
				imageView.backgroundColor = [UIColor clearColor];
				imageView.clipsToBounds = YES;
				imageView.opaque = NO;
				imageView.translatesAutoresizingMaskIntoConstraints = NO;
				
				self.imageView = imageView;
			}
			[animationView addSubview:imageView];
		}
		
		if(spinnerHidden)
			[spinnerView removeFromSuperview];
		else
		{
			UIActivityIndicatorViewStyle style = self.spinnerStyle;
			if(spinnerView && (spinnerView.activityIndicatorViewStyle != style))
			{
				[spinnerView removeFromSuperview];
				spinnerView = nil;
			}
			
			if(!spinnerView)
			{
				spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
				spinnerView.backgroundColor = [UIColor clearColor];
				spinnerView.clipsToBounds = YES;
				spinnerView.color = self.spinnerColor;
				spinnerView.opaque = NO;
				spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
				self.spinnerView = spinnerView;
			}
			[animationView addSubview:spinnerView];
		}
		
		if([self isTextHidden])
			[textLabel removeFromSuperview];
		else
		{
			if(!textLabel)
			{
				textLabel = [UILabel new];
				textLabel.backgroundColor = [UIColor clearColor];
				textLabel.font = self.textFont;
				textLabel.numberOfLines = 0;
				textLabel.opaque = NO;
				textLabel.text = self.text;
				textLabel.textAlignment = NSTextAlignmentCenter;
				textLabel.textColor = self.textColor;
				textLabel.translatesAutoresizingMaskIntoConstraints = NO;
				self.textLabel = textLabel;
			}
			[alertView addSubview:textLabel];
		}
	}
	
	[self toggleAnimations];
	[self setNeedsUpdateConstraints];
}

- (void)rebuildLayoutIfNeeded
{
	if(![self needsRebuildLayout])
		return;
	
	self.needsRebuildLayout = NO;
	[self rebuildLayout];
}

- (void)updateConstraints
{
	if(self.window)
	{
		NSMutableArray<NSLayoutConstraint*>* constraints = ([self.customConstraints mutableCopy] ?: [NSMutableArray<NSLayoutConstraint*> array]);
		NSMutableArray<NSLayoutConstraint*>* disabledConstraints = [NSMutableArray<NSLayoutConstraint*> array];
		
		// Removes the old constraints.
		[self removeConstraints:constraints];
		[constraints removeAllObjects];
		
		UIView* alertView = self.alertView;
		if(alertView && ![self isAlertHidden])
		{
			// Prepares some shortcuts.
			static __unused NSLayoutAttribute ab = NSLayoutAttributeBottom;
			static __unused NSLayoutAttribute al = NSLayoutAttributeLeft;
			static __unused NSLayoutAttribute ar = NSLayoutAttributeRight;
			static __unused NSLayoutAttribute at = NSLayoutAttributeTop;
			static __unused NSLayoutAttribute ah = NSLayoutAttributeHeight;
			static __unused NSLayoutAttribute aw = NSLayoutAttributeWidth;
			static __unused NSLayoutAttribute an = NSLayoutAttributeNotAnAttribute;
			static __unused NSLayoutAttribute ax = NSLayoutAttributeCenterX;
			static __unused NSLayoutAttribute ay = NSLayoutAttributeCenterY;
			static __unused NSLayoutRelation re = NSLayoutRelationEqual;
			static __unused NSLayoutRelation rg = NSLayoutRelationGreaterThanOrEqual;
			static __unused NSLayoutRelation rl = NSLayoutRelationLessThanOrEqual;
			
			BOOL animationImagesHidden = [self areAnimationImagesHidden];
			BOOL buttonHidden = [self isButtonHidden];
			BOOL spinnerHidden = [self isSpinnerHidden];
			BOOL textHidden = [self isTextHidden];
			
			CGSize alertMaxSize = self.alertMaxSize;
			CGSize alertMinSize = self.alertMinSize;
			CGSize animationImageSize = self.animationImageSize;
			
			UIView* alertView = self.alertView;
			UIView* animationView = self.animationView;
			UIView* button = self.button;
			UIView* imageView = self.imageView;
			UIView* spinnerView = self.spinnerView;
			UIView* textLabel = self.textLabel;
			
			// Prepares the needed info.
			NSDictionary* metrics = @{@"margin":@(self.alertMargin), @"padding":@(self.alertPadding), @"spacing":@(self.alertSpacing)};
			NSMutableDictionary* views = [NSMutableDictionary dictionaryWithCapacity:6];
			if(alertView) views[@"alertView"] = alertView;
			if(animationView) views[@"animationView"] = animationView;
			if(button) views[@"button"] = button;
			if(imageView) views[@"imageView"] = imageView;
			if(spinnerView) views[@"spinnerView"] = spinnerView;
			if(textLabel) views[@"textLabel"] = textLabel;
			
			
			// Creates the alert view constraints.
			UIView* v1 = alertView;
			UIView* v2 = self;
			[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=margin@999)-[alertView(0@1)]-(>=margin@999)-|" options:0 metrics:metrics views:views]]; // Left, Right & Width
			[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=margin@999)-[alertView(0@1)]-(>=margin@999)-|" options:0 metrics:metrics views:views]]; // Top, Bottom & Height
			[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ax relatedBy:re toItem:v2 attribute:ax multiplier:1.0f constant:0.0f]]; // Center X
			[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ay relatedBy:re toItem:v2 attribute:ay multiplier:1.0f constant:0.0f]]; // Center Y
			NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:v1 attribute:aw relatedBy:rl toItem:nil attribute:an multiplier:1.0f constant:alertMaxSize.width]; // Max Width
			[((alertMaxSize.width > 0.0f) ? constraints : disabledConstraints) addObject:constraint];
			self.alertViewMaxWidthConstraint = constraint;
			constraint = [NSLayoutConstraint constraintWithItem:v1 attribute:ah relatedBy:rl toItem:nil attribute:an multiplier:1.0f constant:alertMaxSize.height]; // Max Height
			[((alertMaxSize.height > 0.0f) ? constraints : disabledConstraints) addObject:constraint];
			self.alertViewMaxHeightConstraint = constraint;
			constraint = [NSLayoutConstraint constraintWithItem:v1 attribute:aw relatedBy:rg toItem:nil attribute:an multiplier:1.0f constant:alertMinSize.width]; // Min Width
			[((alertMinSize.width > 0.0f) ? constraints : disabledConstraints) addObject:constraint];
			self.alertViewMinWidthConstraint = constraint;
			constraint = [NSLayoutConstraint constraintWithItem:v1 attribute:ah relatedBy:rg toItem:nil attribute:an multiplier:1.0f constant:alertMinSize.height]; // Min Height
			[((alertMinSize.height > 0.0f) ? constraints : disabledConstraints) addObject:constraint];
			self.alertViewMinHeightConstraint = constraint;
			
			if(animationView)
			{
				v1 = animationView;
				v2 = alertView;
				[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=padding)-[animationView(0@1)]-(>=padding)-|" options:0 metrics:metrics views:views]]; // Left, Right & Width
				[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(padding)-[animationView(0@1)]" options:0 metrics:metrics views:views]]; // Top & Height
				[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ax relatedBy:re toItem:v2 attribute:ax multiplier:1.0f constant:0.0f]]; // Center X
				if(textHidden && buttonHidden)
					[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[animationView]-(padding)-|" options:0 metrics:metrics views:views]]; // Bottom
				
				if(imageView && !animationImagesHidden)
				{
					v1 = imageView;
					v2 = animationView;
					[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[imageView]-(>=0)-|" options:0 metrics:metrics views:views]]; // Left, Right
					[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[imageView]-(>=0)-|" options:0 metrics:metrics views:views]]; // Top, Bottom
					[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ax relatedBy:re toItem:v2 attribute:ax multiplier:1.0f constant:0.0f]]; // Center X
					[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ay relatedBy:re toItem:v2 attribute:ay multiplier:1.0f constant:0.0f]]; // Center Y
					constraint = [NSLayoutConstraint constraintWithItem:v1 attribute:aw relatedBy:re toItem:nil attribute:an multiplier:1.0f constant:animationImageSize.width]; // Width
					[constraints addObject:constraint];
					self.imageViewWidthConstraint = constraint;
					constraint = [NSLayoutConstraint constraintWithItem:v1 attribute:ah relatedBy:re toItem:nil attribute:an multiplier:1.0f constant:animationImageSize.height]; // Height
					[constraints addObject:constraint];
					self.imageViewHeightConstraint = constraint;
				}
				
				if(spinnerView && !spinnerHidden)
				{
					v1 = spinnerView;
					v2 = animationView;
					[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[spinnerView]-(>=0)-|" options:0 metrics:metrics views:views]]; // Left, Right
					[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[spinnerView]-(>=0)-|" options:0 metrics:metrics views:views]]; // Top, Bottom
					[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ax relatedBy:re toItem:v2 attribute:ax multiplier:1.0f constant:0.0f]]; // Center X
					[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ay relatedBy:re toItem:v2 attribute:ay multiplier:1.0f constant:0.0f]]; // Center Y
				}
			}
			
			if(textLabel && !textHidden)
			{
				[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[textLabel]-(padding)-|" options:0 metrics:metrics views:views]]; // Left & Right
				NSString* format = (animationView ? @"V:[animationView]-(spacing)-[textLabel]" : @"V:|-(padding)-[textLabel]");
				[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views]]; // Top
				if(buttonHidden)
					[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[textLabel]-(padding)-|" options:0 metrics:metrics views:views]]; // Bottom
			}
			
			if(button && !buttonHidden)
			{
				v1 = button;
				v2 = alertView;
				[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=padding)-[button(>=100)]-(>=padding)-|" options:0 metrics:metrics views:views]]; // Left & Right
				NSString* format = nil;
				if(textLabel && !textHidden)
					format = @"V:[textLabel]-(spacing)-[button]-(padding)-|";
				else if(animationView)
					format = @"V:[animationView]-(spacing)-[button]-(padding)-|";
				else
					format = @"V:|-(padding)-[button]-(padding)-|";
				[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views]]; // Top & Bottom
				[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ax relatedBy:re toItem:v2 attribute:ax multiplier:1.0f constant:0.0f]]; // Center X
			}
		}
		
		// Saves the new constraints.
		[self addConstraints:constraints];
		[constraints addObjectsFromArray:disabledConstraints];
		self.customConstraints = [constraints copy];
	}
	
	[super updateConstraints];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
