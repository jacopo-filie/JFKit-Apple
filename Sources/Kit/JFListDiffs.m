//
//	The MIT License (MIT)
//
//	Copyright © 2023 Jacopo Filié
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

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

#import "JFListDiffs.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

typedef NS_ENUM(UInt8, JFListDiffsEditOperationType)
{
	JFListDiffsOperationTypeDelete,
	JFListDiffsOperationTypeInsert,
	JFListDiffsOperationTypeMove,
	JFListDiffsOperationTypeReplace
};

@interface JFListDiffsEditOperation : NSObject

@property (assign, nonatomic, readonly) NSUInteger count;
@property (assign, nonatomic, readonly) NSUInteger newIndex;
@property (assign, nonatomic, readonly) NSUInteger oldIndex;
@property (assign, nonatomic, readonly) JFListDiffsEditOperationType type;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initDeleteOperationAtIndex:(NSUInteger)oldIndex count:(NSUInteger)count NS_DESIGNATED_INITIALIZER;
- (instancetype)initInsertOperationAtIndex:(NSUInteger)newIndex count:(NSUInteger)count NS_DESIGNATED_INITIALIZER;
- (instancetype)initMoveOperationFromIndex:(NSUInteger)oldIndex toIndex:(NSUInteger)newIndex count:(NSUInteger)count NS_DESIGNATED_INITIALIZER;
- (instancetype)initReplaceOperationAtIndex:(NSUInteger)index count:(NSUInteger)count NS_DESIGNATED_INITIALIZER;

@end

@interface JFListDiffsResultConcrete : NSObject<JFListDiffsResult>

@property (strong, nonatomic, readonly) NSArray<JFListDiffsEditOperation*>* operations;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithOperations:(NSArray<JFListDiffsEditOperation*>*)operations NS_DESIGNATED_INITIALIZER;

@end

@implementation JFListDiffs

+ (id<JFListDiffsResult>)calculateDiff:(id<JFListDiffsDataSource>)dataSource
{
	return [JFListDiffs calculateDiff:dataSource withMovesDetection:YES];
}

+ (id<JFListDiffsResult>)calculateDiff:(id<JFListDiffsDataSource>)dataSource withMovesDetection:(BOOL)shouldDetectMoves
{
	NSUInteger newSize = [dataSource getNewListSize];
	NSUInteger oldSize = [dataSource getOldListSize];

	if(newSize == 0) {
		return [[JFListDiffsResultConcrete alloc] initWithOperations:@[[[JFListDiffsEditOperation alloc] initDeleteOperationAtIndex:0 count:oldSize]]];
	}
	
	if(oldSize == 0) {
		return [[JFListDiffsResultConcrete alloc] initWithOperations:@[[[JFListDiffsEditOperation alloc] initInsertOperationAtIndex:0 count:newSize]]];
	}
	
//	NSUInteger rows = oldSize + 1;
//	NSUInteger columns = newSize + 1;
//
//	NSUInteger** distanceMatrix = [JFListDiffs setUpDistanceMatrixWithRows:rows andColumns:columns];
//
//	for(NSUInteger row = 1; row < rows; row++) {
//		NSUInteger previousRow = row - 1;
//		for(NSUInteger column = 1; column < columns; column++) {
//			NSUInteger previousColumn = column - 1;
//			if([dataSource isOldItem:previousRow equalToNewItem:previousColumn]) {
//				// no change
//				distanceMatrix[row][column] = distanceMatrix[previousRow][previousColumn];
//			} else {
//				NSUInteger deleteCost = distanceMatrix[previousRow][column] + 1;
//				NSUInteger insertCost = distanceMatrix[row][previousColumn] + 1;
//				NSUInteger replaceCost = distanceMatrix[previousRow][previousColumn] + 1;
//			}
//
//
//		}
//	}
//
//	[JFListDiffs tearDownDistanceMatrix:distanceMatrix rows:rows];
	
	NSMutableArray<JFListDiffsEditOperation*>* operations = [NSMutableArray<JFListDiffsEditOperation*> array];
	[operations addObject:[[JFListDiffsEditOperation alloc] initReplaceOperationAtIndex:0 count:MIN(newSize, oldSize)]];

	if(oldSize > newSize) {
		[operations addObject:[[JFListDiffsEditOperation alloc] initDeleteOperationAtIndex:newSize count:(oldSize - newSize)]];
	} else if(oldSize < newSize) {
		[operations addObject:[[JFListDiffsEditOperation alloc] initInsertOperationAtIndex:oldSize count:(newSize - oldSize)]];
	}
	
	return [[JFListDiffsResultConcrete alloc] initWithOperations:[operations copy]];
}

