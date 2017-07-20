//
//  standarTableViewCell.h
//  UltimateSeries
//
//  Created by Fernando Vega Giganto on 7/7/17.
//  Copyright © 2017 Fernando Vega Giganto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MGSwipeTableCell.h>

@interface standarTableViewCell : MGSwipeTableCell

@property (weak, nonatomic) IBOutlet UIImageView *serieImageView;
@property (weak, nonatomic) IBOutlet UILabel *serieLabel;

-(void) showImageFromURL:(NSURL *) imageURL;

@end
