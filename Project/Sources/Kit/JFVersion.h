//
//	The MIT License (MIT)
//
//	Copyright © 2016-2022 Jacopo Filié
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

#import "JFPreprocessorMacros.h"

@import Foundation;

#if JF_MACOS
@import Cocoa;
#else
@import UIKit;
#endif

#import "JFMath.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

#if JF_SHORTCUTS_ENABLED

// =================================================================================================
// MARK: Macros - Shortcuts (iOS)
// =================================================================================================

/**
 * Checks whether the current iOS version is equal to the given version string.
 * @param _version The version string to compare.
 * @return `YES` if the current iOS version is equal to the given version string, `NO` otherwise.
 */
#	define iOS(_version) [JFVersion isIOS:_version]

/**
 * Checks whether the current iOS version is greater than or equal to the given version string.
 * @param _version The version string to compare.
 * @return `YES` if the current iOS version is greater than or equal to the given version string, `NO` otherwise.
 */
#	define iOSPlus(_version) [JFVersion isIOSPlus:_version]

/**
 * Checks whether the current iOS major version is `8`.
 * @return `YES` if the current iOS major version is `8`, `NO` otherwise.
 */
#	define iOS8 [JFVersion isIOS8]

/**
 * Checks whether the current iOS major version is `8` or greater.
 * @return `YES` if the current iOS major version is `8` or greater, `NO` otherwise.
 */
#	define iOS8Plus [JFVersion isIOS8Plus]

/**
 * Checks whether the current iOS major version is `9`.
 * @return `YES` if the current iOS major version is `9`, `NO` otherwise.
 */
#	define iOS9 [JFVersion isIOS9]

/**
 * Checks whether the current iOS major version is `9` or greater.
 * @return `YES` if the current iOS major version is `9` or greater, `NO` otherwise.
 */
#	define iOS9Plus [JFVersion isIOS9Plus]

/**
 * Checks whether the current iOS major version is `10`.
 * @return `YES` if the current iOS major version is `10`, `NO` otherwise.
 */
#	define iOS10 [JFVersion isIOS10]

/**
 * Checks whether the current iOS major version is `10` or greater.
 * @return `YES` if the current iOS major version is `10` or greater, `NO` otherwise.
 */
#	define iOS10Plus [JFVersion isIOS10Plus]

/**
 * Checks whether the current iOS major version is `11`.
 * @return `YES` if the current iOS major version is `11`, `NO` otherwise.
 */
#	define iOS11 [JFVersion isIOS11]

/**
 * Checks whether the current iOS major version is `11` or greater.
 * @return `YES` if the current iOS major version is `11` or greater, `NO` otherwise.
 */
#	define iOS11Plus [JFVersion isIOS11Plus]

// =================================================================================================
// MARK: Macros - Shortcuts (macOS)
// =================================================================================================

/**
 * Checks whether the current macOS version is equal to the given version string.
 * @param _version The version string to compare.
 * @return `YES` if the current macOS version is equal to the given version string, `NO` otherwise.
 */
#	define macOS(_version) [JFVersion isMacOS:_version]

/**
 * Checks whether the current macOS version is greater than or equal to the given version string.
 * @param _version The version string to compare.
 * @return `YES` if the current macOS version is greater than or equal to the given version string, `NO` otherwise.
 */
#	define macOSPlus(_version) [JFVersion isMacOSPlus:_version]

/**
 * Checks whether the current macOS major version is `10` and minor version is `6`.
 * @return `YES` if the current iOS major version is `10` and minor version is `6`, `NO` otherwise.
 */
#	define macOS10_6 [JFVersion isMacOS10_6]

/**
 * Checks whether the current macOS version is greater than or equal to `10.6`.
 * @return `YES` if the current macOS version is greater than or equal to `10.6`, `NO` otherwise.
 */
#	define macOS10_6Plus [JFVersion isMacOS10_6Plus]

/**
 * Checks whether the current macOS major version is `10` and minor version is `7`.
 * @return `YES` if the current iOS major version is `10` and minor version is `7`, `NO` otherwise.
 */
#	define macOS10_7 [JFVersion isMacOS10_7]

