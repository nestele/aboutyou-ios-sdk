//
//  SDLoginViewController.m
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

#import "SDLoginViewController.h"
#import "SDShopManager.h"

@interface SDLoginViewController ()

@property (nonatomic, strong) void (^loginCompletion)(NSString *authToken, NSError *error);

@end

@implementation SDLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.delegate = self;
    
}


/**
 *
 * Start the webview based OAuth flow (implicit type!)
 *
 * @param authUrl The token provider authentication url
 * @param completion The result block
 *
 */
- (void)loginWithAuthUrl:(NSURL *)authUrl andCompletion:(void (^)(NSString *authToken, NSError *error))completion
{
    
    self.loginCompletion = completion;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:authUrl]];
    
}

/**
 *
 * When the user cancels the login flow (e.g. dismisses the web view)
 *
 */
-(void)cancelLogin
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.loginCompletion) self.loginCompletion(nil, nil);
    }];
    
}

#pragma mark UIWebViewDelegate

/**
 *
 * Observe the URLs that are being called by the provider. When something
 * contains an Access Token, then we assume it is OUR Access Token.
 * Careful: It could be any Access Token actually
 *
 */
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *token = [self extractString:[[request URL] absoluteString] toLookFor:@"access_token="];
    
    if (token){
        
        // we have a token, so dismiss the login view
        [self dismissViewControllerAnimated:YES completion:^{
            
            // pass the token
            if (self.loginCompletion) self.loginCompletion(token, nil);
        }];
        
        // no need to load the redirect uri
        return NO;
        
    } else {
    
        // we did not get a token. what should we do??
        // load the request, see what happens
        return YES;
        
    }
}

/**
 *
 * A helper to parse the Access Token
 *
 */
- (NSString *)extractString:(NSString *)fullString toLookFor:(NSString *)lookFor
{
    
    // it's hacky :-/
    
    // string should look like: http://yourrunway.herokuapp.com/oauth#access_token=IF9TkIF5G8POuEpIbzqFZS5mN1Watr&token_type=Bearer&scope=firstname
    
    // remove path, only take parameters
    NSArray *components = [fullString componentsSeparatedByString:@"#"];
    if (components.count != 2) return nil;
    
    NSString *croppedString = components[1];
    
    NSArray *parameters = [croppedString componentsSeparatedByString:@"&"];
    
    for (NSString *parameter in parameters) {
        
        NSRange range = [parameter rangeOfString:lookFor];
        if (range.location != NSNotFound){
            // we got it
            NSString *token = [parameter stringByReplacingOccurrencesOfString:lookFor withString:@""];
            return token;
        }
    }
    
    return nil;
}

@end
