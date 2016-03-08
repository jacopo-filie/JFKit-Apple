//
//	The MIT License (MIT)
//
//	Copyright © 2015-2016 Jacopo Filié
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



#pragma mark - Common headers

// Core
#import "JFAppDelegate.h"
#import	"JFConnectionMachine.h"
#import "JFErrorsManager.h"
#import	"JFManager.h"

// Data Objects
#import "JFByteStream.h"
#import "JFColor.h"
#import "JFString.h"

// User Interface
#import "JFWindowController.h"

// Utilities
#import "JFLogger.h"
#import	"JFPreprocessorMacros.h"
#import "JFTypes.h"
#import	"JFUtilities.h"



#if JF_TARGET_OS_IOS
#pragma mark - iOS specific headers

// User interface (Addons)
#import	"UIButton+JFFramework.h"
#import	"UILabel+JFFramework.h"
#import "UIStoryboard+JFFramework.h"

// User interface
#import "JFAlert.h"

#endif



#if JF_TARGET_OS_OSX
#pragma mark - OSX specific headers

// User interface (Addons)
#import "NSStoryboard+JFFramework.h"

// User interface
#import "JFAlert.h"

#endif



#if JF_TARGET_OS_TV
#pragma mark - tvOS specific headers

// User interface (Addons)
#import	"UIButton+JFFramework.h"
#import	"UILabel+JFFramework.h"
#import "UIStoryboard+JFFramework.h"

#endif
