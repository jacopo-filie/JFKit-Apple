//
//	The MIT License (MIT)
//
//	Copyright © 2019 Jacopo Filié
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

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

/*
 * This class holds a list of IDs associated with the objects that you pass to it through the method `getID:`. The object is retained weakly and can become a dangling pointer if weak references are not supported by the running operating system: remember to clear the IDs of those objects before they are deallocated, in that case.
 */
@interface JFObjectIdentifier : NSObject

// =================================================================================================
// MARK: Properties - Memory
// =================================================================================================

/*
 * Returns the object identifier that uses the common registry.
 */
@property (class, strong, readonly) JFObjectIdentifier* sharedInstance;

// =================================================================================================
// MARK: Methods - Identifiers
// =================================================================================================

/*
 * Removes the given object from the common registry; if the object is not registered yet, it does nothing.
 * @param object The object to unregister.
 */
+ (void)clearID:(id<NSObject>)object;

/*
 * Returns the ID associated with the given object; if the object is not saved in the common registry yet, a new ID is associated with it and saved in the registry.
 * @param object The object whos ID is being requested.
 * @return The ID associated with the given object.
 * @warning On systems that does not support weak references, call the method `clearID:` passing the object that must be unregistered, prior to it being deallocated leaving the registry with a dangling pointer; you can also use the method `resetID:` passing the ID of the object to unregister.
 */
+ (NSUInteger)getID:(id<NSObject>)object;

/*
 * Removes the given object ID from the common registry; if no object with the given ID is registered yet, it does nothing.
 * @param objectID The ID of the object to unregister.
 */
+ (void)resetID:(NSUInteger)objectID;

/*
 * Removes the given object from the instance registry; if the object is not registered yet, it does nothing.
 * @param object The object to unregister.
 */
- (void)clearID:(id<NSObject>)object;

/*
 * Returns the ID associated with the given object; if the object is not saved in the instance registry yet, a new ID is associated with it and saved in the registry.
 * @param object The object whos ID is being requested.
 * @return The ID associated with the given object.
 * @warning On systems that does not support weak references, call the method `clearID:` passing the object that must be unregistered, prior to it being deallocated leaving the registry with a dangling pointer; you can also use the method `resetID:` passing the ID of the object to unregister.
 */
- (NSUInteger)getID:(id<NSObject>)object;

/*
 * Removes the given object ID from the instance registry; if no object with the given ID is registered yet, it does nothing.
 * @param objectID The ID of the object to unregister.
 */
- (void)resetID:(NSUInteger)objectID;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
