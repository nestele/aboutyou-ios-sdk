//
//  SDShopManager.m
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

#import "SDShopManager.h"
#import "SDModels.h"
#import "SDResult.h"
#import "SDAuthUser.h"
#import "SDOrderInit.h"
#import "SDAutoCompletion.h"
#import "SDSuggest.h"
#import "SDErrors.h"
#import "SDConstants.h"
#import <RestKit/RestKit.h>
#import "NSDictionary+UrlEncoding.h"

NSString* const SDShopManagerUserDefaultsSessionIdKey = @"kSDShopManagerUserDefaultsSessionIdKey";

@interface SDShopManager()

@property (nonatomic, strong) RKObjectManager *defaultObjectManager;

@end

@implementation SDShopManager

static BOOL _stage = NO;
static NSString *_appId;
static SDShopManager *_sharedManager;
static dispatch_once_t * once_token_debug; // only for testing


#pragma mark Initialization

+ (void)enableStage
{
    NSAssert(!_sharedManager, @"destroy the active SDShopManager instance, before you enable staging!");
    _stage = YES;
}

#ifdef DEBUG
+ (void)destroy
{
    
    _sharedManager.defaultObjectManager = nil;
    _sharedManager = nil;
    _appId = nil;
    _stage = NO;
    
    *once_token_debug = 0;
    
}
#endif

+ (instancetype)sharedManager
{
    static dispatch_once_t once_token;
    once_token_debug = &once_token;    // Store address of once_token
                                                                   // to access it in debug function.
    
    dispatch_once(&once_token, ^{
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString:[self baseUrlString]]];
        
        RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:httpClient];
        [objectManager setRequestSerializationMIMEType: RKMIMETypeJSON];
        [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/html"];
        
        
        _sharedManager = [[self alloc] initWithObjectManager:objectManager];
        [_sharedManager registerMappings];
        
    });
    
    return _sharedManager;
}

- (id)initWithObjectManager:(RKObjectManager *)objectManager
{
    self = [super init];
    if (self){
        _defaultObjectManager = objectManager;
        
    }
    return self;
}

#pragma mark Resource URLs

#warning No Staging URL for Shop API defined
NSString *const API_END_POINT_STAGE = @"https://shop-api.aboutyou.de/api";
NSString *const API_END_POINT_LIVE = @"https://shop-api.aboutyou.de/api";
#warning No Staging URL for Accesstoken defined
NSString *const API_AUTH_TOKEN_STAGE = @"https://checkout.aboutyou.de";
NSString *const API_AUTH_TOKEN_LIVE = @"https://checkout.aboutyou.de";
#warning No Staging URL for OAUTH2 Me object defined
NSString *const API_AUTH_ME_STAGE = @"https://oauth.collins.kg/oauth/api/me";
NSString *const API_AUTH_ME_LIVE = @"https://oauth.collins.kg/oauth/api/me";

/**
 *
 * The URL that points to the Shop API
 *
 */
+ (NSString *)baseUrlString
{
    
    if (_stage){
        
        return API_END_POINT_STAGE;
        
    } else {
        
        return API_END_POINT_LIVE;
    }
    
}

/**
 *
 * The URL that points to the OAuth2 authentication service
 *
 */
+ (NSString *)authTokenUrlString
{
    
    if (_stage){
        
        return API_AUTH_TOKEN_STAGE;
        
    } else {
        
        return API_AUTH_TOKEN_LIVE;
    }
    
}

/**
 *
 * The URL to retrieve the user object
 *
 */
+ (NSString *)authMeUrlString
{
    
    if (_stage){
        
        return API_AUTH_ME_STAGE;
        
    } else {
        
        return API_AUTH_ME_LIVE;
    }
    
}

#pragma mark Authentication

- (void)setAppId:(NSString *)appId andAppPassword:(NSString *)appPassword
{
    _appId = appId;
    [_defaultObjectManager.HTTPClient setAuthorizationHeaderWithUsername:appId password:appPassword];
}

