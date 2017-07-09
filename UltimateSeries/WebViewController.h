//
//  WebViewController.h
//  UltimateSeries
//
//  Created by Fernando Vega Giganto on 5/7/17.
//  Copyright © 2017 Fernando Vega Giganto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerieModel.h"

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSURL *webURL;
@property (weak, nonatomic) IBOutlet UIWebView *browser;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end
