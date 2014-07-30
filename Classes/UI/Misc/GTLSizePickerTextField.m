//
//  GTLSizePickerTextField.m
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

#import "GTLSizePickerTextField.h"
#import <AboutYouShop-iOS-SDK/SDFacet.h>

@interface GTLSizePickerTextField()

@property (nonatomic, strong) UIPickerView *picker;

@end

@implementation GTLSizePickerTextField

- (void)awakeFromNib{
    
    UIPickerView *sizePicker = [[UIPickerView alloc] init];
    sizePicker.dataSource = self;
    sizePicker.delegate = self;
    sizePicker.backgroundColor = [UIColor whiteColor];
    self.picker = sizePicker;
    
}

- (UIView *)inputView {
    return self.picker;
}

- (UIView *)inputAccessoryView {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return nil;
	} else {
        UIToolbar *inputAccessoryView;
		if (!inputAccessoryView) {
			inputAccessoryView = [[UIToolbar alloc] init];
			inputAccessoryView.barStyle = UIBarStyleBlackTranslucent;
			inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
			[inputAccessoryView sizeToFit];
			CGRect frame = inputAccessoryView.frame;
			frame.size.height = 44.0f;
			inputAccessoryView.frame = frame;
            
			UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
            doneBtn.tintColor = [UIColor whiteColor];
            
			UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            
			NSArray *array = [NSArray arrayWithObjects:flexibleSpaceLeft, doneBtn, nil];
			[inputAccessoryView setItems:array];
		}
		return inputAccessoryView;
	}
}

- (void)done:(id)sender {
	[self resignFirstResponder];
}

#pragma mark - UIPickerViewDatasource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.sizes.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    SDFacet *size = self.sizes[row];
    return size.name;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.selectedSize = self.sizes[row];
    [self resignFirstResponder];
}

- (void)setSizes:(NSArray *)sizes
{
    if (sizes){
        
        _sizes = sizes;
        
    } else {
        
        _sizes = @[];
        
    }
    
    [self.picker reloadAllComponents];
}

- (void)setSelectedSize:(SDFacet *)selectedSize
{
    
    _selectedSize = selectedSize;
    
    if (selectedSize){
        self.text = [NSString stringWithFormat:@"Größe: %@", selectedSize.name];
    } else {
        self.text = @"One-Size";
    }
    
    // tell delegate about it
    if (self.customDelegate){
        [self.customDelegate sizePicker:self didSelectSize:selectedSize];
    }
    
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

@end
