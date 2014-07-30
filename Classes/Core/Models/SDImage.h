//
//  SDImage.h
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

/**
 *  
 */
@interface SDImage : NSObject<SDObjectMapping>

/**
 *  The identifier for the `SDImage` object.
 */
@property (nonatomic, strong) NSNumber *imageId;

/**
 *  The hash for the image.
 */
@property (nonatomic, strong) NSString *hashString;

/**
 *  The Mime-Type of the image file.
 */
@property (nonatomic, strong) NSString *mime;

/**
 *  The extension of the image file.
 */
@property (nonatomic, strong) NSString *ext;

/**
 *  The pixel height of the image.
 */
@property (nonatomic, strong) NSNumber *height;

/**
 *  The pixel width of the image.
 */
@property (nonatomic, strong) NSNumber *width;

/**
 *  The size of the image in bytes.
 */
@property (nonatomic, strong) NSNumber *size;

/**
 *  Returns the URL to obtain the original image file.
 *
 *  @return An `NSString` object
 */
- (NSString *)urlString;

/**
 *  Returns the URL to obtain the image file for a given width.
 *
 *  @param width The desired width in pixels
 *
 *  @return An `NSURL` object
 */
- (NSURL *)imageUrlForWidth:(CGFloat)width;

/**
 *  Returns the URL to obtain the image file for a given height.
 *
 *  @param height The desired height in pixels
 *
 *  @return An `NSURL` object
 */
- (NSURL *)imageUrlForHeight:(CGFloat)height;

@end