/**
 * Checks whether the current macOS version is greater than or equal to `10.7`.
 * @return `YES` if the current macOS version is greater than or equal to `10.7`, `NO` otherwise.
 */
#	define macOS10_7Plus [JFVersion isMacOS10_7Plus]

/**
 * Checks whether the current macOS major version is `10` and minor version is `8`.
 * @return `YES` if the current iOS major version is `10` and minor version is `8`, `NO` otherwise.
 */
#	define macOS10_8 [JFVersion isMacOS10_8]

/**
 * Checks whether the current macOS version is greater than or equal to `10.8`.
 * @return `YES` if the current macOS version is greater than or equal to `10.8`, `NO` otherwise.
 */
#	define macOS10_8Plus [JFVersion isMacOS10_8Plus]

/**
 * Checks whether the current macOS major version is `10` and minor version is `9`.
 * @return `YES` if the current iOS major version is `10` and minor version is `9`, `NO` otherwise.
 */
#	define macOS10_9 [JFVersion isMacOS10_9]

/**
 * Checks whether the current macOS version is greater than or equal to `10.9`.
 * @return `YES` if the current macOS version is greater than or equal to `10.9`, `NO` otherwise.
 */
#	define macOS10_9Plus [JFVersion isMacOS10_9Plus]

/**
 * Checks whether the current macOS major version is `10` and minor version is `10`.
 * @return `YES` if the current iOS major version is `10` and minor version is `10`, `NO` otherwise.
 */
#	define macOS10_10 [JFVersion isMacOS10_10]

/**
 * Checks whether the current macOS version is greater than or equal to `10.10`.
 * @return `YES` if the current macOS version is greater than or equal to `10.10`, `NO` otherwise.
 */
#	define macOS10_10Plus [JFVersion isMacOS10_10Plus]

/**
 * Checks whether the current macOS major version is `10` and minor version is `11`.
 * @return `YES` if the current iOS major version is `10` and minor version is `11`, `NO` otherwise.
 */
#	define macOS10_11 [JFVersion isMacOS10_11]

/**
 * Checks whether the current macOS version is greater than or equal to `10.11`.
 * @return `YES` if the current macOS version is greater than or equal to `10.11`, `NO` otherwise.
 */
#	define macOS10_11Plus [JFVersion isMacOS10_11Plus]

/**
 * Checks whether the current macOS major version is `10` and minor version is `12`.
 * @return `YES` if the current iOS major version is `10` and minor version is `12`, `NO` otherwise.
 */
#	define macOS10_12 [JFVersion isMacOS10_12]

/**
 * Checks whether the current macOS version is greater than or equal to `10.12`.
 * @return `YES` if the current macOS version is greater than or equal to `10.12`, `NO` otherwise.
 */
#	define macOS10_12Plus [JFVersion isMacOS10_12Plus]

/**
 * Checks whether the current macOS major version is `10` and minor version is `13`.
 * @return `YES` if the current iOS major version is `10` and minor version is `13`, `NO` otherwise.
 */
#	define macOS10_13 [JFVersion isMacOS10_13]

/**
 * Checks whether the current macOS version is greater than or equal to `10.13`.
 * @return `YES` if the current macOS version is greater than or equal to `10.13`, `NO` otherwise.
 */
#	define macOS10_13Plus [JFVersion isMacOS10_13Plus]

#endif

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

// =================================================================================================
// MARK: Constants
// =================================================================================================

/**
 * A constant to represent a version component that is invalid.
 */
FOUNDATION_EXPORT NSInteger const JFVersionComponentNotValid;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

/**
 * The `JFVersion` class encapsulates the needed info and methods to easily store and compare version numbers or strings. When converting the version string to components and viceversa, it uses the following string format:
 * @code
 *   <major>.<minor>.<patch> (<build>)
 * @endcode
 * @warning While the major, minor and patch components must be integers, the build component is a string.
 */
@interface JFVersion : NSObject <NSCopying>

// =================================================================================================
// MARK: Properties - Data
// =================================================================================================

/**
 * The build component of the version. It is considered invalid when equal to `nil`.
 */
@property (strong, nonatomic, readonly, nullable) NSString* build;

/**
 * The major component of the version. It is considered invalid when equal to `JFVersionComponentNotValid`.
 */
