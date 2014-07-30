//
//  SDFacet+Color.h
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

/**
 *  An enum that holds the facet ids of all colors.
 */
typedef NS_ENUM(NSInteger, SDColorFacet) {
    /**
     *  Blue
     */
    kSDColorFacetBlue       = 1,
    /**
     *  Black
     */
    kSDColorFacetBlack      = 11,
    /**
     *  Gray
     */
    kSDColorFacetGray       = 12,
    /**
     *  Orange
     */
    kSDColorFacetOrange     = 14,
    /**
     *  Brown
     */
    kSDColorFacetBrown      = 15,
    /**
     *  Red
     */
    kSDColorFacetRed        = 18,
    /**
     *  Lila
     */
    kSDColorFacetLila       = 30,
    /**
     *  Beige
     */
    kSDColorFacetBeige      = 48,
    /**
     *  A colorful pattern
     */
    kSDColorFacetColor      = 55,
    /**
     *  Yellow
     */
    kSDColorFacetYellow     = 67,
    /**
     *  Silver
     */
    kSDColorFacetSilver     = 168,
    /**
     *  Pink
     */
    kSDColorFacetPink       = 204,
    /**
     *  Gold
     */
    kSDColorFacetGold       = 247,
    /**
     *  White
     */
    kSDColorFacetWhite      = 570,
    /**
     *  Green
     */
    kSDColorFacetGreen      = 579
};

/**
 *  
 */
@interface SDFacet (Color)

/**
 *  Returns an array of IDs for familiar Color Facets.
 *
 *  Familiar Facets are those contained in the `SDColorFacet` enum.
 *
 *  @return An `NSArray` with `SDColorFacet` values
 */
+ (NSArray *)simpleColors;

/**
 *  Returns a corresponding `UIColor` for the color facet
 *
 *  @return The corresponding `UIColor`
 */
- (UIColor *)color;

@end
