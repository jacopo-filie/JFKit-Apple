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



@class JFTableViewCell;



#pragma mark - Typedefs

typedef void	(^JFTableViewCellSetupBlock)	(id cell);	// Used to prepare the cell.



#pragma mark



@interface JFTableViewCell : UITableViewCell

#pragma mark Methods

// Memory management
+ (UINib*)		nib;
+ (NSString*)	reuseIdentifier;
- (void)		initializeProperties;

// User interface management
+ (CGFloat)	defaultHeight;
+ (CGFloat)	dynamicHeightForTableView:(UITableView*)tableView setupBlock:(JFTableViewCellSetupBlock)setupBlock;	// The setup block is called before trying to calculate the height.
+ (CGFloat)	dynamicHeightForWidth:(CGFloat)width setupBlock:(JFTableViewCellSetupBlock)setupBlock;				// The setup block is called before trying to calculate the height.
+ (CGFloat)	maximumHeight;
+ (CGFloat)	minimumHeight;
- (void)	initializeUserInterface;

@end