@property (assign, nonatomic, readonly) NSInteger major;

/**
 * The minor component of the version. It is considered invalid when equal to `JFVersionComponentNotValid`.
 */
@property (assign, nonatomic, readonly) NSInteger minor;

/**
 * The patch component of the version. It is considered invalid when equal to `JFVersionComponentNotValid`.
 */
@property (assign, nonatomic, readonly) NSInteger patch;

/**
 * This instance represented as the `NSOperatingSystemVersion` struct. The patch component is ignored.
 */
@property (assign, nonatomic, readonly) NSOperatingSystemVersion operatingSystemVersion API_AVAILABLE(ios(8.0), macos(10.10));

/**
 * This instance represented as a string with the following format:
 * @code
 *   <major>.<minor>.<patch> (<build>)
 * @endcode
 * If the major component is invalid, the string will have `0` in place of that component; if the minor component is invalid, the string will have `0` in place of that component; if the patch component is invalid, the string will ignore that component; if the build component is invalid, the string will ignore that component.
 */
@property (strong, nonatomic, readonly) NSString* string;

// =================================================================================================
// MARK: Lifecycle
// =================================================================================================

/**
 * Returns a version object containing the current operating system version.
 * @return A version object containing the current operating system version.
 */
+ (JFVersion*)currentOperatingSystemVersion;

/**
 * NOT AVAILABLE
 */
+ (instancetype)new NS_UNAVAILABLE;

/**
 * Returns a version object containing the following components:
 * @code
 *   `major` = major;
 *   `minor` = JFVersionComponentNotValid;
 *   `patch` = JFVersionComponentNotValid;
 *   `build` = nil;
 * @endcode
 * @param major The major component value.
 * @return A version object with the given components.
 */
+ (instancetype)versionWithMajorComponent:(NSInteger)major;

/**
 * Returns a version object containing the following components:
 * @code
 *   `major` = major;
 *   `minor` = minor;
 *   `patch` = JFVersionComponentNotValid;
 *   `build` = nil;
 * @endcode
 * @param major The major component value.
 * @param minor The minor component value.
 * @return A version object with the given components.
 */
+ (instancetype)versionWithMajorComponent:(NSInteger)major minor:(NSInteger)minor;

/**
 * NOT AVAILABLE
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes a version object with the given components.
 * @param major The major component value.
 * @param minor The minor component value.
 * @param patch The patch component value.
 * @param build The build component value.
 * @return A version object with the given components.
 */
- (instancetype)initWithMajorComponent:(NSInteger)major minor:(NSInteger)minor patch:(NSInteger)patch build:(NSString* _Nullable)build NS_DESIGNATED_INITIALIZER;

/**
 * Initializes a version object by using the given version struct values.
 * @param operatingSystemVersion The version struct to use.
 * @return A version object containing the given version struct values.
 */
- (instancetype)initWithOperatingSystemVersion:(NSOperatingSystemVersion)operatingSystemVersion API_AVAILABLE(ios(8.0), macos(10.10));

/**
 * Initializes a version object by parsing the given version string. The parser expects a string with the following format:
 * @code
 *   <major>.<minor>.<patch> (<build>)
 * @endcode
 * @param versionString The version string to parse.
 * @return A version object containing the parsed values found in the given string.
 */
- (instancetype)initWithVersionString:(NSString*)versionString;

// =================================================================================================
// MARK: Methods - Comparison
// =================================================================================================

/**
 * Compares this instance with the current operating system version and returns whether the given relation is verified. This instance is always the first element in the comparison. Invalid components are ignored during the comparison. The build component, if valid, is compared using the `NSNumericSearch` option.
 * @param relation The relation type to verify.
 * @return `YES` if the relation is verified, `NO` otherwise.
 */
- (BOOL)compareToCurrentOperatingSystemVersion:(JFRelation)relation;

/**
 * Compares this instance with the given version and returns whether the given relation is verified. This instance is always the first element in the comparison. Invalid components are ignored during the comparison. The build component, if valid, is compared using the `NSNumericSearch` option.
 * @param version The version to compare.
 * @param relation The relation type to verify.
 * @return `YES` if the relation is verified, `NO` otherwise.
 */
