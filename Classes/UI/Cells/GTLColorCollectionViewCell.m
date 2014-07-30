//
//  GTLColorCollectionViewCell.m
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

#import "GTLColorCollectionViewCell.h"
#import <AboutYouShop-iOS-SDK/SDFacet+Color.h>

@interface GTLColorCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *colorNameLabel;


@end

@implementation GTLColorCollectionViewCell

- (void)prepareForReuse
{
    
    self.colorView.backgroundColor = [UIColor clearColor];
    self.colorView.superview.backgroundColor = [UIColor clearColor];
    [self setSelected:NO];
    
}

- (void)setColor:(SDFacet *)color
{
    
    _color = color;
    
    if ([color color]){
        self.colorView.backgroundColor = [color color];
        self.colorView.superview.backgroundColor = [color color];
        self.colorNameLabel.hidden = YES;
    } else {
        self.colorView.backgroundColor = [UIColor whiteColor];
        self.colorView.superview.backgroundColor = [UIColor whiteColor];
        self.colorNameLabel.text = @"Farbe fehlt";
        self.colorNameLabel.hidden = NO;
    }
    
}

- (void)setSelected:(BOOL)selected
{
    
    self.colorView.layer.borderWidth = selected ? 1 : 0;
    self.colorView.superview.layer.borderWidth = selected ? 3 : 0;
    
}


@end
