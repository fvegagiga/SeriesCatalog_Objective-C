//
//  SerieDetailViewController.h
//  UltimateSeries
//
//  Created by Fernando Vega Giganto on 5/7/17.
//  Copyright © 2017 Fernando Vega Giganto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerieModel.h"

@class MasterTableViewController;


// Creamos el protocolo de delegación
@protocol SerieDetailViewControllerDelegate <NSObject>

-(void)deleteFromFavorites:(int) idSerieToDelete;

@end


@interface SerieDetailViewController : UIViewController 

@property (strong, nonatomic) SerieModel *aModel;
@property (nonatomic) BOOL favoriteMode;

@property (nonatomic, weak) id<SerieDetailViewControllerDelegate> delegate;

@end
