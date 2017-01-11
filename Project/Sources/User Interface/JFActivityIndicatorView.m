//
//	The MIT License (MIT)
//
//	Copyright © 2015-2017 Jacopo Filié
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
@property (assign, nonatomic, getter=isButtonHidden)			BOOL	buttonHidden;
@property (assign, nonatomic, getter=isContainerImageHidden)	BOOL	containerImageHidden;
@property (assign, nonatomic, getter=isIndicatorViewHidden)		BOOL	indicatorViewHidden;
@property (assign, nonatomic, getter=isTextLabelHidden)			BOOL	textLabelHidden;

// MARK: Methods - Memory management
+ (void)	initializeProperties:(JFActivityIndicatorView*)object;

// MARK: Methods - User interface management
- (void)	toggleAnimation;

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

@synthesize buttonHidden			= _buttonHidden;
@synthesize containerImageHidden	= _containerImageHidden;
@synthesize containerHidden			= _containerHidden;
@synthesize indicatorViewHidden		= _indicatorViewHidden;
@synthesize textLabelHidden			= _textLabelHidden;

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
// MARK: Properties accessors - User interface (Appearance)
// =================================================================================================

- (void)setBackgroundColor:(UIColor* __nullable)backgroundColor
{
	if(!backgroundColor)
		backgroundColor = JFColorAlpha(80);
	
	if(JFAreObjectsEqual(super.backgroundColor, backgroundColor))
		return;
	
	super.backgroundColor = backgroundColor;
}

- (void)setButtonTitleColor:(UIColor* __nullable)buttonTitleColor
{
	if(JFAreObjectsEqual(_buttonTitleColor, buttonTitleColor))
		return;
	
	_buttonTitleColor = buttonTitleColor;
	
	if(self.window)
		[self.button setTitleColor:buttonTitleColor forState:UIControlStateNormal];
}

- (void)setContainerBackgroundColor:(UIColor* __nullable)containerBackgroundColor
{
	if(!containerBackgroundColor)
		containerBackgroundColor = JFColorAlpha(192);
	
	if(JFAreObjectsEqual(_containerBackgroundColor, containerBackgroundColor))
		return;
	
	_containerBackgroundColor = containerBackgroundColor;
	
	if(self.window)
		self.containerView.backgroundColor = containerBackgroundColor;
}

- (void)setContainerBackgroundImage:(UIImage* __nullable)containerBackgroundImage
{
	if(JFAreObjectsEqual(_containerBackgroundImage, containerBackgroundImage))
		return;
	
	_containerBackgroundImage = containerBackgroundImage;
	
	self.containerImageHidden = !containerBackgroundImage;
	
	if(self.window)
		self.containerImageView.image = containerBackgroundImage;
}

- (void)setContainerCornerRadius:(CGFloat)containerCornerRadius
{
	if(_containerCornerRadius == containerCornerRadius)
		return;
	
	_containerCornerRadius = containerCornerRadius;
	
	if(self.window)
		self.containerView.layer.cornerRadius = containerCornerRadius;
}

- (void)setIndicatorColor:(UIColor* __nullable)indicatorColor
{
	if(!indicatorColor)
		indicatorColor = [UIColor whiteColor];
	
	if(JFAreObjectsEqual(_indicatorColor, indicatorColor))
		return;
	
	_indicatorColor = indicatorColor;
	
	if(self.window)
		self.indicatorView.color = indicatorColor;
}

- (void)setIndicatorImagesAnimationDuration:(NSTimeInterval)indicatorImagesAnimationDuration
{
	if(_indicatorImagesAnimationDuration == indicatorImagesAnimationDuration)
		return;
	
	_indicatorImagesAnimationDuration = indicatorImagesAnimationDuration;
	
	if(self.window)
		self.imageView.animationDuration = indicatorImagesAnimationDuration;
}

- (void)setIndicatorImagesSize:(CGSize)indicatorImagesSize
{
	if(CGSizeEqualToSize(_indicatorImagesSize, indicatorImagesSize))
		return;
	
	_indicatorImagesSize = indicatorImagesSize;
	
	if(self.window)
		[self setNeedsUpdateConstraints];
}

