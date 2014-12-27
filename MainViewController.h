//
//  MainViewController.h
//  TechnoGerms.com
//
//  Created by Ammad iOS on 06/12/2013.
//  Copyright (c) 2013 Techno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthConsumer.h"
#import "EmyAppDelegate.h"

@interface MainViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *webview;
    OAConsumer* consumer;
    OAToken* requestToken;
    OAToken* accessToken;
}
@property (nonatomic,strong) OAToken* accessToken;
@property (nonatomic, retain) IBOutlet UIWebView *webview;
@property (nonatomic, retain) NSString *isLogin;

@end
