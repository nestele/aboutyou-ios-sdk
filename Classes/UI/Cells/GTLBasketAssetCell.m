//
//  GTLBasketAssetCell.m
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

#import "GTLBasketAssetCell.h"
#import <AboutYouShop-iOS-SDK/SDFacet+Color.h>
#import <AboutYouShop-iOS-SDK/SDOrderLine.h>
#import <AboutYouShop-iOS-SDK/SDProduct.h>
#import <AboutYouShop-iOS-SDK/SDProductVariant.h>
#import <AboutYouShop-iOS-SDK/SDImage.h>
#import <AboutYouShop-iOS-SDK/SDQuery.h>
#import <AboutYouShop-iOS-SDK/SDBasket.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface GTLBasketAssetCell()

@property (nonatomic, weak) IBOutlet UIImageView *productImageView;
@property (nonatomic, weak) IBOutlet UILabel *productNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *productArtNoLabel;
@property (nonatomic, weak) IBOutlet UILabel *productColorLabel;
@property (nonatomic, weak) IBOutlet UILabel *productPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *assetPriceLabel;
@property (nonatomic, weak) IBOutlet GTLSizePickerTextField *assetSizeInput;
@property (nonatomic, weak) IBOutlet GTLQuantityPickerTextField *assetQuantityInput;
@property (nonatomic, weak) IBOutlet UIButton *removeAssetButton;

- (IBAction)removeAssetButtonTapped:(id)sender;

@end

@implementation GTLBasketAssetCell

- (void)awakeFromNib
{
    
    _orderLines = @[];
    self.assetQuantityInput.customDelegate = self;
    self.assetSizeInput.customDelegate = self;
    
}

- (void)prepareForReuse
{
    
    _orderLines = @[];
    [self.productImageView cancelImageRequestOperation];
    self.productImageView.image = nil;
    
}

- (void)setOrderLines:(NSArray *)orderLines
{
    
    _orderLines = orderLines;
    [self updateUI];
    
}


- (void)updateUI
{
 
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    nf.numberStyle = NSNumberFormatterCurrencyStyle;
    nf.currencyCode = @"EUR";
    nf.currencySymbol = @"€";
    
    SDOrderLine *firstOrderline = self.orderLines.firstObject;
    SDProduct *product = [self product];
    
    NSPredicate *variantPredicate = [NSPredicate predicateWithFormat:@"variantId == %@", firstOrderline.variantId];
    NSArray *variants = [product.variants filteredArrayUsingPredicate:variantPredicate];
    SDProductVariant *variant = variants.firstObject;
    
    
    self.productNameLabel.text = product.name;
    self.productArtNoLabel.text = [NSString stringWithFormat:@"Artikel-Nr.: %@", variant.ean];
    SDFacet *colorFacet = [SDFacet findFirstFacetWithGroupId:kSDFacetGroupColor inArray:variant.attributes];
    SDFacet *sizeFacet = [SDFacet findFirstFacetWithGroupId:kSDFacetGroupSize inArray:variant.attributes];
    
    self.productColorLabel.text = colorFacet ? colorFacet.name : @"unbekannt";
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray *sizeFacets = [product.availableSizeFacets sortedArrayUsingDescriptors:@[sortDescriptor]];
    self.assetSizeInput.sizes = sizeFacets;
    
    if (sizeFacet)
        self.assetSizeInput.selectedSize = sizeFacet;
    
    float orderlinePrice = firstOrderline.totalPrice.floatValue / 100.;
    float itemPrice = self.orderLines.count * orderlinePrice;
    
    self.productPriceLabel.text = [nf stringFromNumber:[NSNumber numberWithFloat:orderlinePrice]];
    self.assetPriceLabel.text = [nf stringFromNumber:[NSNumber numberWithFloat:itemPrice]];
    self.assetQuantityInput.maxQuantity = 10;
    self.assetQuantityInput.selectedQuantity = self.orderLines.count;
    
    SDImage *image = variant.images.firstObject;
    if (image){
        
        CGFloat imageWidth = self.productImageView.frame.size.width;
        [self.productImageView setImageWithURL:[image imageUrlForWidth:imageWidth]];
        
    }
    
}

- (IBAction)removeAssetButtonTapped:(id)sender
{
    
    SDQuery *basketQuery = [SDBasket query];
    
    for (SDOrderLine *ol in self.orderLines){
        [basketQuery removeOrderLineForItemId:ol.itemId];
    }
    
    if (self.delegate){
        [self.delegate updateBasketWithQuery:basketQuery];
    }
    
}

#pragma mark GTLQuantityPickerTextFieldDelegate

- (void)quantityPicker:(GTLQuantityPickerTextField *)quantityPicker didSelectQuantity:(NSInteger)quantity
{
    
    SDQuery *query = [SDBasket query];
    SDOrderLine *firstOrderLine = self.orderLines.firstObject;
    NSInteger delta = quantity - self.orderLines.count;
    
    if (delta == 0){
        
        // nothing changed
        return;
        
    } else if (delta > 0){
        
        // increase quantity
        
        for (int n=0; n<delta; n++){
            
            [query addOrderLineForVariantId:firstOrderLine.variantId];
            
        }
        
    } else {
        
        // decrease quantity
        
        NSUInteger currentTotal = self.orderLines.count;
        for (NSInteger n=currentTotal+delta; n<currentTotal; n++){
            
            SDOrderLine *so = self.orderLines[n];
            [query removeOrderLineForItemId:so.itemId];
            
        }
        
    }
    
    
    [self.delegate updateBasketWithQuery:query];
    
}

#pragma mark GTLSizePickerTextFieldDelegate

- (void)sizePicker:(GTLSizePickerTextField *)sizePicker didSelectSize:(SDFacet *)size
{
    
    SDProductVariant *selectedVariant = [[self product] variantWithMatchingFacets:@[size]];
    
    // check if current
    SDOrderLine *firstOrderLine = self.orderLines.firstObject;
    if ([selectedVariant.variantId isEqualToNumber:firstOrderLine.variantId]){
        
        // nothing changed
        return;
        
    }

    SDQuery *query = [SDBasket query];
    for (SDOrderLine *orderLine in self.orderLines){
        
        [query updateOrderLineForItemId:orderLine.itemId withVariantId:selectedVariant.variantId];
        
    }
    
    [self.delegate updateBasketWithQuery:query];
        
    
}

- (SDProduct *)product
{
    
    // all variants the same -> all products the same
    SDOrderLine *firstOrderline = self.orderLines.firstObject;
    return [self.delegate productForProductId:firstOrderline.productId];
    
}

@end
