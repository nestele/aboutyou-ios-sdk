//
//  SDFacet.h
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

@class SDQuery;

/**
 *  An enum that holds the facet group ids.
 */
typedef NS_ENUM(NSInteger, SDFacetGroup) {
    
    /**
     *  Brand
     */
    kSDFacetGroupBrand      = 0,
    
    /**
     *  Color
     */
    kSDFacetGroupColor      = 1,
    
    /**
     *  Size
     */
    kSDFacetGroupSize       = 2,
    
    /**
     *  Gender / Age
     */
    kSDFacetGroupGenderAge  = 3,
    
    /**
     *  Bra Cupsize
     */
    kSDFacetGroupCupSize    = 4,
    
    /**
     *  Length
     */
    kSDFacetGroupLength     = 5,
    
    /**
     *  Third Dimension
     */
    kSDFacetGroupDimension3 = 6
};

/**
 *  
 */
@interface SDFacet : SDObject<SDObjectMapping>

/**
 *  The identifier for the facet.
 */
@property (nonatomic, strong) NSNumber *facetId;

/**
 *  The identifier for the facet group.
 */
@property (nonatomic, strong) NSNumber *groupId;

/**
 *  The name of the facet.
 */
@property (nonatomic, strong) NSString *name;

/**
 *  The name of the facet group.
 */
@property (nonatomic, strong) NSString *groupName;

/**
 *  The facet value, represented as `NSString`.
 */
@property (nonatomic, strong) NSString *value;

/**
 *  Creates a query for facet operations.
 *
 *  @return An `SDQuery` object
 */
+ (SDQuery *)query;

/**
 * Cache facets for fast lookup.
 *
 * The facets are cached in memory, so there is no persistence at this time.
 *
 * @param facets An array with facets
 */
+ (void)cacheFacets:(NSArray *)facets;


/**
 *  Obtains a cached facet by its `facetId` and `groupId`.
 *
 *  @param facetId The id of the facet
 *  @param groupId The id of the facet group
 *
 *  @return An `SDFacet` object.
 */
+ (SDFacet *)cachedFacetForId:(NSNumber *)facetId andGroupId:(SDFacetGroup)groupId;


/**
 *  Obtains all cached facets that belong to a certain `groupId`.
 *
 *  @param groudId The `SDFacetGroup`
 *
 *  @return An `NSSet`that holds
 */
+ (NSSet *)cachedFacetsForGroupId:(SDFacetGroup)groupId;


/**
 *  Return the very first `SDFacet` in given array for `SDFacetGroup`.
 *
 *  @param groupId The `SDFacetGroup` for the facet that should be returned
 *  @param facets An `NSArray` of `SDFacet` objects to be searched
 *
 *  @return The first matching `SDFacet`
 */
+ (SDFacet *)findFirstFacetWithGroupId:(SDFacetGroup)groupId inArray:(NSArray *)facets;


/**
 *  Looks up the `SDFacet` in cache and merges attributes into receiver.
 */
- (void)mergeCachedAttributes;

@end
