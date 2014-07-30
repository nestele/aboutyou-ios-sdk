//
//  SDTestCase.h
//  AboutYouShop-iOS-SDK-Tests
//
//  Created by Marius Schmeding on 27.05.14.
//
//

#import <XCTest/XCTest.h>
#import <XCAsyncTestCase/XCTestCase+AsyncTesting.h>
#import <AboutYouShop-iOS-SDK/SDShopManager.h>
#import <AboutYouShop-iOS-SDK/SDQuery.h>
#import <AboutYouShop-iOS-SDK/SDErrors.h>

extern NSString* const SDTestCaseTestingAppId;
extern NSString* const SDTestCaseTestingAppPassword;
extern NSString* const SDTestCaseTestingDefaultProductId;

@class SDResult;

@interface SDTestCase : XCTestCase

@property (nonatomic, strong) SDResult *asyncResult;
@property (nonatomic, strong) NSError *asyncError;

- (NSNumber *)numberForString:(NSString *)numberStringValue;
- (void)waitForAsyncCallToFinish;

- (void)queryFinishedWithResult:(SDResult *)result andError:(NSError *)error;


- (void)assertAsyncErrorDomainMatches:(NSString *)errorDomain;
- (void)assertAsyncErrorCodeMatches:(NSInteger)errorCode;

@end
