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

////////////////////////////////////////////////////////////////////////////////////////////////////

@import Foundation;

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Compatibility addons
// =================================================================================================

#ifndef TARGET_OS_OSX
#	define TARGET_OS_OSX (!TARGET_OS_IPHONE && !TARGET_OS_SIMULATOR && !TARGET_OS_EMBEDDED)
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

// =================================================================================================
// MARK: Feature conditionals
// =================================================================================================

#define JF_WEAK_ENABLED	__has_feature(objc_arc_weak)

// =================================================================================================
// MARK: Target conditionals
// =================================================================================================

#define	JF_ARCH32	!__LP64__
#define	JF_ARCH64	__LP64__
#define	JF_IOS		(TARGET_OS_MAC && TARGET_OS_IPHONE && TARGET_OS_IOS)
#define	JF_MACOS	(TARGET_OS_MAC && TARGET_OS_OSX)
#define	JF_TVOS		(TARGET_OS_MAC && TARGET_OS_IPHONE && TARGET_OS_TV)
#define	JF_WATCHOS	(TARGET_OS_MAC && TARGET_OS_IPHONE && TARGET_OS_WATCH)

////////////////////////////////////////////////////////////////////////////////////////////////////
