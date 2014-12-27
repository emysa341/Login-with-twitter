//
//  MainViewController.m
//  TechnoGerms.com
//
//  Created by Ammad iOS on 06/12/2013.
//  Copyright (c) 2013 Techno. All rights reserved.

//  codegerms.com See more details on codegerms.com

#import "MainViewController.h"

NSString *client_id = @"2sVEcZDhudTeScaMShpd3w";
NSString *secret = @"CVqonV4B8wDxSnwzzXCC2uhak8H22R1gXhbsCSF1400";
NSString *callback = @"http://codegerms.com/callback";


@interface MainViewController ()

@end

@implementation MainViewController
@synthesize webview, isLogin,accessToken;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        consumer = [[OAConsumer alloc] initWithKey:client_id secret:secret realm:nil];
    NSURL* requestTokenUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
    OAMutableURLRequest* requestTokenRequest = [[OAMutableURLRequest alloc] initWithURL:requestTokenUrl
                                                                               consumer:consumer
                                                                                  token:nil
                                                                                  realm:nil
                                                                      signatureProvider:nil];
    OARequestParameter* callbackParam = [[OARequestParameter alloc] initWithName:@"oauth_callback" value:callback];
    [requestTokenRequest setHTTPMethod:@"POST"];
    [requestTokenRequest setParameters:[NSArray arrayWithObject:callbackParam]];
    OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
    [dataFetcher fetchDataWithRequest:requestTokenRequest
                             delegate:self
                    didFinishSelector:@selector(didReceiveRequestToken:data:)
                      didFailSelector:@selector(didFailOAuth:error:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didReceiveRequestToken:(OAServiceTicket*)ticket data:(NSData*)data {
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    requestToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
    
    NSURL* authorizeUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/authorize"];
    OAMutableURLRequest* authorizeRequest = [[OAMutableURLRequest alloc] initWithURL:authorizeUrl
                                                                            consumer:nil
                                                                               token:nil
                                                                               realm:nil
                                                                   signatureProvider:nil];
    NSString* oauthToken = requestToken.key;
    OARequestParameter* oauthTokenParam = [[OARequestParameter alloc] initWithName:@"oauth_token" value:oauthToken];
    [authorizeRequest setParameters:[NSArray arrayWithObject:oauthTokenParam]];
    
    [webview loadRequest:authorizeRequest];
}

- (void)didReceiveAccessToken:(OAServiceTicket*)ticket data:(NSData*)data {
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    accessToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
    // WebServiceSocket *connection = [[WebServiceSocket alloc] init];
    //  connection.delegate = self;
    NSString *pdata = [NSString stringWithFormat:@"type=2&token=%@&secret=%@&login=%@", accessToken.key, accessToken.secret, self.isLogin];
    // [connection fetch:1 withPostdata:pdata withGetData:@"" isSilent:NO];
    NSLog(@"%@",accessToken.secret);
   

    
    if (accessToken) {
        NSURL* userdatarequestu = [NSURL URLWithString:@"https://api.twitter.com/1.1/account/verify_credentials.json"];
        OAMutableURLRequest* requestTokenRequest = [[OAMutableURLRequest alloc] initWithURL:userdatarequestu
                                                                                   consumer:consumer
                                                                                      token:accessToken
                                                                                      realm:nil
                                                                          signatureProvider:nil];

        [requestTokenRequest setHTTPMethod:@"GET"];
        OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
        [dataFetcher fetchDataWithRequest:requestTokenRequest
                                 delegate:self
                        didFinishSelector:@selector(didReceiveuserdata:data:)
                          didFailSelector:@selector(didFailOdatah:error:)];    } else {
        // ERROR!
    }
    

    
}


- (void)didReceiveuserdata:(OAServiceTicket*)ticket data:(NSData*)data {
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
}

- (void)didFailOAuth:(OAServiceTicket*)ticket error:(NSError*)error {
    // ERROR!
}


- (void)didFailOdatah:(OAServiceTicket*)ticket error:(NSError*)error {
    // ERROR!
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    //  [indicator startAnimating];
        NSString *temp = [NSString stringWithFormat:@"%@",request];
  //  BOOL result = [[temp lowercaseString] hasPrefix:@"http://codegerms.com/callback"];
   // if (result) {
    NSRange textRange = [[temp lowercaseString] rangeOfString:[@"http://codegerms.com/callback" lowercaseString]];
    
    if(textRange.location != NSNotFound){
    
    
        // Extract oauth_verifier from URL query
        NSString* verifier = nil;
        NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
        for (NSString* param in urlParams) {
            NSArray* keyValue = [param componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            if ([key isEqualToString:@"oauth_verifier"]) {
                verifier = [keyValue objectAtIndex:1];
                break;
            }
        }
        
        if (verifier) {
            NSURL* accessTokenUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
            OAMutableURLRequest* accessTokenRequest = [[OAMutableURLRequest alloc] initWithURL:accessTokenUrl consumer:consumer token:requestToken realm:nil signatureProvider:nil];
            OARequestParameter* verifierParam = [[OARequestParameter alloc] initWithName:@"oauth_verifier" value:verifier];
            [accessTokenRequest setHTTPMethod:@"POST"];
            [accessTokenRequest setParameters:[NSArray arrayWithObject:verifierParam]];
            OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
            [dataFetcher fetchDataWithRequest:accessTokenRequest
                                     delegate:self
                            didFinishSelector:@selector(didReceiveAccessToken:data:)
                              didFailSelector:@selector(didFailOAuth:error:)];
        } else {
            // ERROR!
        }
        
        [webView removeFromSuperview];
        
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    // ERROR!
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // [indicator stopAnimating];
}



@end