- (NSURL *)authenticationUrlWithRedirectUriString:(NSString *)redirectUri andScopes:(NSArray *)scopesArray shouldRegister:(BOOL)shouldRegister
{
 
    // are we ready for this?
    NSAssert(_appId, @"You must set your App ID before requesting the authenticationUrl.");
    NSAssert(redirectUri, @"You must provide a redirectUri when requesting the authenticationUrl.");
    
    NSMutableDictionary *urlParameters = [NSMutableDictionary dictionary];
    
    // prepare scopes string (whitespace separated list)
    NSString *scope;
    if (scopesArray) scope = [scopesArray componentsJoinedByString:@" "];
    
    // create parameters array
    if (_appId) urlParameters[@"client_id"] = _appId;
    if (redirectUri) urlParameters[@"redirect_uri"] = redirectUri;
    if (scope) urlParameters[@"scope"] = scope;
    
    // implicit auth
    urlParameters[@"response_type"] = @"token";
    
    // responsive view
    urlParameters[@"popup"] = @"true";
    
    // register view
    if (shouldRegister) urlParameters[@"register"] = @"true";
    
    NSString *urlString = [NSString stringWithFormat:@"%@?%@", [SDShopManager authTokenUrlString], [urlParameters urlEncodedString]];
    
    return [NSURL URLWithString:urlString];
}

- (void)getRemoteUserObjectForToken:(NSString *)authToken onCompletion:(void (^)(SDAuthUser *, NSError *))completion
{
    
    // format HTTP header value
    NSString *authValue = [NSString stringWithFormat:@"Bearer %@", authToken];
    
    // create simple request
    NSURL *url = [NSURL URLWithString:[SDShopManager authMeUrlString]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:authValue forHTTPHeaderField:@"Authorization"];
    
    // a descriptor for the response
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[SDAuthUser objectMapping] method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    // perform operation
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:urlRequest responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        // pass the user object...
        SDAuthUser *user = mappingResult.firstObject;
        if (completion) completion(user, nil);
        
        // TODO store the user object for later use
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        if (completion) completion(nil, error);
        
        // TODO handle authetication errors
        
    }];
    
#warning security risk! Should be fixed A.S.A.P (requires a trusted SSL certificate)
    operation.HTTPRequestOperation.allowsInvalidSSLCertificate = YES;
    
    [operation start];
}

#pragma mark Object Mapping

- (void)registerMappings
{
    
    NSIndexSet *defaultStatusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    
    // Result mapping
    // Since the response is an array of multiple possible results, we use a wrapping result object
    RKObjectMapping *resultMapping = [RKObjectMapping mappingForClass:[SDResult class]];
    
    
    // SDCategory response
    [resultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"category_tree" toKeyPath:@"categoryTree" withMapping:[SDCategory objectMapping]]];
    // SDFacet response
    [resultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"facets.facet" toKeyPath:@"facets" withMapping:[SDFacet objectMapping]]];
    // SDProduct response
    [resultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"products.ids" toKeyPath:@"products" withMapping:[SDProduct objectMapping]]];
    // SDBasket response
    [resultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"basket" toKeyPath:@"basket" withMapping:[SDBasket objectMapping]]];
    // SDAutoCompletion response
    [resultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"autocompletion" toKeyPath:@"autoCompletion" withMapping:[SDAutoCompletion objectMapping]]];
    // SDSuggest response
    [resultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"suggest" withMapping:[SDSuggest objectMapping]]];
    
    // SDProductSearch response
    [resultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"product_search" toKeyPath:@"productSearch" withMapping:[SDProductSearch objectMapping]]];
    
    // SDOrderInit
    [resultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"initiate_order" toKeyPath:@"orderInit" withMapping:[SDOrderInit objectMapping]]];
    
    
    
    [self.defaultObjectManager addResponseDescriptor:
     [RKResponseDescriptor responseDescriptorWithMapping:resultMapping
                                                  method:RKRequestMethodPOST
                                             pathPattern:nil
                                                 keyPath:@""
                                             statusCodes:defaultStatusCodes]];
    
    
}

#pragma mark Session Handling

+ (NSString *)sessionId
{
    
    // lookup persisted sessionId
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [d synchronize];
    NSString *sessionId = [d objectForKey:SDShopManagerUserDefaultsSessionIdKey];
    
    if (!sessionId || sessionId.length < 1){
        // create new sessionId
        sessionId = [[NSUUID UUID] UUIDString];
        [self setSessionId:sessionId];
    }
    
    return sessionId;
    
}

