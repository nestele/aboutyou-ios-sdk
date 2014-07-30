//
//  GTLProductVC.m
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

#import "GTLProductVC.h"
#import "GTLQuantityPickerTextField.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AboutYouShop-iOS-SDK/SDShopSDK.h>

@interface GTLProductVC ()

@property (weak, nonatomic) IBOutlet UIButton *productDetailsButton;
@property (weak, nonatomic) IBOutlet GTLSizePickerTextField *productSizeInput;
@property (weak, nonatomic) IBOutlet GTLQuantityPickerTextField *productQuantityInput;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet SDImageCollectionView *largeImageCollectionView;
@property (weak, nonatomic) IBOutlet SDImageCollectionView *smallImageCollectionView;

@property (strong, nonatomic) GTLColorCollectionVC *colorsCollectionVC;
@property (strong, nonatomic) SDProduct *selectedStyle;
@property (strong, nonatomic) SDProductVariant *selectedVariant;


- (IBAction)addToBasketButtonTapped:(id)sender;



@end

@implementation GTLProductVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.smallImageCollectionView.collectionViewContainer = self;
    self.largeImageCollectionView.collectionViewContainer = self;
    
    self.navigationItem.title = self.product.name;
    self.productNameLabel.text = self.product.name;
    
    [self.colorsCollectionVC.collectionView reloadData];
    
    self.productSizeInput.customDelegate = self;
    
    self.productQuantityInput.maxQuantity = 10;
    self.productQuantityInput.selectedQuantity = 1;
    
    // set style to update UI
    self.selectedStyle = _selectedStyle;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.smallImageCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"colors"]){
        
        self.colorsCollectionVC = segue.destinationViewController;
        self.colorsCollectionVC.delegate = self;
        [self.colorsCollectionVC.collectionView reloadData];
        
        [self.colorsCollectionVC.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        
    } else if ([segue.identifier isEqualToString:@"productDetails"]){
        
        GTLProductDetailsVC *productDetailsVC = segue.destinationViewController;
        productDetailsVC.delegate = self;
        
    }
    
    
}

- (IBAction)addToBasketButtonTapped:(id)sender {
    
    if (self.selectedVariant == nil){
        
        // something went wrong
        // some kind of notification here!
        return;
        
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    SDQuery *basketQuery = [SDBasket query];
    
    NSInteger amount = self.productQuantityInput.selectedQuantity;
    
    for (int n = 0; n < amount; n++){
        
        [basketQuery addOrderLineForVariantId:self.selectedVariant.variantId];
        
    }
    
    [basketQuery performInBackground:^(SDResult *result, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (result){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SDShopManagerDidAddProductToBasketNotification object:nil];
            
            // wait before calling finish selector
            [self performSelector:@selector(productWasAddedToBasket) withObject:nil afterDelay:1.];
            
        } else {
            
            [[[UIAlertView alloc] initWithTitle:nil message:@"Ein unbekannter Fehler ist aufgetreten" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            
        }
        
    }];
    
}

#pragma mark GTLImageCollectionVCDelegate

- (void)imageCollectionView:(SDImageCollectionView *)imageCollection didSelectImageAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (imageCollection == self.largeImageCollectionView){
        
        [self.smallImageCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        
    } else {
        
        [self.largeImageCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
    }
    
}

- (void)imageCollectionView:(SDImageCollectionView *)imageCollection didScrollToImageAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (imageCollection == self.largeImageCollectionView){
        
        [self.smallImageCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        
    }
    
}

- (NSArray *)images
{
    if (self.selectedStyle.defaultVariant.images){
        return self.selectedStyle.defaultVariant.images;
    } else {
        return @[];
    }
}

- (void)setProduct:(SDProduct *)product
{
    _product = product;
    
    self.selectedStyle = product;
    if (product.defaultVariant){
        
        self.selectedVariant = product.defaultVariant;
        
    }
    
}

- (void)setSelectedVariant:(SDProductVariant *)selectedVariant
{
    _selectedVariant = selectedVariant;
    [self updateUI];
    
}

- (void)setSelectedStyle:(SDProduct *)selectedStyle
{
    _selectedStyle = selectedStyle;
    
    // update size picker
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"value" ascending:YES];
    NSArray *sizeFacets = [selectedStyle.availableSizeFacets sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    SDFacet *currentSize = self.productSizeInput.selectedSize;
    
    // assign available sizes to picker
    self.productSizeInput.sizes = sizeFacets;
    
    if (currentSize && [sizeFacets containsObject:currentSize]){
        // size is available -> select this facet
        self.productSizeInput.selectedSize = currentSize;
    } else {
        // size is not available :( select another one
        self.productSizeInput.selectedSize = sizeFacets.firstObject;
    }
    
    
}

- (void)updateUI
{
    
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    nf.numberStyle = NSNumberFormatterCurrencyStyle;
    nf.currencySymbol = @"€";
    
    NSNumber *variantPrice = [NSNumber numberWithFloat:self.selectedVariant.price.floatValue/100];
    
    self.productPriceLabel.text = [nf stringFromNumber:variantPrice];
    
    
}

- (void)reloadImages
{
    
    [self.largeImageCollectionView reloadData];
    [self.smallImageCollectionView reloadData];
    
    [self.smallImageCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    
}

- (NSArray *)styles
{
    
    return self.product.styles;
    
}

#pragma mark GTLColorCollectionVCDelegate

- (void)colorCollectionView:(GTLColorCollectionVC *)colorCollection didSelectColorAtIndexPath:(NSIndexPath *)indexPath
{
    
    SDProduct *selectedStyle = self.product.styles[indexPath.item];
    self.selectedStyle = selectedStyle;
    
    SDFacet *selectedSize = self.productSizeInput.selectedSize;
    if (selectedSize){
        
        SDProductVariant *selectedVariant = [selectedStyle variantWithMatchingFacets:@[selectedSize]];
        self.selectedVariant = selectedVariant;
        
    } else {
        
        // invalid size -> choose first variant
        self.selectedVariant = selectedStyle.variants.firstObject;
        
    }
    
    [self reloadImages];
    
}

#pragma mark GTLSizePickerTextField

- (void)sizePicker:(GTLSizePickerTextField *)sizePicker didSelectSize:(SDFacet *)size
{
    SDProductVariant *variant;
    
    if (size)
        variant = [self.selectedStyle variantWithMatchingFacets:@[size]];
    else
        variant = [self.selectedStyle defaultVariant];
    
    
    if (variant)
        self.selectedVariant = variant;
    else
        [[[UIAlertView alloc] initWithTitle:@"Fehler" message:@"Ein Fehler ist aufgetreten" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    
    
    
}

#pragma mark Subclassing

- (void)productWasAddedToBasket
{
    
    // subclass it
    
}

@end
