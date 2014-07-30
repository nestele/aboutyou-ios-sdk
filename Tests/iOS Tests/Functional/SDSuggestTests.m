//
//  SDSuggestTests.m
//  AboutYouShop-iOS-SDK-Tests
//
//  Created by Marius Schmeding on 13.06.14.
//
//

#import <XCTest/XCTest.h>
#import "SDTestCase.h"
#import <AboutYouShop-iOS-SDK/SDSuggest.h>

@interface SDSuggestTests : SDTestCase

@end

@implementation SDSuggestTests

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

- (void)testThatSuggestIsCorrect
{
    
    [SDQuery performDryWithFixture:@"suggest" onCompletion:^(SDResult *result, NSError *error) {
        
        [self queryFinishedWithResult:result andError:error];
        
    }];
    
    [self waitForAsyncCallToFinish];
    
    SDSuggest *suggest = self.asyncResult.suggest;
    
    // suggestions exist
    XCTAssertTrue(suggest.words.count > 0, @"");
    
    // specific suggestion exists
    XCTAssertEqualObjects(suggest.words[3], @"fit", @"");
    
}

@end
