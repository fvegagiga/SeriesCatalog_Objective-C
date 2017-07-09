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

@end

@implementation WebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self displayURL: self.webURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.activityView stopAnimating];
    self.activityView.hidden = YES;
    
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

    NSLog(@"Error : %@",error);

}
#pragma mark - Utils

-(void)displayURL:(NSURL *) infoURL {
    
    NSLog(@"Vamos a la web: %@", infoURL);
    
    self.browser.delegate = self;
    
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
    
    [self.browser loadRequest:[NSURLRequest requestWithURL:infoURL]];
    
}

@end
