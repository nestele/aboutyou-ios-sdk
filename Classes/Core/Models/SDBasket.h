//
//  SDBasket.h
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
#import "SDObject.h"

@class SDProduct, SDOrderLine, SDProductVariant, SDQuery;

/**
 *  
 */
@interface SDBasket : SDObject

/**
 *  The total price for all items in the basket
 */
@property (nonatomic, strong) NSNumber *totalPrice;

/**
 *  The net price for all items in the basket
 */
@property (nonatomic, strong) NSNumber *totalNet;

/**
 *  The total Vat for all items in the basket
 */
@property (nonatomic, strong) NSNumber *totalVat;

/**
 *
 */
@property (nonatomic, strong) NSArray *products;

/**
 *  All items that are currently in the basket
 */
@property (nonatomic, strong) NSArray *orderLines;

/**
 *  Creates a query for basket operations.
 *
 *  @return An `SDQuery` object
 */
+ (SDQuery *)query;

/**
 *  Looks for a certain product in the basket.
 *
 *  @param productId The `productId` to look for
 *
 *  @return An `SDProduct` object
 */
- (SDProduct *)productForProductId:(NSNumber *)productId;

@end
