//
//	The MIT License (MIT)
//
//	Copyright © 2015-2018 Jacopo Filié
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



#import "JFTableViewCell.h"

#import "JFShortcuts.h"



@interface JFTableViewCell ()

#pragma mark Properties

// Flags
@property (assign, nonatomic, getter = isUserInterfaceInitialized)	BOOL	userInterfaceInitialized;

// User interface management
+ (JFTableViewCell*)	sizingCell;

@end



#pragma mark



@implementation JFTableViewCell

#pragma mark Properties

// Flags
@synthesize userInterfaceInitialized	= _userInterfaceInitialized;


#pragma mark Memory management

+ (UINib*)nib
{
	return [UINib nibWithNibName:ClassName bundle:nil];
}

+ (NSString*)reuseIdentifier
{
	return ClassName;
}

- (void)initializeProperties
{
	// Flags
	_userInterfaceInitialized = NO;
}

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		[self initializeProperties];
	}
	return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if(self)
	{
		[self initializeProperties];
	}
	return self;
}


#pragma mark User interface management

+ (CGFloat)defaultHeight
{
	return [self minimumHeight];
}

+ (CGFloat)dynamicHeightForTableView:(UITableView*)tableView setupBlock:(JFTableViewCellSetupBlock)setupBlock
{
	CGFloat width = CGRectGetWidth(tableView.bounds);
	
	if((tableView.style == UITableViewStyleGrouped) && !iOS7Plus)
	{
		CGFloat margin = 0.0f;
		
		if(iPhone)				margin = 10.0f;
		else if(width <= 20.0f)	margin = width - 10.0f;
		else if(width < 400.0f)	margin = 10.0f;
		else					margin = MAX(31.0f, MIN(45.0f, width * 0.06f));
		
		width -= MAX(margin, 0.0f) * 2.0f;
	}
	
	CGFloat retVal = [self dynamicHeightForWidth:width setupBlock:setupBlock];
	
	if(tableView.separatorStyle != UITableViewCellSeparatorStyleNone)
		retVal++;
	
	return retVal;
}

+ (CGFloat)dynamicHeightForWidth:(CGFloat)width setupBlock:(JFTableViewCellSetupBlock)setupBlock
{
	JFTableViewCell* cell = [self sizingCell];
	if(!cell)
		return [self defaultHeight];
	
	if(setupBlock)
		setupBlock(cell);
	
	CGRect frame = cell.frame;
	frame.size.width = width;
	cell.frame = frame;
	
	[cell setNeedsLayout];
	[cell layoutIfNeeded];
	
	CGSize calculatedSize = CGSizeZero;
	
	if(iOS8Plus)
		calculatedSize = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize withHorizontalFittingPriority:UILayoutPriorityFittingSizeLevel verticalFittingPriority:UILayoutPriorityFittingSizeLevel];
	else
		calculatedSize = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
	
	CGFloat retVal = MAX(calculatedSize.height, [self minimumHeight]);
	retVal = MIN(retVal, [self maximumHeight]);
	
	return retVal;
}

+ (CGFloat)maximumHeight
{
	return 2009.0; // This value is imposed by Apple (see UITableViewDelegate references).
}

+ (CGFloat)minimumHeight
{
	return 44.0;
}

+ (JFTableViewCell*)sizingCell
{
	static NSMutableDictionary* sizingCells = nil;
	static dispatch_once_t onceToken = 0;
	
	dispatch_once(&onceToken, ^{
		sizingCells = [NSMutableDictionary new];
	});
	
	NSString* key = ClassName;
	
	JFTableViewCell* retObj = [sizingCells objectForKey:key];
	if(!retObj)
	{
		// I hate try-catch blocks, but I couldn't find anything better yet.
		@try {
			retObj = [[[self nib] instantiateWithOwner:self options:nil] firstObject];
		}
		@catch (NSException* exception) {
			retObj = [[[self class] alloc] init];
		}
		@finally {
			if(retObj)
				[sizingCells setObject:retObj forKey:key];
		}
	}
	
	return retObj;
}

- (void)initializeUserInterface
{}


#pragma mark User interface management (Lifecycle)

- (void)didMoveToWindow
{
	[super didMoveToWindow];
	
	if(![self isUserInterfaceInitialized])
	{
		[self initializeUserInterface];
		self.userInterfaceInitialized = YES;
	}
}

@end
