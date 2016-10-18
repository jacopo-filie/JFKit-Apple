//
//	The MIT License (MIT)
//
//	Copyright © 2016 Jacopo Filié
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



NS_ASSUME_NONNULL_BEGIN
@interface JFVersion : NSObject <NSCopying>

// MARK: Properties - Data
@property (strong, nonatomic, readonly, nullable)	NSString*	buildVersion; // Valid if not 'nil' nor empty.
@property (assign, nonatomic, readonly)				NSInteger	majorVersion; // Valid if greater than or equal to 0.
@property (assign, nonatomic, readonly)				NSInteger	minorVersion; // Valid if greater than or equal to 0.
@property (assign, nonatomic, readonly)				NSInteger	patchVersion; // Valid if greater than 0.

// MARK: Properties - Info
@property (assign, nonatomic, readonly)	NSOperatingSystemVersion	operatingSystemVersion OBJC_AVAILABLE(__MAC_10_10, __IPHONE_8_0, __TVOS_9_0, __WATCHOS_2_0);
@property (strong, nonatomic, readonly)	NSString*					versionString; // Returns a string with format "<major>.<minor>.<patch> (<build>)"; only the valid components will be used.

// MARK: Methods - Memory management
- (instancetype)	init NS_UNAVAILABLE;
- (instancetype)	initWithMajorVersion:(NSInteger)major minor:(NSInteger)minor patch:(NSInteger)patch;
- (instancetype)	initWithMajorVersion:(NSInteger)major minor:(NSInteger)minor patch:(NSInteger)patch build:(NSString* __nullable)build NS_DESIGNATED_INITIALIZER;
- (instancetype)	initWithOperatingSystemVersion:(NSOperatingSystemVersion)operatingSystemVersion OBJC_AVAILABLE(__MAC_10_10, __IPHONE_8_0, __TVOS_9_0, __WATCHOS_2_0);
- (instancetype)	initWithOperatingSystemVersion:(NSOperatingSystemVersion)operatingSystemVersion build:(NSString* __nullable)build OBJC_AVAILABLE(__MAC_10_10, __IPHONE_8_0, __TVOS_9_0, __WATCHOS_2_0);
- (instancetype)	initWithVersionString:(NSString*)versionString; // Uses the same string format as "versionString".

@end
NS_ASSUME_NONNULL_END
