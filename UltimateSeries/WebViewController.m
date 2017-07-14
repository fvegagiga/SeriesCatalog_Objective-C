//
//  WebViewController.m
//  UltimateSeries
//
//  Created by Fernando Vega Giganto on 5/7/17.
//  Copyright © 2017 Fernando Vega Giganto. All rights reserved.
//

#import "WebViewController.h"
#import "SerieModel.h"

@interface WebViewController ()

@property (strong, nonatomic) WKWebView *browser;

@end

@implementation WebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.browser = [[WKWebView alloc] init];
    
    // Indicamos que las constraints las introduciremos por código
    self.browser.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view insertSubview:self.browser atIndex:0];
    
    // Definimos las constraints para el WebView
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.browser
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1 constant:0 ]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.browser
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1 constant:0 ]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.browser
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1 constant:0 ]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.browser
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1 constant:0 ]];
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self displayURL: self.webURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WKNavigationDelegate

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self.activityView stopAnimating];
    self.activityView.hidden = YES;
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"Error : %@",error);

}

#pragma mark - Utils

-(void)displayURL:(NSURL *) infoURL {
    
    NSLog(@"Vamos a la web: %@", infoURL); 
    
    self.browser.navigationDelegate = self;
    
    self.activityView.hidden = NO;
    [self.activityView startAnimating];

    // Hacemos la petición web remoto;
    [self.browser loadRequest:[NSURLRequest requestWithURL:infoURL]];
    
}

@end
