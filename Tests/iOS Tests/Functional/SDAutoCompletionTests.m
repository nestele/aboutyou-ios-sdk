//
//  SDAutoCompletionTests.m
//  AboutYouShop-iOS-SDK-Tests
//
//  Created by Marius Schmeding on 13.06.14.
//
//

#import <XCTest/XCTest.h>
#import "SDTestCase.h"
#import <AboutYouShop-iOS-SDK/SDAutoCompletion.h>

@interface SDAutoCompletionTests : SDTestCase

@end

@implementation SDAutoCompletionTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testThatAutoCompletionIsCorrect
{
    
    [SDQuery performDryWithFixture:@"autocompletion-shop" onCompletion:^(SDResult *result, NSError *error) {
        
        [self queryFinishedWithResult:result andError:error];
        
    }];
    
    [self waitForAsyncCallToFinish];
    
    SDAutoCompletion *autoCompletion = self.asyncResult.autoCompletion;
    
    // categories
    XCTAssertTrue(autoCompletion.categories.count > 0, @"");
    
    // products
    XCTAssertTrue(autoCompletion.products.count > 0, @"");
    
}

@end
