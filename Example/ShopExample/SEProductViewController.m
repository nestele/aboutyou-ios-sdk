//
//  SEProductViewController.m
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

#import "SEProductViewController.h"
#import <AboutYouShop-iOS-SDK/SDShopSDK.h>

@interface SEProductViewController ()

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UILabel *productNameLabel;
@property (nonatomic, weak) IBOutlet UISwitch *productActiveSwitch;


@property (nonatomic, strong) NSArray *variants;

@end

@implementation SEProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.variants = @[];
    self.searchBar.delegate = self;
    
    [self reloadData];
}

- (void)reloadData
{
    
    NSString *productIdString = self.searchBar.text;
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    NSNumber *productId = [nf numberFromString:productIdString];
    
    if (!productId) return;
    
    SDQuery *q = [SDProduct queryForGet];
    [q addProductIds:@[productId]];
    [q addFields:@[@"variants"]];
    
    [q performInBackground:^(SDResult *result, NSError *error) {
        
        [self.searchBar resignFirstResponder];
        
        if (result.products){
            
            SDProduct *product = result.products.firstObject;
            
            // facet in product only contains the id...
            SDFacet *brandFacet = [product brandFacet];
            // ...so we must resolve the facet from the facet cache
            SDFacet *completeBrandFacet = [SDFacet cachedFacetForId:brandFacet.facetId andGroupId:brandFacet.groupId.integerValue];
            
            // use brand facet for whatever ;)
            NSLog(@"brand name: %@", completeBrandFacet.name);
            
            self.productNameLabel.text = product.name;
            self.productActiveSwitch.on = product.active;
            
            self.variants = product.variants;
            [self.tableView reloadData];
            
        }
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.variants.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"variantCell" forIndexPath:indexPath];
    
    SDProductVariant *variant = self.variants[indexPath.row];
    cell.textLabel.text = variant.price.stringValue;
    cell.detailTextLabel.text = variant.variantId.stringValue;
    
    return cell;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [self reloadData];
    
}

@end
