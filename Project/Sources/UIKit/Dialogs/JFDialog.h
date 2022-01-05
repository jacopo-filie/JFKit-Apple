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

@class JFDialog;

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_BEGIN

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@interface JFDialogButton : NSObject

@property (copy, nonatomic, readonly) NSString* title;

+ (instancetype)new NS_UNAVAILABLE;
+ (instancetype)newWithTitle:(NSString*)title;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTitle:(NSString*)title;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@protocol JFDialogObserver <NSObject>

@optional

- (void)dialog:(__kindof JFDialog*)sender didDismissWithButton:(__kindof JFDialogButton* _Nullable)button;
- (void)dialog:(__kindof JFDialog*)sender willDismissWithButton:(__kindof JFDialogButton* _Nullable)button;
- (void)dialogDidPresent:(__kindof JFDialog*)sender;
- (void)dialogWillPresent:(__kindof JFDialog*)sender;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// MARK: -

@interface JFDialog<__covariant ButtonType : JFDialogButton*, __covariant ObserverType : id<JFDialogObserver>> : NSObject

@property (strong, nonatomic, nullable) ButtonType cancelButton;
@property (copy, nonatomic, nullable) NSArray<ButtonType>* otherButtons;
@property (strong, nonatomic, nullable) ButtonType preferredButton;
@property (copy, nonatomic, nullable) NSString* title;
@property (assign, nonatomic, readonly, getter=isVisible) BOOL visible;

- (void)addObserver:(ObserverType)observer;
- (void)removeObserver:(ObserverType)observer;

@end

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

NS_ASSUME_NONNULL_END

// –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
