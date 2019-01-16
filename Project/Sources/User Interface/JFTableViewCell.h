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

@import UIKit;

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Types
// =================================================================================================

/**
 * The block to use to prepare the given cell before calculating its height.
 */
typedef void (^JFTableViewCellSetupBlock) (id cell);

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

/**
 * A collection of frequently needed properties and methods to make the usage the table view cells easier.
 */
@interface JFTableViewCell : UITableViewCell

// =================================================================================================
// MARK: Properties - Memory
// =================================================================================================

/**
 * The NIB file associated with this kind of cells.
 */
@property (class, strong, nonatomic, readonly) UINib* nib;

/**
 * The identifier used to recycle this kind of cells.
 */
@property (class, copy, nonatomic, readonly) NSString* reuseIdentifier;

// =================================================================================================
// MARK: Properties - Presentation
// =================================================================================================

/**
 * The default height of this kind of cells; it returns the minimum height in the default implementation.
 */
@property (class, assign, nonatomic, readonly) CGFloat defaultHeight;

/**
 * The maximum height of this kind of cells.
 */
@property (class, assign, nonatomic, readonly) CGFloat maximumHeight;

/**
 * The minimum height of this kind of cells.
 */
@property (class, assign, nonatomic, readonly) CGFloat minimumHeight;

// =================================================================================================
// MARK: Methods - Presentation
// =================================================================================================

/**
 * Calculates the height of the cell after preparing it using the given setup block, constraining it to the given table view width and attributes.
 * @param tableView The table view used for constraining the result.
 * @param setupBlock The block to use to prepare the cell before calculating its height.
 * @return The height of the cell needed to wrap its content.
 */
+ (CGFloat)dynamicHeightForTableView:(UITableView*)tableView setupBlock:(JFTableViewCellSetupBlock)setupBlock;

/**
 * Calculates the height of the cell after preparing it using the given setup block, constraining it to the given width.
 * @param width The width used for constraining the result.
 * @param setupBlock The block to use to prepare the cell before calculating its height.
 * @return The height of the cell needed to wrap its content.
 */
+ (CGFloat)dynamicHeightForWidth:(CGFloat)width setupBlock:(JFTableViewCellSetupBlock)setupBlock;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

/**
 * The following properties and methods should only be called by subclasses.
 */
@interface JFTableViewCell (/* Protected */)

/**
 * Called when the view is added to a window.
 */
- (void)prepareLayout;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
