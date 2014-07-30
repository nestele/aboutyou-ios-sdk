//
//  SDTestCase.m
//  AboutYouShop-iOS-SDK-Tests
//
//  Created by Marius Schmeding on 27.05.14.
//
//

#import "SDTestCase.h"

NSString* const SDTestCaseTestingAppId = @"";
NSString* const SDTestCaseTestingAppPassword = @"";

NSString* const SDTestCaseTestingDefaultProductId = @"1";

@implementation SDTestCase

static NSNumberFormatter *_nf;

+ (void)initialize
{
    
    _nf = [[NSNumberFormatter alloc] init];
    
}

- (void)tearDown
{
    _asyncError = nil;
    _asyncResult = nil;
}

- (NSNumber *)numberForString:(NSString *)numberStringValue
{
    
    return [_nf numberFromString:numberStringValue];
    
}

- (void)waitForAsyncCallToFinish
{
    
    if (self.asyncResult || self.asyncError){
        
        // it seems, that the query has finished early, e.g. because validation failed
        // so do nothing
        
    } else {
        
        [self waitForTimeout:10];
        
    }
    
}

- (void)queryFinishedWithResult:(SDResult *)result andError:(NSError *)error
{
    
    self.asyncResult = result;
    self.asyncError = error;
    
    if (error) [self notify:XCTAsyncTestCaseStatusFailed];
    else [self notify:XCTAsyncTestCaseStatusSucceeded];
    
}

- (void)assertAsyncErrorDomainMatches:(NSString *)errorDomain
{
    
    XCTAssertTrue([errorDomain isEqualToString:self.asyncError.domain], @"Query should have failed with domain %@, but was %@", errorDomain, self.asyncError.domain);
    
}

- (void)assertAsyncErrorCodeMatches:(NSInteger)errorCode
{
    
    XCTAssertEqual(self.asyncError.code, errorCode, @"Query should have failed with code %d, but was %d", errorCode, self.asyncError.code);
    
}

@end
