//
//  SDProductVariant.m
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

#import <Restkit/RestKit.h>
#import "SDProductVariant.h"
#import "SDImage.h"
#import "SDFacet.h"

@implementation SDProductVariant

static RKObjectMapping *_objectMapping;

+ (RKObjectMapping *)objectMapping
{
    
    if (!_objectMapping){
        
        _objectMapping = [RKObjectMapping mappingForClass:[self class]];
        [_objectMapping addAttributeMappingsFromArray:[self classAttributeMappingsArray]];
        [_objectMapping addAttributeMappingsFromDictionary:[self classAttributeMappingsDictionary]];
        
        // SDProductVariant images
        [_objectMapping addPropertyMapping:
         [RKRelationshipMapping relationshipMappingFromKeyPath:@"images"
                                                     toKeyPath:@"images"
                                                   withMapping:[SDImage objectMapping]]];
        
        // Would like to map attributes automatically but can't. See workaround below.
        /*
         // SDProductVariant attributes
         [_objectMapping addPropertyMapping:
         [RKRelationshipMapping relationshipMappingFromKeyPath:@"attributes"
         toKeyPath:@"attributes"
         withMapping:[SDFacet objectMapping]]];
         */
        
    }
    return _objectMapping;
}

+ (NSArray *)classAttributeMappingsArray
{
    
    return @[
             @"ean",
             @"price",
             @"oldPrice",
             @"retailPrice",
             @"quantity",
             @"attributes"
             ];
    
}

+ (NSDictionary *)classAttributeMappingsDictionary
{
    
    return @{
             @"id" : @"variantId",
             @"default" : @"isDefault"
             };
    
}

/**
 *
 * Overrides the attributes setter because the response JSON is such a mess
 * that there is no way to find a clean mapping solution!!
 * No need to call this manually. Called by RestKit.
 *
 * @param attributes The JSON attributes array like it is in the response
 *
 */
- (void)setAttributes:(NSArray *)attributes
{
    
    NSMutableArray *attr = [NSMutableArray array];
    
    NSDictionary *dict = attributes.firstObject;
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    
    for (NSString *key in dict){
        
        NSString *stringToken = [key stringByReplacingOccurrencesOfString:@"attributes_" withString:@""];
        NSNumber *groupId = [nf numberFromString:stringToken];
        id test = dict[key][0];
        NSNumber *facetId = test;
        
        if (groupId && facetId){
            
            // the JSON only contains groupId and facetId
            SDFacet *facet = [[SDFacet alloc] init];
            facet.groupId = groupId;
            facet.facetId = facetId;
            
            // merge more attributes if facet is in cache
            [facet mergeCachedAttributes];
            
            [attr addObject:facet];
        }
        
    }
    
    _attributes = attr;
    
}

- (BOOL)hasFacets:(NSArray *)facets
{
    
    NSAssert(facets.count > 0, @"Empty facet array not allowed in facet check");
    for (SDFacet *facet in facets){
        
        if (![self.attributes containsObject:facet]){
            
            return NO;
            
        }
    }
    
    return YES;
    
}

@end