- (void)setIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle
{
	if(_indicatorStyle == indicatorStyle)
		return;
	
	_indicatorStyle = indicatorStyle;
	
	if(self.window)
		[self setNeedsLayout];
}

- (void)setTextColor:(UIColor* __nullable)textColor
{
	if(!textColor)
		textColor = [UIColor whiteColor];
	
	_textColor = textColor;
	
	if(self.window)
		self.textLabel.textColor = textColor;
}

// =================================================================================================
// MARK: Properties accessors - User interface (Flags)
// =================================================================================================

- (void)setButtonHidden:(BOOL)buttonHidden
{
	if(_buttonHidden == buttonHidden)
		return;
	
	_buttonHidden = buttonHidden;
	
	if(self.window)
		[self setNeedsLayout];
}

- (void)setContainerHidden:(BOOL)containerHidden
{
	if(_containerHidden == containerHidden)
		return;
	
	_containerHidden = containerHidden;
	
	if(self.window)
		[self setNeedsLayout];
}

- (void)setContainerImageHidden:(BOOL)containerImageHidden
{
	if(_containerImageHidden == containerImageHidden)
		return;
	
	_containerImageHidden = containerImageHidden;
	
	if(self.window)
		[self setNeedsLayout];
}

- (void)setHidden:(BOOL)hidden
{
	super.hidden = hidden;
	[self toggleAnimation];
}

- (void)setIndicatorViewHidden:(BOOL)indicatorViewHidden
{
	if(_indicatorViewHidden == indicatorViewHidden)
		return;
	
	_indicatorViewHidden = indicatorViewHidden;
	
	if(self.window)
		[self setNeedsLayout];
}

- (void)setTextLabelHidden:(BOOL)textLabelHidden
{
	if(_textLabelHidden == textLabelHidden)
		return;
	
	_textLabelHidden = textLabelHidden;
	
	if(self.window)
		[self setNeedsLayout];
}

// =================================================================================================
// MARK: Methods - Memory management
// =================================================================================================

