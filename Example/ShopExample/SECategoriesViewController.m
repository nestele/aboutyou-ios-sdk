//
//  SECategoriesViewController.m
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

#import "SECategoriesViewController.h"

@interface SECategoriesViewController ()

@property (nonatomic, strong) NSArray *categories;

@end

@implementation SECategoriesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.categories = @[];
    
    [self reloadData];
}

- (void)reloadData
{
    
    SDQuery *q = [SDCategory query];
    [q performInBackground:^(SDResult *result, NSError *error) {
        if (result.categoryTree){
            
            self.categories = [self flattenArray:result.categoryTree];
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
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftDetailCell" forIndexPath:indexPath];
    
    SDCategory *category = self.categories[indexPath.row];
    cell.textLabel.text = category.categoryId.stringValue;
    cell.detailTextLabel.text = category.name;
    
    return cell;
}

- (NSArray *)flattenArray:(NSArray *)array
{
    
    NSMutableArray *result = [NSMutableArray array];
    for (SDCategory *cat in array) {
        if (cat.active){
            [result addObject:cat];
            if (cat.subCategories) {
                [result addObjectsFromArray:[self flattenArray:cat.subCategories]];
            }
        }
    }
    return [NSArray arrayWithArray:result];
    
}

@end
