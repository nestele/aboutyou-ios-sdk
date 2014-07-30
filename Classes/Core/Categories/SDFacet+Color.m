//
//  SDFacet+Color.m
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

#import "SDFacet+Color.h"

@implementation SDFacet (Color)

/**
 *
 * Return the corresponding UIColor for a given Color facet
 *
 */
- (UIColor *)color
{
    
    NSAssert(self.groupId.integerValue == kSDFacetGroupColor, @"Trying to ask for a color for a non-color facet!");
    
    UIColor *col = [UIColor redColor];
    
    switch (self.facetId.integerValue) {
        case kSDColorFacetBeige:
            col = [self colorFromHexadecimalString:@"#d1b664"];
            break;
        case kSDColorFacetBlack:
            col = [self colorFromHexadecimalString:@"#000000"];
            break;
        case kSDColorFacetBlue:
            col = [self colorFromHexadecimalString:@"#33cccc"];
            break;
        case kSDColorFacetBrown:
            col = [self colorFromHexadecimalString:@"#87400c"];
            break;
        case kSDColorFacetGreen:
            col = [self colorFromHexadecimalString:@"#999966"];
            break;
        case kSDColorFacetRed:
            col = [self colorFromHexadecimalString:@"#ff0000"];
            break;
        case kSDColorFacetYellow:
            col = [self colorFromHexadecimalString:@"#fffc00"];
            break;
        case kSDColorFacetWhite:
            col = [self colorFromHexadecimalString:@"#ffffff"];
            break;
        case kSDColorFacetSilver:
            col = [self colorFromHexadecimalString:@"#d2d2d2"];
            break;
        case kSDColorFacetGold:
            col = [self colorFromHexadecimalString:@"#cca633"];
            break;
        case kSDColorFacetOrange:
            col = [self colorFromHexadecimalString:@"#ff9966"];
            break;
        case kSDColorFacetPink:
            col = [self colorFromHexadecimalString:@"#ff3376"];
            break;
        case kSDColorFacetLila:
            col = [self colorFromHexadecimalString:@"#7e007a"];
            break;
        case kSDColorFacetGray:
            col = [self colorFromHexadecimalString:@"#6a6a6a"];
            break;
        case kSDColorFacetColor:
            col = [self colorFromHexadecimalString:@"#e3897f"];
            break;
            
        default:
            NSLog(@"No color defined for color:%@, facetId:%@", self.name, self.facetId);
            break;
            
    }
    
    return col;
    
}

+ (NSArray *)simpleColors
{
    
    return @[
             @(kSDColorFacetBeige),
             @(kSDColorFacetBlack),
             @(kSDColorFacetBlue),
             @(kSDColorFacetBrown),
             @(kSDColorFacetGreen),
             @(kSDColorFacetRed),
             @(kSDColorFacetYellow),
             @(kSDColorFacetWhite),
             @(kSDColorFacetSilver),
             @(kSDColorFacetGold),
             @(kSDColorFacetOrange),
             @(kSDColorFacetPink),
             @(kSDColorFacetLila),
             @(kSDColorFacetGray),
             @(kSDColorFacetColor)
             ];
    
}

- (UIColor *)colorFromHexadecimalString:(NSString *)string {
    NSScanner *scanner = [NSScanner scannerWithString:string];
    scanner.charactersToBeSkipped = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    
    unsigned value;
    [scanner scanHexInt:&value];
    
    CGFloat r = ((value & 0xFF0000) >> 16) / 255.0f;
    CGFloat g = ((value & 0xFF00) >> 8) / 255.0f;
    CGFloat b = ((value & 0xFF)) / 255.0f;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

@end