- (BOOL)compareToVersion:(JFVersion*)version relation:(JFRelation)relation;

/**
 * Compares this instance with the given version and returns whether the given relation is verified. This instance is always the first element in the comparison. Invalid components are ignored during the comparison. The build component, if valid, is compared using the given comparator block.
 * @param version The version to compare.
 * @param relation The relation type to verify.
 * @param comparatorBlock The block to use for comparing the build components, if valid.
 * @return `YES` if the relation is verified, `NO` otherwise.
 */
- (BOOL)compareToVersion:(JFVersion*)version relation:(JFRelation)relation buildComparatorBlock:(NSComparisonResult (^)(NSString* build1, NSString* build2))comparatorBlock;

/**
 * Checks whether this instance is equal to the given version. This instance is always the first element in the comparison. Invalid components are ignored during the comparison. The build component, if valid, is compared using the `NSNumericSearch` option.
 * @param version The version to compare.
 * @return `YES` if the versions are equal, `NO` otherwise.
 */
- (BOOL)isEqualToVersion:(JFVersion*)version;

/**
 * Checks whether this instance is greater than the given version. This instance is always the first element in the comparison. Invalid components are ignored during the comparison. The build component, if valid, is compared using the `NSNumericSearch` option.
 * @param version The version to compare.
 * @return `YES` if this instance is greater than the given version, `NO` otherwise.
 */
- (BOOL)isGreaterThanVersion:(JFVersion*)version;

/**
 * Checks whether this instance is less than the given version. This instance is always the first element in the comparison. Invalid components are ignored during the comparison. The build component, if valid, is compared using the `NSNumericSearch` option.
 * @param version The version to compare.
 * @return `YES` if this instance is less than the given version, `NO` otherwise.
 */
- (BOOL)isLessThanVersion:(JFVersion*)version;

// =================================================================================================
// MARK: Methods - Comparison (iOS)
// =================================================================================================

/**
 * Checks whether the current iOS version is equal to the given version string.
 * @param version The version string to compare.
 * @return `YES` if the current iOS version is equal to the given version string, `NO` otherwise.
 */
+ (BOOL)isIOS:(JFVersion*)version;

/**
 * Checks whether the current iOS version is greater than or equal to the given version string.
 * @param version The version string to compare.
 * @return `YES` if the current iOS version is greater than or equal to the given version string, `NO` otherwise.
 */
+ (BOOL)isIOSPlus:(JFVersion*)version;

/**
 * Checks whether the current iOS major version is `8`.
 * @return `YES` if the current iOS major version is `8`, `NO` otherwise.
 */
+ (BOOL)isIOS8;

/**
 * Checks whether the current iOS major version is `8` or greater.
 * @return `YES` if the current iOS major version is `8` or greater, `NO` otherwise.
 */
+ (BOOL)isIOS8Plus;

/**
 * Checks whether the current iOS major version is `9`.
 * @return `YES` if the current iOS major version is `9`, `NO` otherwise.
 */
+ (BOOL)isIOS9;

/**
 * Checks whether the current iOS major version is `9` or greater.
 * @return `YES` if the current iOS major version is `9` or greater, `NO` otherwise.
 */
+ (BOOL)isIOS9Plus;

/**
 * Checks whether the current iOS major version is `10`.
 * @return `YES` if the current iOS major version is `10`, `NO` otherwise.
 */
+ (BOOL)isIOS10;

/**
 * Checks whether the current iOS major version is `10` or greater.
 * @return `YES` if the current iOS major version is `10` or greater, `NO` otherwise.
 */
+ (BOOL)isIOS10Plus;

/**
 * Checks whether the current iOS major version is `11`.
 * @return `YES` if the current iOS major version is `11`, `NO` otherwise.
 */
+ (BOOL)isIOS11;

/**
 * Checks whether the current iOS major version is `11` or greater.
 * @return `YES` if the current iOS major version is `11` or greater, `NO` otherwise.
 */
+ (BOOL)isIOS11Plus;

// =================================================================================================
// MARK: Methods - Comparison (macOS)
// =================================================================================================

