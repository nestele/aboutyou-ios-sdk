//
//  SDFacet.m
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

#import "SDFacet.h"
#import "SDQuery.h"
#import "SDShopManager.h"

@implementation SDFacet

static RKObjectMapping *_objectMapping;
static NSMutableSet *_cachedFacets;

+ (void)initialize
{
    _cachedFacets = [NSMutableSet set];
}

#pragma mark mapping

+ (RKObjectMapping *)objectMapping
{
    
    if (!_objectMapping){
        
        _objectMapping = [RKObjectMapping mappingForClass:[self class]];
        [_objectMapping addAttributeMappingsFromArray:[self classAttributeMappingsArray]];
        [_objectMapping addAttributeMappingsFromDictionary:[self classAttributeMappingsDictionary]];
        
    }
    return _objectMapping;
}

+ (NSArray *)classAttributeMappingsArray
{
    
    return @[
             @"name",
             @"value"
             ];
    
}

+ (NSDictionary *)classAttributeMappingsDictionary
{
    
    return @{
             @"id" : @"groupId",
             @"facet_id" : @"facetId",
             @"group_name" : @"groupName"
             };
    
}

#pragma mark Query creation

+ (SDQuery *)query
{
    
    SDQuery *q = [[SDQuery alloc] init];
    q.body[@"group_ids"] = [NSMutableArray array];
    q.container = [NSArray arrayWithObject:@{@"facets" : q.body}];
    return q;
    
}

#pragma mark caching

+ (void)cacheFacets:(NSArray *)facets
{
    
    NSAssert(facets != nil, @"Facets array must not be nil.");
    
    [_cachedFacets addObjectsFromArray:facets];
    
}

+ (SDFacet *)cachedFacetForId:(NSNumber *)facetId andGroupId:(SDFacetGroup)groupId
{
    
    SDFacet *substituteFacet = [[SDFacet alloc] init];
    substituteFacet.facetId = facetId;
    substituteFacet.groupId = @(groupId);
    
    if ([_cachedFacets containsObject:substituteFacet]){
        
        NSArray *cacheArray = _cachedFacets.allObjects;
        NSUInteger cachedFacetId = [cacheArray indexOfObject:substituteFacet];
        return cacheArray[cachedFacetId];
        
    } else {
        
        return nil;
        
    }
    
}

+ (NSSet *)cachedFacetsForGroupId:(SDFacetGroup)groupId{
    
    NSPredicate *groupIdPredicate = [NSPredicate predicateWithFormat:@"groupId == %d", groupId];
    NSSet *facets = [_cachedFacets filteredSetUsingPredicate:groupIdPredicate];
    
    return facets;
    
}

+ (SDFacet *)findFirstFacetWithGroupId:(SDFacetGroup)groupId inArray:(NSArray *)facets
{
    
    for (SDFacet *facet in facets){
        if (facet.groupId.integerValue == groupId) return facet;
    }
    
    return nil;
    
}

- (void)mergeCachedAttributes
{
    
    SDFacet *cachedFacet = [SDFacet cachedFacetForId:self.facetId andGroupId:self.groupId.integerValue];
    
    if (cachedFacet){
        
        self.name = cachedFacet.name;
        self.value = cachedFacet.value;
        self.groupName = cachedFacet.groupName;
        
    }
    
}

#pragma mark comparison

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[SDFacet class]] || ![self isKindOfClass:[SDFacet class]]){
        return false;
    } else {
        NSNumber *selfFacetId = self.facetId;
        NSNumber *otherFacetId = ((SDFacet*)object).facetId;
        
        NSNumber *selfGroupId = self.groupId;
        NSNumber *otherGroupId = ((SDFacet*)object).groupId;
        
        if (selfFacetId == nil || otherFacetId == nil || selfGroupId == nil || otherGroupId == nil){
            return false;
        } else {
            return [selfFacetId isEqualToNumber:otherFacetId] && [selfGroupId isEqualToNumber:otherGroupId];
        }
    }
}

- (NSUInteger)hash
{
    return [self.facetId hash] ^ [self.groupId hash];
}

@end
