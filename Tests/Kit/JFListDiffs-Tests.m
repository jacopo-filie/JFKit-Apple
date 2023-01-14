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

#import <XCTest/XCTest.h>

#import "JFListDiffs.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@interface JFListDiffs_Tests : XCTestCase

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@interface JFListDiffs_Tests_DataSource : NSObject <JFListDiffsDataSource>

@property (strong, nonatomic) NSArray<NSString*>* list1;
@property (strong, nonatomic) NSArray<NSString*>* list2;

@end

@implementation JFListDiffs_Tests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
	
	NSString* a = @"A";
	NSString* b = @"B";
	NSString* c = @"C";
	
	JFListDiffs_Tests_DataSource* dataSource = [JFListDiffs_Tests_DataSource new];
	dataSource.list2 = @[c, b, a, b, a, c];
	
	id<JFListDiffsResult> result = [JFListDiffs calculateDiff:dataSource];
	XCTAssertNotNil(result);
	
	dataSource.list1 = @[a, b, c, a, b, b, a];
	dataSource.list2 = @[];

	result = [JFListDiffs calculateDiff:dataSource];
	XCTAssertNotNil(result);
	
	dataSource.list1 = @[a, b, c, a, b, b, a];
	dataSource.list2 = @[c, b, a, b, a, c];
	
	result = [JFListDiffs calculateDiff:dataSource];
	XCTAssertNotNil(result);
	
	dataSource.list1 = @[c, b, a, b, a, c];
	dataSource.list2 = @[a, b, c, a, b, b, a];
	
	result = [JFListDiffs calculateDiff:dataSource];
	XCTAssertNotNil(result);
	
	dataSource.list1 = @[c, b, a, b, a, c];
	dataSource.list2 = @[a, b, c, a, b, b];
	
	result = [JFListDiffs calculateDiff:dataSource];
	XCTAssertNotNil(result);
	//NSUInteger newIndex = [result getNewIndexFromOldIndex:0];
	//NSUInteger oldIndex = [result getOldIndexFromNewIndex:0];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

@implementation JFListDiffs_Tests_DataSource

@synthesize list2 = _list2;
@synthesize list1 = _list1;

- (instancetype)init
{
	self = [super init];
	_list2 = @[];
	_list1 = @[];
	return self;
}

- (NSUInteger)getNewListSize
{
	return self.list2.count;
}

- (NSUInteger)getOldListSize
{
	return self.list1.count;
}

- (BOOL)isContentOfOldItem:(NSUInteger)oldItemIndex equalToContentOfNewItem:(NSUInteger)newItemIndex
{
	return [self.list1[oldItemIndex] isEqualToString:self.list2[newItemIndex]];
}

- (BOOL)isOldItem:(NSUInteger)oldItemIndex equalToNewItem:(NSUInteger)newItemIndex
{
	return self.list1[oldItemIndex] == self.list2[newItemIndex];
}

@end
