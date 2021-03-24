//
//	The MIT License (MIT)
//
//	Copyright © 2015-2021 Jacopo Filié
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

@import Foundation;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Types
// =================================================================================================

/**
 * A container for streams of bytes.
 */
typedef struct {
	
	/**
	 * The bytes contained by this stream.
	 */
	Byte* _Nullable bytes;
	
	/**
	 * The number of elements contained by `bytes`.
	 */
	NSUInteger length;
} JFByteStream;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Constants
// =================================================================================================

/**
 * A constant empty stream.
 */
FOUNDATION_EXPORT JFByteStream const JFByteStreamZero;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

// =================================================================================================
// MARK: Functions
// =================================================================================================

/**
 * Allocates a new stream in memory containing `length` elements.
 * @param length The length of the new stream.
 * @return A new stream containing `length` elements.
 */
FOUNDATION_EXPORT JFByteStream JFByteStreamAlloc(NSUInteger length);

/**
 * Copies the first `count` elements of the given stream inside a newly created stream.
 * @param source The source stream.
 * @param count The number of elements to copy to the new stream.
 * @return A new stream containing a copy of the first `count` elements of the source stream. If `count` is greater than the length of the source stream the full source stream will be copied.
 */
FOUNDATION_EXPORT JFByteStream JFByteStreamCCopy(JFByteStream source, NSUInteger count);

/**
 * Copies the elements of the given stream inside a newly created stream.
 * @param source The source stream.
 * @return A new stream containing a full copy of the source stream.
 */
FOUNDATION_EXPORT JFByteStream JFByteStreamCopy(JFByteStream source);

/**
 * Compares two streams and returns whether they are equal or not.
 * @param byteStream1 The first element of the comparison.
 * @param byteStream2 The second element of the comparison.
 * @return `YES` if the given streams are equal, `NO` otherwise.
 */
FOUNDATION_EXPORT BOOL JFByteStreamEqualToByteStream(JFByteStream byteStream1, JFByteStream byteStream2);

/**
 * Deallocates the given stream bytes.
 * @param byteStream The stream to deallocate.
 */
FOUNDATION_EXPORT void JFByteStreamFree(JFByteStream byteStream);

/**
 * Creates a new stream with `length` elements and sets its internal buffer `bytes` to the given bytes.
 * @param bytes The elements to set as stream internal buffer.
 * @param length The number of elements of the given bytes.
 * @return A new stream containing `length` elements which are inside `bytes`.
 */
FOUNDATION_EXPORT JFByteStream JFByteStreamMake(Byte* _Nullable bytes, NSUInteger length);

/**
 * Reallocates the stream buffer to contain `length` elements.
 * @param byteStream The stream to be modified.
 * @param length The new length of the stream.
 * @return The stream given with the parameter `byteStream`.
 */
FOUNDATION_EXPORT JFByteStream JFByteStreamRealloc(JFByteStream byteStream, NSUInteger length);

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
