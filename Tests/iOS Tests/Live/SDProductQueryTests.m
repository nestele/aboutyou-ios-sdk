//
//  SDProductQueryTests.m
//  AboutYouShop-iOS-SDK-Tests
//
//  Created by Marius Schmeding on 27.05.14.
//
//

#import <XCTest/XCTest.h>
#import "SDTestCase.h"
#import <AboutYouShop-iOS-SDK/SDProduct.h>
#import <AboutYouShop-iOS-SDK/SDResult.h>
#import <XCAsyncTestCase/XCTestCase+AsyncTesting.h>

@interface SDProductQueryTests : SDTestCase

@end

@implementation SDProductQueryTests

- (void)setUp
{
    [super setUp];
    
    [SDShopManager enableStage];
    [[SDShopManager sharedManager] setAppId:SDTestCaseTestingAppId
                             andAppPassword:SDTestCaseTestingAppPassword];
    
}

- (void)tearDown
{
    [SDShopManager destroy];
    
    [super tearDown];
}

- (void)testThatProductGetWithUnknownProductIdFailsWithError
{
    NSArray *productIds = @[@123456];
    SDQuery *productQuery = [SDProduct queryForGet];
    [productQuery addProductIds:productIds];
    [productQuery performInBackground:^(SDResult *result, NSError *error) {
        
        [self queryFinishedWithResult:result andError:error];
        
    }];
    
    [self waitForAsyncCallToFinish];
    
    // check if request returned error
    XCTAssertNotNil(self.asyncError, @"Expected Error for unknown Product Id, but none occured.");
    [self assertAsyncErrorDomainMatches:SDShopSDKErrorDomain];
    [self assertAsyncErrorCodeMatches:SDQueryBadResponseError];
    
}

- (void)testThatSimpleResponseForProductGetMapsPropertiesCorrectly
{
    
    NSArray *productIds = @[[self numberForString:SDTestCaseTestingDefaultProductId]];
    SDQuery *productQuery = [SDProduct queryForGet];
    [productQuery addProductIds:productIds];
    [productQuery performInBackground:^(SDResult *result, NSError *error) {
        
        [self queryFinishedWithResult:result andError:error];
        
    }];
    
    [self waitForAsyncCallToFinish];
    
    // check if request successful
    XCTAssertNil(self.asyncError, @"Query finished with an error: %@", self.asyncError.localizedDescription);
    
    SDProduct *product = self.asyncResult.products.firstObject;
    
    // check if response any good
    XCTAssertNotNil(product, @"No product where one should be");
    
    // check if product looks like expected
    XCTAssertNotNil(product.productId, @"Product has no id");
    XCTAssertNotNil(product.name, @"Product has no name");
    
}

@end
