//
//	The MIT License (MIT)
//
//	Copyright © 2016-2018 Jacopo Filié
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

#import "JFTypes.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

#if JF_SHORTCUTS_ENABLED

// =================================================================================================
// MARK: Macros - Equality management (iOS)
// =================================================================================================
#if JF_IOS

#define iOS(_version)		[JFVersion isIOS:_version]
#define iOSPlus(_version)	[JFVersion isIOSPlus:_version]
#define iOS6				JFVersion.isIOS6
#define iOS6Plus			JFVersion.isIOS6Plus
#define iOS7				JFVersion.isIOS7
#define iOS7Plus			JFVersion.isIOS7Plus
#define iOS8				JFVersion.isIOS8
#define iOS8Plus			JFVersion.isIOS8Plus
#define iOS9				JFVersion.isIOS9
#define iOS9Plus			JFVersion.isIOS9Plus
#define iOS10				JFVersion.isIOS10
#define iOS10Plus			JFVersion.isIOS10Plus
#define iOS11				JFVersion.isIOS11
#define iOS11Plus			JFVersion.isIOS11Plus

#endif
// =================================================================================================
// MARK: Macros - Equality management (macOS)
// =================================================================================================
#if JF_MACOS

#define macOS(_version)		[JFVersion isMacOS:_version]
#define macOSPlus(_version)	[JFVersion isMacOSPlus:_version]
#define macOS10_6			JFVersion.isMacOS10_6
#define macOS10_6Plus		JFVersion.isMacOS10_6Plus
#define macOS10_7			JFVersion.isMacOS10_7
#define macOS10_7Plus		JFVersion.isMacOS10_7Plus
#define macOS10_8			JFVersion.isMacOS10_8
#define macOS10_8Plus		JFVersion.isMacOS10_8Plus
#define macOS10_9			JFVersion.isMacOS10_9
#define macOS10_9Plus		JFVersion.isMacOS10_9Plus
#define macOS10_10			JFVersion.isMacOS10_10
#define macOS10_10Plus		JFVersion.isMacOS10_10Plus
#define macOS10_11			JFVersion.isMacOS10_11
#define macOS10_11Plus		JFVersion.isMacOS10_11Plus
#define macOS10_12			JFVersion.isMacOS10_12
#define macOS10_12Plus		JFVersion.isMacOS10_12Plus
#define macOS10_13			JFVersion.isMacOS10_13
#define macOS10_13Plus		JFVersion.isMacOS10_13Plus

#endif
// =================================================================================================
// MARK: Macros - Equality management (tvOS)
// =================================================================================================
#if JF_TVOS

#define tvOS(_version)		[JFVersion isTVOS:_version]
#define tvOSPlus(_version)	[JFVersion isTVOSPlus:_version]
#define tvOS9				JFVersion.isTVOS9
#define tvOS9Plus			JFVersion.isTVOS9Plus
#define tvOS10				JFVersion.isTVOS10
#define tvOS10Plus			JFVersion.isTVOS10Plus

#endif

#endif // JF_SHORTCUTS_ENABLED

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

// =================================================================================================
// MARK: Constants - Data
// =================================================================================================

FOUNDATION_EXPORT NSInteger const	JFVersionNotValid;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

NS_ASSUME_NONNULL_BEGIN
@interface JFVersion : NSObject <NSCopying>

// MARK: Properties - Data
@property (strong, nonatomic, readonly, nullable)	NSString*	buildVersion; // Invalid if nil.
@property (assign, nonatomic, readonly)				NSInteger	majorVersion; // Invalid if equal to 'JFVersionNotValid'.
@property (assign, nonatomic, readonly)				NSInteger	minorVersion; // Invalid if equal to 'JFVersionNotValid'.
@property (assign, nonatomic, readonly)				NSInteger	patchVersion; // Invalid if equal to 'JFVersionNotValid'.

// MARK: Properties - Info
@property (assign, nonatomic, readonly)	NSOperatingSystemVersion	operatingSystemVersion JF_AVAILABLE(__MAC_10_10, __IPHONE_8_0, __TVOS_9_0, __WATCHOS_2_0);
@property (strong, nonatomic, readonly)	NSString*					versionString; // Returns a string with format "<major>.<minor>.<patch> (<build>)"; only the valid components will be used (patch version will be used only if strictly positive).

