//
//  SDResult.h
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

@class SDBasket, SDProductSearch, SDOrderInit, SDAutoCompletion, SDSuggest;

/**
 *  SDResult
 */
@interface SDResult : NSObject

/**
 *  Holds an array of `SDCategory` objects.
 */
@property (nonatomic, strong) NSArray *categoryTree;

/**
 *  Holds an array of `SDFacet` objects.
 */
@property (nonatomic, strong) NSArray *facets;

/**
 *  Holds an array of `SDProduct` objects.
 */
@property (nonatomic, strong) NSArray *products;

/**
 *  Holds an `SDProductSearch` object.
 */
@property (nonatomic, strong) SDProductSearch *productSearch;

/**
 *  Holds the `SDBasket` object.
 */
@property (nonatomic, strong) SDBasket *basket;

/**
 *  Holds the `SDOrderInit` object.
 */
@property (nonatomic, strong) SDOrderInit *orderInit;

/**
 *  Holds the `SDAutoCompletion` object.
 */
@property (nonatomic, strong) SDAutoCompletion *autoCompletion;

/**
 *  Holds the `SDSuggest` object.
 */
@property (nonatomic, strong) SDSuggest *suggest;

/**
 *  All Errors, returned by the API.
 *
 *  @return An `NSArray` with `NSError` objects
 */
- (NSArray *)apiErrors;

@end
