//
//  SDQuery.h
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

@class SDResult;

/**
 *  
 */
@interface SDQuery : NSObject

@property (nonatomic, strong) NSMutableDictionary *body;
@property (nonatomic, strong) NSArray *container;

/**
 *  Sets the response limit.
 *
 *  @param limit The limit
 */
- (void)setLimit:(NSInteger)limit;

/**
 *  Sets the response offset.
 *
 *  @param offset The offset
 */
- (void)setOffset:(NSInteger)offset;

/**
 *  Executes the Query.
 *
 *  @param completion The completion handler
 */
- (void)performInBackground:(void (^)(SDResult *result, NSError *error))completion;

/**
 *  Executes a 'dry' Query for Testing.
 *
 *  @param fileName   The name of the fixture JSON file. Must be included in the Resource bundle.
 *  @param completion The completion handler
 */
+ (void)performDryWithFixture:(NSString *)fileName onCompletion:(void (^)(SDResult *result, NSError *error))completion;

#pragma mark SDFacet

/**
 *  Adds the `SDFacetGroups`. 
 *
 *  An array with `NSNumber` values is expected, not `NSInteger`.
 *
 *  @param facetGroupIds An `NSArray` with `NSNumber` values
 */
- (void)addFacetGroups:(NSArray *)facetGroups;

#pragma mark SDCategory

/**
 *  Adds the category ids.
 *
 *  @param categoryIds An `NSArray` with `NSNumber` values
 */
- (void)addCategoryIds:(NSArray *)categoryIds;

#pragma mark SDProduct

/**
 *  Adds the product ids.
 *
 *  @param productIds An `NSArray` with `NSNumber` values
 */
- (void)addProductIds:(NSArray *)productIds;

/**
 *  Adds fields.
 *
 *  @param fields An `NSArray` with `NSString` values
 */
- (void)addFields:(NSArray *)fields;

/**
 *  Adds filters.
 *
 *  @param filters An `NSDictionary`
 */
- (void)addFilters:(NSDictionary *)filters;

#pragma mark SDBasket

/**
 *  Adds orderlines to the basket and generates an id for the new item.
 *
 *  @param variantId The identifier for a product variant
 *
 *  @return The generated item id
 */
- (NSString *)addOrderLineForVariantId:(NSNumber *)variantId;

/**
 *  Changes the variant id for an existing item in the basket.
 *
 *  @param itemId    The item id
 *  @param variantId The desired variant id for the item
 */
- (void)updateOrderLineForItemId:(NSString *)itemId withVariantId:(NSNumber *)variantId;

/**
 *  Removes an item from the basket.
 *
 *  @param itemId The identifier for the item that should be removed
 */
- (void)removeOrderLineForItemId:(NSString *)itemId;

#pragma mark SDAutoCompletion

/**
 *  Sets the AutoCompletion search word.
 *
 *  @param searchWord The `NSString` to search for
 */
- (void)setSearchWord:(NSString *)searchWord;

/**
 *  Adds the types to search for.
 */
- (void)addTypes:(NSArray *)types;

@end
