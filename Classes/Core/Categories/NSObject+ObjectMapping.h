//
//  NSObject+ObjectMapping.h
//
//  Copyright (c) 2014 Slice-Dice GmbH (http://slice-dice.de/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

/**
 *
 */
@interface NSObject (ObjectMapping)

/**
 * Sometimes we need to map the response from a dictioniary {rootKey: {...}},
 * so a mapping has to be applied which takes this into account.
 *
 * @param rootKey The key in a response, whose value is the dictionary that
 * should be mapped. If rootKey is nil, then the default mapping is returned.
 */
+ (RKObjectMapping *)objectMappingForRootKey:(NSString *)rootKey;


/**
 * Return the given key in a nested rootKey representation "(rootKey).key"
 *
 * @param key The key that should be nested
 * @param rootKey The nesting key
 */
+ (NSString *)key:(NSString *)key nestedInKey:(NSString *)rootKey;

@end
