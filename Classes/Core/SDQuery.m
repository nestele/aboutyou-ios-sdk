//
//  SDQuery.m
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

#import "SDQuery.h"
#import "SDProductVariant.h"
#import "SDShopManager.h"
#import "SDErrors.h"
#import "SDResult.h"

@interface SDQuery()


@end

@implementation SDQuery

- (NSMutableDictionary *)body
{
    
    if (!_body){
        
        _body = [NSMutableDictionary dictionary];
        
    }
    
    return _body;
    
}

- (void)setLimit:(NSInteger)limit
{
    
    NSAssert(limit >= 0, @"Query->result->limit must be equal or greater 0");
    self.body[@"result"][@"limit"] = [NSNumber numberWithInteger:limit];
    
}

- (void)setOffset:(NSInteger)offset
{
    
    NSAssert(offset >= 0, @"Query->result->offset must be equal or greater 0");
    self.body[@"result"][@"offset"] = [NSNumber numberWithInteger:offset];
    
}

- (void)addProductIds:(NSArray *)productIds
{
    
    NSMutableArray *bodyProductIds = self.body[@"ids"];
    [bodyProductIds addObjectsFromArray:productIds];
    
}

- (void)addFields:(NSArray *)fields
{
    
    NSMutableArray *bodyFields = self.body[@"fields"];
    [bodyFields addObjectsFromArray:fields];
    
}

- (void)addFilters:(NSDictionary *)filters
{
    
    NSMutableDictionary *bodyFilters = self.body[@"filter"];
    [bodyFilters setValuesForKeysWithDictionary:filters];
    
}

- (NSString *)addOrderLineForVariantId:(NSNumber *)variantId
{
    if (!self.body[@"order_lines"]) self.body[@"order_lines"] = [NSMutableArray array];
    
    NSString *itemId = [[NSUUID UUID] UUIDString];
    
    NSDictionary *basketItem = @{
                                 @"id" : itemId,
                                 @"variant_id" : variantId
                                 };
    
    NSMutableArray *orderLines = self.body[@"order_lines"];
    [orderLines addObject:basketItem];
    
    return itemId;
}

- (void)updateOrderLineForItemId:(NSString *)itemId withVariantId:(NSNumber *)variantId
{
    
    if (!self.body[@"order_lines"]) self.body[@"order_lines"] = [NSMutableArray array];
    
    NSDictionary *basketItem = @{
                                 @"id" : itemId,
                                 @"variant_id" : variantId
                                 };
    
    NSMutableArray *orderLines = self.body[@"order_lines"];
    [orderLines addObject:basketItem];
    
}

- (void)removeOrderLineForItemId:(NSString *)itemId
{
    if (!self.body[@"order_lines"]) self.body[@"order_lines"] = [NSMutableArray array];
    
    NSDictionary *basketItem = @{
                                 @"delete" : itemId
                                 };
    
    NSMutableArray *orderLines = self.body[@"order_lines"];
    [orderLines addObject:basketItem];
    
}

- (void)setSearchWord:(NSString *)searchWord
{
    
    self.body[@"searchword"] = searchWord;
    
}

- (void)addTypes:(NSArray *)types
{
    
    NSMutableArray *bodyFilters = self.body[@"types"];
    [bodyFilters addObjectsFromArray:types];
    
}

- (void)performInBackground:(void (^)(SDResult *result, NSError *error))completion
{
 
    NSError *validationError = [self validate];
    
    if (validationError){
        
        // return error directly
        if (completion) completion(nil, validationError);
        
    } else {
        
        // perform call
        NSDictionary *dict = @{@"method" : @"POST",
                               @"path" : @"",
                               @"body" : self.container};
        
        
        [[SDShopManager sharedManager] performQuery:dict onCompletion:^(SDResult *result, NSError *error) {
            
            NSError *queryError;
            NSArray *apiErrors = [result apiErrors];
            if (apiErrors){
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey: NSLocalizedString(@"API error occured", nil),
                                           NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The server returned one or more errors", nil),
                                           NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Check the apiErrors of the result for more information", nil)
                                           };
                
                queryError = [NSError errorWithDomain:SDShopSDKErrorDomain
                                                 code:SDQueryBadResponseError
                                             userInfo:userInfo];
            } else {
                
                queryError = error;
                
            }
            
            if (completion) completion(result, queryError);
            
        }];
        
    }
    
}

+ (void)performDryWithFixture:(NSString *)fileName onCompletion:(void (^)(SDResult *, NSError *))completion
{
    // perform 'dry' query
    NSDictionary *dict = @{@"dry" : fileName};
    
    [[SDShopManager sharedManager] performQuery:dict onCompletion:^(SDResult *result, NSError *error) {
        
        NSError *queryError;
        NSArray *apiErrors = [result apiErrors];
        if (apiErrors){
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"API error occured", nil),
                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The server returned one or more errors", nil),
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Check the apiErrors of the result for more information", nil)
                                       };
            
            queryError = [NSError errorWithDomain:SDShopSDKErrorDomain
                                             code:SDQueryBadResponseError
                                         userInfo:userInfo];
        } else {
            
            queryError = error;
            
        }
        
        if (completion) completion(result, queryError);
        
    }];
    
}

#pragma mark SDFacet

- (void)addFacetGroups:(NSArray *)facetGroups
{
    
    NSMutableArray *bodyGroupIds = self.body[@"group_ids"];
    [bodyGroupIds addObjectsFromArray:facetGroups];
    
}

#pragma mark SDCategory

- (void)addCategoryIds:(NSArray *)categoryIds
{
    
    NSMutableArray *bodyCategoryIds = self.body[@"ids"];
    [bodyCategoryIds addObjectsFromArray:categoryIds];
    
}

#pragma mark validation

- (NSError *)validate{
    
    // check, if container was defined
    if (!self.container){
        
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Query validation failed", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Query is empty", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"You must add properties to the query", nil)
                                   };
        
        return [NSError errorWithDomain:SDShopSDKErrorDomain
                                   code:SDQueryInvalidStructureError
                               userInfo:userInfo];
        
    }
    
    // validation succeeded
    return nil;
    
}

@end
