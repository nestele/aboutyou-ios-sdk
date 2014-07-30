//
//  SDShopManager.h
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

#import <Foundation/Foundation.h>


/**
 *  The `SDShopManager` handles communication with the AboutYou API.
 *
 */

@class SDResult, SDAuthUser;

@interface SDShopManager : NSObject

/**
 * Enables staging environment. 
 * 
 * Must be called, before the ShopManager is created.
 */
+ (void)enableStage;

#ifdef DEBUG
/**
 *  Destroys the ShopManager singleton object and any data associated to it.
 *
 *  We don't need this in production, but for unit tests.
 */
+ (void)destroy;
#endif

/**
 * Returns the ShopManager singleton object.
 */
+ (instancetype)sharedManager;


/**
 *  Returns the AboutYou Session-ID.
 *
 *  The Session-ID is being persisted. If no Session-ID exists by the time this method is called, one will be created and persisted for you.
 *
 *  @return The AboutYou Session-ID
 */
+ (NSString *)sessionId;


/**
 *  Stores a Session-ID, which can be any `NSString`.
 *
 *  @param sessionId A Session-ID
 */
+ (void)setSessionId:(NSString *)sessionId;


/**
 * Sets the AboutYou credentials.
 *
 * The credentials will be attached to every request to the AboutYou API. You find your App credentials in the AboutYou Devcenter (http://devcenter.aboutyou.com/).
 *
 * @param appId The identifier of your AboutYou App
 * @param appPassword The app secret of your AboutYou App
 */
- (void)setAppId:(NSString *)appId andAppPassword:(NSString *)appPassword;


/**
 * Returns the OAuth2 URL to perform user login against.
 *
 * @param redirectUri The redirect Uri
 */
- (NSURL *)authenticationUrlWithRedirectUriString:(NSString *)redirectUri andScopes:(NSArray *)scopesArray shouldRegister:(BOOL)shouldRegister;


/**
 * Performs a request towards the Collins OAuth provider to get the object that represents the authenticated user.
 *
 * @param authToken The auth token for the user
 */
- (void)getRemoteUserObjectForToken:(NSString *)authToken onCompletion:(void (^)(SDAuthUser *, NSError *))completion;

/**
 *  Initiates the order for items in basket.
 *
 *
 *
 *  @param leave      Boolean whether or not the app should pass control to Safari, once the order was initiated
 *  @param successUrl An URL that should be directed to, after purchase succeeds
 *  @param completion The block to be called when initiation completes
 */
- (void)initiateOrderAndLeave:(BOOL)leave withSuccessUrl:(NSString *)successUrl onCompletion:(void (^)(NSError *))completion;


/**
 * Executes Query.
 *
 * @param query
 */
- (void)performQuery:(NSDictionary *)query onCompletion:(void (^)(SDResult *result, NSError *error))completion;

@end
