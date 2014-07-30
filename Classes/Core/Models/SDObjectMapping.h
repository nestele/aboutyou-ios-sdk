//
//  SDObjectMapping.h
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
#import "RKObjectMapping.h"

/**
 *  A protocol that defines compliance for `SDObject` Subclasses to support mapping from the AboutYou API object representations.
 */
@protocol SDObjectMapping <NSObject>

/**
 *  Returns attribute- and relationship mapping information to be used by `SDShopManager`
 *
 *  @return An `RKObjectMapping` object
 */
+ (RKObjectMapping *)objectMapping;

@optional

/**
 *  Keys that will map directly to the resource object.
 *
 *  @return An `NSArray` with key string
 */
+ (NSArray *)classAttributeMappingsArray;

/**
 *  Key-Value-Pairs that describe the mapping from resource object to our models.
 *
 *  @return An `NSDictionary`
 */
+ (NSDictionary *)classAttributeMappingsDictionary;

@end