// MARK: Methods - Memory management
+ (JFVersion*)		currentOperatingSystemVersion;
+ (instancetype)	versionWithMajorVersion:(NSInteger)major;
+ (instancetype)	versionWithMajorVersion:(NSInteger)major minor:(NSInteger)minor;
- (instancetype)	init NS_UNAVAILABLE;
- (instancetype)	initWithMajorVersion:(NSInteger)major minor:(NSInteger)minor patch:(NSInteger)patch;
- (instancetype)	initWithMajorVersion:(NSInteger)major minor:(NSInteger)minor patch:(NSInteger)patch build:(NSString* __nullable)build NS_DESIGNATED_INITIALIZER;
- (instancetype)	initWithOperatingSystemVersion:(NSOperatingSystemVersion)operatingSystemVersion JF_AVAILABLE(__MAC_10_10, __IPHONE_8_0, __TVOS_9_0, __WATCHOS_2_0);
- (instancetype)	initWithOperatingSystemVersion:(NSOperatingSystemVersion)operatingSystemVersion build:(NSString* __nullable)build JF_AVAILABLE(__MAC_10_10, __IPHONE_8_0, __TVOS_9_0, __WATCHOS_2_0);
- (instancetype)	initWithVersionString:(NSString*)versionString; // Uses the same string format as "versionString".

// MARK: Methods - Equality management
- (BOOL)	compareToCurrentOperatingSystemVersion:(JFRelation)relation;
- (BOOL)	compareToVersion:(JFVersion*)version relation:(JFRelation)relation; // Will skip invalid values while comparing versions.
- (BOOL)	isEqualToVersion:(JFVersion*)version;
- (BOOL)	isGreaterThanVersion:(JFVersion*)version;
- (BOOL)	isLessThanVersion:(JFVersion*)version;

#if JF_IOS
// MARK: Methods - Equality management (iOS)
+ (BOOL)	isIOS:(JFVersion*)version;
+ (BOOL)	isIOSPlus:(JFVersion*)version;
+ (BOOL)	isIOS6;
+ (BOOL)	isIOS6Plus;
+ (BOOL)	isIOS7;
+ (BOOL)	isIOS7Plus;
+ (BOOL)	isIOS8;
+ (BOOL)	isIOS8Plus;
+ (BOOL)	isIOS9;
+ (BOOL)	isIOS9Plus;
+ (BOOL)	isIOS10;
+ (BOOL)	isIOS10Plus;
+ (BOOL)	isIOS11;
+ (BOOL)	isIOS11Plus;
#endif

#if JF_MACOS
// MARK: Methods - Equality management (macOS)
+ (BOOL)	isMacOS:(JFVersion*)version;
+ (BOOL)	isMacOSPlus:(JFVersion*)version;
+ (BOOL)	isMacOS10_6;
+ (BOOL)	isMacOS10_6Plus;
+ (BOOL)	isMacOS10_7;
+ (BOOL)	isMacOS10_7Plus;
+ (BOOL)	isMacOS10_8;
+ (BOOL)	isMacOS10_8Plus;
+ (BOOL)	isMacOS10_9;
+ (BOOL)	isMacOS10_9Plus;
+ (BOOL)	isMacOS10_10;
+ (BOOL)	isMacOS10_10Plus;
+ (BOOL)	isMacOS10_11;
+ (BOOL)	isMacOS10_11Plus;
+ (BOOL)	isMacOS10_12;
+ (BOOL)	isMacOS10_12Plus;
+ (BOOL)	isMacOS10_13;
+ (BOOL)	isMacOS10_13Plus;
#endif

#if JF_TVOS
// MARK: Methods - Equality management (tvOS)
+ (BOOL)	isTVOS:(JFVersion*)version;
+ (BOOL)	isTVOSPlus:(JFVersion*)version;
+ (BOOL)	isTVOS9;
+ (BOOL)	isTVOS9Plus;
+ (BOOL)	isTVOS10;
+ (BOOL)	isTVOS10Plus;
#endif

@end
NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
