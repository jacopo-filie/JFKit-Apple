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

////////////////////////////////////////////////////////////////////////////////////////////////////

#import "JFTableViewCell.h"

#import "JFShortcuts.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface JFTableViewCell ()

// =================================================================================================
// MARK: Methods - Presentation
// =================================================================================================

+ (JFTableViewCell* __nullable)sizingCell;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

@implementation JFTableViewCell

// =================================================================================================
// MARK: Properties accessors - Memory
// =================================================================================================

+ (UINib*)nib
{
	return [UINib nibWithNibName:ClassName bundle:nil];
}

+ (NSString*)reuseIdentifier
{
	return ClassName;
}

// =================================================================================================
// MARK: Properties accessors - Presentation
// =================================================================================================

+ (CGFloat)defaultHeight
{
	return self.minimumHeight;
}

+ (CGFloat)maximumHeight
{
	return CGFLOAT_MAX;
}

+ (CGFloat)minimumHeight
{
	return 44.0; // The minimum height that is considered enough to perform an easy touch on the cell.
}

// =================================================================================================
// MARK: Methods - Presentation
// =================================================================================================

+ (CGFloat)dynamicHeightForTableView:(UITableView*)tableView setupBlock:(JFTableViewCellSetupBlock)setupBlock
{
	CGFloat retVal = [self dynamicHeightForWidth:CGRectGetWidth(tableView.bounds) setupBlock:setupBlock];
	
	if(tableView.separatorStyle != UITableViewCellSeparatorStyleNone)
		retVal++;
	
	return retVal;
}

+ (CGFloat)dynamicHeightForWidth:(CGFloat)width setupBlock:(JFTableViewCellSetupBlock)setupBlock
{
	JFTableViewCell* cell = [JFTableViewCell sizingCell];
	if(!cell)
		return [self defaultHeight];
	
	setupBlock(cell);
	
	CGRect frame = cell.frame;
	frame.size.width = width;
	cell.frame = frame;
	
	[cell setNeedsLayout];
	[cell layoutIfNeeded];
	
	CGSize calculatedSize = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize withHorizontalFittingPriority:UILayoutPriorityFittingSizeLevel verticalFittingPriority:UILayoutPriorityFittingSizeLevel];
	
	CGFloat retVal = MAX(calculatedSize.height, [self minimumHeight]);
	retVal = MIN(retVal, [self maximumHeight]);
	
	return retVal;
}

+ (JFTableViewCell* __nullable)sizingCell
{
	static NSMutableDictionary<NSString*, JFTableViewCell*>* pool = nil;
	if(!pool)
		pool = [NSMutableDictionary<NSString*, JFTableViewCell*> new];

	NSString* key = self.reuseIdentifier;
	
	JFTableViewCell* retObj = pool[key];
	if(!retObj)
	{
		@try
		{
			retObj = [self.nib instantiateWithOwner:self options:nil].firstObject;
		}
		@catch(NSException* exception)
		{
			retObj = [self.class new];
		}
		@finally
		{
			pool[key] = retObj;
		}
	}
	return retObj;
}

- (void)didMoveToWindow
{
	[super didMoveToWindow];
	
	if(self.window)
		[self prepareLayout];
}

- (void)prepareLayout
{}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