//- (NSInteger)levenshteinDistanceBetween:(NSString *)source and:(NSString *)target
//{
//	NSInteger sourceLength = [source length];
//	NSInteger targetLength = [target length];
//	NSInteger distanceMatrix[sourceLength + 1][targetLength + 1];
//
//	for (NSInteger i = 0; i <= sourceLength; i++) {
//		distanceMatrix[i][0] = i;
//	}
//
//	for (NSInteger j = 0; j <= targetLength; j++) {
//		distanceMatrix[0][j] = j;
//	}
//
//	for (NSInteger i = 1; i <= sourceLength; i++) {
//		unichar sourceChar = [source characterAtIndex:i - 1];
//
//		for (NSInteger j = 1; j <= targetLength; j++) {
//			unichar targetChar = [target characterAtIndex:j - 1];
//			NSInteger cost = (sourceChar == targetChar) ? 0 : 1;
//			NSInteger deletion = distanceMatrix[i - 1][j] + 1;
//			NSInteger insertion = distanceMatrix[i][j - 1] + 1;
//			NSInteger substitution = distanceMatrix[i - 1][j - 1] + cost;
//			distanceMatrix[i][j] = MIN(MIN(deletion, insertion), substitution);
//		}
//	}
//	return distanceMatrix[sourceLength][targetLength];
//}

+ (NSUInteger**)setUpDistanceMatrixWithRows:(NSUInteger)rows andColumns:(NSUInteger)columns
{
	NSUInteger** matrix = (NSUInteger**)malloc(rows * sizeof(NSUInteger*));
	
	for(NSUInteger row = 0; row < rows; row++) {
		matrix[row] = (NSUInteger*)malloc(columns * sizeof(NSUInteger));
		matrix[row][0] = row;
	}
	
	for(NSUInteger column = 1; column < columns; column++) {
		matrix[0][column] = column;
	}

	return matrix;
}

+ (void)tearDownDistanceMatrix:(NSUInteger**)matrix rows:(NSUInteger)rows
{
	for(NSUInteger i = 0; i < rows; i++) {
		free(matrix[i]);
	}
	
	free(matrix);
}

@end

@implementation JFListDiffsEditOperation

@synthesize count = _count;
@synthesize newIndex = _newIndex;
@synthesize oldIndex = _oldIndex;
@synthesize type = _type;

- (instancetype)initDeleteOperationAtIndex:(NSUInteger)oldIndex count:(NSUInteger)count
{
	self = [super init];
	_count = count;
	_newIndex = NSUIntegerMax;
	_oldIndex = oldIndex;
	_type = JFListDiffsOperationTypeDelete;
	return self;
}

- (instancetype)initInsertOperationAtIndex:(NSUInteger)newIndex count:(NSUInteger)count
{
	self = [super init];
	_count = count;
	_newIndex = newIndex;
	_oldIndex = NSUIntegerMax;
	_type = JFListDiffsOperationTypeInsert;
	return self;
}

- (instancetype)initMoveOperationFromIndex:(NSUInteger)oldIndex toIndex:(NSUInteger)newIndex count:(NSUInteger)count
{
	self = [super init];
	_count = count;
	_newIndex = newIndex;
	_oldIndex = oldIndex;
	_type = JFListDiffsOperationTypeMove;
	return self;
}

- (instancetype)initReplaceOperationAtIndex:(NSUInteger)index count:(NSUInteger)count
{
	self = [super init];
	_count = count;
	_newIndex = index;
	_oldIndex = index;
	_type =  JFListDiffsOperationTypeReplace;
	return self;
}

@end

@implementation JFListDiffsResultConcrete

@synthesize operations = _operations;

- (instancetype)initWithOperations:(NSArray<JFListDiffsEditOperation*>*)operations
{
	self = [super init];
	_operations = operations;
	return self;
}

- (void)dispatchUpdates:(id<JFListDiffsDispatcher>)dispatcher
{}

- (NSUInteger)getNewIndexFromOldIndex:(NSUInteger)oldIndex
{
	return NSUIntegerMax;
}

- (NSUInteger)getOldIndexFromNewIndex:(NSUInteger)newIndex
{
	return NSUIntegerMax;
}

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