/**
 * Checks whether the current macOS version is equal to the given version string.
 * @param version The version string to compare.
 * @return `YES` if the current macOS version is equal to the given version string, `NO` otherwise.
 */
+ (BOOL)isMacOS:(JFVersion*)version;

/**
 * Checks whether the current macOS version is greater than or equal to the given version string.
 * @param version The version string to compare.
 * @return `YES` if the current macOS version is greater than or equal to the given version string, `NO` otherwise.
 */
+ (BOOL)isMacOSPlus:(JFVersion*)version;

/**
 * Checks whether the current macOS major version is `10` and minor version is `6`.
 * @return `YES` if the current iOS major version is `10` and minor version is `6`, `NO` otherwise.
 */
+ (BOOL)isMacOS10_6;

/**
 * Checks whether the current macOS version is greater than or equal to `10.6`.
 * @return `YES` if the current macOS version is greater than or equal to `10.6`, `NO` otherwise.
 */
+ (BOOL)isMacOS10_6Plus;

/**
 * Checks whether the current macOS major version is `10` and minor version is `7`.
 * @return `YES` if the current iOS major version is `10` and minor version is `7`, `NO` otherwise.
 */
+ (BOOL)isMacOS10_7;

/**
 * Checks whether the current macOS version is greater than or equal to `10.7`.
 * @return `YES` if the current macOS version is greater than or equal to `10.7`, `NO` otherwise.
 */
+ (BOOL)isMacOS10_7Plus;

/**
 * Checks whether the current macOS major version is `10` and minor version is `8`.
 * @return `YES` if the current iOS major version is `10` and minor version is `8`, `NO` otherwise.
 */
+ (BOOL)isMacOS10_8;

/**
 * Checks whether the current macOS version is greater than or equal to `10.8`.
 * @return `YES` if the current macOS version is greater than or equal to `10.8`, `NO` otherwise.
 */
+ (BOOL)isMacOS10_8Plus;

/**
 * Checks whether the current macOS major version is `10` and minor version is `9`.
 * @return `YES` if the current iOS major version is `10` and minor version is `9`, `NO` otherwise.
 */
+ (BOOL)isMacOS10_9;

/**
 * Checks whether the current macOS version is greater than or equal to `10.9`.
 * @return `YES` if the current macOS version is greater than or equal to `10.9`, `NO` otherwise.
 */
+ (BOOL)isMacOS10_9Plus;

/**
 * Checks whether the current macOS major version is `10` and minor version is `10`.
 * @return `YES` if the current iOS major version is `10` and minor version is `10`, `NO` otherwise.
 */
+ (BOOL)isMacOS10_10;

/**
 * Checks whether the current macOS version is greater than or equal to `10.10`.
 * @return `YES` if the current macOS version is greater than or equal to `10.10`, `NO` otherwise.
 */
+ (BOOL)isMacOS10_10Plus;

/**
 * Checks whether the current macOS major version is `10` and minor version is `11`.
 * @return `YES` if the current iOS major version is `10` and minor version is `11`, `NO` otherwise.
 */
+ (BOOL)isMacOS10_11;

/**
 * Checks whether the current macOS version is greater than or equal to `10.11`.
 * @return `YES` if the current macOS version is greater than or equal to `10.11`, `NO` otherwise.
 */
+ (BOOL)isMacOS10_11Plus;

/**
 * Checks whether the current macOS major version is `10` and minor version is `12`.
 * @return `YES` if the current iOS major version is `10` and minor version is `12`, `NO` otherwise.
 */
+ (BOOL)isMacOS10_12;

/**
 * Checks whether the current macOS version is greater than or equal to `10.12`.
 * @return `YES` if the current macOS version is greater than or equal to `10.12`, `NO` otherwise.
 */
+ (BOOL)isMacOS10_12Plus;

/**
 * Checks whether the current macOS major version is `10` and minor version is `13`.
 * @return `YES` if the current iOS major version is `10` and minor version is `13`, `NO` otherwise.
 */
+ (BOOL)isMacOS10_13;

/**
 * Checks whether the current macOS version is greater than or equal to `10.13`.
 * @return `YES` if the current macOS version is greater than or equal to `10.13`, `NO` otherwise.
 */
+ (BOOL)isMacOS10_13Plus;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
