//
//	The MIT License (MIT)
//
//	Copyright © 2022 Jacopo Filié
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
@import JFKit;

#import "JFDialogButton.h"
#import "JFDialogObserver.h"

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@interface JFDialog<__covariant ButtonType : JFDialogButton*, __covariant ObserverType : id<JFDialogObserver>> : NSObject

// =================================================================================================
// MARK: Properties
// =================================================================================================

@property (copy, nonatomic, nullable) NSString* message;
@property (copy, nonatomic, nullable) NSString* title;

@property (strong, nonatomic, nullable) ButtonType cancelButton;
@property (strong, nonatomic, nullable) ButtonType destructiveButton;
@property (copy, nonatomic, nullable) NSArray<ButtonType>* otherButtons;

@property (strong, nonatomic, nullable) ButtonType preferredButton;
@property (assign, nonatomic) NSTimeInterval timeout;

@property (assign, nonatomic, readonly, getter=isBeingDismissed) BOOL beingDismissed;
@property (assign, nonatomic, readonly, getter=isBeingPresented) BOOL beingPresented;
@property (assign, nonatomic, readonly, getter=isVisible) BOOL visible;

// =================================================================================================
// MARK: Methods - Dismissal
// =================================================================================================

- (BOOL)dismiss;
- (BOOL)dismissWithClosure:(JFClosure* _Nullable)closure;
- (BOOL)dismissWithTappedButton:(ButtonType _Nullable)button;
- (BOOL)dismissWithTappedButton:(ButtonType _Nullable)button closure:(JFClosure* _Nullable)closure;

// =================================================================================================
// MARK: Methods - Observers
// =================================================================================================

- (void)addObserver:(ObserverType)observer;
- (void)removeObserver:(ObserverType)observer;

// =================================================================================================
// MARK: Methods - Presentation
// =================================================================================================

#if JF_IOS
- (BOOL)presentFromViewController:(UIViewController*)presenter;
- (BOOL)presentFromViewController:(UIViewController*)presenter closure:(JFClosure* _Nullable)closure;
#else
- (BOOL)present;
- (BOOL)presentWithClosure:(JFClosure* _Nullable)closure;
#endif

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
