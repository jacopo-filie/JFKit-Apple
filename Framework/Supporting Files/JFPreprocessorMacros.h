//
//	The MIT License (MIT)
//
//	Copyright © 2015-2017 Jacopo Filié
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

#ifndef __IOS_AVAILABLE
#	define __IOS_AVAILABLE(_ios)
#endif
#ifndef __OSX_AVAILABLE
#	define __OSX_AVAILABLE(_macos)
#endif
#ifndef __TVOS_AVAILABLE
#	define __TVOS_AVAILABLE(_tvos)
#endif
#ifndef __WATCHOS_AVAILABLE
#	define __WATCHOS_AVAILABLE(_watchos)
#endif
#ifndef TARGET_OS_OSX
#	define TARGET_OS_OSX (!TARGET_OS_IPHONE && !TARGET_OS_SIMULATOR && !TARGET_OS_EMBEDDED)
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

// =================================================================================================
// MARK: Availability
// =================================================================================================

#define JF_AVAILABLE(_macos, _ios, _tvos, _watchos)	__OSX_AVAILABLE(_macos) __IOS_AVAILABLE(_ios) __TVOS_AVAILABLE(_tvos) __WATCHOS_AVAILABLE(_watchos)
#define JF_AVAILABLE_IT(_ios, _tvos)										__IOS_AVAILABLE(_ios) __TVOS_AVAILABLE(_tvos)
#define JF_AVAILABLE_MI(_macos, _ios)				__OSX_AVAILABLE(_macos) __IOS_AVAILABLE(_ios)
#define JF_AVAILABLE_MIT(_macos, _ios, _tvos)		__OSX_AVAILABLE(_macos) __IOS_AVAILABLE(_ios) __TVOS_AVAILABLE(_tvos)

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -

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