+ (void)setSessionId:(NSString *)sessionId
{
    
    // persist sessionId
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    if (sessionId && sessionId.length > 0){
        [d setObject:sessionId forKey:SDShopManagerUserDefaultsSessionIdKey];
        [d synchronize];
    } else {
        [d setObject:@"" forKey:SDShopManagerUserDefaultsSessionIdKey];
        [d synchronize];
        
        // because we are losing access to the basket, we fire clearance notification
        [[NSNotificationCenter defaultCenter] postNotificationName:SDShopManagerDidRemoveAllProductsFromBasketNotification object:nil];
        
        
    }
    
}

#pragma mark Requests

- (void)performQuery:(NSDictionary *)query onCompletion:(void (^)(SDResult *, NSError *))completion
{
    NSString *dryTestFileName = query[@"dry"];
    if (dryTestFileName){
        // perform a 'dry' request for the specified JSON file
        [self performDryQueryForResource:dryTestFileName onCompletion:completion];
        return;
    }
    
    NSString *method = query[@"method"];
    NSString *path = query[@"path"];
    id body = query[@"body"];
    
    NSMutableURLRequest *request = [_defaultObjectManager requestWithObject:nil method:RKRequestMethodFromString(method) path:path parameters:body];
    
    RKObjectRequestOperation *operation = [_defaultObjectManager objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        if (completion) completion(mappingResult.firstObject, nil);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        NSError *queryError;
        if (operation.HTTPRequestOperation.response.statusCode == SDQueryUnauthorized){
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Unauthorized Query", nil),
                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The server rejected the Query", nil),
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"You must set appId and appPassword before performing a Query", nil)
                                       };
            
            queryError = [NSError errorWithDomain:SDShopSDKErrorDomain
                                       code:SDQueryUnauthorized
                                   userInfo:userInfo];
        }
        else {
            queryError = error;
        }
        
        if (completion) completion(nil, queryError);
        
    }];
    
    [_defaultObjectManager enqueueObjectRequestOperation:operation];
    
}


- (void)performDryQueryForResource:(NSString *)filename onCompletion:(void (^)(SDResult *, NSError *))completion
{
    
    NSError *error = nil;
    
    NSString *resourcePath = [[NSBundle bundleForClass:[SDShopManager class]] pathForResource:filename ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:resourcePath];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) {
        if (completion) completion(nil, error);
        return;
    }
    
    NSMutableDictionary *mappingsDictionary = [[NSMutableDictionary alloc] init];
    for (RKResponseDescriptor *descriptor in _defaultObjectManager.responseDescriptors) {
        [mappingsDictionary setObject:descriptor.mapping forKey:descriptor.keyPath];
    }
    RKMapperOperation *mapperOperation = [[RKMapperOperation alloc] initWithRepresentation:jsonArray mappingsDictionary:mappingsDictionary];
    
    BOOL isMapped = [mapperOperation execute:&error];
    if (isMapped && !error) {
        if (completion) completion(mapperOperation.mappingResult.firstObject, nil);
    } else {
        if (completion) completion(nil, error);
    }
    
}

- (void)initiateOrderAndLeave:(BOOL)leave
               withSuccessUrl:(NSString *)successUrl
                 onCompletion:(void (^)(NSError *))completion
{
    
    NSArray *arr = @[@{@"initiate_order": @{@"session_id" : [SDShopManager sessionId], @"success_url" : successUrl}}];
    NSDictionary *query = @{@"method" : @"POST", @"path" : @"", @"body" : arr};
    
    [self performQuery:query onCompletion:^(SDResult *result, NSError *error) {
       
        if (leave && result.orderInit.userToken && result.orderInit.appToken){
            
            // the provided Url does not work, so it must be handcrafted :(
            NSString *checkoutUrl = [NSString stringWithFormat:@"%@/?user_token=%@&app_token=%@&basketId=%@&appId=%@",
                                     [SDShopManager authTokenUrlString],
                                     result.orderInit.userToken,
                                     result.orderInit.appToken,
                                     [SDShopManager sessionId],
                                     _appId];
            
            // transfer control to Safari
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:checkoutUrl]];
            
        }
        
        if (completion) completion(error);
        
    }];
    
    
}





@end
