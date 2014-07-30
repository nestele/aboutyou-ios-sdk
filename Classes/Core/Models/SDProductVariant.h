//
//  SDProductVariant.h
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
#import "SDObjectMapping.h"

/**
 *  
 */
@interface SDProductVariant : NSObject<SDObjectMapping>

/**
 *  The identifier for the variant.
 */
@property (nonatomic, strong) NSNumber *variantId;

/**
 *  The EAN code of the variant.
 */
@property (nonatomic, strong) NSString *ean;

/**
 *  Whether or not the variant is the default variant for its enclosing `SDProduct`.
 */
@property (nonatomic) BOOL isDefault;

/**
 *  Current price of the variant (in Eurocents).
 */
@property (nonatomic, strong) NSNumber *price;

/**
 *  The price before it was changed to the current price (in Eurocents).
 */
@property (nonatomic, strong) NSNumber *oldPrice;

/**
 *  The recommended price by the producer (in Eurocents).
 */
@property (nonatomic, strong) NSNumber *retailPrice;

/**
 *  An array of `SDImage` objects.
 */
@property (nonatomic, strong) NSArray *images;

/**
 *  An array of `SDFacet` objects.
 */
@property (nonatomic, strong) NSArray *attributes;

/**
 *  The available quantity in stock.
 */
@property (nonatomic, strong) NSNumber *quantity;


/**
 *  The identifier of a certain variant representing an `SDBasket` item.
 */
@property (nonatomic, strong) NSString *specialId;

/**
 *  Checks, if any of the given `SDFacet` objects match any facet of the variant.
 *
 *  @param facets An `NSArray` of `SDFacet` objects
 *
 *  @return Boolean, if at least one facet matches
 */
- (BOOL)hasFacets:(NSArray *)facets;

@end
