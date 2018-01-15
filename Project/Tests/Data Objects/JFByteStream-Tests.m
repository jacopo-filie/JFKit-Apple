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



#import <XCTest/XCTest.h>

#import "JFByteStream.h"
#import "JFString.h"



@interface JFByteStream_Tests : XCTestCase

@end



#pragma mark



@implementation JFByteStream_Tests

#pragma mark Tests

- (void)testConstants
{
	// JFByteStreamZero
	JFByteStream byteStream = JFByteStreamZero;
	XCTAssert((byteStream.bytes == NULL), @"The pointer to the bytes of the stream should be NULL.");
	XCTAssert((byteStream.length == 0), @"The length of the bytes of the stream should be 0.");
}

- (void)testFunctions
{
	// JFByteStreamAlloc
	NSUInteger length = 5;
	JFByteStream byteStream = JFByteStreamAlloc(length);
	XCTAssert((byteStream.bytes != NULL), @"The pointer to the bytes of the stream is NULL.");
	XCTAssert((byteStream.length == length), @"The length of the bytes is '%@'; it should be '%@'.", JFStringFromNSUInteger(byteStream.length), JFStringFromNSUInteger(length));
	JFByteStreamFree(byteStream);
	
	// JFByteStreamCCopy
	JFByteStream source = JFByteStreamAlloc(length + 5);
	byteStream = JFByteStreamCCopy(source, length);
	XCTAssert((byteStream.bytes != NULL), @"The pointer to the bytes of the stream is NULL.");
	XCTAssert((byteStream.length == length), @"The length of the bytes is '%@'; it should be '%@'.", JFStringFromNSUInteger(byteStream.length), JFStringFromNSUInteger(length));
	XCTAssert((memcmp(source.bytes, byteStream.bytes, length) == 0), @"The copied stream is not a substream of the source stream.");
	JFByteStreamFree(byteStream);
	
	// JFByteStreamCopy
	byteStream = JFByteStreamCopy(source);
	XCTAssert((byteStream.bytes != NULL), @"The pointer to the bytes of the stream is NULL.");
	XCTAssert((byteStream.length == source.length), @"The length of the bytes is '%@'; it should be '%@'.", JFStringFromNSUInteger(byteStream.length), JFStringFromNSUInteger(source.length));
	XCTAssert((memcmp(source.bytes, byteStream.bytes, length) == 0), @"The copied stream is not a perfect copy of the source stream.");
	
	// JFByteStreamEqualToByteStream
	XCTAssert(JFByteStreamEqualToByteStream(source, byteStream), @"The copied stream is not equal to the source stream.");
	JFByteStreamFree(byteStream);
	JFByteStreamFree(source);
	
	// JFByteStreamMake
	NSString* string = @"Prova";
	const char* chars = [string UTF8String];
	Byte* bytes = (Byte*)chars;
	length = strlen(chars);
	byteStream = JFByteStreamMake(bytes, length);
	XCTAssert((byteStream.bytes == bytes), @"The pointer to the bytes of the stream is '%@'; it should be '%@'.", JFStringFromPointer(byteStream.bytes), JFStringFromPointer(bytes));
	XCTAssert((byteStream.length == length), @"The length of the bytes is '%@'; it should be '%@'.", JFStringFromNSUInteger(byteStream.length), JFStringFromNSUInteger(source.length));
	
	// JFByteStreamRealloc
	length = 10;
	byteStream = JFByteStreamAlloc(length);
	length *= 2;
	byteStream = JFByteStreamRealloc(byteStream, length);
	XCTAssert((byteStream.bytes != NULL), @"The pointer to the bytes of the stream is NULL.");
	XCTAssert((byteStream.length == length), @"The length of the bytes is '%@'; it should be '%@'.", JFStringFromNSUInteger(byteStream.length), JFStringFromNSUInteger(length));
}

@end
