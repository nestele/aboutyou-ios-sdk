//
//  NSObject+ObjectMapping.m
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

#import "NSObject+ObjectMapping.h"
#import "SDObjectMapping.h"

@implementation NSObject (ObjectMapping)


/**
 * Transforms a given attributeMappingsDictionary in the form {key : value} to
 * the form {(prefix).key : value}
 *
 * @param prefix
 */
+ (NSDictionary *)classAttributeMappingsDictionaryWithPrefix:(NSString *)prefix
{
    
    NSDictionary *mapping = [(id<SDObjectMapping>)self classAttributeMappingsDictionary];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:mapping.count];
    
    for (NSString *key in mapping){
        
        NSString *transformedKey = [self key:key nestedInKey:prefix];
        dict[transformedKey] = mapping[key];
        
    }
    return dict;
    
}


/**
 * Transforms a given attributeMappingsArray in the form [key] to
 * a dictionary in the form {(prefix).key : key}
 *
 * @param prefix
 */
+ (NSDictionary *)classAttributeMappingsDictionaryFromArrayWithPrefix:(NSString *)prefix
{
    
    NSArray *mapping = [(id<SDObjectMapping>)self classAttributeMappingsArray];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:mapping.count];
    
    for (NSString *key in mapping){
        
        NSString *transformedKey = [self key:key nestedInKey:prefix];
        dict[transformedKey] = key;
        
    }
    
    return dict;
    
}

+ (RKObjectMapping *)objectMappingForRootKey:(NSString *)rootKey
{
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    if ([[self class] conformsToProtocol:@protocol(SDObjectMapping)]){
        
        // transform flat mapping array to rootKey mapping
        [mapping addAttributeMappingsFromDictionary:[self classAttributeMappingsDictionaryFromArrayWithPrefix:rootKey]];
        
        // transform flat mapping dictionary to rootKey mapping
        [mapping addAttributeMappingsFromDictionary:[self classAttributeMappingsDictionaryWithPrefix:rootKey]];
        
        
    }
    
    if (rootKey){
        // register the rootKey and make sure to map collections correctly
        mapping.forceCollectionMapping = YES;
        [mapping addAttributeMappingFromKeyOfRepresentationToAttribute:rootKey];
    }
    
    return mapping;
    
}

+ (NSString *)key:(NSString *)key nestedInKey:(NSString *)rootKey
{
    
    if (!rootKey){
        return key;
    } else {
        return [NSString stringWithFormat:@"(%@).%@", rootKey, key];
    }
    
}

@end