+ (void)initializeProperties:(JFActivityIndicatorView*)object
{
	// User interface (Appearance)
	object->_containerCornerRadius				= 8;
	object->_indicatorImagesAnimationDuration	= 0;
	object->_indicatorImagesSize				= CGSizeZero;
	object->_indicatorStyle						= UIActivityIndicatorViewStyleWhiteLarge;
	
	// User interface (Constraints)
	object->_constraints	= [NSMutableArray<NSLayoutConstraint*> new];
	
	// User interface (Flags)
	object->_buttonHidden			= YES;
	object->_containerHidden		= NO;
	object->_indicatorViewHidden	= NO;
	object->_textLabelHidden		= YES;
	
	// User interface (Inherited)
	object.opaque = NO;
	object.userInteractionEnabled = YES;
	
	// Resets the resettable properties.
	object.backgroundColor			= nil;
	object.containerBackgroundColor	= nil;
	object.indicatorColor			= nil;
	object.textColor				= nil;
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

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	UIButton* button = self.button;
	UIView* containerView = self.containerView;
	UIImageView* containerImageView = self.containerImageView;
	UIImageView* imageView = self.imageView;
	UIActivityIndicatorView* indicatorView = self.indicatorView;
	UILabel* textLabel = self.textLabel;
	
	if([self isContainerHidden])
	{
		// Removes everything.
		[button removeFromSuperview];
		[containerView removeFromSuperview];
		[containerImageView removeFromSuperview];
		[imageView removeFromSuperview];
		[indicatorView removeFromSuperview];
		[textLabel removeFromSuperview];
	}
	else
	{
		// Layouts the container view.
		if(!containerView)
		{
			containerView = [UIView new];
			containerView.backgroundColor = self.containerBackgroundColor;
			containerView.layer.cornerRadius = self.containerCornerRadius;
			containerView.opaque = NO;
			containerView.translatesAutoresizingMaskIntoConstraints = NO;
			
			self.containerView = containerView;
			[self addSubview:containerView];
		}
		
		// Layouts the container image view.
		if([self isContainerImageHidden])
			[containerImageView removeFromSuperview];
		else
		{
			if(!containerImageView)
			{
				containerImageView = [UIImageView new];
				containerImageView.image = self.containerBackgroundImage;
				containerImageView.translatesAutoresizingMaskIntoConstraints = NO;
				[containerView addSubview:containerImageView];
				self.containerImageView = containerImageView;
			}
			[containerView addSubview:containerImageView];
		}
		
		// Layouts the button.
		if([self isButtonHidden])
			[button removeFromSuperview];
		else
		{
			if(!button)
			{
				button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
				button.jf_actionBlock = self.buttonActionBlock;
				button.translatesAutoresizingMaskIntoConstraints = NO;
				[button setTitle:self.buttonTitle forState:UIControlStateNormal];
				[button setTitleColor:self.buttonTitleColor forState:UIControlStateNormal];
				self.button = button;
			}
			[containerView addSubview:button];
		}
		
		if([self isIndicatorViewHidden])
		{
			// Layouts the image view.
			[indicatorView removeFromSuperview];
			if(!imageView)
			{
				imageView = [UIImageView new];
				imageView.animationDuration = self.indicatorImagesAnimationDuration;
				imageView.animationImages = self.indicatorImages;
				imageView.translatesAutoresizingMaskIntoConstraints = NO;
				self.imageView = imageView;
			}
			[containerView addSubview:imageView];
		}
		else
		{
			// Layouts the indicator view.
			[imageView removeFromSuperview];
			UIActivityIndicatorViewStyle style = self.indicatorStyle;
			if(!indicatorView || (indicatorView.activityIndicatorViewStyle != style))
			{
				if(indicatorView)
					[indicatorView removeFromSuperview];
				
				indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
				indicatorView.color = self.indicatorColor;
				indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
				self.indicatorView = indicatorView;
			}
			[containerView addSubview:indicatorView];
		}
		
		// Layouts the text label.
		if([self isTextLabelHidden])
			[textLabel removeFromSuperview];
		else
		{
			if(!textLabel)
			{
				textLabel = [UILabel new];
				textLabel.backgroundColor = [UIColor clearColor];
				textLabel.numberOfLines = 0;
				textLabel.opaque = NO;
				textLabel.text = self.text;
				textLabel.textAlignment = NSTextAlignmentCenter;
				textLabel.textColor = self.textColor;
				textLabel.translatesAutoresizingMaskIntoConstraints = NO;
				self.textLabel = textLabel;
			}
			[containerView addSubview:textLabel];
		}
	}
	
	[self toggleAnimation];
	[self setNeedsUpdateConstraints];
}

- (void)toggleAnimation
{
	UIImageView* imageView = self.imageView;
	UIActivityIndicatorView* indicatorView = self.indicatorView;
	
	if([self isIndicatorViewHidden])
	{
		[indicatorView stopAnimating];
		
		if([self isHidden])
			[imageView stopAnimating];
		else
			[imageView startAnimating];
	}
	else
	{
		[imageView stopAnimating];
		
		if([self isHidden])
			[indicatorView stopAnimating];
		else
			[indicatorView startAnimating];
	}
}

// =================================================================================================
// MARK: Methods - User interface management (Constraints)
// =================================================================================================

