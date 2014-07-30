//
//  SDOrderLine.m
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

#import "SDOrderLine.h"

@implementation SDOrderLine

static RKObjectMapping *_objectMapping;

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
    
    return @[@"tax"];
    
}

+ (NSDictionary *)classAttributeMappingsDictionary
{
    
    return @{
                                           @"total_price" : @"totalPrice",
                                           @"total_net" : @"totalNet",
                                           @"total_vat" : @"totalVat",
                                           @"variant_id" : @"variantId",
                                           @"product_id" : @"productId",
                                           @"id" : @"itemId"
                                           };
    
}

@end
