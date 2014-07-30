//
//  SDProduct.m
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

#import "SDProduct.h"
#import "RKRelationshipMapping.h"
#import "SDProductVariant.h"
#import "SDImage.h"
#import "NSObject+ObjectMapping.h"
#import "SDFacet.h"
#import "SDQuery.h"
#import "SDShopManager.h"

@implementation SDProduct

static NSDictionary *_objectMappings;

/**
 *
 * Creates the objectMapping and establishes relationships with an
 * optional rootKey
 *
 * @param rootKey A key that embeds the product object in a JSON response
 *
 */
+ (RKObjectMapping *)createMappingForRootKey:(NSString *)rootKey
{
    
    RKObjectMapping *mapping = [self objectMappingForRootKey:rootKey];
    
    // SDProduct variants
    [mapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:[self key:@"variants" nestedInKey:rootKey]
                                                 toKeyPath:@"variants"
                                               withMapping:[SDProductVariant objectMapping]]];
    // SDProduct default variant
    [mapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:[self key:@"default_variant" nestedInKey:rootKey]
                                                 toKeyPath:@"defaultVariant"
                                               withMapping:[SDProductVariant objectMapping]]];
    // SDProduct default image
    [mapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:[self key:@"default_image" nestedInKey:rootKey]
                                                 toKeyPath:@"defaultImage"
                                               withMapping:[SDImage objectMapping]]];
    
    return mapping;
    
}

/**
 *
 * Lazy construction of product mappings
 *
 */
+ (RKObjectMapping *)objectMapping
{
    if (!_objectMappings){
        
        NSMutableDictionary *objectMappings = [NSMutableDictionary dictionary];
        
        // setup for root-key-objects
        NSString *rootKey = @"productId";
        
        // create default mapping and mapping for nested objects with rootKey
        RKObjectMapping *defaultMapping = [self createMappingForRootKey:nil];
        RKObjectMapping *rootKeyMapping = [self createMappingForRootKey:rootKey];
        
        // styles is an array of products, always with default mapping
        [defaultMapping addPropertyMapping:
         [RKRelationshipMapping relationshipMappingFromKeyPath:[self key:@"styles" nestedInKey:nil]
                                                     toKeyPath:@"styles"
                                                   withMapping:defaultMapping]];
        [rootKeyMapping addPropertyMapping:
         [RKRelationshipMapping relationshipMappingFromKeyPath:[self key:@"styles" nestedInKey:rootKey]
                                                     toKeyPath:@"styles"
                                                   withMapping:defaultMapping]];
        
        
        objectMappings[@"default"] = defaultMapping;
        objectMappings[rootKey] = rootKeyMapping;
        
        _objectMappings = objectMappings;
    }
    
    return _objectMappings[@"productId"];
    
}

+ (RKObjectMapping *)flatObjectMapping
{
    
    // quick + dirty
    
    // lazily load mappings
    [self objectMapping];
    
    return _objectMappings[@"default"];
    
}

+ (NSArray *)classAttributeMappingsArray
{
    
    return @[
             @"name",
             @"sale",
             @"active"
             ];
    
}

+ (NSDictionary *)classAttributeMappingsDictionary
{
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes addEntriesFromDictionary:[super classAttributeMappingsDictionary]];
    [attributes addEntriesFromDictionary:@{
                                           @"description_long" : @"longDescription",
                                           @"description_short" : @"shortDescription",
                                           @"min_price" : @"minPrice",
                                           @"max_price" : @"maxPrice",
                                           @"id"        : @"hotfixProductId"
                                           }];
    
    return attributes;
    
}

# pragma mark Query construction

+ (SDQuery *)queryForGet
{
    SDQuery *q = [[SDQuery alloc] init];
    q.body[@"ids"] = [NSMutableArray array];
    q.body[@"fields"] = [NSMutableArray array];
    q.container = [NSArray arrayWithObject:@{@"products" : q.body}];
    return q;
}

+ (SDQuery *)queryForSearch
{
    SDQuery *q = [[SDQuery alloc] init];
    q.body[@"result"] = [NSMutableDictionary dictionary];
    q.body[@"filter"] = [NSMutableDictionary dictionary];
    q.body[@"session_id"] = [SDShopManager sessionId];
    q.container = [NSArray arrayWithObject:@{@"product_search" : q.body}];
    return q;
}

- (NSArray *)styles
{
    
    NSMutableArray *styles = [NSMutableArray array];
    [styles addObject:self];
    [styles addObjectsFromArray:_styles];
    return styles;
    
}

- (NSSet *)availableColorFacets
{
    
    // get all the variants of the product's associated styles
    NSArray *allVariants = [self.styles valueForKeyPath:@"@unionOfArrays.variants"];
    
    // get all the attributes of the product's variants
    NSSet *allVariantAttributes = [NSSet setWithArray:[allVariants valueForKeyPath:@"@unionOfArrays.attributes"]];
    
    // create keypath to desired attributes
    //NSString *groupKeypath = [NSString stringWithFormat:@"@distinctUnionOfArrays.attributes_%d", kSDFacetGroupColor];
    
    // get desired attributeIds
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupId == %d", kSDFacetGroupColor];
    NSSet *groupAttributeIds = [allVariantAttributes filteredSetUsingPredicate:predicate];
    
    return groupAttributeIds;
    
}

- (NSSet *)availableSizeFacets
{
    // get all the attributes of the product's variants
    NSSet *allVariantAttributes = [NSSet setWithArray:[self.variants valueForKeyPath:@"@unionOfArrays.attributes"]];
    
    // create keypath to desired attributes
    //NSString *groupKeypath = [NSString stringWithFormat:@"@unionOfArrays.attributes_%d", kSDFacetGroupSize];
    
    // get desired attributeIds
    //NSArray *groupAttributeIds = [allVariantAttributes valueForKeyPath:groupKeypath];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupId == %d", kSDFacetGroupSize];
    NSSet *groupAttributeIds = [allVariantAttributes filteredSetUsingPredicate:predicate];
    
    return groupAttributeIds;
    
}

- (SDProductVariant *)defaultVariant
{
    
    if (!_defaultVariant){
        
        //NSLog(@"No default variant specified for product %@ (%@)", self.name, self.productId);
        return self.variants.firstObject;
        
    } else {
        return _defaultVariant;
    }
    
}

- (SDFacet *)brandFacet
{
    // get all the attributes of the product's variants
    NSArray *allVariantAttributes = [self.variants valueForKeyPath:@"@distinctUnionOfArrays.attributes"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupId == %d", kSDFacetGroupBrand];
    NSArray *groupAttributeIds = [allVariantAttributes filteredArrayUsingPredicate:predicate];
    
    return groupAttributeIds.firstObject;
    
    
}

- (SDProductVariant *)variantWithMatchingFacets:(NSArray *)facets
{
    
    NSArray *allVariants = [self.styles valueForKeyPath:@"@unionOfArrays.variants"];
    
    for (SDProductVariant *variant in allVariants){
        
        if ([variant hasFacets:facets]) return variant;
        
    }
    
    return nil;
    
}

- (SDProductVariant *)variantWithId:(NSNumber *)variantId
{
    
    NSArray *allVariants = [self.styles valueForKeyPath:@"@unionOfArrays.variants"];
    
    for (SDProductVariant *variant in allVariants){
        
        if ([variant.variantId isEqualToNumber:variantId]) return variant;
        
    }
    
    return nil;
    
}

@end
