//
//  SDQueryTests.m
//  AboutYouShop-iOS-SDK-Tests
//
//  Created by Marius Schmeding on 27.05.14.
//
//

#import <XCTest/XCTest.h>
#import "SDTestCase.h"
#import <AboutYouShop-iOS-SDK/SDProduct.h>

@interface SDQueryTests : SDTestCase

@end

@implementation SDQueryTests

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
    self.asyncError = nil;
    self.asyncResult = nil;
    
    [super tearDown];
}

- (void)testThatQueryResultFailsWhenQueryIsEmpty
{
    
    SDQuery *emptyQuery = [[SDQuery alloc] init];
    [emptyQuery performInBackground:^(SDResult *result, NSError *error) {
        
        [self queryFinishedWithResult:result andError:error];
        
    }];
    
    [self waitForAsyncCallToFinish];
    
    XCTAssertNotNil(self.asyncError, @"Query shoud have failed, but no error was thrown");
    [self assertAsyncErrorDomainMatches:SDShopSDKErrorDomain];
    [self assertAsyncErrorCodeMatches:SDQueryInvalidStructureError];
    
}

- (void)testThatQueryResultFailsWith401WhenNoCredentialsProvided
{
    
    // destroy the auto setup
    [SDShopManager destroy];
    [SDShopManager enableStage];
    
    NSArray *productIds = @[[self numberForString:SDTestCaseTestingDefaultProductId]];
    SDQuery *productQuery = [SDProduct queryForGet];
    [productQuery addProductIds:productIds];
    [productQuery performInBackground:^(SDResult *result, NSError *error) {
        
        [self queryFinishedWithResult:result andError:error];
        
    }];
    
    [self waitForAsyncCallToFinish];
    
    XCTAssertNotNil(self.asyncError, @"Query shoud have failed, but no error was thrown");
    [self assertAsyncErrorDomainMatches:SDShopSDKErrorDomain];
    [self assertAsyncErrorCodeMatches:401];
    
}

@end
