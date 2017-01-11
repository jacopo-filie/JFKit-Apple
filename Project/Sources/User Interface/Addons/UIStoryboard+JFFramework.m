//
//	The MIT License (MIT)
//
//	Copyright © 2016-2017 Jacopo Filié
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



#import "UIStoryboard+JFFramework.h"

#import <objc/runtime.h>

#import "JFTypes.h"
#import "JRSwizzle.h"



@interface UIStoryboard (JFFramework_Private)

#pragma mark Methods

// User interface management
- (__kindof UIViewController*)	jf_swizzled_instantiateInitialViewController;
- (__kindof UIViewController*)	jf_swizzled_instantiateViewControllerWithIdentifier:(NSString*)identifier;

@end



#pragma mark



@interface UIStoryboardSegue (JFFramework_Private)

#pragma mark Methods

// User interface management
- (void)	jf_swizzled_perform;

@end



#pragma mark



@implementation UIStoryboard (JFFramework)

#pragma mark Properties accessors (Relationships)

- (NSMutableSet<id<JFStoryboardObserver>>*)jf_observers
{
	NSMutableSet<id<JFStoryboardObserver>>* retObj = objc_getAssociatedObject(self, _cmd);
	if(!retObj)
	{
		retObj = [NSMutableSet<id<JFStoryboardObserver>> new];
		objc_setAssociatedObject(self, _cmd, retObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return retObj;
}


#pragma mark Memory management

+ (void)load
{
	static dispatch_once_t onceToken = 0;
	dispatch_once(&onceToken, ^{
		
		// Prepares the swizzling block.
		void (^swizzleMethod)(SEL, SEL) = ^(SEL original, SEL swizzled)
		{
			NSError* error;
			[[self class] jr_swizzleMethod:original withMethod:swizzled error:&error];
			NSAssert(!error, @"Failed to swizzle '%@' for error '%@'.", NSStringFromSelector(original), error);
		};
		
		// Swizzle the user interface methods.
		swizzleMethod(@selector(instantiateInitialViewController), @selector(jf_swizzled_instantiateInitialViewController));
		swizzleMethod(@selector(instantiateViewControllerWithIdentifier:), @selector(jf_swizzled_instantiateViewControllerWithIdentifier:));
	});
}


#pragma mark User interface management

- (__kindof UIViewController*)jf_swizzled_instantiateInitialViewController
{
	// Performs the original implementation.
	id retObj = [self jf_swizzled_instantiateInitialViewController];
	
	// Notifies the observers.
	for(id<JFStoryboardObserver> observer in self.jf_observers)
	{
		if([observer respondsToSelector:@selector(jf_storyboard:didInstantiateInitialViewController:)])
			[observer jf_storyboard:self didInstantiateInitialViewController:retObj];
	}
	
	// Returs the result.
	return retObj;
}

- (__kindof UIViewController*)jf_swizzled_instantiateViewControllerWithIdentifier:(NSString*)identifier
{
	// Performs the original implementation.
	id retObj = [self jf_swizzled_instantiateViewControllerWithIdentifier:identifier];
	
	// Notifies the observers.
	for(id<JFStoryboardObserver> observer in self.jf_observers)
	{
		if([observer respondsToSelector:@selector(jf_storyboard:didInstantiateViewController:withIdentifier:)])
			[observer jf_storyboard:self didInstantiateViewController:retObj withIdentifier:identifier];
	}
	
	// Returs the result.
	return retObj;
}

@end



#pragma mark



@implementation UIStoryboardSegue (JFFramework)

#pragma mark Memory management

+ (void)load
{
	static dispatch_once_t onceToken = 0;
	dispatch_once(&onceToken, ^{
		
		// Prepares the swizzling block.
		void (^swizzleMethod)(SEL, SEL) = ^(SEL original, SEL swizzled)
		{
			NSError* error;
			[[self class] jr_swizzleMethod:original withMethod:swizzled error:&error];
			NSAssert(!error, @"Failed to swizzle '%@' for error '%@'.", NSStringFromSelector(original), error);
		};
		
		// Swizzle the user interface methods.
		swizzleMethod(@selector(perform), @selector(jf_swizzled_perform));
	});
}


#pragma mark User interface management

- (void)jf_swizzled_perform
{
	// Prepares the storyboards.
	NSMutableSet<UIStoryboard*>* storyboards = [NSMutableSet<UIStoryboard*> set];
	UIStoryboard* storyboard = self.sourceViewController.storyboard;
	if(storyboard)
		[storyboards addObject:storyboard];
	storyboard = self.destinationViewController.storyboard;
	if(storyboard)
		[storyboards addObject:storyboard];
	
	// Notifies the storyboard observers.
	for(UIStoryboard* storyboard in storyboards)
	{
		for(id<JFStoryboardObserver> observer in storyboard.jf_observers)
		{
			if([observer respondsToSelector:@selector(jf_storyboard:willPerformSegue:)])
				[observer jf_storyboard:storyboard willPerformSegue:self];
		}
	}
	
	// Prepares the completion block.
	JFBlock completionBlock = ^(void)
	{
		// Notifies the storyboard observers.
		for(UIStoryboard* storyboard in storyboards)
		{
			for(id<JFStoryboardObserver> observer in storyboard.jf_observers)
			{
				if([observer respondsToSelector:@selector(jf_storyboard:didPerformSegue:)])
					[observer jf_storyboard:storyboard didPerformSegue:self];
			}
		}
	};
	
	// Performs the original implementation.
	[CATransaction begin];
	[CATransaction setCompletionBlock:completionBlock];
	[self jf_swizzled_perform];
	[CATransaction commit];
}

@end
