//
//  standarTableViewCell.m
//  UltimateSeries
//
//  Created by Fernando Vega Giganto on 7/7/17.
//  Copyright © 2017 Fernando Vega Giganto. All rights reserved.
//

#import "standarTableViewCell.h"

@interface standarTableViewCell ()

@property (nonatomic, strong) NSURLSessionDataTask *imageDataTask;

@end

@implementation standarTableViewCell


-(void) showImageFromURL:(NSURL *) imageURL{
    
    if (self.imageDataTask != nil) {
        [self.imageDataTask cancel];
        self.imageDataTask = nil;
    }
    
    self.imageDataTask = [[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error==nil){
            UIImage *image = [UIImage imageWithData:data];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.serieImageView.image = image;
            }];
            
        }
        
        self.imageDataTask = nil;
    }];
    
    [self.imageDataTask resume];
}

@end
