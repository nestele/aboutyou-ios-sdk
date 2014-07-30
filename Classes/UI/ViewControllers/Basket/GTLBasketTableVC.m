//
//  GTLBasketTableVC.m
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

#import "GTLBasketTableVC.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AboutYouShop-iOS-SDK/SDShopSDK.h>

@interface GTLBasketTableVC ()

@property (nonatomic, weak) IBOutlet UILabel *netValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *shippingValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *taxValueLabel;
@property (nonatomic, weak) IBOutlet UIButton *checkoutButton;

@property (nonatomic) BOOL needsRefresh;

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) SDBasket *basket;

- (IBAction)checkoutButtonTapped:(id)sender;

@end

@implementation GTLBasketTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.items = [NSMutableArray array];
    
    self.needsRefresh = YES;
    [self updateFooterView];
    
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    // Observe basket changes
    [[NSNotificationCenter defaultCenter] addObserverForName:SDShopManagerDidAddProductToBasketNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        self.needsRefresh = YES;
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.needsRefresh){
        [self loadDataAndClear:YES withHudAnimation:YES];
        self.needsRefresh = NO;
    }
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SDShopManagerDidAddProductToBasketNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateFooterView
{
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    nf.numberStyle = NSNumberFormatterCurrencyStyle;
    nf.currencyCode = @"EUR";
    nf.currencySymbol = @"€";
    
    self.netValueLabel.text = [nf stringFromNumber:[NSNumber numberWithFloat:self.basket.totalNet.floatValue / 100.]];
    self.shippingValueLabel.text = [nf stringFromNumber:[NSNumber numberWithFloat:0.]];
    self.totalValueLabel.text = [nf stringFromNumber:[NSNumber numberWithFloat:self.basket.totalPrice.floatValue / 100.]];
    self.taxValueLabel.text = [nf stringFromNumber:[NSNumber numberWithFloat:self.basket.totalVat.floatValue / 100.]];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTLBasketAssetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"assetCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.orderLines = self.items[indexPath.row];
    
    return cell;
}

- (void)loadDataAndClear:(BOOL)clear withHudAnimation:(BOOL)animated
{
    if (animated) [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    SDQuery *basketQuery = [SDBasket query];
    [basketQuery performInBackground:^(SDResult *result, NSError *error) {
        
        if (animated) [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.refreshControl endRefreshing];
        
        self.checkoutButton.enabled = NO;
        
        if (!error){
            
            self.basket = result.basket;
            
            // update the collection with loaded data
            if (clear){
                [self.items removeAllObjects];
            }
            
            NSArray *items = [self splitOrderLinesIntoItems:result.basket.orderLines];
            [self.items addObjectsFromArray:items];
            
            [self.tableView reloadData];
            [self updateFooterView];
            
            self.checkoutButton.enabled = self.items.count > 0;
            
        } else {
            
            // display an error
            
        }
        
    }];
    
}

- (NSArray *)splitOrderLinesIntoItems:(NSArray *)orderLines
{
    
    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];

    for (SDOrderLine *ol in orderLines){
        
        NSString *variantId = ol.variantId.stringValue;
        
        NSMutableArray *items = tmpDict[variantId];
        if (!items){
            items = [NSMutableArray array];
            tmpDict[variantId] = items;
        }
        
        [items addObject:ol];
        
    }
    
    return tmpDict.allValues;
    
}

- (IBAction)checkoutButtonTapped:(id)sender
{
    
    [[SDShopManager sharedManager] initiateOrderAndLeave:YES withSuccessUrl:@"http://aboutyou.de" onCompletion:^(NSError *error) {
        
        if (!error){
            // we're done, aren't we?
            
            // ready for new session
            [SDShopManager setSessionId:nil];
            
        }
        
    }];
    
}


- (void)refresh:(UIRefreshControl *)refreshControl
{
    
    [self loadDataAndClear:YES withHudAnimation:NO];
    
}

#pragma mark GTLBasketAssetCellDelegate

- (void)updateBasketWithQuery:(SDQuery *)updateQuery
{
    if (!updateQuery) return;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [updateQuery performInBackground:^(SDResult *result, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SDShopManagerDidRemoveAllProductsFromBasketNotification object:nil];
            
            [self loadDataAndClear:YES withHudAnimation:YES];
            
        } else {
            
            [[[UIAlertView alloc] initWithTitle:nil message:@"Ein unbekannter Fehler ist aufgetreten" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            
        }
    }];
}

- (SDProduct *)productForProductId:(NSNumber *)productId
{
    
    return [self.basket productForProductId:productId];
    
}

@end
