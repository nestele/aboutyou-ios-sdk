//
//  SELoginViewController.m
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

#import "SELoginViewController.h"

@interface SELoginViewController ()

@end

@implementation SELoginViewController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
#warning No Redirect URI specified
    NSURL *authUrl = [[SDShopManager sharedManager] authenticationUrlWithRedirectUriString:@"http://your-redirect-uri" andScopes:@[@"firstname"] shouldRegister:NO];
    
    [self loginWithAuthUrl:authUrl andCompletion:^(NSString *authToken, NSError *error) {
        
        [[[UIAlertView alloc] initWithTitle:@"Your Token" message:authToken delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        
    }];
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    // Display an error?
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Authentication failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    
}

@end
