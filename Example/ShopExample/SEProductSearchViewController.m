//
//  SEProductSearchViewController.m
//  ShopExample
//
//  Created by jesse on 11.04.14.
//  Copyright (c) 2014 Slice and Dice. All rights reserved.
//

#import "SEProductSearchViewController.h"

@interface SEProductSearchViewController ()

@end

@implementation SEProductSearchViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SDCategory *category = [[SDCategory alloc] init];
    category.categoryId = @(16333);
    
    [self getProductsForCategory:category onCompletion:^(NSArray *products) {
        availableProducts = products;
        [self.tableView reloadData];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [availableProducts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCell" forIndexPath:indexPath];
    
    SDProduct *product = availableProducts[indexPath.row];
    cell.textLabel.text = product.name;
    
    SDFacet *brandFacet = [product brandFacet];
    SDFacet *completeBrandFacet = [SDFacet cachedFacetForId:brandFacet.facetId andGroupId:[brandFacet.groupId integerValue]];
    
    cell.detailTextLabel.text = completeBrandFacet.name;
    
    return cell;
}


-(void)getProductsForCategory:(SDCategory *)category onCompletion:(void (^)(NSArray *products))completion
{
    //Be sure that we got Facets cached already
    if (! [[SDFacet cachedFacetsForGroupId:kSDFacetGroupBrand] count] || ! [[SDFacet cachedFacetsForGroupId:kSDFacetGroupColor] count]) {
        [[SDShopManager sharedManager] getFacets:@[@(kSDFacetGroupBrand), @(kSDFacetGroupColor)] onCompletation:^(SDResult *result, NSError *error) {
            if (result.facets){
                [SDFacet cacheFacets:result.facets];
                [self requestProducts:category onCompletion:completion];
            }
        }];
    }
    else {
        [self requestProducts:category onCompletion:completion];
    }
}

-(void)requestProducts:(SDCategory *)category onCompletion:(void (^)(NSArray *products))completion
{
    NSMutableArray *products = [[NSMutableArray alloc] init];
    SDProductCriteria *criteria = [[SDProductCriteria alloc] initWithSessionId:[SDShopManager sessionId]];
    [criteria setLimit:@(200)];
    [criteria addCategory:category.categoryId];
    [criteria addField:@"variants"];
    
    [self getProductsWithCriteriaRecursive:criteria withProducts:products onCompletion:^(NSArray *products) {
        completion(products);
    }];
}

-(void)getProductsWithCriteriaRecursive:(SDProductCriteria *)criteria withProducts:(NSMutableArray *)products onCompletion:(void (^)(NSArray *products))completion
{
    [[SDShopManager sharedManager] getProductsWithCriteria:criteria onCompletation:^(SDResult *result, NSError *error) {
        if (! error) {
            NSNumber *productCount = result.productSearch.productCount;
            [products addObjectsFromArray:result.productSearch.products];
            
            if ([productCount integerValue] > [products count]) {
                [criteria setOffset:@([products count])];
                [self getProductsWithCriteriaRecursive:criteria withProducts:products onCompletion:completion];
                
            }
            else {
                completion(products);
            }
        }
    }];
}


@end
