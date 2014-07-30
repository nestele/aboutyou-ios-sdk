//
//  SDProduct.h
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
#import "SDObject.h"

@class SDImage, SDProductVariant, SDFacet, SDQuery;

/**
 *  
 */
@interface SDProduct : SDObject<SDObjectMapping>

/**
 *  The identifier for the product.
 */
@property (nonatomic, strong) NSNumber *productId;

/**
 *  Basically the same as `productId`.
 *
 *  Under the current mapping circumstances this property is necessary to cover different sets of mappings. Because it is a workaround, it is marked as deprecated.
 */
@property (nonatomic, strong) NSNumber *hotfixProductId __deprecated;

/**
 *  The name of the product.
 */
@property (nonatomic, strong) NSString *name;

/**
 *  A long description of the product.
 */
@property (nonatomic, strong) NSString *longDescription;

/**
 *  A short description of the product.
 */
@property (nonatomic, strong) NSString *shortDescription;

/**
 *  The minimum price of all variants (in eurocents).
 */
@property (nonatomic, strong) NSNumber *minPrice;

/**
 *  The maximum price of all variants (in eurocents).
 */
@property (nonatomic, strong) NSNumber *maxPrice;

/**
 *  The product is on sale (an old price exists).
 */
@property (nonatomic, strong) NSNumber *sale;

/**
 *  The default/main image of the product.
 */
@property (nonatomic, strong) SDImage *defaultImage;

/**
 *  The default `SDProductVariant` object for the product.
 *
 *  The original 'default_variant' of the API product representation is overriden to always return a variant, even if no default is defined.
 */
@property (nonatomic, strong) SDProductVariant *defaultVariant;

/**
 *  Indicates, whether the product is an active member of the category tree within your AboutYou app.
 */
@property (nonatomic) BOOL active;

/**
 *  An array of `SDProductVariant` objects, that belong to the product.
 */
@property (nonatomic, strong) NSArray *variants;

/**
 *  An array of `SDProduct` objects, which represent different styles of the product.
 *
 *  The styles for a product are given in the form {product1.styles:[product2,product3]} so the default style is excluded from the array
 *
 *  The receiver object is always included.
 */
@property (nonatomic, strong) NSArray *styles;

/**
 *  Constructs a query for 'products' API operation.
 *
 *  @return An `SDQuery` object
 */
+ (SDQuery *)queryForGet;

/**
 *  Constructs a query for 'product_search' API operations.
 *
 *  @return An `SDQuery` object
 */
+ (SDQuery *)queryForSearch;

/**
 *  The colors of a given product are represented by the `SDFacet` objects found in "styles.variants.attributes.colorGroupId".
 */
- (NSSet *)availableColorFacets;

/**
 *  The sizes of a given style are represented by the `SDFacet` objects found in "variants.attributes.sizeGroupId".
 *
 */
- (NSSet *)availableSizeFacets;

/**
 *  The brand of the product.
 *
 *  @return An `SDFacet` object
 */
- (SDFacet *)brandFacet;

/**
 *  Returns the first `SDProductVariant` under the receiver and all its styles, matching all of the desired facets.
 *
 *  @param facets An array of `SDFacet` objects
 *
 *  @return An `SDProductVariant` object
 */
- (SDProductVariant *)variantWithMatchingFacets:(NSArray *)facets;

/**
 *  Returns the `SDProductVariant` with matching `variantId`.
 *
 *  All variants under the product and its styles are being searched.
 *
 *  @param variantId The identifier for the desired `SDProductVariant` object
 *
 *  @return The `SDProductVariant` object.
 */
- (SDProductVariant *)variantWithId:(NSNumber *)variantId;


+ (RKObjectMapping *)flatObjectMapping;

@end
