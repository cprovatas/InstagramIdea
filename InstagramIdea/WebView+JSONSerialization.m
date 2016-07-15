//
//  WebView+JSONSerialization.m
//  InstagramIdea
//
//  Created by Charlton Provatas on 6/26/16.
//  Copyright © 2016 Charlton Provatas. All rights reserved.
//

#import "WebView+JSONSerialization.h"
#import "JSONParser.h"

@implementation WebView_JSONSerialization {
    
    NSString *webDataString;
    JSONParser *parser;
    bool isAppendingExistingJson;
}

- (void)viewDidLoad{
    
    _webView = [[WKWebView alloc] initWithFrame:_webView.frame configuration:[[WKWebViewConfiguration alloc] init]];
     _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [_webView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString:@"https://www.instagram.com/accounts/login"] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval: 10.0]]; //caches web view so it can show feed on launch after 1st login
    [self.view addSubview: _webView];
   // _webView.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldDismiss) name:@"readInstagramJson" object: nil];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    isAppendingExistingJson = YES;
    NSString *javascriptToEvaluate = isAppendingExistingJson ? @"window.scrollTo(0,document.body.scrollHeight); document.documentElement.outerHTML.toString();" : @"document.documentElement.outerHTML.toString();";
    
    
    [NSTimer scheduledTimerWithTimeInterval: 2.0 target:self selector:@selector(dumbMethod) userInfo:nil repeats:NO];
    
    [_webView evaluateJavaScript:javascriptToEvaluate completionHandler:^(id _Nullable html, NSError * _Nullable error) {
       webDataString = html;
    
       
        //           NSProgressIndicator *activityIndicator = [[NSProgressIndicator alloc] initWithFrame:_webView.frame];
//           activityIndicator.style = NSProgressIndicatorSpinningStyle;
//           [self.view addSubview: activityIndicator];
//           [activityIndicator startAnimation: self];
//           
//           parser = [JSONParser sharedInstance];
//           [parser serializeInstagramJson: webDataString];
//           
//       }else {
//           
//           _webView.hidden = NO;
//       }
   
   }];
}

- (void)shouldDismiss{
    
    dispatch_async(dispatch_get_main_queue(), ^{ [self dismissViewController: self]; });
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"readInstagramJson" object:nil];
}

- (void)appendExistingJson{
    
    isAppendingExistingJson = YES;
    [self viewDidLoad];
}

- (void)dumbMethod{
    
    [_webView evaluateJavaScript:@"window._timings.domInteractive = phil;document.documentElement.outerHTML.toString();" completionHandler:^(id _Nullable html, NSError * _Nullable error) {
        _messageText.stringValue = @"Please login below";
        webDataString = html;
        NSLog(@"here : %@", html);
        webDataString = [webDataString substringFromIndex:[webDataString rangeOfString:@"{\"country_code\": "].location]; //remove source code before json starts
        webDataString = [webDataString substringToIndex:[webDataString rangeOfString:@";</script>"].location]; //remove source code after json ends
        
//        if(webDataString.length > 1054){ //determine wheter the feed is loaded now or not
//            
//            //  _webView.hidden = YES;
//            _messageText.stringValue = [@"Loading Your Instagram Feed...";
//                                        }
       // [_webView evaluateJavaScript:@"window.scrollTo(0,document.body.scrollHeight);" completionHandler:nil];
        //[NSTimer scheduledTimerWithTimeInterval: 2.0 target:self selector:@selector(dumbMethod) userInfo:nil repeats:NO];
        }];
    
}

@end
