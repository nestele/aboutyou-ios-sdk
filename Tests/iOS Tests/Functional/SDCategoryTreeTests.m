//
//  SDCategoryTreeTests.m
//  AboutYouShop-iOS-SDK-Tests
//
//  Created by Marius Schmeding on 12.06.14.
//
//

#import <XCTest/XCTest.h>
#import "SDTestCase.h"
#import <AboutYouShop-iOS-SDK/SDCategory.h>

@interface SDCategoryTreeTests : SDTestCase

@end

@implementation SDCategoryTreeTests

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

- (void)testThatCategoryTreeIsCorrect
{
    
    [SDQuery performDryWithFixture:@"category-tree" onCompletion:^(SDResult *result, NSError *error) {
        
        [self queryFinishedWithResult:result andError:error];
        
    }];
    
    [self waitForAsyncCallToFinish];
    
    NSArray *catTree = self.asyncResult.categoryTree;
    
    // 2 total categories
    XCTAssertTrue(catTree.count == 2, @"");
    
    // 1 active category
    NSPredicate *activePredicate = [NSPredicate predicateWithFormat:@"active == TRUE"];
    NSArray *activeCats = [catTree filteredArrayUsingPredicate:activePredicate];
    XCTAssertTrue(activeCats.count == 1, @"");
    
}

@end