- (void)updateConstraints
{
	if(self.window)
	{
		NSMutableArray<NSLayoutConstraint*>* constraints = [self.constraints mutableCopy];
		
		// Removes the old constraints.
		[self removeConstraints:constraints];
		[constraints removeAllObjects];
		
		UIView* containerView = self.containerView;
		if(containerView && ![self isContainerHidden])
		{
			BOOL buttonHidden = [self isButtonHidden];
			BOOL containerImageHidden = [self isContainerImageHidden];
			BOOL indicatorViewHidden = [self isIndicatorViewHidden];
			BOOL textLabelHidden = [self isTextLabelHidden];
			
			CGSize indicatorImagesSize = self.indicatorImagesSize;
			
			UIView* button = self.button;
			UIView* containerImageView = self.containerImageView;
			UIView* indicatorView = (indicatorViewHidden ? self.imageView : self.indicatorView);
			UIView* textLabel = self.textLabel;
			
			// Prepares some constraint shortcuts.
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
			
			// Prepares the needed info.
			NSDictionary* metrics = @{@"containerOffset":@10, @"offset":@15, @"indicatorImagesWidth":@(indicatorImagesSize.width), @"indicatorImagesHeight":@(indicatorImagesSize.height)};
			NSMutableDictionary* views = [NSMutableDictionary dictionaryWithCapacity:5];
			if(button)				views[@"button"]				= button;
			if(containerImageView)	views[@"containerImageView"]	= containerImageView;
			if(containerView)		views[@"containerView"]			= containerView;
			if(indicatorView)		views[@"indicatorView"]			= indicatorView;
			if(textLabel)			views[@"textLabel"]				= textLabel;
			
			// Creates the container view constraints.
			UIView* v1 = containerView;
			UIView* v2 = containerView.superview;
			[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=containerOffset@999)-[containerView(0@1)]-(>=containerOffset@999)-|" options:0 metrics:metrics views:views]]; // Left, Right & Width
			[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=containerOffset@999)-[containerView(0@1)]-(>=containerOffset@999)-|" options:0 metrics:metrics views:views]]; // Top, Bottom & Height
			[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ax relatedBy:re toItem:v2 attribute:ax multiplier:1.0f constant:0.0f]]; // Center X
			[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ay relatedBy:re toItem:v2 attribute:ay multiplier:1.0f constant:0.0f]]; // Center Y
			
			if(!containerImageHidden)
			{
				// Creates the container image view constraints.
				[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[containerImageView]-(0)-|" options:0 metrics:metrics views:views]]; // Left & Right
				[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[containerImageView]-(0)-|" options:0 metrics:metrics views:views]]; // Top & Bottom
			}
			
			// Creates the indicator/image view constraints.
			v1 = indicatorView;
			v2 = containerView;
			if(indicatorViewHidden)
			{
				// Creates the image view constraints.
				[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=offset)-[indicatorView(indicatorImagesWidth)]-(>=offset)-|" options:0 metrics:metrics views:views]]; // Left, Right & Width
				[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offset)-[indicatorView(indicatorImagesHeight)]" options:0 metrics:metrics views:views]]; // Top & Height
			}
			else
			{
				// Creates the indicator view constraints.
				[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=offset)-[indicatorView]-(>=offset)-|" options:0 metrics:metrics views:views]]; // Left & Right
				[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offset)-[indicatorView]" options:0 metrics:metrics views:views]]; // Top
			}
			[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ax relatedBy:re toItem:v2 attribute:ax multiplier:1.0f constant:0.0f]]; // Center X
			if(buttonHidden && textLabelHidden)
				[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[indicatorView]-(offset)-|" options:0 metrics:metrics views:views]]; // Bottom
			
			if(!textLabelHidden)
			{
				// Creates the text label constraints.
				[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offset)-[textLabel]-(offset)-|" options:0 metrics:metrics views:views]]; // Left & Right
				[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[indicatorView]-(20)-[textLabel]" options:0 metrics:metrics views:views]]; // Top
				if(buttonHidden)
					[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[textLabel]-(offset)-|" options:0 metrics:metrics views:views]]; // Bottom
			}
			
			if(!buttonHidden)
			{
				// Creates the button constraints.
				v1 = button;
				v2 = containerView;
				[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=offset)-[button]-(>=offset)-|" options:0 metrics:metrics views:views]]; // Left & Right
				NSString* formatString = [NSString stringWithFormat:@"V:[%@]-(25)-[button]-(offset)-|", (textLabelHidden ? @"indicatorView" : @"textLabel")];
				[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:formatString options:0 metrics:metrics views:views]]; // Top & Bottom
				[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ax relatedBy:re toItem:v2 attribute:ax multiplier:1.0f constant:0.0f]]; // Center X
			}
			
			[self addConstraints:constraints];
		}
		
		// Saves the new constraints.
		[self.constraints setArray:constraints];
	}
	
	[super updateConstraints];
}

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
